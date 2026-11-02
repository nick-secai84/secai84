# Architecture

## Workspace layout

```
secai84/                  ← meta-repo; always launch agents from here
├── CLAUDE.md, AGENTS.md  ← rules for every agent, every repo
├── docs/                 ← program, design, standards, templates, runbooks, specs
├── adrs/                 ← decisions, YYYYMMDD-slug.md
├── .claude/              ← shared skills, subagents, project hooks
├── .agents/              ← the same generic skills for other harnesses
└── repos/                ← each project cloned here (git-ignored)
    ├── CLAUDE.md         ← standards every project meets
    ├── splunk-enrichment-addon/   ← its own git repo
    └── tines-enrichment-stories/  ← its own git repo
```

## How instructions layer

From most general to most specific, each layer has one job:

1. **User settings** (`~/.claude/settings.json`): your permission mode, deny rules and plugins. Personal, never committed.
2. **Root `CLAUDE.md`**: hard rules true everywhere, each with a reason and a test.
3. **`repos/CLAUDE.md`**: standards every project repo meets.
4. **Project `CLAUDE.md` / `AGENTS.md`**: that project's commands and conventions.
5. **Memory**: what the agent has learned about how *you* like to work. Personal, never committed.

If it should bind every contributor, commit it to a CLAUDE.md or a doc. If it's one person's preference, it goes in memory.

## Shared tooling: thin skill → subagent → compact report

* A **skill** (`.claude/skills/<name>/SKILL.md`) works out its arguments, runs a quick pre-flight, and dispatches a subagent.
* A **subagent** (`.claude/agents/<name>.md`) does the long, noisy work in its own context and returns one compact table. Each one says what it does **not** do.

| Skill | Agent | What it does |
|---|---|---|
| `/checkout <repo>` | — | Clone a project into `repos/` (user-only) |
| `/pull-all` | — | Fast-forward every clean repo under `repos/` (user-only) |
| `/sync-main` | `repo-housekeeper` | After a merge: fast-forward main, delete merged branches |
| `/drive-pr` | `pr-driver` (+ `resolve-copilot`, `triage-ci-failure`) | Loop review rounds and CI fixes until the PR merges on green |
| `/resolve-copilot` | `resolve-copilot` | One round of Copilot review threads |
| `/phase-handoff` | — | Write the kickoff prompt for the next session of a multi-phase project |
| `/feature-request` | — | Draft an API-customer-level feature request to an outside vendor |

## Guardrails held by machinery, not memory

* `.claude/settings.json` hooks block writes to `.env` and format written files (gofmt, ruff, prettier, when installed).
* Branch rulesets on every repo's `main`: no force-push or deletion, squash merges only, conversations resolved, CI required.
* CI on every PR, so "merge on green" means something.

## Project architecture pattern

Every project follows the same shape. The details are each team's call:

```
source adapter(s) ──▶ core logic ──▶ provider interface ──▶ provider adapters (VirusTotal, Context, ...)
   (SIEM, SOAR)                                             ──▶ sink adapter(s) (write results back)
```

**TBD per project:** language, packaging, configuration format.
