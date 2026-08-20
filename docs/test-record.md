# Test Record

## 2026-08-20 Local Verification for 0.1.4

Environment:

- MoonBit: `moon 0.1.20260803`
- Target: default `wasm`

Commands:

```bash
moon check --deny-warn
moon build
moon test --deny-warn
moon fmt --check
moon doc
moon run examples/basic
moon run cmd/main
moon publish --dry-run
```

Result:

- `moon check --deny-warn`: passed.
- `moon build`: passed.
- `moon test --deny-warn`: 29 tests passed, 0 failed.
- `moon fmt --check`: passed.
- `moon doc`: passed.
- `examples/basic`: printed audit, identity proof, doc proof, maintenance evidence and final acceptance review.
- `cmd/main`: printed `HarborCheck ready 100/100`, `doc-proof=ready`, `maintenance=trace-ready` and `acceptance=acceptance-ready`.
- `moon publish --dry-run`: server returned `202 Accepted`; dry run completed successfully for `EJJ-ai-nb/harborcheck` version `0.1.4`, with no changes made.
- Effective MoonBit LOC after the maintenance-evidence extension: 4411 nonblank non-comment `.mbt` lines.

## 2026-08-20 Local Verification for 0.1.3

Result:

- `moon check --deny-warn`: passed.
- `moon build`: passed.
- `moon test --deny-warn`: 26 tests passed, 0 failed.
- `moon fmt --check`: passed.
- `moon doc`: passed.
- `examples/basic`: printed audit, identity proof, doc proof and final acceptance review.
- `cmd/main`: printed `HarborCheck ready 100/100`, `doc-proof=ready` and `acceptance=review-ready-with-notes`.
- `moon publish --dry-run`: server returned `202 Accepted`; dry run completed successfully for `EJJ-ai-nb/harborcheck` version `0.1.3`, with no changes made.
- Effective MoonBit LOC after the acceptance-review extension: 3631 nonblank non-comment `.mbt` lines.

## 2026-08-17 Local Verification

Environment:

- MoonBit: `moon 0.1.20260803`
- Target: default `wasm`

Commands:

```bash
moon check --deny-warn
moon build
moon test --deny-warn
moon fmt --check
moon run examples/basic
moon run cmd/main
```

Result:

- `moon check --deny-warn`: passed.
- `moon build`: passed.
- `moon test --deny-warn`: 22 tests passed, 0 failed.
- `moon fmt --check`: passed.
- `examples/basic`: printed audit report `100/100 ready` and doc proof `ready`.
- `cmd/main`: printed `HarborCheck ready 100/100` and `doc-proof=ready`.

## 2026-08-10 Local Verification

Environment:

- MoonBit: `moon 0.1.20260803`
- Target: default `wasm`

Commands:

```bash
moon check
moon build
moon test
moon run examples/basic
moon run cmd/main
```

Result:

- `moon test`: 20 tests passed, 0 failed.
- `examples/basic`: printed a Markdown audit report.
- `cmd/main`: printed `HarborCheck ready 100/100`.
