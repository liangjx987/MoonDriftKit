///|
/// Equal-width integer bucket specification.
pub(all) struct BucketSpec {
  min : Int
  max : Int
  buckets : Int
} derive(Eq, Debug)

///|
pub fn BucketSpec::new(min : Int, max : Int, buckets : Int) -> BucketSpec {
  guard max > min && buckets > 0 else { return { min: 0, max: 1, buckets: 1 } }
  { min, max, buckets }
}

///|
pub fn BucketSpec::bucket_count(self : BucketSpec) -> Int {
  self.buckets
}

///|
pub fn BucketSpec::index_of(self : BucketSpec, value : Int) -> Int {
  if value <= self.min {
    0
  } else if value >= self.max {
    self.buckets - 1
  } else {
    let width = self.max - self.min
    let shifted = value - self.min
    let index = shifted * self.buckets / width
    if index >= self.buckets {
      self.buckets - 1
    } else {
      index
    }
  }
}

///|
pub fn BucketSpec::lower_bound(self : BucketSpec, index : Int) -> Int {
  self.min + (self.max - self.min) * index / self.buckets
}

///|
pub fn BucketSpec::upper_bound(self : BucketSpec, index : Int) -> Int {
  if index + 1 >= self.buckets {
    self.max
  } else {
    self.min + (self.max - self.min) * (index + 1) / self.buckets
  }
}
