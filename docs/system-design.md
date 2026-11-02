# System design

How the pieces of SecAI84 fit together. The workspace is newly created, so anything not yet decided is marked **TBD**.

## The parts

| Part | What it is | Owner |
|---|---|---|
| `secai84` (this repo) | Meta-repo: rules, decisions, shared agent tooling, program outline | SecAI84 |
| Project repos (`splunk-enrichment-addon`, `tines-enrichment-stories`, ...) | Open-source (MIT) tools built by cohort teams | SecAI84 and contributors |
| Platforms the projects plug into | Splunk (SIEM), Tines (SOAR / workflow automation) | Their vendors |
| Threat-intel providers | VirusTotal, AbuseIPDB, urlscan.io, the [Context MCP](https://github.com/everydaysecurity-ai/context-osint-mcp), and others. All optional and pluggable | Their vendors |

## How data flows

```
   Splunk / Tines  ──indicators (domains, URLs, IPs, emails, phones)──▶  SecAI84 project  ──lookups──▶  provider A
         ▲                                                                │    ▲                         provider B
         └──────────────── enrichment, verdicts, evidence links ──────────┘    └──── results ────────────┘
```

* **Lookups:** a project asks one or more providers what's known about an indicator and writes the answer, with its sources, back into Splunk or the Tines story.
* **Submissions:** where a provider supports it (for example the Context MCP's `check_scam` or `start_investigation`), a project may submit an unknown indicator for analysis and pick up the result later, using the user's own account.

Each project's `docs/data-catalog.md` says exactly what data goes to which provider.

## Boundaries

* Every outside product is used only through its public surfaces (see `CLAUDE.md` and [ADR-20261102](../adrs/20261102-integrations-via-public-surfaces.md)).
* The user of a project supplies their own credentials for every platform and provider. Projects ship no shared keys.
* No SecAI84-operated infrastructure exists yet. **TBD:** whether any project needs hosted infrastructure. If one does, the IaC and budget standards get written first (see `repos/CLAUDE.md`, "Add when needed").
