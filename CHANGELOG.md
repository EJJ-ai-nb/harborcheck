# Changelog

## 0.1.3 - 2026-08-20

- Added applicant identity consistency proof for submission text, GitHub owner, `moon.mod`, Mooncakes owner and git author evidence.
- Added final acceptance review model that combines repository audit, identity proof, documentation proof, CI status, Mooncakes status, commit trace and effective MoonBit LOC.
- Added Markdown and JSON exporters for final acceptance reports.
- Added example and CLI output for identity proof and acceptance review.
- Expanded tests from 22 to 26 cases.

## 0.1.2 - 2026-08-17

- Fixed the README minimum example fence so Mooncakes documentation rendering can parse the nested Markdown sample safely.
- Republished the adjusted documentation-proof package metadata.

## 0.1.1 - 2026-08-17

- Repositioned the project as a README example verifier and open-source provenance proof toolkit.
- Added `DocSnippet`, `SourceEvidence` and `DocProofReport`.
- Added Markdown fenced code block extraction for README / docs examples.
- Added runnable MoonBit example signal detection.
- Added provenance checks for source origin and license clarity.
- Added Markdown export for document proof reports.
- Added tests for runnable README examples and unclear external provenance.
- Updated README, submission document, API notes, design notes and research notes.

## 0.1.0 - 2026-08-10

- Added MoonBit-native project snapshot model.
- Added snapshot bundle parser for external repository collectors.
- Added public rule catalog and catalog Markdown export.
- Added `moon.mod` metadata extraction and validation.
- Added README, CI, test, example, Git trace, Mooncakes and license audit rules.
- Added Markdown and JSON report exporters.
- Added actionable repair steps and release checklist export.
- Added runnable `examples/basic` and `cmd/main` smoke entry.
- Added blackbox and whitebox tests for valid, invalid, boundary and export paths.
