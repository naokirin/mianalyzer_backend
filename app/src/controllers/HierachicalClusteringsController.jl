module HierachicalClusteringsController
using DataFrames, Query
using ..HierachicalClustering
using JSON

export call

function charts(records, labels, normalized)
  results = []
  for dist_type in [:euclidean, :mahalanobis, :cosine]
    for linkage in [:ward, :average]
      result_records = HierachicalClustering.fit(records, labels, dist_type, linkage, normalized)
      results = vcat(results, Dict(:dist_type => dist_type,
                                   :linkage => linkage,
                                   :records => result_records))
    end
  end
  results
end

"""
call(message)

Computes hierachical clustering from records.

Differences for euclidean, mahalanobis and cosine.  
Linkages for ward and average.

# Arguments
- `message::Dict`: the arguments dict
  - `"records"`: the array of array of rows
  - `"labels"``: the labels of columns
  - `"normalized"`: needed to normalize values for columns

# Return
the json string of result object

# Examples
```jldoctest
julia> HierachicalClusteringsController.call(Dict("labels" => ["one", "two", "three"], "normalized" => true,  "records" => [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]))
"{\"charts\":[{\"dist_type\":\"euclidean\",\"linkage\":\"ward\",\"records\":[[\"one\",\"two\"],\"three\"]},{\"dist_type\":\"euclidean\",\"linkage\":\"average\",\"records\":[[\"one\",\"two\"],\"three\"]},{\"dist_type\":\"mahalanobis\",\"linkage\":\"ward\",\"records\":[[\"one\",\"two\"],\"three\"]},{\"dist_type\":\"mahalanobis\",\"linkage\":\"average\",\"records\":[[\"one\",\"two\"],\"three\"]},{\"dist_type\":\"cosine\",\"linkage\":\"ward\",\"records\":[[\"one\",\"two\"],\"three\"]},{\"dist_type\":\"cosine\",\"linkage\":\"average\",\"records\":[[\"one\",\"two\"],\"three\"]}]}"
```
"""
function call(message)
  records = hcat(convert.(Array{Any,1}, message["records"])...)'
  labels = message["labels"]
  normalized = message["normalized"]

  Dict(:charts => charts(records, labels, normalized)) |> JSON.json
end
end

