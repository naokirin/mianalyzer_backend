module CorrelationsController
using DataFrames, StatsBase, Statistics, Query, Combinatorics
using ..Stats
using JSON

export call

"""
call(message)

Computes two column correlations of pearson and spearman from records.

# Arguments
- `message::Dict`: the arguments dict
  - `"records"`: the array of array of rows

# Return
the json string of result object

# Examples
```jldoctest
julia> CorrelationsController.call(Dict("records" => [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]))
"{\"spearman_correlations\":[-1.0,1.0,-1.0],\"correlations\":[-1.0,0.9522165814091075,-0.9522165814091075],\"combs\":[[1,2],[1,3],[2,3]]}"
```
"""
function call(message)
  _records = hcat(message["records"]...)

  combs = collect(combinations(1:size(_records, 1), 2))
  cors = []
  corsspearman = []
  for i = combs
    cors = vcat(cors, Statistics.cor(_records[i[1], :], _records[i[2], :]))
    corsspearman = vcat(corsspearman, StatsBase.corspearman(_records[i[1], :], _records[i[2], :]))
  end

  Dict(
        :combs => combs,
        :correlations => cors,
        :spearman_correlations => corsspearman
       ) |> JSON.json
end
end
