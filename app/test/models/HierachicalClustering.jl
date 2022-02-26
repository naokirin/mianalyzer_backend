using Test
using MianalyzerBackend
const HierachicalClustering = MianalyzerBackend.HierachicalClustering

@testset "HierachicalClustering" begin
  @testset ".call" begin
    actual = HierachicalClustering.fit([1 1; 1 1; 3 3; 3 3; 10 10],
                                       ["label1", "label2", "label3", "label4", "label5"],
                                       :euclidean,
                                       :ward)
    @test actual == [[["label1", "label2"], ["label3", "label4"]], "label5"]
  end
end

