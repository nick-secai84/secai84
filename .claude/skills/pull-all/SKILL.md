---
name: pull-all
argument-hint: (no arguments)
model: haiku
allowed-tools: Bash(ls *), Bash(git -C *), Bash(test *)
disable-model-invocation: true
---

Pull the latest changes for every checked-out sub-repository under `repos/`.

## Instructions

1. Verify that the `repos/` directory exists:
   ```
   test -d repos/
   ```
   If it does not exist, tell the user: "No `repos/` directory found. Run `/checkout <repo-name>` first to clone a repository." Then stop.

2. List every immediate subdirectory of `repos/`:
   ```
   ls repos/
   ```
   For each entry, check whether it is a git repository:
   ```
   test -d repos/<name>/.git
   ```
   If the `.git/` directory does not exist, skip the entry silently — it is not a git repo.

3. For each git repository found, process it in order:

   a. **Dirty-tree check** — detect uncommitted changes:
      ```
      git -C repos/<name> status --porcelain
      ```
      If the output is non-empty, record the repo as **Skipped (dirty)** and move on. Do not stash or modify the working tree.

   b. **Upstream check** — confirm the current branch has a remote tracking branch:
      ```
      git -C repos/<name> rev-parse --abbrev-ref --symbolic-full-name @{u}
      ```
      If this command fails (exit code non-zero), record the repo as **Skipped (no upstream)** and move on.

   c. **Pull** — fast-forward only:
      ```
      git -C repos/<name> pull --ff-only
      ```
      - If the output contains `Already up to date.`, record as **Already current**.
      - If the output contains `Updating`, record as **Updated** and capture the SHA range line (e.g. `Updating abc1234..def5678`).
      - If the command exits non-zero (diverged branch, network error, etc.), record as **Failed** and capture the first line of stderr.

4. Print a grouped summary. Use this format (omit any group that has no entries):

   ```
   ## pull-all results

   **Updated** (N)
   - repo-name — Updating abc1234..def5678

   **Already current** (N)
   - repo-name

   **Skipped** (N)
   - repo-name — dirty working tree
   - repo-name — no upstream on current branch

   **Failed** (N)
   - repo-name — <first line of error>
   ```

   If every repo was already current, a single line is fine: "All repos are up to date."
