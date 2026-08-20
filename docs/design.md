# HarborCheck Design

## Goal

HarborCheck turns README examples and open-source provenance evidence into deterministic MoonBit data checks. The library is intentionally pure: it does not read files, call GitHub, call Mooncakes or shell out to `moon`. This keeps the core reusable in CLI tools, CI jobs, web pages and tests.

## Core Boundary

The primary boundary is `doc_proof(markdown, sources)`.

External adapters provide Markdown text and source records. HarborCheck is responsible for:

- extracting fenced code blocks;
- identifying MoonBit snippets with runnable signals;
- checking whether each source record has origin and license evidence;
- producing a compact proof report for maintainers and reviewers.

## Auxiliary Boundary

`ProjectSnapshot` remains as an auxiliary submission-material checker. It verifies README, CI, package metadata, tests, examples, license and Mooncakes release signals, but it is no longer the only identity of the project.

## Proof Groups

- Documentation snippets: index, language, body, label and runnable signal.
- Source evidence: owned code, third-party code, dataset, asset and generated text records.
- License clarity: common OSI licenses plus open-data/open-asset license signals.
- Identity evidence: applicant, contact, GitHub, Mooncakes, `moon.mod` and git author records.
- Maintenance evidence: issues, test records, changelog entries, release records, CI runs, design decisions and license notes.
- Submission checklist: CI, tests, examples, public repository and Mooncakes metadata.
- Final acceptance signals: composed audit verdict, identity verdict, doc proof verdict, code scale, remote CI status, Mooncakes build status, commit trace and published version.

## Identity Proof Boundary

The identity layer is deliberately data-driven. It does not guess who owns a repository and does not read git config directly. An adapter can pass the canonical `SubmissionIdentity`, the submission text and optional git metadata. HarborCheck compares each observed value with the expected value and reports a deterministic `consistent`, `needs-review` or `identity-mismatch` verdict.

This boundary is useful for contests and package release workflows where one accidental account switch can invalidate otherwise good engineering work. The library keeps this logic separate from the repository audit so callers can use identity proof alone when reviewing application materials.

## Final Acceptance Boundary

`final_acceptance_review` composes three independent proofs:

- repository readiness from `audit`;
- applicant and namespace consistency from `acceptance_identity_report`;
- README example and provenance readiness from `doc_proof`.

It also accepts live evidence collected outside the library, including effective MoonBit LOC, latest GitHub Actions status, Mooncakes build status, latest commit author, contest-period commit count and published version. This keeps HarborCheck pure while still letting a CI job or local script build a single acceptance report.

The final verdict is intentionally conservative. Hard failures in CI, Mooncakes, identity or doc proof produce `blocked`. Scale below the reference target is treated as a warning because project usefulness and completeness matter more than padding source lines.

## Maintenance Evidence Boundary

`maintenance_review` models the development-process records that reviewers often need but that are easy to scatter across Markdown files and release pages. It does not connect to GitHub Issues or Mooncakes directly. Instead, callers pass `MaintenanceRecord` values collected by any adapter, and HarborCheck checks whether the set covers issue/work-item records, test records, changelog entries, release records, CI evidence, design decisions and license notes.

This boundary turns the hackathon's suggested retained materials into deterministic MoonBit data. A complete project should be able to show not only that the current code works, but also that its decisions, tests and release path are traceable for future maintainers.

## Why not a generic parser

The project does not try to be a complete Markdown parser or command executor. Those are broad and unsafe surfaces. HarborCheck focuses on the subset needed to prove that MoonBit documentation examples and source records are reviewable.

## Differentiation

Release-oriented tools usually automate versioning, publishing, repository inspection or package readiness scoring. HarborCheck is narrower: it verifies README code blocks and provenance records, then keeps release checklist checks as supporting evidence. This makes the project useful even before publishing, inside documentation review, classroom examples, CI proof generation and open-source compliance checks.
