This is the meta-repository for SecAI84, a training program in agentic software development. **No source code goes in this folder.** It holds the program's rules, cross-project decisions and shared agent tooling. Each project has its own repository in [repos/](repos/).

This repository contains:
* Program and workspace design in [docs/](docs/). Start with [docs/system-design.md](docs/system-design.md), then [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
* The program outline: [docs/program.md](docs/program.md). How participants work: [docs/contributing.md](docs/contributing.md)
* Architectural Decision Records in [adrs/](adrs/) (template: [adrs/TEMPLATE.md](adrs/TEMPLATE.md))
* The decision framework: [docs/DECISION_FRAMEWORK.md](docs/DECISION_FRAMEWORK.md), which says when to act and when to ask
* Multi-phase runbooks and their phase handoffs in [docs/runbooks/](docs/runbooks/)
* Shared agents and skills in [.claude/](.claude/) (mirrored for other harnesses in [.agents/](.agents/))

Always run Claude Code (or any agent harness) from this folder's root so this context is loaded. **If you are working from a subfolder, still apply the relevant docs/ and adrs/.**

**Committing:** `repos/*` are separate git repositories. Commit changes to `repos/<name>` from inside that repo, using `git -C repos/<name> ...`. A commit run from the root goes to the meta-repo, which is the wrong repo. Before any write, check `git -C <path> remote get-url origin`.

## Outside companies: public surfaces only

Projects integrate with products made by other companies: SIEMs, SOAR platforms, threat-intel providers, and the Context MCP server. SecAI84 participants are outside developers to every one of those companies, and they work the way any outside developer does.

**Prohibited in any SecAI84 repo, issue, PR, or agent output:** any company's non-public source code, secrets or credentials, customer data, or internal service names, architecture, or detection logic. Also prohibited: committing to any company's private repository.

**Permitted:** public APIs, public SDKs, public docs and public repos, used under each product's own terms, with each user's own account and keys.

**When a project needs something a vendor's API doesn't offer, write a feature request, not a workaround.** Use [docs/templates/feature-request.md](docs/templates/feature-request.md) (or `/feature-request`), and file it through the vendor's public channel. Keep the request at the level of what the API should do for the caller. Don't send designs for the vendor's internals, and don't send patches to non-public code.

**The test:** *could anyone outside that company write, read, or do this using only public material?* If not, it doesn't belong here.

Governing decision: [ADR-20261102 public surfaces only](adrs/20261102-integrations-via-public-surfaces.md).

**For agents specifically:** if a task seems to need a vendor's internals (a private repo, an undocumented endpoint, a schema that isn't public), stop and draft a feature request instead. Never guess at internals and present the guess as fact. If you find non-public material from any company in a SecAI84 repo, report it to the program owner; don't spread it further by quoting it.

## Projects are useful on their own

Every project is open source (MIT) and must be useful to the wider security community. Each external service is one option behind the project's own interface, and no single vendor's product is required to use the project.

**The test:** *does this project still make sense to someone who doesn't use a given provider?* If not, rescope it before you build it.

**For agents specifically:** put every provider behind the same interface, and make sure at least one free or freely available option works first.

## Participant personal data never goes into a repo

Names beyond a GitHub handle, emails, phone numbers, addresses, employment details, enrollment and payment records, and assessments of individual participants stay out of every repository, issue and PR. That includes the meta-repo. Public commit metadata (the author name and email a participant chooses for git) is the only exception.

**The test:** *would this line tell a stranger something about a participant that their public GitHub profile doesn't?* If so, it doesn't go in.

**For agents specifically:** don't write participant details into docs, memory files that get committed, test fixtures or examples. Use made-up data in fixtures and mark it as made up.

## Access to anyone else's private systems is a one-way door

Giving a participant (or a participant's agent) access to any company's private repositories, private data, cloud accounts or credentials requires the program owner's explicit approval at the CLI first. A participant signing up for a product's public free tier with their own account is not "access" in this sense.

**For agents specifically:** never invite collaborators, share tokens, add deploy keys, or widen access to anything outside SecAI84's own public repos. If a task needs it, stop and ask.

## Working agreement

* The default is to go fast. For two-way-door decisions: decide, act, and report what you decided and why.
* One-way doors (see [docs/DECISION_FRAMEWORK.md](docs/DECISION_FRAMEWORK.md)): stop and ask the program owner at the CLI. Name the decision, its consequence and the cost of undoing it, and record the approval in the PR description.
* When local tests pass, push and open the PR in the same turn. A PR is how CI runs and how the cohort sees the work.
* Merge only when every check is green. Merge with squash. Never bypass a check, admin-merge, or rerun a flaky check until it passes. Fix the flake or report it.
* Verify the real thing: run the tool, call the real API with a test account, and exercise the failure path. Unit tests and logs alone don't prove a feature works.
* Every subagent brief includes: "If a command is denied, do not work around it with another tool or a throwaway script, and never disable the sandbox; list leftovers in your report."
* Secrets live in environment variables or a secrets manager, never in files you write. A hook blocks writes to `.env`.
* When the same correction comes up twice, promote it: write an ADR or add a rule here, and where possible enforce it with a lint, a hook, or a test.
