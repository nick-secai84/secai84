# Contributing

How participants (and anyone else) work on SecAI84 projects.

## Setup, once

1. Install Claude Code (or another harness), the GitHub CLI and `jq`. Run `gh auth login`.
2. Clone the meta-repo and **always launch from its root**:
   ```
   gh repo clone nick-secai84/secai84 && cd secai84 && claude
   ```
3. Clone your project: `/checkout <project>`. It lands in `repos/<project>`. To push branches and merge, you need write access to the project repo. The program owner adds each cohort participant as a collaborator when the cohort starts, and removes them when it ends. Anyone else can contribute from a fork.
4. Sign up for the free tiers your project needs (Splunk, Tines Community Edition, threat-intel providers, the [Context MCP](https://github.com/everydaysecurity-ai/context-osint-mcp)) with your own account. Never share keys.

## Your own settings (not committed)

The workspace's rules work best with broad autonomy plus a short deny list that holds in every mode. A starting point for `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["Read", "Write", "Edit", "Glob", "Grep", "Bash(git:*)", "Bash(gh:*)", "Bash(make:*)", "Bash(ls:*)", "Bash(mkdir:*)", "WebSearch"],
    "deny": ["Bash(rm:*)", "Bash(sudo:*)", "Bash(curl:*)", "Bash(wget:*)"]
  },
  "autoMemoryEnabled": true,
  "enabledPlugins": { "superpowers@claude-plugins-official": true }
}
```

The deny list means your agent can't delete files or fetch arbitrary URLs. It will leave temporary files for you to clean up, and that's the point. Pick your own permission mode. Auto mode is a good middle ground.

## The loop, every change

1. **Branch** in the project repo: `git -C repos/<project> switch -c <short-topic>`.
2. **Build test-first.** For anything bigger than a small fix: brainstorm, write a spec in the project's `docs/specs/`, write a plan, then build.
3. **Run `make ci` locally.** It's exactly what CI runs.
4. **Push and open the PR in the same turn.** Small PRs. The description says what changed, why, and how you verified it on the real thing. If the PR passes through a one-way door, record the approval.
5. **Drive it to merge:** `/drive-pr` from the project's checkout. Agents merge with squash, **only on green**. Never bypass a check.
6. **Tidy up:** `/sync-main <project>`.

## Asking a vendor for something

Every product you integrate with belongs to another company. You use what it publishes, like any outside developer. When a vendor's public API can't do what your project needs, don't work around it and don't guess at internals. Run `/feature-request` (or fill in [the template](templates/feature-request.md)), review it yourself, and file it through the vendor's public channel. Then design your project so it works today and gets better if the feature arrives.

## When to stop and ask

See [DECISION_FRAMEWORK.md](DECISION_FRAMEWORK.md). In short, ask before anything that costs money, publishes a name, changes a license, touches participant data, uses another company's brand, or changes repo settings. Everything else: decide, act, and say what you decided.

## Data

No personal data about any participant goes in any repo (see `CLAUDE.md`). Fixtures use made-up data, labelled as made up.
