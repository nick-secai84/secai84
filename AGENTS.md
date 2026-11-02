# AGENTS.md

Read [CLAUDE.md](CLAUDE.md). Its rules apply whatever agent runtime you are (Claude Code, Codex, Cursor, or anything else). Shared skills for other harnesses are in [.agents/skills/](.agents/skills/).

The rules you must not miss:

1. **This folder holds no source code.** Projects live in `repos/<name>`, each its own git repo. Commit with `git -C repos/<name>`, after checking `git -C repos/<name> remote get-url origin`.
2. **Outside companies only through public surfaces.** Public APIs, SDKs, docs and repos, with each user's own account. Never use any company's non-public code, data, secrets or internal names. When a vendor's API lacks something, write a feature request (`docs/templates/feature-request.md`), not a workaround.
3. **Every provider sits behind the project's own interface.** No single vendor's product is required, and a free option works first.
4. **No participant personal data in any repo.**
5. **One-way doors need the program owner's approval at the CLI first.** See `docs/DECISION_FRAMEWORK.md`.
6. **Merge only on green CI.** Never bypass checks, and never work around a denied command.

The docs in [docs/](docs/) and the decisions in [adrs/](adrs/) bind here too.
