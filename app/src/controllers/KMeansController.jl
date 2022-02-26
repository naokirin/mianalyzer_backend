module KMeansController
using DataFrames, Query
using ..KMeans
using JSON

export call

"""
call(message)

Computes k-means from records.

# Arguments
- `message::Dict`: the arguments dict
  - `"records"`: the array of array of rows
  - `"cluster_num"``: cluster number

# Return
the json string of result object

# Examples
```jldoctest
julia> KMeansController.call(Dict("cluster_num" => 2, "records" => [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]))
"{\"centers\":[[1.5,1.5,1.0],[3.0,0.0,9.0]],\"clusters\":[[[1.0,2.0,0.0],[2.0,1.0,2.0]],[[3.0,0.0,9.0]]]}"
```
"""
function call(message)
  records = message["records"] |> collect
  cluster_num = message["cluster_num"]
  kmeans_result = KMeans.call(records, cluster_num)

  Dict(
    :clusters => kmeans_result[:clusters],
    :centers => kmeans_result[:centers]
  ) |> JSON.json
end
end
