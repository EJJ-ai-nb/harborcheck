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

## Identity Proof Model

`SubmissionIdentity` describes the single canonical applicant identity that should appear consistently in the submission document, GitHub repository, Mooncakes namespace and git author evidence.

Important types:

- `SubmissionIdentity`: applicant name, phone, email, GitHub owner, repository name, Mooncakes owner and package name.
- `IdentityEvidence`: one observed value from a submission document, repository URL, `moon.mod`, Mooncakes metadata or git config.
- `IdentityFinding`: one pass, warning or failure for a single identity evidence item.
- `IdentityReport`: full score, verdict and evidence list.

Important functions:

- `identity_consistency(identity, evidence)` compares manually supplied evidence against the canonical identity.
- `acceptance_identity_report(identity, snapshot, submission_text)` derives evidence from `ProjectSnapshot`, `moon.mod`, submission text and git metadata.
- `acceptance_identity_markdown(...)` returns a reviewer-friendly Markdown identity proof.
- `IdentityReport::has_mismatch()` reports whether any identity evidence failed.
- `IdentityReport::to_json()` provides a compact machine-readable report.

Identity verdicts:

- `consistent`: every known evidence item matches.
- `needs-review`: unknown evidence keys were supplied but no mismatch was found.
- `identity-mismatch`: at least one observed value does not match the canonical identity.

## Final Acceptance Review

`final_acceptance_review` combines repository audit, identity proof, documentation proof and live submission signals into one result. It is intended for pre-acceptance notes, not for replacing GitHub, Mooncakes or `moon` commands.

Important types:

- `AcceptanceProfile`: effective MoonBit LOC, target LOC, CI status, Mooncakes build status, latest commit evidence, contest-period commit count and published version.
- `AcceptanceSignal`: one acceptance-level signal, such as green CI, successful Mooncakes build, identity consistency or scale below the reference target.
- `AcceptanceReview`: composed audit, identity, doc proof, acceptance signals, score and verdict.

Important functions:

- `final_acceptance_review(snapshot, identity, submission, markdown, sources, profile)` creates the full review.
- `final_acceptance_markdown(...)` exports Markdown evidence.
- `final_acceptance_json(...)` exports compact JSON evidence.
- `AcceptanceReview::has_hard_blockers()` identifies whether final acceptance has a blocking issue.
- `AcceptanceReview::line_gap()` returns the remaining effective LOC gap to the configured target.
- `AcceptanceReview::next_actions()` lists concrete remediation actions from non-passing signals.

Acceptance verdicts:

- `acceptance-ready`: no hard blocker, no warning and a high composed score.
- `review-ready-with-notes`: hard requirements pass but advisory items remain, such as code scale below the 4k reference.
- `blocked`: at least one hard acceptance signal failed.
- `needs-polish`: no hard blocker was found, but the composed score is too low for a confident final review.
