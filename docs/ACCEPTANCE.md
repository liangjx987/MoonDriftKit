# Acceptance Notes

MoonDriftKit is prepared as a compact but meaningful MoonBit ecosystem library.

## Verification

```text
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon run cmd/main
```

The project is backend-neutral and avoids platform IO in the library package.
The CLI package is separated under `cmd/main`.

## Implemented Scope

- `BucketSpec` for stable bucketing.
- `Histogram` for baseline/current windows.
- `compare_histograms` for drift reports.
- `DriftWindow` for fixed-size streaming windows.
- JSON report export.
- CLI demo and regression tests.
