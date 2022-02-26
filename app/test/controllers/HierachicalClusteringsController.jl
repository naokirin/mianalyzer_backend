using Test
using JSON
using MianalyzerBackend
const HierachicalClusteringsController = MianalyzerBackend.HierachicalClusteringsController

include("../TestSupport.jl")

@testset "HierachicalClusteringsController" begin
  @testset ".call" begin
    request = Dict([
                    ("records", [[100.0, 100.0], [100.0, 200.0], [300.0, 300.0]]),
                    ("labels", ["first", "second", "third"]),
                    ("normalized", false)
                   ])

    expected_charts = Dict(
                           "records" => [["first", "second"], "third"],
                           "linkage" => "ward",
                           "dist_type" => "euclidean"
                          )

    actual = JSON.parse(IOBuffer(HierachicalClusteringsController.call(request)))

    @test actual["charts"][1] == expected_charts
  end
end

