module BasicStatisticsController
using DataFrames, Statistics, Query, Combinatorics
using ..Stats, ..Histogram
using JSON

export call

"""
call(message)

Computes mean, std, max, min and row count from records.

# Arguments
- `message::Dict`: the arguments dict
  - `"records"`: Array of array of rows

# Return
the json string of result object

# Examples
```jldoctest
julia> BasicStatisticsController.call(Dict("records" => [[1.0, 2.0, 3.0, 4.0], [2.0, 4.0, 6.0, 8.0]]))
"{\"means\":[1.5,3.0,4.5,6.0],\"row_count\":2,\"maxs\":[2.0,4.0,6.0,8.0],\"stds\":[0.7071067811865476,1.4142135623730951,2.1213203435596424,2.8284271247461903],\"mins\":[1.0,2.0,3.0,4.0]}"
```
"""
function call(message)
  records = hcat(convert.(Array{Any,1}, message["records"])...)

  row_count = Stats.count(records[1, :])
  means, stds, maxs, mins = [], [], [], []
  for i = 1:size(records, 1)
    means = vcat(means, Statistics.mean(records[i, :]))
    stds = vcat(stds, Statistics.stdm(records[i, :], means[i]))
    maxs = vcat(maxs, Stats.max(records[i, :]))
    mins = vcat(mins, Stats.min(records[i, :]))
  end

  Dict(
   :means => means,
   :stds => stds,
   :maxs => maxs,
   :mins => mins,
   :row_count => row_count
  ) |> JSON.json
end
end
