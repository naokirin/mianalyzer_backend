using Test

enabled_tests = lowercase.(ARGS)
function addtests(fname)
  key = lowercase(splitext(fname)[1])
  if isempty(enabled_tests) || key in enabled_tests
    include(fname)
  end
end

addtests("models/RandomForestClassifier.jl")
addtests("models/Stats.jl")
addtests("models/Histogram.jl")
addtests("models/GaussianMixture.jl")
addtests("models/KMeans.jl")
addtests("models/GMeans.jl")
addtests("models/HierachicalClustering.jl")
addtests("controllers/BasicStatisticsController.jl")
addtests("controllers/CorrelationsController.jl")
addtests("controllers/GaussianMixturesController.jl")
addtests("controllers/TimeSeriesController.jl")
addtests("controllers/KMeansController.jl")
addtests("controllers/GMeansController.jl")
addtests("controllers/HierachicalClusteringsController.jl")
