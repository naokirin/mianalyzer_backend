module KMeans

using Query, DataFrames, Clustering

export call

function score(centers, X)
  dmat = Distances.pairwise(Distances.SqEuclidean(), centers, X)
  sum(findmin(dmat; dims=1)[1])
end

function kmeans_internal(values, X, cluster_num)
  result = kmeans(X, cluster_num; maxiter=300, display=:none)
  df = DataFrame(index=1:length(values), data=values)
  centers = mapslices(x->[x], result.centers, dims=1)[:]
  clusters = df |>
               @groupby(result.assignments[_.index]) |>
               @map(x -> x |> @map(typeof(_.data) <: Array ? _.data : _.data.value) |> collect) |>
               collect
  (centers, clusters)
end

function call(values, cluster_num)
  X = hcat(values...)
  centers, clusters = (nothing, nothing)
  score = nothing
  for i in 1:100
    centers_, clusters_ = kmeans_internal(values, X, cluster_num)
    if isnothing(score) || score > score(centers_, clusters_)
      centers, clusters = (centers_, clusters_)
    end
  end

  Dict(:clusters => clusters, :centers => centers)
end

end
