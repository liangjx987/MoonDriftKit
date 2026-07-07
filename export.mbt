///|
pub fn DriftReport::to_json(self : DriftReport) -> String {
  let buf = StringBuilder(size_hint=128 + self.buckets.length() * 96)
  buf.write_string("{\"level\":\"")
  buf.write_string(self.level_name())
  buf.write_string(
    "\",\"score_bp\":\{self.score_bp},\"max_delta_bp\":\{self.max_delta_bp},\"shifted_buckets\":\{self.shifted_buckets},\"reference_total\":\{self.reference_total},\"current_total\":\{self.current_total},\"buckets\":[",
  )
  for i = 0; i < self.buckets.length(); i = i + 1 {
    if i > 0 {
      buf.write_string(",")
    }
    let bucket = self.buckets[i]
    buf.write_string(
      "{\"index\":\{bucket.index},\"lower\":\{bucket.lower},\"upper\":\{bucket.upper},\"reference_bp\":\{bucket.reference_bp},\"current_bp\":\{bucket.current_bp},\"delta_bp\":\{bucket.delta_bp}}",
    )
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
pub fn Histogram::to_json(self : Histogram) -> String {
  let buf = StringBuilder(size_hint=64 + self.counts.length() * 16)
  buf.write_string(
    "{\"min\":\{self.spec.min},\"max\":\{self.spec.max},\"buckets\":\{self.spec.buckets},\"total\":\{self.total},\"counts\":[",
  )
  for i = 0; i < self.counts.length(); i = i + 1 {
    if i > 0 {
      buf.write_string(",")
    }
    buf.write_string(self.counts[i].to_string())
  }
  buf.write_string("]}")
  buf.to_string()
}
