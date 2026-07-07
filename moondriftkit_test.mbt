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
