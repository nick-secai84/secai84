# Dependency pinning standard

Every third-party dependency (language packages, Docker images, GitHub Actions, CLI tools) resolves to **one exact version at build time**. A build that passed yesterday must build the same thing today. Agents merge on green, and that only means something if green is reproducible.

| Ecosystem | How to pin |
|---|---|
| Python | `uv` or `poetry` with the lockfile committed. Ranges in `pyproject.toml` are fine **with** a committed lock |
| Node | `package-lock.json` (or `pnpm-lock.yaml`) committed; `npm ci` in CI |
| Go | `go.mod` + `go.sum` committed |
| Docker | An explicit version tag, or better, a digest. Never `:latest` or `:stable` |
| GitHub Actions | A full commit SHA, with the version as a comment: `uses: actions/checkout@<sha> # v4.2.2` |
| CLI tools in CI | An explicit version in the install step |

**Anti-patterns to catch in your own review, before any tool flags them:** `:latest`, `@main` or `@master`, a lockfile change missing from a PR that changed a manifest, `pip install foo` with no version, `curl | sh` installers in CI.

**Bumps:** update deliberately, one ecosystem per PR, with the lockfile in the same change. A version bump is a two-way door, but a license change in a bump is not (see `DECISION_FRAMEWORK.md`).
