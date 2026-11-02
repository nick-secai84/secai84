#!/usr/bin/env bash
# Guards against a real incident: bare <angle-bracket> placeholders that GitHub's
# markdown renderer silently parses as unknown HTML tags and strips, leaving
# no visible trace. Renders each file through GitHub's own markdown API (the
# same one that serves github.com) and confirms every placeholder's SOURCE
# OCCURRENCE COUNT is matched by its RENDERED OCCURRENCE COUNT — not just
# presence. A placeholder repeated N times where only some occurrences are
# code-span-wrapped would pass a bare presence check (the surviving instance
# masks the still-dropped ones); comparing counts catches that. HTML comments
# are excluded — they're invisible on GitHub by design and unrelated to this
# failure mode. YAML frontmatter is also excluded — its fields (e.g.
# argument-hint) are literal CLI hint text on a different rendering surface,
# never backtick-quoted anywhere in this repo's skills.
#
# Usage: .claude/skills/phase-handoff/check-placeholders.sh [file ...]
# Defaults to template.md, SKILL.md, and every docs/runbooks/handoffs/*.md.
# Requires: gh (authenticated), jq, perl.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../../.." && pwd)"

if [ "$#" -gt 0 ]; then
  files=("$@")
else
  files=(
    "$script_dir/template.md"
    "$script_dir/SKILL.md"
    "$repo_root"/docs/runbooks/handoffs/*.md
  )
fi

total_drops=0

for f in "${files[@]}"; do
  [ -f "$f" ] || continue

  rendered=$(jq -nc --rawfile t "$f" '{mode:"gfm", text:$t}' \
    | gh api /markdown -X POST --input - \
    | perl -pe 's/<[^>]+>//g' \
    | perl -pe 's/&lt;/</g; s/&gt;/>/g; s/&amp;/&/g; s/&quot;/"/g; s/&#39;/'"'"'/g' \
    | tr -d '`')

  source_no_comments=$(perl -0777 -pe 's/\A---\n.*?\n---\n//s; s/<!--.*?-->//gs' "$f")

  rendered_flat=$(printf '%s' "$rendered" | tr '\n' ' ')

  file_drops=0
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    src_count=$(printf '%s' "$line" | perl -pe 's/^\s*(\d+)\s.*/$1/')
    placeholder=$(printf '%s' "$line" | perl -pe 's/^\s*\d+\s//')
    norm=$(printf '%s' "$placeholder" | tr -d '`' | perl -pe 's/\s+/ /g')
    rendered_count=$(printf '%s' "$rendered_flat" | { grep -o -F -- "$norm" || true; } | wc -l | tr -d ' ')
    if [ "$rendered_count" -lt "$src_count" ]; then
      missing=$((src_count - rendered_count))
      echo "DROPPED in ${f#"$repo_root"/}: $placeholder (appears ${src_count}x in source, only ${rendered_count}x survive rendering — ${missing} dropped)"
      file_drops=$((file_drops + missing))
    fi
  done < <(printf '%s' "$source_no_comments" \
    | perl -0777 -ne 'while (/<([^<>]+)>/gs) { my $m = $1; $m =~ s/\s+/ /g; print "<$m>\n" }' \
    | sort | uniq -c)

  total_drops=$((total_drops + file_drops))
done

if [ "$total_drops" -gt 0 ]; then
  echo "$total_drops placeholder(s) silently dropped by GitHub's renderer — wrap in code spans (backticks)." >&2
  exit 1
fi

echo "All placeholders survive GitHub's renderer."
