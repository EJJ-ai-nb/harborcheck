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
- Submission checklist: CI, tests, examples, public repository and Mooncakes metadata.

## Why not a generic parser

The project does not try to be a complete Markdown parser or command executor. Those are broad and unsafe surfaces. HarborCheck focuses on the subset needed to prove that MoonBit documentation examples and source records are reviewable.

## Differentiation

Release-oriented tools usually automate versioning, publishing, repository inspection or package readiness scoring. HarborCheck is narrower: it verifies README code blocks and provenance records, then keeps release checklist checks as supporting evidence. This makes the project useful even before publishing, inside documentation review, classroom examples, CI proof generation and open-source compliance checks.
