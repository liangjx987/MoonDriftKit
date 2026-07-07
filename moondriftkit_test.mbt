///|
test "bucket spec maps values into fixed ranges" {
  let spec = BucketSpec::new(0, 100, 5)
  assert_eq(spec.index_of(-10), 0)
  assert_eq(spec.index_of(0), 0)
  assert_eq(spec.index_of(19), 0)
  assert_eq(spec.index_of(20), 1)
  assert_eq(spec.index_of(99), 4)
  assert_eq(spec.index_of(120), 4)
}

///|
test "histogram counts values and basis point shares" {
  let hist = Histogram::new(BucketSpec::new(0, 100, 4)).add_many([5, 8, 30, 55])
  assert_eq(hist.total, 4)
  assert_eq(hist.count_at(0), 2)
  assert_eq(hist.count_at(1), 1)
  assert_eq(hist.share_bp_at(0), 5000)
}

///|
test "drift report classifies shifted distributions" {
  let spec = BucketSpec::new(0, 100, 5)
  let reference = Histogram::new(spec).add_many([5, 15, 25, 35, 45])
  let current = Histogram::new(spec).add_many([65, 75, 85, 95, 99])
  let report = compare_histograms(reference, current)
  assert_true(report.level == Drift)
  assert_true(report.is_alert())
  assert_true(report.score_bp >= 8000)
  assert_eq(report.buckets.length(), 5)
}

///|
test "drift report keeps close windows stable" {
  let spec = BucketSpec::new(0, 100, 5)
  let reference = Histogram::new(spec).add_many([10, 20, 30, 40, 50])
  let current = Histogram::new(spec).add_many([11, 21, 31, 41, 51])
  let report = compare_histograms(reference, current)
  assert_true(report.level == Stable)
  assert_false(report.is_alert())
}

///|
test "drift window keeps the most recent values" {
  let spec = BucketSpec::new(0, 100, 5)
  let window = DriftWindow::new(spec, 3).push(10).push(20).push(30).push(90)
  let hist = window.histogram()
  assert_eq(window.length(), 3)
  assert_eq(hist.total, 3)
  assert_eq(hist.count_at(0), 0)
  assert_eq(hist.count_at(1), 2)
  assert_eq(hist.count_at(4), 1)
}

///|
test "json exports are deterministic" {
  let spec = BucketSpec::new(0, 100, 2)
  let reference = Histogram::new(spec).add_many([10, 20])
  let current = Histogram::new(spec).add_many([80, 90])
  let report = compare_histograms(reference, current)
  assert_true(reference.to_json().contains("\"counts\":[2,0]"))
  assert_true(report.to_json().contains("\"level\":\"drift\""))
  assert_true(report.to_json().contains("\"score_bp\":10000"))
}

///|
test "level names are stable public strings" {
  let spec = BucketSpec::new(0, 10, 2)
  let stable = compare_histograms(
    Histogram::new(spec).add_many([1, 2]),
    Histogram::new(spec).add_many([1, 2]),
  )
  assert_eq(stable.level_name(), "stable")
}

///|
test "strict policy can escalate borderline movement" {
  let spec = BucketSpec::new(0, 100, 5)
  let reference = Histogram::new(spec).add_many([
    5, 10, 25, 30, 35, 45, 50, 55, 65, 75,
  ])
  let current = Histogram::new(spec).add_many([
    5, 10, 25, 30, 35, 45, 50, 85, 65, 75,
  ])
  let default_report = compare_histograms(reference, current)
  let strict_report = compare_histograms_with_policy(
    reference,
    current,
    DriftPolicy::strict(),
  )
  assert_true(default_report.level == Watch)
  assert_true(strict_report.level == Drift)
}
