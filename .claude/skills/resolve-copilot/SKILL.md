---
name: resolve-copilot
description: Use when the user wants unresolved Copilot review comments on a GitHub pull request addressed and resolved.
argument-hint: "[pr-number] [--no-commit | --no-push] (pr-number defaults to the current branch's open PR)"
allowed-tools: Bash(git status*), Bash(git diff*), Bash(git branch --show-current*), Bash(git stash push*), Bash(git stash pop*), Bash(git add*), Bash(git commit*), Bash(git push), Bash(gh pr view*), Bash(gh repo view*), Bash(gh api repos/*/pulls/*/comments/*/replies*), Read, Edit, Agent
---

You orchestrate Copilot review resolution. The per-thread work (fetch diff, read file, apply fix, reply, resolve) is delegated to the `resolve-copilot` subagent **to protect your context** — don't re-read every file/diff yourself. But the subagent has **less context than you** (only the caller-context snippet + a file-scoped diff), so after it returns you do two things it can't: **sanity-check its fixes against what you know**, then **commit + push**.

## Step 1 — Identify the PR, repo, and flags

If the user supplied a PR number, use it. Otherwise run `gh pr view --json number,headRefName,baseRefName`. If there is no open PR, tell the user and stop. Capture the repo and head branch:
```
gh pr view -R OWNER/REPO PR_NUMBER --json number,headRefName,baseRefName
gh repo view --json owner,name
```
Parse optional flags from the args: `--no-commit` (skip Step 5 entirely) and `--no-push` (commit locally but don't push). Default is commit **and** push.

**Before proceeding**, confirm the current checkout is already on `headRefName`. If `git branch --show-current` returns a different branch, stop here and tell the user — nothing has been stashed or changed yet, so there is nothing to restore.

## Step 2 — Gather caller context

Scan the current conversation for context to pass through — comments the user flagged as wrong/intentional, why code is written a certain way, threads to skip, and any decisions or facts you hold that the subagent won't. Collect into a `CALLER_CONTEXT` block. If there is none, omit it — do not ask.

Important: You are NOT ALLOWED to make any judgement at this stage; you operate on the assumption that all of Copilot's findings are legitimate. You solely are collecting context to hand off to the agent. It is the subagent's job to make the initial judgement of fact on whether the findings are legitimate. Your independent assessment will happen during step 4.

## Step 3 — Stash pre-existing work, then delegate

Unless `--no-commit`, start from a clean tree so the Step-5 commit can only ever contain *this run's* changes. Run `git status --porcelain` in the PR's repo; **if anything is staged or modified, `git stash push -m "resolve-copilot auto-stash"`** and remember that you stashed (you restore it in Step 5). If the tree is already clean — or `--no-commit` was passed — don't stash.

Call the Agent tool with `subagent_type: resolve-copilot`, `description: "Resolve Copilot review threads on PR #NUMBER"`, and prompt:
```
Resolve all unresolved Copilot review threads on PR #NUMBER in repo OWNER/REPO. Apply fixes, post replies, and resolve threads. Do not commit or push.

CALLER_CONTEXT
[block, or omit this section if none]
```

## Step 4 — Sanity-check the reported fixes (from the descriptions, not the diffs)

The subagent's summary — a results table plus a **Review focus** list describing each *interpretive* fix (what it changed + why) — is already in your context. **Review those descriptions; do NOT blanket `git diff` or re-read files** (that re-pollutes the context this delegation exists to protect). The main failure you're catching: the subagent, having less context, reconciles an inconsistency the wrong way, "fixes" something intentional, or contradicts a fact only you hold — and that almost always shows up *in its own description of what it changed* (e.g., it reports rewording to "the module is unbuilt" when you know the module exists).

1. Read each reported fix against what you already know — decisions from this conversation, the caller context you passed, and codebase facts already in your context.
2. Escalate to a **targeted** look (`git diff -- FILE`, or read just the affected lines) **only** for a fix that raises a flag: it contradicts something you know, is described vaguely, is marked interpretive/reconciling, or changes contract/semantic wording. Mechanical fixes (typos, formatting, precise-name swaps) need no diff.
3. For a flagged-and-confirmed-wrong fix: correct it with Edit, and if the subagent already resolved that thread on the wrong basis, post a follow-up reply documenting the correction — using the comment `databaseId` from the subagent's **Thread reference** list (the thread stays resolved; a reply doesn't reopen it):
   ```
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments/COMMENT_DATABASEID/replies -X POST -f body="..."
   ```
4. If a thread genuinely needs a human decision, leave it and surface it in Step 6.

Note: Unlike Step 2, you ARE allowed to make judgements at this stage.

## Step 5 — Commit, push, and restore the stash

If `--no-commit`, skip committing — the fixes stay in the working tree for the user (you didn't stash, so there's nothing to restore). Otherwise, in the git repo whose `origin` matches OWNER/REPO:
1. Re-confirm you are on the PR's head branch (`headRefName`). If not, stop and tell the user (and restore the stash — see below) rather than committing to the wrong branch.
2. Because Step 3 left you on a clean tree, every change present is this run's work. Stage the touched files (`git add <those paths>` — targeted, so a pre-existing *untracked* file isn't swept), run `git diff --check`, then `git commit` with a message referencing the PR and that it addresses Copilot review threads (plus your corrections, if any). If the subagent and your review made no changes at all, skip the commit.
3. Unless `--no-push`, push the head branch with bare `git push` (it already tracks its `origin` upstream, so no remote/refspec arguments are needed). The allowlist pre-approves only the **exact** `Bash(git push)` (not `git push *`), so the normal push doesn't prompt; explicit `git push --force`/`--delete`/refspec forms aren't pre-approved and fall through to the normal permission flow (a prompt in default mode; the classifier in auto mode).

   **This allow is a convenience; the skill does not provide a force-push safety boundary — don't treat it as one.** A command-string rule can't bound what `git push` *does*: behavior depends on git config (`remote.<remote>.push` refspecs, `push.default`), so even a bare `git push` can force or fan out under an unusual/hostile config — and an allow-listed bare push runs **without a prompt** in default mode. The skill itself only ever issues bare `git push` and never constructs a force/delete/refspec push. Actually bounding force-push under hostile conditions is the operator's environment to enforce (e.g. auto mode's classifier, or a managed-settings deny) — this skill makes no such guarantee.
4. **Restore the stash:** if you stashed in Step 3, `git stash pop --index` now — the `--index` flag reinstates the user's original staged/unstaged split (a plain `git stash pop` would bring everything back unstaged, silently dropping their staging). Do this even if step 2 found nothing to commit.

**Stash safety — the one failure mode.** If you stashed and do NOT reach a clean `git stash pop --index` (you stopped early, a thread needs human intervention, the push failed, or the pop reported a conflict — note that `--index` itself fails if the staged state can't be cleanly reinstated), do not drop the stash, and make the **last line of your Step-6 report a loud warning** so the user restores it — e.g. `⚠ Your uncommitted changes were stashed (see git stash list) — run git stash pop --index to restore them (staged state included).`

Pushing triggers a fresh Copilot re-review of the new commit, so new threads may appear afterward — note that the user can re-run `/resolve-copilot`.

## Step 6 — Report

Relay the subagent's summary table. Then add:
- **Review** — any fixes you corrected in Step 4 and why (or "none — descriptions verified against context").
- **Commit/push** — the commit SHA and whether it was pushed, or why it was skipped.
- **Stash** — if you stashed in Step 3: "restored (`git stash pop --index`)" on success, or the loud ⚠ warning above if it could not be restored.
