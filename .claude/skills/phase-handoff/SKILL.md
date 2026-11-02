---
name: phase-handoff
description: Use when a phase/tranche session of a multi-phase project is ending and the next phase will run in a fresh session, when the user asks for a handoff or kickoff prompt for the next phase, or when an existing handoff needs revising after plan deviations. Applies to any runbook/tranche-plan-driven project (one session per phase); or with --with-opus-plan when the next phase will be planned in plan mode (Opus) before a cleared-context execution (Sonnet); or with --session <name> to dispatch the prompt straight into an already-open, named session instead of writing a file.
argument-hint: "[<runbook-or-plan path> <phase-id>] [--with-opus-plan] [--session <name>] (optional — inferred from the session if omitted)"
---

You author the kickoff **handoff prompt** for the next phase of a multi-phase project. SecAI84 executes one session per phase — two with `--with-opus-plan` (plan, then cleared-context execute): the next session starts with **zero context**, and the handoff prompt is the only bridge. Everything the next session must know — and must NOT re-derive or re-litigate — goes in the prompt. The authoring work is identical regardless of delivery: the prompt is either written to a file for the operator to paste, or dispatched directly into an already-open, named session with `--session`.

**The register to hit:** dense over long (every line earns its place); decisions framed as settled, not open; assumptions that went stale corrected in place; every reading-list item paired with what to extract from it. The template beside this skill encodes this shape — follow its section guidance rather than inventing structure.

## Step 1 — Gather

Collect, verifying every claim against the live tree (not memory):

- The runbook/plan: the next phase's tranche rows, gates, dependencies, and the progress table.
- The ending session's reality: what merged (PR numbers, commit SHAs), what deviated from the plan and why, what tripped you up (these become Deviations and Gotchas), open threads (unresolved review items, in-flight owner actions).
- Linear issue ids and states for the phase.
- Locked decisions: ADR clauses, owner rulings from this or earlier sessions — with where each is recorded.
- Relevant memory files (name them; the next session READS them, it does not re-derive them).

## Step 2 — Author from the template

Copy `template.md` (beside this skill) and fill it. The file has two parts: a short header block (context for a human browsing the repo — NOT pasted into the session) and, below the `---`, the **verbatim kickoff prompt**.

Consider every template section; not all apply to every phase. Drop a section deliberately, never silently — if it's empty because there's genuinely nothing (e.g., no deviations yet for phase 0), either omit it or write "None yet."

## --with-opus-plan — plan-first phases

