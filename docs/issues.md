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
