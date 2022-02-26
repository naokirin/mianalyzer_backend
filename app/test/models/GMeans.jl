using Test
using MianalyzerBackend
const GMeans = MianalyzerBackend.GMeans

@testset "GMeans" begin
  @testset ".call" begin
    actual = GMeans.call([[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]])
    @test actual[:clusters] == [[[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]]
    @test actual[:centers] == [[3, 3]]
  end
end

