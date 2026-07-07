///|
fn main {
  let spec = @drift.BucketSpec::new(0, 100, 5)
  let baseline = @drift.Histogram::new(spec).add_many([
    42, 45, 47, 48, 50, 52, 53, 55, 56, 57,
  ])
  let current = @drift.Histogram::new(spec).add_many([
    62, 65, 68, 70, 73, 75, 78, 80, 83, 86,
  ])
  let report = @drift.compare_histograms(baseline, current)

  println("MoonDriftKit demo")
  println("level: \{report.level_name()}")
  println("score_bp: \{report.score_bp}")
  println("max_delta_bp: \{report.max_delta_bp}")
  println("shifted_buckets: \{report.shifted_buckets}")
  println(report.to_json())
}
