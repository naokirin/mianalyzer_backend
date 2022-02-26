using Test
using JSON
using MianalyzerBackend
const BasicStatisticsController = MianalyzerBackend.BasicStatisticsController

include("../TestSupport.jl")

@testset "BasicStatisticsController" begin
  @testset ".call" begin
    request = Dict([("records", [[100.0], [200.0], [300.0]])])

    actual = JSON.parse(IOBuffer(BasicStatisticsController.call(request)))

    @test actual["means"] == [200]
    @test actual["stds"] == [100]
    @test actual["maxs"] == [300]
    @test actual["mins"] == [100]
    @test actual["row_count"] == 3
  end
end

