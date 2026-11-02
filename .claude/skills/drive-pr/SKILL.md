---
name: drive-pr
description: Use when the user wants a pull request driven all the way to merge — looping Copilot review rounds until the feedback stops being worth acting on, getting CI green, and merging.
argument-hint: "[pr-number] [--merge squash|merge|rebase|none] [--max-rounds N] [--max-ci-fixes N] [--review-wait MIN] [--budget MIN] [--nits judge|fix|skip] (pr-number defaults to the current branch's open PR)"
allowed-tools: Bash(gh pr view*), Bash(gh repo view*), Bash(git rev-parse*), Bash(git -C * status*), Bash(git -C * branch --show-current*), Agent
---

You are a thin shim. You resolve the PR + repo + flags, run a fast pre-flight, gather caller context, dispatch the `pr-driver` subagent, and relay its report verbatim. The whole drive — every Copilot round, CI fix, and the merge — happens inside the subagent so the main conversation absorbs only the final table. You do NOT run the loop yourself.

Invoke this from the PR's own checkout (the same assumption `resolve-copilot` makes). For a sub-repo PR that means `cd repos/<name>` first; the pre-flight below catches a wrong-repo invocation before a subagent is spent.

The `git -C *` patterns in `allowed-tools` mirror the wildcard forms already in use in `pull-all` (`Bash(git -C *)`) and `resolve-copilot` (`Bash(gh api repos/*/pulls/*/comments/*/replies*)`), so the pre-flight's `git -C "$REPO_DIR" status` / `branch` do not prompt. This allow-list is a convenience, not a safety boundary — the shim only ever issues read-only git.

## Step 1 — Resolve the PR and repo

If the user supplied a PR number, use it. Otherwise:
```
gh pr view --json number,headRefName,baseRefName
```
No open PR for the current branch → tell the user and stop.

Then capture the repo slug and the repo's working tree:
```
gh repo view --json owner,name            # -> OWNER/REPO
git rev-parse --show-toplevel             # -> REPO_DIR (absolute path)
```
`git rev-parse --show-toplevel` resolves whether cwd is the repo root or a subdirectory of it; if it fails (cwd is not a git repo), tell the user to run `/drive-pr` from the PR's checkout and stop.

## Step 2 — Pre-flight (fail fast, before burning a subagent)

Run both checks against `REPO_DIR`:
```
git -C "$REPO_DIR" branch --show-current      # must equal headRefName
git -C "$REPO_DIR" status --porcelain         # must be empty
```
- Current branch ≠ `headRefName` → stop, tell the user which branch they are on. The driver commits and pushes; it must not run on the wrong branch (this also catches a sub-repo PR invoked from the meta-repo root).
- `git status --porcelain` not empty → stop, tell the user to commit or stash first.

This is deliberately stricter than `resolve-copilot`, which stashes — a long unattended loop should not hold someone's uncommitted work hostage in a stash.

## Step 3 — Gather caller context

Scan the current conversation for context to pass through: comments the user flagged as wrong or intentional, design constraints, threads to skip. Collect into a `CALLER_CONTEXT` block. If there is none, omit it — **do not ask the user.**

## Step 4 — Resolve parameters, dispatch, and relay

Resolve every flag to an explicit value (defaults below), then call `Agent` with:
- `subagent_type`: `pr-driver`
- `description`: `Drive PR #N to merge`
- `prompt`:

```
Drive PR #N in repo OWNER/REPO to merge.
REPO_DIR: <absolute path from Step 1>
Parameters: merge=<squash|merge|rebase|none> max-rounds=<N> max-ci-fixes=<N> review-wait=<MIN> budget=<MIN> nits=<judge|fix|skip>

CALLER_CONTEXT
[block, or omit this section if none]
```

Then **relay the agent's report verbatim. Do not add commentary or summarize.**

### Parameters

| Flag | Default | Meaning |
|---|---|---|
| `--merge` | `squash` | Merge method. `none` = drive to green, stop before merging. |
| `--max-rounds` | `5` | Hard cap on Copilot review rounds. |
| `--max-ci-fixes` | `3` | Consecutive fix attempts on a failing CI job before giving up. |
| `--review-wait` | `15` | Minutes to wait for a Copilot review of a pushed SHA. |
| `--budget` | `90` | Overall wall-clock minutes. |
| `--nits` | `judge` | `judge` = the agent's stop rule. `fix` = action every new nit each round (disables the stop rule; still bounded by `--max-rounds` and the once-per-thread filter). `skip` = never fix nits. |

`--budget` defaults to 90, not 60: five rounds at a 15-minute review wait cannot fit in 60 minutes, and a budget that is arithmetically unreachable would fire spuriously.
