module Histogram
using StatsBase

export fit

function fit(values, nbins=15)
  fitted = StatsBase.fit(StatsBase.Histogram, values, nbins=nbins, closed=:left)
  vcat(hcat(fitted.edges[1][1:end-1]...), hcat(fitted.weights...))
end

end
