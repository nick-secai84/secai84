---
name: sync-main
description: Post-merge housekeeping for one sub-repo — sync its default branch (fast-forward) and prune local branches that are merged or whose PR merged, by delegating to the repo-housekeeper subagent. The git work stays in the subagent's context; you only relay its compact summary. Run once per repo after a PR merges.
argument-hint: "[repo-path] (optional — defaults to the current repo)"
model: haiku
allowed-tools: Bash(git rev-parse*), Bash(realpath*), Bash(cd*), Bash(pwd), Agent
disable-model-invocation: true
---

You are a thin shim. You resolve which repo to housekeep, hand it to the
`repo-housekeeper` subagent (so the verbose git output stays out of the main
conversation), and relay the subagent's summary. You do NOT run git yourself
beyond resolving the path.

## Step 1 — Resolve the target repo path

- If an argument was given, treat it as the repo path and make it absolute:
  `realpath "<arg>"`.
- If no argument, use the current repo: `git rev-parse --show-toplevel`.
- If neither yields a path (no arg and not inside a repo), tell the user to run
  `/sync-main <repo-path>` and stop.

Call the result `REPO_PATH`.

## Step 2 — Delegate to the subagent

Call the Agent tool with:
- `subagent_type`: `repo-housekeeper`
- `description`: `Post-merge sync — <repo basename>`
- `prompt`: `Run post-merge git housekeeping on the repo at REPO_PATH. cd into it and follow your procedure: refuse a dirty tree, fetch --prune, fast-forward the default branch, and delete only branches that are merged or have a merged PR (keep and flag anything else). Return your compact summary.`

  (Substitute the real absolute path for REPO_PATH.)

## Step 3 — Relay

Return the subagent's summary verbatim. Do not add git output or commentary. If
the subagent aborted (dirty tree, or the default branch can't fast-forward),
relay that line as-is so the user can resolve it — do not try to fix it yourself.

To housekeep several repos (e.g. a project repo and a companion change in another project), the user
runs `/sync-main` once per repo.
