module Correlogram
using StatsBase

export call

function call(values)
  lags = 0:(size(values, 1)-1)
  vcat(hcat(lags...), hcat(StatsBase.autocor(values, lags)...))
end

end
