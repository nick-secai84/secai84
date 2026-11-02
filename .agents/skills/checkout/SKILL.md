---
name: checkout
argument-hint: [repo-name | owner/repo-name]
model: haiku
allowed-tools: Bash(gh repo clone *), Bash(mkdir *), Bash(ls *)
disable-model-invocation: true
---

Clone a project repository into the `repos/` folder.

## Instructions

1. If `$ARGUMENTS` is empty or missing, tell the user: "Usage: `/checkout <repo-name>` for a SecAI84 project repo (owner `nick-secai84`), or `/checkout <owner>/<repo-name>` for any other public repo, such as `everydaysecurity-ai/context-osint-mcp`." Then stop.

2. Work out the owner and the folder name:
   - If `$ARGUMENTS` contains a `/`, it is `OWNER/NAME`. Use it as given.
   - Otherwise OWNER is `nick-secai84` and NAME is `$ARGUMENTS`.

3. Ensure the `repos/` directory exists. If it does not, create it:
   ```
   mkdir -p repos/
   ```

4. Check if `repos/NAME` already exists:
   ```
   ls repos/NAME
   ```
   If it exists, tell the user: "**NAME** is already checked out at `repos/NAME`." Then stop.

5. Clone the repository:
   ```
   gh repo clone OWNER/NAME repos/NAME
   ```

6. If the clone succeeds, tell the user: "**NAME** has been cloned to `repos/NAME`. Read `repos/NAME/CLAUDE.md` before you start."

7. If the clone fails, relay the error from `gh` so the user can troubleshoot (e.g., repo not found, auth issues).
