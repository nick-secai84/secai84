# SecAI84

SecAI84 is a four-week, hands-on program in **agentic software development**. It's for experienced engineers who want to build software the way it's built now: with AI agents doing most of the typing, and with the engineer setting direction, drawing hard lines, and checking the result.

Participants spend 10–20 hours a week building real open-source (MIT) security tools that plug into the products security teams already run.

## What this repository is

This is the **meta-repo**. It holds no source code. It holds the things every project and every agent session shares:

| Path | What it holds |
|---|---|
| [CLAUDE.md](CLAUDE.md) / [AGENTS.md](AGENTS.md) | The rules every agent follows, in every repo |
| [docs/](docs/) | Program outline, workspace design, the decision framework, standards, templates |
| [adrs/](adrs/) | Architectural Decision Records |
| [.claude/](.claude/) | Shared skills (`/checkout`, `/pull-all`, `/drive-pr`, `/sync-main`, `/phase-handoff`, `/feature-request`) and subagents |
| [.agents/](.agents/) | The same generic skills for other agent harnesses |
| `repos/` | Where you clone each project repo. Git ignores it here; each project is its own repo |

## Quick start

1. Install [Claude Code](https://claude.com/claude-code) (or your harness of choice), [GitHub CLI](https://cli.github.com/) and `jq`. Sign in with `gh auth login`.
2. Clone this repo and launch from its root, **always**:
   ```
   gh repo clone nick-secai84/secai84
   cd secai84
   claude
   ```
3. Clone the project you're working on: `/checkout splunk-enrichment-addon` (or `gh repo clone nick-secai84/splunk-enrichment-addon repos/splunk-enrichment-addon`).
4. Read the project's `README.md` and `CLAUDE.md`, then [docs/contributing.md](docs/contributing.md).

Launching from the root is what gives the agent every rule, decision and shared tool, whichever project you're touching.

## Projects

| Repo | What it is |
|---|---|
| [splunk-enrichment-addon](https://github.com/nick-secai84/splunk-enrichment-addon) | A Splunk add-on that enriches indicators in searches and notable events from pluggable threat-intel providers |
| [tines-enrichment-stories](https://github.com/nick-secai84/tines-enrichment-stories) | Importable Tines stories (built on Community Edition) for indicator lookup, check-before-acting, and investigate-and-wait |

## License

MIT. See [LICENSE](LICENSE).
