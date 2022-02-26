using Test
using MianalyzerBackend
const KMeans = MianalyzerBackend.KMeans

@testset "KMeans" begin
  @testset ".call" begin
    actual = KMeans.call([[1, 1, 1], [2, 2, 2], [3, 3, 3], [4, 4, 4], [5, 5, 5]], 1)
    @test actual[:clusters] == [[[1, 1, 1], [2, 2, 2], [3, 3, 3], [4, 4, 4], [5, 5, 5]]]
    @test actual[:centers] == [[3.0, 3.0, 3.0]]

    actual = KMeans.call([[1, 1], [2, 2]], 2)
    @test actual[:clusters] == [[[1, 1]], [[2, 2]]]
    @test actual[:centers] == [[1.0, 1.0], [2.0, 2.0]]
  end
end

