module Imports

using PyCall

global const mixture = PyNULL()
global const ensemble = PyNULL()
global const model_selection = PyNULL()
global const gmeans = PyNULL()

export mixture, gmeans, ensemble

function __init__()
  copy!(mixture, pyimport("sklearn.mixture"))
  copy!(ensemble, pyimport("sklearn.ensemble"))
  copy!(model_selection, pyimport("sklearn.model_selection"))
  copy!(gmeans, pyimport("pyclustering.cluster.gmeans"))
end
end
