module GaussianMixture

using Distributed
using ..Imports

export fit

function fit(values, n_components=nothing)
  lowest_bic = Inf
  r = hcat(zeros(size(values, 1)), values)
  n_components_range = [1]
  if isnothing(n_components)
    n_components_range = 1:(size(values, 1) > 10 ? 10 : size(values, 1))
  else
    n_components_range = [n_components]
  end

  best_gmm = Nothing
  for n_comps in n_components_range
    gmm = mixture.GaussianMixture(n_components=n_comps, covariance_type="diag")
    gmm.fit(r)
    bic = gmm.bic(r)
    if bic < lowest_bic
      lowest_bic = bic
      best_gmm = gmm
    end
  end

  best_gmm
end

end
