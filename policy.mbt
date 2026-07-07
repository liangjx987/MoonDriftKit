///|
/// Tunable thresholds for classifying drift reports.
pub(all) struct DriftPolicy {
  watch_score_bp : Int
  drift_score_bp : Int
  watch_max_delta_bp : Int
  drift_max_delta_bp : Int
  watch_shifted_buckets : Int
  drift_shifted_buckets : Int
} derive(Eq, Debug)

///|
pub fn DriftPolicy::default() -> DriftPolicy {
  {
    watch_score_bp: 800,
    drift_score_bp: 2000,
    watch_max_delta_bp: 1200,
    drift_max_delta_bp: 2500,
    watch_shifted_buckets: 2,
    drift_shifted_buckets: 4,
  }
}

///|
pub fn DriftPolicy::strict() -> DriftPolicy {
  {
    watch_score_bp: 400,
    drift_score_bp: 1000,
    watch_max_delta_bp: 800,
    drift_max_delta_bp: 1800,
    watch_shifted_buckets: 1,
    drift_shifted_buckets: 2,
  }
}

///|
pub fn DriftPolicy::classify(
  self : DriftPolicy,
  score_bp : Int,
  max_delta_bp : Int,
  shifted : Int,
) -> DriftLevel {
  if score_bp >= self.drift_score_bp ||
    max_delta_bp >= self.drift_max_delta_bp ||
    shifted >= self.drift_shifted_buckets {
    Drift
  } else if score_bp >= self.watch_score_bp ||
    max_delta_bp >= self.watch_max_delta_bp ||
    shifted >= self.watch_shifted_buckets {
    Watch
  } else {
    Stable
  }
}
