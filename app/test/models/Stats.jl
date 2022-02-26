using Test
using MianalyzerBackend
const Stats = MianalyzerBackend.Stats

@testset "Stats" begin
  @testset ".max" begin
    @test Stats.max([1 2 3 4 5]) == 5
    @test Stats.max([10.1 10.2 10.9 10.6]) == 10.9
  end

  @testset ".min" begin
    @test Stats.min([1 2 3 4 5]) == 1
    @test Stats.min([10.1 10.2 10.9 10.6]) == 10.1
  end

  @testset ".mean" begin
    @test Stats.mean([1 2 3 4 5]) == 3
    @test Stats.mean([10.1 10.2 10.9 10.6]) == 10.45
  end

  @testset ".sum" begin
    @test Stats.sum([1 2 3 4 5]) == 15
    @test Stats.sum([10.1 10.2 10.9 10.6]) == 41.8
  end

  @testset ".count" begin
    @test Stats.count([1 2 3 4 5]) == 5
    @test Stats.count([10.1 10.2 10.9 10.6]) == 4
  end

end

