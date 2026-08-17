# API Notes

## Doc Proof Model

`doc_proof` is the main boundary for README example verification and open-source provenance proof.

Important types:

- `DocSnippet`: one fenced Markdown code block, with index, language, body, label and runnable signal.
- `SourceEvidence`: one provenance record for owned code, third-party code, dataset, asset or generated text.
- `DocProofReport`: summary counts, verdict, snippets and source records.

## Doc Proof Functions

- `extract_doc_snippets(markdown)` extracts fenced code blocks from Markdown.
- `doc_proof(markdown, sources)` checks runnable MoonBit example signals and provenance clarity.
- `doc_proof_markdown(markdown, sources)` returns a Markdown proof report.
- `DocProofReport::to_markdown()` renders snippets and source evidence in reviewer-friendly form.

Verdicts:

- `ready`: at least one runnable MoonBit example signal and all source records are clear.
- `needs-examples`: no fenced code blocks were found.
- `needs-runnable-example`: snippets exist, but none look runnable as MoonBit examples.
- `needs-source-proof`: a source record is missing origin or license evidence.

## Snapshot Audit Model

`ProjectSnapshot` is the auxiliary submission-material boundary. A caller can collect repository files with any external tool, then pass their contents to HarborCheck without giving the library file-system or network access.

Important fields:

- `moon_mod`: raw `moon.mod` text;
- `readme`: raw `README.md` text;
- `ci_workflow`: raw GitHub Actions workflow text;
- `examples`, `tests`, `commands`: concise evidence strings for runnable examples, test paths and verification commands;
- `commit_count`, `repository_public`, `mooncakes_published`: submission trace signals.

## Snapshot Functions

- `parse_manifest(text)` extracts the Mooncakes identity and package metadata.
- `snapshot_from_bundle(text)` parses a simple `--- file: path` bundle format into a `ProjectSnapshot`.
- `rule_catalog()` returns the built-in rule metadata.
- `audit(snapshot)` returns an `AuditReport`.
- `audit_markdown(snapshot)` returns a Markdown report.
- `audit_json(snapshot)` returns a compact JSON summary.
- `release_checklist(snapshot)` returns actionable remediation steps.
- `example_snapshot()` returns a complete fixture for demos and smoke tests.

## Report Semantics

`AuditReport.score` starts at 100 and subtracts rule penalties. `ready` requires zero failed checks and a score of at least 90. `almost-ready` allows at most two failures and a score of at least 75. Everything else is `needs-work`.

`AuditReport::repair_steps()` filters the report to non-passing findings and marks failed checks as blocking. `AuditReport::to_release_checklist()` renders those steps as Markdown for maintainers.