Use when the next phase is decision-heavy (unresolved design choices, cross-repo
impact, owner sign-offs pending) and will run as: Opus plans in plan mode →
operator approves → the approved plan is saved to a file (the SESSION MODEL
block mandates this as the session's first post-approval action) → Sonnet
executes in a cleared-context session from that file alone. The clear is an
operator action nothing enforces — the plan file plus the stand-alone contract
make the handoff hold either way. If the flag wasn't given but the next phase
looks decision-heavy, ask the operator which model applies rather than assuming.

Authoring deltas (all marked in the template):
- Opener verb becomes "Plan `<PHASE-ID>` ..." — the prompt briefs a planner.
- Include the SESSION MODEL block with its section list unabridged; it makes the
  plan document a handoff in its own right (opener "Execute ...", handoff-shaped
  sections, obligations copied forward).
- Retitle UPCOMING DECISIONS → DECISIONS TO LOCK IN PLANNING and make it
  exhaustive — it is the planner's worklist, annotated with who decides.
- THIS PHASE gives scope/objectives + decision inputs, not step-by-step tasks —
  steps are the planner's job; pre-specifying them anchors the planner.

## --session `<name>` — dispatch straight into an open session

Use when the operator already has the next session open and named (`/rename <name>`)
and wants the prompt delivered into it rather than written to a file and pasted.
Authoring is unchanged — this changes DELIVERY only, plus the three template deltas
below. There is no handoff file, and none in the close-out PR; that PR still carries
the runbook progress-table edit, Linear updates, and any code.

Needs `ListAgents` + `SendMessage` (Claude Code ≥ 2.1.224, macOS/Linux). If they are
deferred in your session, load them first: ToolSearch `select:ListAgents,SendMessage`.
If they do not exist at all the feature is unavailable — say so and use file delivery.

Pre-flight — all of it before you send:
1. Resolve the target: call `ListAgents` and find the row whose name matches `<name>`
   EXACTLY. Not there → STOP and ask the operator to open/rename it; never guess,
   never send to a near-match. Two rows share the name → use that row's `[ref]`, or
   ask the operator which one.
2. With --with-opus-plan: confirm with the operator that the target is on Opus with
   plan mode ON before sending. (SESSION MODEL's plan-mode check makes a mis-set
   target fail safe, but it costs a round trip.)
3. Permission boundaries are per-session: nothing in the brief may ask the receiver to
   do something denied or blocked in YOUR session — a peer doing it for you launders
   the operator's decision. Route blocked items back to the operator instead.

Send it as ONE `SendMessage` call. Never split a brief across messages: messages drain
at the receiver's next tool round, so it can start acting on part 1 before part 2
lands, and a partial brief is worse than none. `summary`: `<PHASE-ID> kickoff brief`.
`message`: the DISPATCH PREAMBLE followed by the whole below-the-`---` prompt.

Template deltas (all marked in the template):
- Prepend the DISPATCH PREAMBLE block — it redirects authority to the operator in the
  receiving session.
- Omit the header block entirely; it exists for a human browsing a file, and there is
  no file.
- BEFORE ENDING THE SESSION takes its delivery-agnostic wording — the receiver cannot
  know whether ITS successor session will exist.

Do not ask the receiver to acknowledge. The dispatch is fire-and-forget: the operator
is watching the target session, and a failed send is visible to them. After sending,
distinguish the outcomes and record each one where the phase's durable state lives
(close-out note and/or the phase memory) — never write a bare "DISPATCHED" line for
an outcome that was not a confirmed clean send:
- Clean return → tell the operator the target name and that the brief is in flight,
  and that the target session is where to watch it land. Record: handoff for
  `<PHASE-ID>` DISPATCHED to session `<name>` on `<DATE>`, no file by design.
- Held (you get a notice) → NOT a failure, but NOT delivery yet either. Tell the
  operator to approve it in the target session. Do not re-send and do not write a
  file — a later release would leave the receiver holding two briefs. Record: handoff
  for `<PHASE-ID>` PENDING to session `<name>` on `<DATE>`, held for operator
  approval, no file by design. PENDING is not a resting state — resolve it before the
  phase is considered handed off:
  - Confirmed released (operator approved it) → overwrite the line with DISPATCHED.
  - Confirmed NOT released — the operator denies or dismisses the hold, or the target
    session closes/ends before approving — is a terminal failure, not an open
    PENDING. Overwrite the line to FAILED (held, never approved) and fall back to
    file delivery so the handoff still lands somewhere.
  - No confirmation yet when THIS session ends → leave the line PENDING, but say so
    to the operator explicitly as an open item needing follow-up, not a completed
    step — a stale PENDING that nobody is tracking is the same failure as marking it
    DISPATCHED outright, just delayed.
- Error, or the name never resolved → fall back to file delivery and say why. Record
  the file delivery per the file-delivery path above, not a dispatch line — nothing
  was sent, so nothing is DISPATCHED, PENDING, or FAILED.

A missing record leaves a later session hunting for "the `<PHASE-ID>` handoff" finding
nothing and concluding the step was skipped. A record that says DISPATCHED when the
send was actually held or failed is worse: it tells that session the bridge exists
when it does not.

## Step 3 — Quality gate (all must pass)

- **Self-contained:** a reader with zero context can execute. No "as discussed", no unexplained codenames; every referenced path, id, and command verified to exist.
- **No secrets:** never paste tokens, decrypted parameter values, credentials, or anything a redaction rule elsewhere forbids committing. Point to where a secret lives; never inline it.
- **Locked decisions are load-bearing:** each phrased as settled ("FINAL — do not re-litigate") with a pointer to where it's recorded.
- **Stale assumptions corrected explicitly:** if something the plan or an earlier phase believed is no longer true, say so in place ("the old X is STALE: ...") — silence lets the next session act on it.
- **Ambiguity posture stated:** the prompt tells the next session to re-verify against the live tree and to ask the operator rather than guess.
- **Dense, not long:** every line earns its place. Target ≤ ~2 pages.
- **(--with-opus-plan) Contract intact:** SESSION MODEL block present with the section list unabridged; the PLAN DELIVERY save-path is concrete (real handoffs dir + slug + phase — only the time stamp + entropy suffix are minted at write time); the decisions worklist is exhaustive; THIS PHASE contains no step-level prescriptions.
- **(--session) Dispatch-safe:** DISPATCH PREAMBLE present and unmodified; the whole brief fits one message; nothing in it asks the receiver to do what was blocked in your session; no reference to a handoff-file path that will never be written; the durable-state record's status (DISPATCHED / PENDING / FAILED / none) matches the actual, currently-known send outcome, never optimistically marked DISPATCHED for a held or failed send, and never left as a stale PENDING once the hold's outcome becomes known.

## Step 4 — Deliver

- (file delivery) Default location: next to the runbook/plan it serves — meta-repo cross-cutting projects: `docs/runbooks/handoffs/<runbook-slug>-<phase>.md`; product-repo projects: the repo's own plans/runbooks directory. Commit it with the phase's close-out PR (from the owning repo).
- (file delivery) Tell the user the file path and that the block below the `---` is pasted **verbatim** as the next session's first prompt.
- (--session) Dispatch per the `--session` section above, then report by outcome —
  "no file was written" is true for clean and (currently) held sends only:
  - Clean or still-held: report the target session name and the outcome (clean /
    held), state plainly that no file was written yet, and say where the
    outcome-matched record (DISPATCHED / PENDING) was written — for PENDING, flag it
    to the operator as an open item still needing resolution, not a completed step.
  - Error, or the name never resolved: no send was ever attempted, so this is
    ordinary file delivery — follow the (file delivery) bullets above and say why
    the session path wasn't used. Write no DISPATCHED/PENDING/FAILED line; there is
    no dispatch attempt to have a status.
  - A hold later confirmed FAILED (denied, dismissed, or the target session closed
    before approving): a send WAS attempted and terminally didn't land — follow the
    (file delivery) bullets above, say why the session path didn't complete, AND
    overwrite the existing PENDING line with FAILED, pointing at the file that now
    actually carries the handoff.
- (--with-opus-plan) File delivery: tell the user to start the next session on Opus in plan mode (e.g. /model opusplan) and paste the block verbatim. Dispatch: before sending, confirm with the operator that the target is already on Opus in plan mode. Either way, on approval the session saves the plan to a NEW uniquely-named file (time stamp + entropy-source suffix minted at write time, announced only after the write succeeds; uniqueness enforced by never-overwrite + re-mint, never assumed of the suffix) and hands them the exact one-line kickoff (`Execute the plan at <that path>`); do not /clear before that file exists. A never-saved plan has no path anyone can hold, so a skipped save stays file-not-found and no kickoff line can ever point at changed or rebound content. In-session execution also works; the plan file still governs and the retained context is harmless redundancy.
- The template's final section obligates the NEXT session to produce its successor handoff with this skill — its wording is delivery-agnostic (file or dispatch), so keep that section in as written.
