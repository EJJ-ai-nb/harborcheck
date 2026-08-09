# Test Record

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

- `moon test`: 14 tests passed, 0 failed.
- `examples/basic`: printed a Markdown audit report.
- `cmd/main`: printed `HarborCheck ready 100/100`.
