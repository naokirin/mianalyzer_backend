using Test
using JSON
using MianalyzerBackend
const TimeSeriesController = MianalyzerBackend.TimeSeriesController

include("../TestSupport.jl")

@testset "TimeSeriesController" begin
  @testset ".call" begin
    request = Dict([
                    ("records", [[1.0, 100.0], [2.0, 200.0], [3.0, 300.0], [4.0, 200.0], [5.0, 100.0]]),
                    ("time_category", "number"),
                    ("grouping_type", "min")
                   ])

    actual = JSON.parse(IOBuffer(TimeSeriesController.call(request)))

    @test actual["correlogram"] == [[0.0, 1.0], [1.0, 0.05714285714285714], [2.0, -0.6714285714285714], [3.0, -0.11428571428571428], [4.0, 0.22857142857142856]]
    @test actual["fft"] == [["1/10", 1.0], ["1/4", 0.2908926654166549], ["1/2", 0.042440667916678346]]
    @test actual["hist"] == [[100.0, 2.0], [150.0, 0.0], [200.0, 2.0], [250.0, 0.0], [300.0, 1.0]]
  end
end

