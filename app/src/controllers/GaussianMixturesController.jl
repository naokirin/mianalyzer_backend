module GaussianMixturesController
using StatsBase, LinearAlgebra
using ..Stats, ..GaussianMixture
using JSON

export call

"""
call(message)

Computes gaussian mixtures from records.

# Arguments
- `message::Dict`: the arguments dict
  - `"records"`: the array of array of rows
  - `"components"`: component number (limitation: less than or equal to the row size)

# Return
the json string of result object

# Examples
```jldoctest
julia> GaussianMixturesController.call(Dict("components" => 2, "records" => [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]))
"{\"means\":[[2.499966642114253,0.9999999999999978],[0.5000333578858548,1.9999999999999956],[0.9999999999999991,8.99999999999998]],\"weights\":[[0.6666814927233754,0.3333185072766262],[0.6666814927234248,0.33331850727657647],[0.6666666666666674,0.3333333333333341]],\"stds\":[[0.5000454740003658,0.001000000001110223],[0.5000454740005074,0.0010000000044408921],[1.0000004999998753,0.0010000000852651246]]}"
```
"""
function call(message)
  records = hcat(convert.(Array{Any,1}, message["records"])...)
  components = message["components"]
  means, stds, weights, mins, maxs = [], [], [], [], []
  for i in 1:size(records, 1)
    values = convert(Array{Float64, 1}, view(records, i, :))
    best_gmm = GaussianMixture.fit(values, components)

    push!(means, best_gmm.means_[:, 2])
    covars = best_gmm.covariances_[:, 2]
    push!(stds, sqrt.(covars))
    push!(weights, best_gmm.weights_)
  end

  Dict(
       :means => means,
       :stds => stds,
       :weights => weights,
      ) |> JSON.json
end
end
