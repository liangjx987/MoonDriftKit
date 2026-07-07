# Related Work

MoonDriftKit avoids overlap with existing MoonBit packages by focusing on
drift monitoring rather than general statistics, charting, JSON processing, or
machine learning.

## Differentiation

- Chart and SVG libraries visualize data; MoonDriftKit produces deterministic
  monitoring reports that such libraries can render.
- Dataframe or collection libraries store and transform rows; MoonDriftKit only
  keeps compact histograms and recent windows.
- General math/statistics packages expose formulas; MoonDriftKit packages a
  practical data-quality workflow around baseline/current comparison, alert
  levels, and JSON evidence.
- Model libraries train or run inference; MoonDriftKit monitors whether the
  input distribution has moved after deployment.

## Intended Users

- MoonBit service developers who want lightweight runtime quality gates.
- Tool authors building dashboards or CI checks.
- Data pipeline authors who need repeatable regression evidence.
- Teaching projects explaining distribution drift without large dependencies.
