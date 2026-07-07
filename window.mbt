///|
/// Fixed-size integer window for streaming monitoring examples.
pub(all) struct DriftWindow {
  spec : BucketSpec
  capacity : Int
  values : Array[Int]
} derive(Eq, Debug)

///|
pub fn DriftWindow::new(spec : BucketSpec, capacity : Int) -> DriftWindow {
  { spec, capacity: if capacity > 0 { capacity } else { 1 }, values: [] }
}

///|
pub fn DriftWindow::push(self : DriftWindow, value : Int) -> DriftWindow {
  let next : Array[Int] = []
  let start = if self.values.length() + 1 > self.capacity {
    self.values.length() + 1 - self.capacity
  } else {
    0
  }
  for i = start; i < self.values.length(); i = i + 1 {
    next.push(self.values[i])
  }
  next.push(value)
  { spec: self.spec, capacity: self.capacity, values: next }
}

///|
pub fn DriftWindow::histogram(self : DriftWindow) -> Histogram {
  Histogram::new(self.spec).add_many(self.values)
}

///|
pub fn DriftWindow::length(self : DriftWindow) -> Int {
  self.values.length()
}
