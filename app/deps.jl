using Pkg

Pkg.update()
Pkg.add("DataFrames")
Pkg.add("StatsBase")
Pkg.add("Combinatorics")
Pkg.add("Distances")
Pkg.add("Clustering")
Pkg.add("FFTW")
Pkg.add("Query")
Pkg.add("HTTP")
Pkg.add("JSON")
Pkg.add("Glob")

Pkg.add("Conda")
using Conda
Conda.add("scikit-learn")
Conda.add("pyclustering", channel="conda-forge")
Conda.update()

Pkg.add("PyCall")

pkg"activate . "

cd(@__DIR__)
ROOT_PATH = pwd()
push!(LOAD_PATH, ROOT_PATH, "src")

pkg"instantiate"
pkg"precompile"

