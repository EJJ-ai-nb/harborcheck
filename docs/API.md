# API Notes

## Data Model

`ProjectSnapshot` is the single input boundary. A caller can collect real repository files with any external tool, then pass their contents to HarborCheck without giving the library file-system or network access.

Important fields:

- `moon_mod`: raw `moon.mod` text;
- `readme`: raw `README.md` text;
- `ci_workflow`: raw GitHub Actions workflow text;
- `examples`, `tests`, `commands`: concise evidence strings for runnable examples, test paths and verification commands;
- `commit_count`, `repository_public`, `mooncakes_published`: release trace signals.

## Main Functions

- `parse_manifest(text)` extracts the Mooncakes identity and package metadata.
- `audit(snapshot)` returns an `AuditReport`.
- `audit_markdown(snapshot)` returns a Markdown report.
- `audit_json(snapshot)` returns a compact JSON summary.
- `release_checklist(snapshot)` returns actionable remediation steps.
- `example_snapshot()` returns a complete fixture for demos and smoke tests.

## Report Semantics

`AuditReport.score` starts at 100 and subtracts rule penalties. `ready` requires zero failed checks and a score of at least 90. `almost-ready` allows at most two failures and a score of at least 75. Everything else is `needs-work`.

`AuditReport::repair_steps()` filters the report to non-passing findings and marks failed checks as blocking. `AuditReport::to_release_checklist()` renders those steps as Markdown for maintainers.
