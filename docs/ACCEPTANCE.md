# Acceptance Notes

MoonDriftKit is prepared as a compact but meaningful MoonBit ecosystem library.

## Verification

```text
moon fmt --check
moon check --target all
moon build --target all
moon test --target all
moon info && git diff --exit-code -- '*.mbti'
moon run cmd/main
```

MoonBit toolchains that expose `--deny-warn` can replace the first and fifth
commands with `moon fmt --deny-warn` and `moon info --deny-warn`. The CI
detects the supported form so the declared quality gate remains strict across
toolchain releases.

The project is backend-neutral and avoids platform IO in the library package.
The CLI package is separated under `cmd/main`.

## Implemented Scope

- `BucketSpec` for stable bucketing.
- `Histogram` for baseline/current windows.
- `compare_histograms` for drift reports.
- `DriftWindow` for fixed-size streaming windows.
- `DriftPolicy` for configurable watch/drift thresholds.
- JSON report export.
- CLI demo and regression tests.
- Value-isolation regression coverage: adding to a derived `Histogram` cannot
  change the retained baseline.
