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
  assert_eq(hist.count_at(0), 1)
  assert_eq(hist.count_at(1), 1)
  assert_eq(hist.count_at(4), 1)
}
