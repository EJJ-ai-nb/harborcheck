# HarborCheck Design

## Goal

HarborCheck turns MoonBit package release readiness into deterministic data checks. The library is intentionally pure: it does not read files, call GitHub, call Mooncakes or shell out to `moon`. This keeps the core reusable in CLI tools, CI jobs, web pages and tests.

## Boundary

The boundary is `ProjectSnapshot`. External adapters are responsible for collecting repository files and command results. HarborCheck is responsible for interpreting that evidence, scoring it, and producing reports.

## Rule Groups

- Package config: validates Mooncakes-compatible name, SemVer version, README path, repository URL, SPDX license and description.
- README: checks project identity, problem statement, install command, usage example, API, support scope, unsupported scope, verification commands and license notes.
- CI: checks MoonBit installation plus `moon check`, `moon build`, `moon test` and runnable examples.
- Tests/examples: checks evidence for normal, invalid, boundary and export paths.
- Release trace: checks public repository, commit count, Mooncakes publication signal, changelog, design notes and issue records.

## Why not a generic parser

The project does not try to be a TOML, YAML or Markdown parser. Those are broad formats. HarborCheck focuses on the subset needed for MoonBit package review, which keeps the code small enough to maintain and strict enough for repeatable validation.

## Differentiation

Existing release-oriented packages may automate versioning, publishing or repository inspection. HarborCheck keeps a narrower pure-library boundary: it audits a provided review snapshot and returns deterministic findings, score, Markdown/JSON reports and repair steps. That makes it easy to embed in other tools without taking over file-system access, network access or package publishing.
