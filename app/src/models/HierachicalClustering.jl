module HierachicalClustering
using Clustering, Distances, Statistics, LinearAlgebra

export fit

function fit(records, labels, dist_type, linkage, normalized=false)
  if normalized
    values = records./sum(records, dims=1)
  else
    values = records
  end
  matrix = nothing
  if dist_type == :euclidean
    matrix = pairwise(Euclidean(), values, dims=1)
  elseif dist_type == :mahalanobis
    cov_i = cov(values)
    matrix = pairwise(Mahalanobis(cov_i, skipchecks=false), values, dims=1)
  elseif dist_type == :cosine
    matrix = pairwise(CosineDist(), values, dims=1)
  end

  clustering = hclust(matrix, linkage=linkage, branchorder=:optimal)
  result = []
  cache = Dict()
  for (i, x) in enumerate(mapslices(x -> [x], clustering.merges, dims=2)[:])
    left, right = nothing, nothing
    if x[1] < 0
      left = labels[abs(x[1])]
    else
      left = pop!(cache, x[1])
    end

    if x[2] < 0
      right = labels[abs(x[2])]
    else
      right = pop!(cache, x[2])
    end

    result = [left, right]
    get!(cache, i, result)
  end

  result
end

end
