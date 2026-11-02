# Decision framework

The default is **go fast**. Most decisions are two-way doors: if you don't like the result, you undo it. Make those decisions yourself, ship, and say what you decided and why.

A small class of decisions are **one-way doors**. They're expensive or impossible to undo, or they bind someone outside the team. For those, stop and get the program owner's approval first, then ship just as fast.

## Reversibility × impact

|                  | **Low impact**                  | **High impact**                     |
|------------------|---------------------------------|-------------------------------------|
| **Reversible**   | Just do it                      | Do it, and write down the pattern   |
| **Irreversible** | Do it, and record it in an ADR  | **Approval required before acting** |

**Shortcut:** if you couldn't undo it within a day, or it commits someone outside this repo (a user, a partner, a participant, a vendor), treat it as a one-way door.

## Examples

| Decision | Door | Action |
|---|---|---|
| Pick a language, framework or test library for a project | Two-way | Decide as a team, record it in the project's README |
| Change internal structure, rename modules, refactor | Two-way | Ship it |
| Add a provider behind an existing interface | Two-way | Ship it |
| Add a dependency with a permissive license (MIT, Apache-2.0, BSD) | Two-way | Ship it, pinned |
| Add a dependency with a copyleft (GPL, AGPL, LGPL, MPL) or unknown license | **One-way** | Ask first. The project ships as MIT |
| Change a project's license, or add contributor terms | **One-way** | Ask first, and write an ADR |
| Publish a package to a public registry (Splunkbase, the Tines library, PyPI, npm, Docker Hub) under a name | **One-way** | Ask first. Names are hard to take back |
| Freeze a plugin or provider interface that outside users build against (a 1.0 release) | **One-way** | Ask first, and write an ADR |
| Sign up for a vendor service on SecAI84's behalf, start a free trial, or anything that costs money or starts a contract clock | **One-way** | Ask first. A participant's own free-tier account is their call |
| Use another company's name or logo, or describe a partnership or endorsement, in public material | **One-way** | Ask first |
| Give anyone access to another company's private repos, data, accounts or credentials | **One-way** | Ask first (see `CLAUDE.md`) |
| Collect, store or publish anything about a participant beyond their public GitHub handle | **One-way** | Ask first (see `CLAUDE.md`) |
| Publish a participant testimonial or reference | **One-way** | Ask first |
| Create, rename, transfer, delete, or change the visibility of a GitHub repo | **One-way** | Ask first |
| Change branch rulesets or CI required checks | **One-way** | Ask first |

## How approval is given

Ask the program owner (Nick) at the CLI or in the cohort channel, in four lines:

1. What you want to do
2. Why
3. What it would cost to undo
4. The alternatives you considered (even "none yet" is fine)

A "yes" is recorded in the PR description that implements it. No answer means not yet; it never means go. If the decision sets a pattern other projects will follow, also write an ADR (`adrs/YYYYMMDD-slug.md`, from [the template](../adrs/TEMPLATE.md)).

## When to write an ADR

* Every approved one-way door
* Any decision other projects will copy
* Any time someone asks "why did we do X instead of Y?" and the answer isn't in the code

ADRs are records, not approvals, and they take 10–15 minutes. Amendments are new ADRs that supersede the old one. Don't edit an accepted ADR's decision.

## Making doors two-way

The cheapest approval is the one you don't need. Prefer designs that keep decisions reversible:

* **Interfaces in front of every external service.** Changing provider then means writing one adapter, not rewriting the project.
* **Small PRs.** A one-file change is a two-way door. A fifty-file change often isn't.
* **Pre-1.0 versioning.** Until an interface is frozen, say so in the README, so changing it stays cheap.
