---
name: feature-request
description: Use when a SecAI84 project needs something a vendor's public API (a SIEM, SOAR platform, threat-intel provider, or the Context MCP) doesn't offer. Drafts an ordinary API-customer feature request from docs/templates/feature-request.md, for a person to review and file through the vendor's public channel. Never files it itself.
argument-hint: "[project-name] [vendor] [one-line need]"
allowed-tools: Read, Write, Grep, Glob
---

You draft a feature request to an outside vendor. SecAI84 participants are outside developers to every vendor they integrate with. They ask for capabilities the way any API customer would, and the vendor decides whether and how to build them. See "Outside companies: public surfaces only" in `CLAUDE.md`.

## Steps

1. Work out the project (from `$ARGUMENTS`, or the repo under `repos/` the conversation is about), the vendor, and the need. If one of them isn't clear from the conversation, ask one question, then go on.
2. Check that the public surface really can't do it: read the vendor's public API reference, or ask the user to confirm what they tried. If an existing call covers the need, say so and stop.
3. Fill in `docs/templates/feature-request.md`. Write the draft to `repos/<project>/docs/feature-requests/YYYYMMDD-<vendor>-<slug>.md`, in the project repo, not the meta-repo.
4. Before you hand it over, self-check every line against these rules, and fix what fails:
   - It describes what the API should do for the caller, not how the vendor should build it.
   - It names no internal services, schemas or code of the vendor's. It cites only public docs.
   - It includes no participant personal data and no secrets.
   - "How we'll cope without it" is filled in, so the project doesn't depend on the vendor saying yes.
5. Tell the user where the draft is, and the vendor's public channel for filing it: its public issue tracker, community forum, or feedback form. For the Context MCP that is https://github.com/everydaysecurity-ai/context-osint-mcp/issues/new. **They** review and file it. Don't file it yourself: posting to another company's channel is outward-facing.

You do NOT open issues, post comments, or contact any vendor by any channel.
