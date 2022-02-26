using Test
using JSON
using MianalyzerBackend
const CorrelationsController = MianalyzerBackend.CorrelationsController

include("../TestSupport.jl")

@testset "CorrelationsController" begin
  @testset ".call" begin
    request = Dict([("records", [[1.0, 100.0], [2.0, 200.0], [3.0, 300.0]])])

    actual = JSON.parse(IOBuffer(CorrelationsController.call(request)))

    @test actual["combs"] == [[1,2]]
    @test actual["correlations"] == [1.0]
    @test actual["spearman_correlations"] == [1.0]
  end
end

