module GMeans

using Query
using ..Imports

export call

function call(values)
  gmeans_instance = gmeans.gmeans(values).process()
  clusters = gmeans_instance.get_clusters()
  centers = gmeans_instance.get_centers()

  cluster_results = size(clusters, 1) <= 1 ? mapslices(x -> [x], clusters, dims=2)[:] : clusters

  Dict(:clusters => cluster_results |> @map(x -> x |> @map(values[_+1]) |> collect) |> collect,
       :centers => mapslices(x -> [x], centers, dims=2)[:])
end

end
