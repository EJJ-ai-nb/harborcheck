# Research Notes

Date: 2026-08-16

## Mooncakes Search

Checked `https://mooncakes.io/api/v0/modules`.

- Total modules returned: 1949.
- Exact `harborcheck` match: 0.
- Exact package name `EJJ-ai-nb/harborcheck`: 0.

Closest keyword groups found in Mooncakes:

- `audit`: includes packages such as `minie135/moon-audit`, `Noverberrain/moonmodguard`, `chenzehaoo/moon_guard`, `BeiLaDuo/cidr-audit`.
- `release`: includes packages such as `dijdzv/moon-release`, `LL728/moonseal`, `sheldonshi115/moon_doctor`.
- `mooncakes`: includes packages such as `Estrella-11/moondockit` and protocol or example packages.

## Differentiation

HarborCheck is not a general release automation CLI, package publisher, source scanner, TOML parser, YAML parser or documentation linter.

HarborCheck focuses on one boundary: a MoonBit package review snapshot. It validates the evidence reviewers ask for:

- `moon.mod` identity and metadata;
- README completeness;
- CI command coverage;
- runnable examples and tests;
- OSI license signal;
- Git trace and maintenance records;
- Mooncakes owner/package consistency;
- actionable repair checklist.

This keeps HarborCheck complementary to packages that automate releases, inspect modules, or provide lower-level parsers.

## Naming Decision

The name `HarborCheck` was chosen to avoid collision with existing `moon-*`, `moonguard`, `moon_doctor`, and `moon-release` style names while still describing the package's role: checking whether a MoonBit package is ready to enter the Mooncakes harbor.
