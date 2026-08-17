# Research Notes

Date: 2026-08-17

## Mooncakes Search

Checked `https://mooncakes.io/api/v0/modules`.

- Exact `harborcheck` match before first publication: 0.
- Exact package name `EJJ-ai-nb/harborcheck` before first publication: 0.

Closest keyword groups found in Mooncakes:

- `audit`: packages tend to focus on audit rules, module checks or domain-specific validation.
- `release`: packages tend to focus on versioning, publish flow or release automation.
- `mooncakes`: packages include protocol helpers, examples or package workflow utilities.

## Differentiation

HarborCheck is not a general release automation CLI, package publisher, repository crawler, TOML parser, YAML parser or full Markdown parser.

HarborCheck now focuses on one primary boundary: documentation and provenance proof for MoonBit packages. It validates evidence that is easy to miss during review:

- fenced README / docs code blocks;
- MoonBit runnable example signals;
- owned code records;
- third-party source URL records;
- license clarity for code, data and assets;
- Markdown proof reports for maintainers;
- auxiliary checklist checks for CI, tests, examples and Mooncakes metadata.

This keeps HarborCheck complementary to packages that automate releases or inspect modules. The reusable value is in proving that documentation examples and source records are reviewable, not in taking over the publish process.

## Naming Decision

The name `HarborCheck` is retained because the package is already published under `EJJ-ai-nb/harborcheck`, but the meaning is narrowed: checking whether the materials entering a MoonBit project harbor have reproducible examples and clear provenance.
