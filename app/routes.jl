@time using MianalyzerBackend: TimeSeriesController, CorrelationsController, BasicStatisticsController, GaussianMixturesController, KMeansController, GMeansController, HierachicalClusteringsController

function handler(f, jsonpayload)
  return f(jsonpayload)
end

function routes(path, payload)
  if path == "/time_series"
    return handler(TimeSeriesController.call, payload)
  elseif path == "/correlations"
    return handler(CorrelationsController.call, payload)
  elseif path == "/basic_statistics"
    return handler(BasicStatisticsController.call, payload)
  elseif path == "/gaussian_mixtures"
    return handler(GaussianMixturesController.call, payload)
  elseif path == "/kmeans"
    return handler(KMeansController.call, payload)
  elseif path == "/gmeans"
    return handler(GMeansController.call, payload)
  elseif path == "/hierachical_clustering"
    return handler(HierachicalClusteringsController.call, payload)
  else
    throw(ErrorException("No route matches."))
  end
end


