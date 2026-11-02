# ADR-20261102: Outside products are integrated through public surfaces only

**Status:** Accepted
**Date:** 2026-11-02
**Approver:** Program owner
**Author:** Nick

## Context
SecAI84 projects integrate with products made by other companies: SIEMs, SOAR platforms, threat-intel providers, and the Context MCP server. Participants need one clear, testable line for what they may use from those companies and how they ask for changes. The projects should also be useful to people who don't use any particular provider.

## Decision
1. Projects use outside products only through public surfaces: public APIs, SDKs, docs and repos, under each product's own terms, with each user's own account and keys.
2. When a project needs a capability a vendor doesn't offer, a participant files an ordinary API-customer feature request (`docs/templates/feature-request.md`) through the vendor's public channel. The vendor decides whether and how to build it.
3. Every project puts each provider behind the project's own interface, and ships a free or freely available option first.

## Alternatives Considered

| Option | Why Not Chosen |
|--------|----------------|
| Use private access a vendor might grant | Hard to revoke cleanly when a cohort ends, and the result can't be reproduced by the project's users. |
| Single-vendor projects | Less useful to the community, and fragile when that vendor changes terms. |
| Send vendors detailed designs or patches | The vendor's product design is the vendor's job. Requests stay at the "what the API should do for me" level, like any API customer's. |

## Consequences

**Positive:** A one-line test for every case. No outside company's secrets or non-public code ever enter SecAI84 repos. Anything a project does, its users can do too.
**Negative / Risks:** Some integrations wait on a vendor shipping a requested feature. Projects design around what's public today.
**Migration Path:** Widening access later needs a new ADR and explicit approval (it's a one-way door per `docs/DECISION_FRAMEWORK.md`).
