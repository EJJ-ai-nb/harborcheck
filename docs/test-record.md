# Test Record

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
