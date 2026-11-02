# ADR-20261102: Meta-repo workspace for all SecAI84 projects

**Status:** Accepted
**Date:** 2026-11-02
**Approver:** Program owner
**Author:** Nick

## Context
SecAI84 participants build several open-source projects at once with AI agents doing much of the work. An agent is only as autonomous as the context it can see. It needs the program's hard rules, the decision framework and the shared tooling in every session, whichever project it's touching.

## Decision
One public meta-repo (`nick-secai84/secai84`) holds the rules, docs, ADRs and shared agents and skills, and no source code. Each project is its own repo, cloned into the meta-repo's git-ignored `repos/` folder. Agents always launch from the meta-repo root.

## Alternatives Considered

| Option | Why Not Chosen |
|--------|----------------|
| Monorepo with all projects | Projects have different languages, release cycles and users. A user who wants one connector shouldn't clone them all. |
| Independent repos with copied rules | The copies drift. A rule fixed in one place stays broken in the others. |
| Git submodules | Extra ceremony for participants; detached-HEAD surprises; agents mishandle them. |

## Consequences

**Positive:** Every session sees every rule. Cross-project changes happen in one session. Shared skills and agents live in one place.
**Negative / Risks:** The meta-repo is itself a git repo, so a bare `git commit` from the root goes to the wrong repo. CLAUDE.md says so, and the agents use `git -C <repo>` after checking the remote.
**Migration Path:** Cheap. Each project repo is already self-contained. Copy the rules each one needs into its own CLAUDE.md and archive the meta-repo.
