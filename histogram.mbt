///|
/// Compact integer histogram used for baseline and current windows.
pub(all) struct Histogram {
  spec : BucketSpec
  counts : Array[Int]
  total : Int
} derive(Eq, Debug)

///|
pub fn Histogram::new(spec : BucketSpec) -> Histogram {
  { spec, counts: Array::make(spec.bucket_count(), 0), total: 0 }
}

///|
pub fn Histogram::add(self : Histogram, value : Int) -> Histogram {
  let index = self.spec.index_of(value)
  self.counts[index] = self.counts[index] + 1
  { spec: self.spec, counts: self.counts, total: self.total + 1 }
}

///|
pub fn Histogram::add_many(self : Histogram, values : Array[Int]) -> Histogram {
  let mut next = self
  for i = 0; i < values.length(); i = i + 1 {
    next = next.add(values[i])
  }
  next
}

///|
pub fn Histogram::count_at(self : Histogram, index : Int) -> Int {
  if index >= 0 && index < self.counts.length() {
    self.counts[index]
  } else {
    0
  }
}

///|
pub fn Histogram::share_bp_at(self : Histogram, index : Int) -> Int {
  if self.total <= 0 {
    0
  } else {
    self.count_at(index) * 10000 / self.total
  }
}
