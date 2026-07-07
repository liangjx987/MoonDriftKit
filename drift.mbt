///|
pub(all) enum DriftLevel {
  Stable
  Watch
  Drift
} derive(Eq, Debug)

///|
/// Per-bucket comparison in basis points.
pub(all) struct BucketDelta {
  index : Int
  lower : Int
  upper : Int
  reference_bp : Int
  current_bp : Int
  delta_bp : Int
} derive(Eq, Debug)

///|
/// Drift report comparing a baseline histogram with a current histogram.
pub(all) struct DriftReport {
  level : DriftLevel
  score_bp : Int
  max_delta_bp : Int
  shifted_buckets : Int
  reference_total : Int
  current_total : Int
  buckets : Array[BucketDelta]
} derive(Eq, Debug)

///|
pub fn compare_histograms(
  reference : Histogram,
  current : Histogram,
) -> DriftReport {
  let bucket_count = min_int(reference.counts.length(), current.counts.length())
  let deltas : Array[BucketDelta] = []
  let mut total_delta = 0
  let mut max_delta = 0
  let mut shifted = 0
  for i = 0; i < bucket_count; i = i + 1 {
    let reference_bp = reference.share_bp_at(i)
    let current_bp = current.share_bp_at(i)
    let delta = abs_int(current_bp - reference_bp)
    if delta > max_delta {
      max_delta = delta
    }
    if delta >= 500 {
      shifted = shifted + 1
    }
    total_delta = total_delta + delta
    deltas.push({
      index: i,
      lower: reference.spec.lower_bound(i),
      upper: reference.spec.upper_bound(i),
      reference_bp,
      current_bp,
      delta_bp: delta,
    })
  }
  let score = total_delta / 2
  {
    level: classify_drift(score, max_delta, shifted),
    score_bp: score,
    max_delta_bp: max_delta,
    shifted_buckets: shifted,
    reference_total: reference.total,
    current_total: current.total,
    buckets: deltas,
  }
}

///|
pub fn DriftReport::is_alert(self : DriftReport) -> Bool {
  match self.level {
    Drift => true
    _ => false
  }
}

///|
pub fn DriftReport::level_name(self : DriftReport) -> String {
  match self.level {
    Stable => "stable"
    Watch => "watch"
    Drift => "drift"
  }
}

///|
fn classify_drift(
  score_bp : Int,
  max_delta_bp : Int,
  shifted : Int,
) -> DriftLevel {
  if score_bp >= 2000 || max_delta_bp >= 2500 || shifted >= 4 {
    Drift
  } else if score_bp >= 800 || max_delta_bp >= 1200 || shifted >= 2 {
    Watch
  } else {
    Stable
  }
}

///|
fn abs_int(value : Int) -> Int {
  if value < 0 {
    -value
  } else {
    value
  }
}

///|
fn min_int(a : Int, b : Int) -> Int {
  if a < b {
    a
  } else {
    b
  }
}
