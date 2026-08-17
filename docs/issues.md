# Issue Record

## HC-001 Package Identity Consistency

- Problem: Mooncakes owner/package, README and `moon.mod` can drift.
- Decision: Parse `moon.mod` and compare it with snapshot metadata.
- Status: Implemented in 0.1.0.

## HC-002 README Completeness

- Problem: Reviewers need purpose, install, usage, API, scope, tests and license in one place.
- Decision: Use keyword and heading evidence instead of full Markdown parsing.
- Status: Implemented in 0.1.0.

## HC-003 CI Reproducibility

- Problem: A project may have tests but no automatic reviewer-visible workflow.
- Decision: Check for MoonBit installation plus `moon check`, `moon build`, `moon test` and smoke run commands.
- Status: Implemented in 0.1.0.

## HC-004 Report Export

- Problem: Humans need Markdown, integrations need JSON.
- Decision: Provide both exporters from the same `AuditReport`.
- Status: Implemented in 0.1.0.

## HC-005 README Example Proof

- Problem: README examples may look complete but fail to show a runnable MoonBit shape.
- Decision: Add `extract_doc_snippets` and `doc_proof` to identify fenced MoonBit examples with runnable signals.
- Status: Implemented in 0.1.1.

## HC-006 Source Provenance Proof

- Problem: Code, data, assets or generated text can be reused without clear source and license evidence.
- Decision: Add `SourceEvidence` records and report unclear origin or license issues.
- Status: Implemented in 0.1.1.

## HC-007 Project Boundary Adjustment

- Problem: A broad release-readiness description can overlap with other release-audit tools.
- Decision: Make README example verification and provenance proof the primary scope; keep submission checklist checks as auxiliary functionality.
- Status: Implemented in 0.1.1.
