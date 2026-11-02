Each immediate subfolder is a separate git repository for a single project. Documents generally don't go in this folder; they belong in the right project repo, or in the meta-repo.

Cross-project decisions go in [../docs](../docs) or [../adrs](../adrs). Project-specific decisions go in that repo's `docs/` or `adrs/`.

## Every repo MUST have

* `README.md`: what the project is for, who would use it, how to install and run it, and current status. Someone new should be able to pick it up from the README alone.
* `CLAUDE.md`: commands (setup, test, run), layout, key files, conventions. Keep it short and link to `docs/architecture.md` if it needs more.
* `AGENTS.md`: a harness-neutral pointer ("Read CLAUDE.md; it applies to any agent runtime"), the 3–6 rules that must not be missed, and "the root `../../CLAUDE.md`, `docs/` and `adrs/` bind here too".
* `LICENSE`: MIT, copyright SecAI84 LLC and contributors. Don't change the license without an ADR and the program owner's approval (see `../docs/DECISION_FRAMEWORK.md`).
* `docs/data-catalog.md`: the data the project consumes, produces and stores, including what it sends to each third-party provider. This is how a user judges what leaves their network.
* `Makefile` with `up`, `down`, `test` and `ci` targets. `make ci` is exactly what CI runs.
* `.github/workflows/ci.yml` that runs `make ci` on every PR and on pushes to `main`. Agents may merge only on green, so a repo without CI can't be merged autonomously.

## Standards

* **Providers behind an interface.** Every threat-intel provider (VirusTotal, AbuseIPDB, urlscan.io, the Context MCP, and so on) sits behind one project-defined interface. None is a hard dependency, and a free or freely available one works first.
* **Outside products through public surfaces only.** Public APIs, SDKs and docs, with each user's own account. A missing capability becomes a feature request (`../docs/templates/feature-request.md`), not a workaround. See "Outside companies: public surfaces only" in `../CLAUDE.md`.
* **Dependency pinning.** Every dependency resolves to an exact version at build time. Commit a lockfile in the same change, or pin inline where an ecosystem has no lockfile (GitHub Actions by commit SHA, Docker images by version or digest). No `:latest`, `main` or floating tags. See [`../docs/dependency-pinning.md`](../docs/dependency-pinning.md).
* **Secrets only from the environment.** API keys come from environment variables or the user's secret store. `.env.example` lists the names with empty values, and the real `.env` is gitignored. Tests never need a real key: use fakes or recorded fixtures, with made-up data marked as such.
* **Tests in CI need no network.** Live-API checks are a separate, opt-in target (for example `make test-live`) that reads keys from the environment.
* **Add when needed:** `docs/budget.md` once a project runs paid infrastructure, and `docs/telemetry.md` once it emits metrics. Write the standard into `../docs/` first.
