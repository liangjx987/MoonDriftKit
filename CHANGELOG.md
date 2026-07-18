# Changelog

## 0.2.0 - 2026-07-18

### Fixed

- Made `Histogram::add` copy bucket storage before updating it, so deriving a
  histogram cannot mutate the caller's existing baseline.
- Added a regression test for histogram value isolation.

### Changed

- Updated the CLI package metadata and acceptance workflow for the current
  MoonBit toolchain.
- Documented reproducible install, import, build, test, and CLI steps.

## 0.1.0 - 2026-07-07

### Added

- Initialized MoonDriftKit as a MoonBit drift-monitoring foundation library.
- Added bucket specifications, histograms, drift reports, streaming windows,
  configurable policies, JSON export, tests, CLI demo, docs, and CI.
