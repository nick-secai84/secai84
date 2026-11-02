# ADR-20261102: Projects are MIT licensed

**Status:** Accepted
**Date:** 2026-11-02
**Approver:** Program owner
**Author:** Nick

## Context
SecAI84 projects are open-source coursework meant for wide reuse, including inside companies whose legal teams avoid copyleft. Participants, SecAI84 and the projects' users all need to be able to use the result without negotiation.

## Decision
Every SecAI84 repository is MIT licensed, copyright "SecAI84 LLC and contributors". Dependencies must be compatible with shipping under MIT. Copyleft or unknown-license dependencies need approval first.

## Alternatives Considered

| Option | Why Not Chosen |
|--------|----------------|
| Apache-2.0 | Explicit patent grant is nice, but MIT is simpler for participants and is the most common license for security tooling. Revisit if a project needs a patent grant. |
| GPL / AGPL | Discourages adoption by the security teams the projects are for. |

## Consequences

**Positive:** Maximum reuse; one license across every project; no per-project decision.
**Negative / Risks:** No patent grant; anyone may fork into closed products.
**Migration Path:** Relicensing needs every contributor's agreement, so treat a change as a one-way door. A participation/contributor agreement is still open (see `docs/program.md`).
