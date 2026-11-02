# Program outline

> **Status: draft.** The program owner sets the final syllabus.

**Format:** 4 weeks, 10–20 hours a week, building open-source (MIT) projects in small teams. Each week's practice is learned by using it on a real project, not in a separate exercise.

**Who it's for:** experienced software engineers who want to work the way agent-heavy teams work now: setting direction and hard lines, delegating the typing, and verifying the result.

## Week 1: The workspace is the product

Set up and understand the environment that makes an agent trustworthy.

* Launch from the meta-repo root. Read `CLAUDE.md`, `AGENTS.md`, `docs/DECISION_FRAMEWORK.md` and the ADRs. Explain in your own words why each hard rule has a test attached.
* Pick a project. Clone it with `/checkout`, run `make ci`, and open your first PR (even a README fix). Watch CI gate it, then merge on green.
* Make the project's first two-way-door decisions (language, layout, test framework) and record them in the project README.
* Start building your memory: when you correct the agent, have it save the correction with its reason.

**Done when:** you have merged a PR that CI gated, and your project has a stated language, layout and `make ci` that runs real (if tiny) tests.

## Week 2: Brainstorm → spec → plan → test-first build

Turn a fuzzy goal into working, tested code without hand-holding the agent line by line.

* Brainstorm a feature with the agent, then write the spec to `docs/specs/` in the project.
* Write an implementation plan and execute it test-first. Small PRs, each merged on green.
* Define the project's provider interface and ship one free provider that works end to end.
* Write your first ADR for a decision others will copy.

**Done when:** one real feature works end to end against a real service, behind an interface, with tests in CI.

## Week 3: Delegation: subagents, skills, PR loops

Make long work stay coherent: push noisy work into subagents and let tooling drive PRs to merge.

* Use `/drive-pr` to take a PR through review rounds and CI to merge. Read the `pr-driver` agent to see how it stops itself.
* Use `triage-ci-failure` on a red build. Fix the cause, not the symptom.
* Add a second provider (for example the Context MCP) behind the same interface. Where a vendor's API falls short, file a feature request with `/feature-request`.
* Write one new skill or agent your team needed (thin skill → subagent → compact report).

**Done when:** at least two providers work behind one interface, and your team has added one piece of shared tooling.

## Week 4: Ship and hand off

Leave the project in a state a stranger could pick up.

* Verify the real thing: install from a clean machine, run against live services, exercise the failure paths.
* Cut a pre-1.0 release (publishing to a public registry is a one-way door, so ask first).
* Write the runbook for what's left and end with `/phase-handoff`, so the next cohort's first session starts with everything it needs.
* Promote your team's repeated corrections into CLAUDE.md, a lint, or a test.

**Done when:** a new contributor could start from the README and the handoff alone.

## Open items (program owner)

* Final syllabus and session schedule
* Participation and contributor terms for the cohort
* How cohort communication works (channel, office hours)
