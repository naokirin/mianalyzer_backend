using Test
using JSON
using MianalyzerBackend
const KMeansController = MianalyzerBackend.KMeansController

include("../TestSupport.jl")

@testset "KMeanController" begin
  @testset ".call" begin
    request = Dict([
                    ("records", [[1.0, 1.0], [2.0, 2.0]]),
                    ("cluster_num", 2)
                   ])

    actual = JSON.parse(IOBuffer(KMeansController.call(request)))

    @test actual["clusters"] == [[[1.0, 1.0]], [[2.0, 2.0]]]
    @test actual["centers"] == [[1.0, 1.0], [2.0, 2.0]]
  end
end

