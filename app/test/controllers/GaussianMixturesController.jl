using Test
using JSON
using MianalyzerBackend
const GaussianMixturesController = MianalyzerBackend.GaussianMixturesController

include("../TestSupport.jl")

@testset "GaussianMixturesController" begin
  @testset ".call" begin
    request = Dict([
                    ("records", [[100.0], [200.0], [300.0], [200.0]]),
                    ("components", 1)
                   ])

    actual = JSON.parse(IOBuffer(GaussianMixturesController.call(request)))

    @test isapprox(actual["means"][1][1], 200.0; atol=eps(Float32), rtol=0)
    @test isapprox(actual["stds"][1][1], 70.71067812; atol=eps(Float32), rtol=0)
    @test isapprox(actual["weights"][1][1], 1.0; atol=eps(Float32), rtol=0)
  end
end

