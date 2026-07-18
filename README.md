# MoonDriftKit

MoonDriftKit is a zero-dependency MoonBit library for deterministic streaming
data-drift checks and histogram stability reports. It is intended for model
input monitoring, telemetry-quality gates, experiment guardrails, and data
pipeline regression checks.

## Install

```bash
moon add liangjx987/moondriftkit
```

## Minimal use

```moonbit
import "liangjx987/moondriftkit"

let spec = BucketSpec::new(0, 100, 5)
let baseline = Histogram::new(spec).add_many([42, 45, 48, 51, 54])
let current = Histogram::new(spec).add_many([70, 72, 75, 80, 86])
let report = compare_histograms(baseline, current)

assert_true(report.is_alert())
assert_eq(report.level_name(), "drift")
```

`Histogram` values are safe to retain as baselines: `add` returns a new value
without changing the source histogram.

## Verify from a clone

```bash
moon fmt --check
moon check --target all
moon build --target all
moon test --target all
moon info && git diff --exit-code -- '*.mbti'
moon run cmd/main
```

On toolchains that support the stricter flags, use `moon fmt --deny-warn` and
`moon info --deny-warn` instead. MoonBit 0.10.4 uses the equivalent checked
format and generated-metadata diff commands above.

## Scope

- Equal-width integer bucket specifications and compact histograms.
- Deterministic basis-point drift scores and stable/watch/drift policies.
- Fixed-size recent-value windows and reproducible JSON reports.
- A runnable CLI demonstration under `cmd/main`.

MoonDriftKit deliberately does not implement ingestion, dashboards, model
training, or a general dataframe engine. Those layers can consume the stable
report exported by this package.

See [README.mbt.md](README.mbt.md) for API-oriented package documentation,
[docs/ACCEPTANCE.md](docs/ACCEPTANCE.md) for acceptance evidence, and
[LICENSE](LICENSE) for the Apache-2.0 license text.

