# MoonDriftKit

MoonDriftKit is a MoonBit foundation library for streaming data drift detection,
histogram stability reports, and deterministic monitoring evidence.

It is designed for model input monitoring, feature distribution checks,
telemetry quality gates, experiment guardrails, and data pipeline regression
tests.

## Core Features

- Equal-width integer bucket specifications.
- Compact baseline and current histograms.
- Basis-point distribution shares for deterministic cross-backend results.
- Drift reports with score, maximum bucket shift, shifted bucket count, and
  stable/watch/drift levels.
- Fixed-size streaming windows for recent values.
- Configurable drift policies for conservative or strict alerting.
- Stable JSON export for CI logs, dashboards, and reproducible review evidence.
- CLI demo for quick smoke testing.

## Quick Example

```mbt nocheck
///|
test {
  let spec = BucketSpec::new(0, 100, 5)
  let reference = Histogram::new(spec).add_many([42, 45, 48, 51, 54])
  let current = Histogram::new(spec).add_many([70, 72, 75, 80, 86])
  let report = compare_histograms(reference, current)

  assert_true(report.is_alert())
  assert_eq(report.level_name(), "drift")
}
```

## Streaming Window

```mbt nocheck
///|
test {
  let spec = BucketSpec::new(0, 100, 5)
  let window = DriftWindow::new(spec, 3).push(10).push(20).push(30).push(90)

  assert_eq(window.length(), 3)
  assert_eq(window.histogram().total, 3)
}
```

## Policy Tuning

```mbt nocheck
///|
test {
  let spec = BucketSpec::new(0, 100, 5)
  let reference = Histogram::new(spec).add_many([10, 20, 30, 40, 50])
  let current = Histogram::new(spec).add_many([10, 20, 30, 60, 90])
  let report = compare_histograms_with_policy(
    reference,
    current,
    DriftPolicy::strict(),
  )

  assert_true(report.level == Drift)
}
```

## Design Notes

MoonDriftKit intentionally uses integer basis points rather than platform
floating point math. This keeps reports stable across JavaScript, WebAssembly,
Wasm-GC, and native builds, which is important for CI and contest review.

The default score is a symmetric population shift score:

```text
score_bp = sum(abs(current_share_bp - reference_share_bp)) / 2
```

It is not a replacement for every statistical test. It is a small, inspectable
foundation for practical drift gates and data quality signals.

## Commands

```bash
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon run cmd/main
```

## Project Boundary

MoonDriftKit does not provide plotting, dataframe storage, model training, or
network ingestion. It focuses on the reusable drift-monitoring core that other
MoonBit tools can embed.
