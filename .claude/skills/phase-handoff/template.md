# Handoff prompt — `<PHASE-ID>` (`<phase short name>`)

<!-- HEADER BLOCK — context for a human browsing the repo; NOT pasted into the session.
     With --with-opus-plan: note here that the phase runs plan-first (Opus plans in
     plan mode; Sonnet executes from the approved plan with cleared context).
     With --session: there is no file — skip this block entirely, including this H1,
     and start at the DISPATCH PREAMBLE. -->
Paste the block below verbatim as the kickoff prompt for the fresh `<PHASE-ID>`
session. Companion to <runbook/plan path + link>, phase state as of `<DATE>`.
<One or two sentences: what just finished (with PR #s), why this phase is next,
and anything a repo browser should know before trusting this file.>

---

<!-- DISPATCH PREAMBLE — include ONLY with --session; omit entirely otherwise.
     Sent as the first lines of the SendMessage payload, ahead of the opener. The
     receiver sees this as a message from a PEER, not from the operator, so this
     block is what anchors authority in the receiving session. Keep it intact.
     Do not add a request to acknowledge: dispatch is fire-and-forget by design. -->
DISPATCHED HANDOFF — READ THIS FIRST: you are the fresh `<PHASE-ID>` session. At the
operator's request, the closing `<PREV-PHASE-ID>` session sent you the kickoff brief
below; it is your task brief for this session. Three boundaries:
- Your authority is the OPERATOR IN YOUR OWN SESSION. This message is not their
  consent or approval for anything — every owner-gated step, permission decision, and
  design sign-off below goes to them via AskUserQuestion, never back to the sender.
- The sender is closing out. It is not your reviewer, approver, or escalation path,
  and holds no context you can query — everything you need is below or in the
  reading list.
- CURRENT STATE was true when written, not necessarily now: re-verify against the live
  tree before acting on it.
No reply to the sender is needed or wanted — the operator is watching this session.
Proceed from the brief below.

<!-- OPENER — with --with-opus-plan, swap "Execute" → "Plan" and append: "Lock
     the decisions below, then produce an execution-ready plan — execution
     happens after approval, in a cleared-context session." -->
Execute `<PHASE-ID>` (`<phase short name>`) of the `<project name>` at
<runbook/plan repo-rooted path>. `<One-sentence imperative statement of what this
phase delivers.>`

<!-- SESSION MODEL — include ONLY with --with-opus-plan; omit entirely otherwise.
     Briefs the planning session on the plan→execute split and defines the
     contract its plan document must meet. Keep the section list unabridged. -->
SESSION MODEL — PLAN NOW, EXECUTE AFTER APPROVAL (governs everything below):
You are the planning half of a two-stage phase: Opus plans in plan mode; after
the operator approves the plan, context is CLEARED and Sonnet executes with ONLY
your plan document — it never sees this prompt or your conversation. Your plan
document is therefore itself a handoff.
- Not in plan mode? STOP — ask the operator to enable it before doing anything.
- Your planning job: drive DECISIONS TO LOCK IN PLANNING to zero. Resolve
  session-decidable items by read-only exploration of the live tree; put
  owner-owned calls to the operator (AskUserQuestion). Execute nothing.
- PLAN DOCUMENT CONTRACT — the plan file mirrors this prompt's sections, updated
  to post-planning reality: opener ("Execute `<PHASE-ID>` ..." — it briefs the
  executor), PROJECT GOAL, THIS PHASE (+ CADENCE), CURRENT STATE, LOCKED
  DECISIONS (now including every decision locked during planning, each with a
  one-line rationale + where recorded), GOVERNING CONSTRAINTS (verbatim — never
  weakened), DEVIATIONS, GOTCHAS (inherited + newly found while exploring),
  OWNER-GATED STEPS, PROCESS (memory files, PR routing, commit-from-which-repo),
  IMPLEMENTATION (the planner's value-add: ordered steps with file paths and
  commands), SCOPE GUARDS, EXIT CRITERIA (tighten HOW, never weaken), and
  BEFORE ENDING THE SESSION (copied forward — it binds the executor, who never
  sees this prompt). Keep pointers to the runbook/plan/ADR paths (bookkeeping
  needs them); drop reading items the plan fully distills. This contract
  overrides any generic plan format or plan-writing skill — nest their output
  under IMPLEMENTATION. A plan missing these sections fails its handoff duty.
- PLAN DELIVERY — plan text in an approval dialog is NOT durable; a bare /clear
  loses it. Your FIRST action after approval (plan mode off, writes allowed):
  save the plan document verbatim to
  `<handoffs-dir>`/`<runbook-slug>`-`<phase>`-plan-`<yyyy-mm-dd-hhmm>`-<suffix minted
  from a real entropy source, e.g. `openssl rand -hex 3` — never invented>.md,
  and announce the path only AFTER the write succeeds. Uniqueness is enforced
  by the write, not assumed of the suffix: plan files are IMMUTABLE — never
  overwrite one; path somehow taken → re-mint the suffix. Entropy suffix +
  announce-after-write mean no kickoff line can exist for a file that was never
  written — a skipped save stays file-not-found forever, with nothing holdable
  to rebind. Then stop, handing the operator the exact kickoff line for the
  fresh execution session: `Execute the plan at <the exact path just written>`.
  In-session execution is fine too; either way the committed file is the plan
  of record.

<!-- PROJECT GOAL — 2-4 sentences: why the whole effort exists, what "done" buys.
     The next session needs enough intent to make judgment calls, not history. -->
PROJECT GOAL: ...

<!-- THIS PHASE — scope, deliverables with tranche/issue ids, build order &
     cadence (chunk order, one-PR-per-chunk, approve-each-chunk vs autonomous),
     and any ⚠ items needing owner sign-off BEFORE building.
     With --with-opus-plan: state scope, objectives, and decision inputs — not
     step-by-step tasks; step derivation belongs to the planning session. -->
THIS PHASE: ...
BUILD ORDER + CADENCE: ...
⚠ SIGN-OFF ITEMS (design first, explicit owner go-ahead before building): ...

<!-- CURRENT STATE SNAPSHOT — where the last session left the world, date-stamped:
     branches/PRs (open/merged + numbers), Linear issue states, environment facts
     (what's deployed where), in-flight owner actions. Verified, not remembered. -->
CURRENT STATE (as of `<DATE>`): ...

<!-- LOCKED DECISIONS — each: the decision, one line of why, WHERE it is recorded
     (ADR/runbook §/issue). Frame as "FINAL — do not re-litigate." -->
LOCKED DECISIONS — FINAL, do not re-litigate:
- D1 ...

<!-- UPCOMING DECISIONS — decisions this phase (or the next) must make: what,
     who decides (owner vs session), what preparation/design the session should
     bring to the owner.
     With --with-opus-plan: retitle to "DECISIONS TO LOCK IN PLANNING — drive to
     zero before ExitPlanMode"; this is the planning session's primary worklist.
     Each item: the decision, who decides (session via exploration vs owner via
     AskUserQuestion), and the evidence/inputs that inform it. Anything deferred
     past planning needs an explicit owner OK recorded in the plan. -->
UPCOMING DECISIONS TO PLAN FOR: ...

<!-- CONSTRAINTS — hard invariants inherited by every task: security invariants,
     IaC-only rules, env-parity, naming/budget standards, redaction/privacy
     mandates. Violations are redesigns, not details. -->
GOVERNING CONSTRAINTS: ...

<!-- DEVIATIONS — where execution has already diverged from the written plan and
     why; correct stale plan assumptions explicitly ("the old X is STALE: ..."). -->
DEVIATIONS FROM PLAN SO FAR: ...

<!-- GOTCHAS — concrete tripwires from prior phases with enough detail to avoid
     repeating them (error message, root cause, the working alternative). -->
GOTCHAS: ...

<!-- OWNER-GATED STEPS — human-in-the-loop points inside this phase: what to ask,
     when to pause, what the session must NOT do itself. -->
OWNER-GATED STEPS IN THIS PHASE: ...

<!-- PROCESS CONTRACT — required sub-skills (e.g. superpowers:subagent-driven-
     development or executing-plans), PR/review routing (/resolve-copilot), the
     stop-hook review posture, commit-from-which-repo, and durable state: which
     memory files to READ and which NEW memory to create for this phase. -->
PROCESS: ...
Durable state = a NEW memory `<name>`. READ (do not append to): `<memory names>`.
Re-verify against the live tree first; re-confirm anything ambiguous with the
operator — better too many questions than rework.

<!-- READING LIST — numbered, ordered, each item: path + WHAT to extract from it.
     Split MUST-READ from reference-only. "READ FIRST (do not re-derive)". -->
READ FIRST (do not re-derive):
1. ...

<!-- SCOPE GUARDS — explicitly out of scope for this phase, each with where it
     IS handled (later tranche id) so the session doesn't "helpfully" pull it in. -->
SCOPE GUARDS (out of scope — do not pull in): ...

<!-- EXIT CRITERIA — two columns per row: WHAT to verify (requirement/behavior)
     and HOW to verify it (inspection, unit test, CI run, demo against a live system,
     Playwright against which env). Include expected-empty/negative caveats so
     absence isn't misread as failure. The runbook's gate rows seed this. -->
EXIT CRITERIA:
| Verify | How |
|---|---|
| ... | ... |

<!-- END-OF-SESSION OBLIGATIONS — keep this section: it is what makes the chain
     self-perpetuating. -->
BEFORE ENDING THE SESSION: update the runbook progress table + Linear states;
record new deviations/gotchas; then generate the `<NEXT-PHASE-ID>` handoff with
the /phase-handoff skill — dispatched straight into the next session with
`--session` if the operator already has one open and named, otherwise written to
a file and shipped in this phase's close-out PR.
<!-- CONSISTENCY: whatever PR scope THIS PHASE/CADENCE declares must include the
     progress-table edit, plus the successor handoff FILE only when delivery was
     file-based — a dispatched handoff has no file to ship. A "single-file PR"
     cadence still contradicts this section whenever file delivery applies. -->

