using Test
using MianalyzerBackend
const Histogram = MianalyzerBackend.Histogram

@testset "Histogram" begin
  @testset ".fit" begin
    @test Histogram.fit([1, 2, 3, 4, 5]) == [1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0; 1 0 1 0 1 0 1 0 1]
  end
end

