using Test
using JSON
using MianalyzerBackend
const GMeansController = MianalyzerBackend.GMeansController

include("../TestSupport.jl")

@testset "GMeanController" begin
  @testset ".call" begin
    request = Dict([("records", [[1.0, 1.0], [2.0, 2.0], [3.0, 3.0], [4.0, 4.0], [5.0, 5.0]])])

    actual = JSON.parse(IOBuffer(GMeansController.call(request)))

    @test actual["clusters"] == [[[1.0, 1.0], [2.0, 2.0], [3.0, 3.0], [4.0, 4.0], [5.0, 5.0]]]
    @test actual["centers"] == [[3.0, 3.0]]
  end
end

