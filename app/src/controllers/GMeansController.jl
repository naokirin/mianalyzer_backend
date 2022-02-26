module GMeansController
using DataFrames, Query, Combinatorics
using ..GMeans
using JSON

export call

"""
call(message)

Computes g-means from records.

# Arguments
- `message::Dict`: the arguments dict
  - `"records"`: the array of array of rows

# Return
the json string of result object

# Examples
```jldoctest
julia> GMeansController.call(Dict("records" => [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]))
"{\"centers\":[[3.0,0.0,9.0],[2.0,1.0,2.0],[1.0,2.0,0.0]],\"clusters\":[[[3.0,0.0,9.0]],[[2.0,1.0,2.0]],[[1.0,2.0,0.0]]]}"
```
"""
function call(message)
  gmeans_result = message["records"] |> collect |> GMeans.call

  Dict(
      :clusters => gmeans_result[:clusters],
      :centers => gmeans_result[:centers]
  ) |> JSON.json
end
end
