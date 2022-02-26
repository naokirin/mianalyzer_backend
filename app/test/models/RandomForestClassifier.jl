using Test
using MianalyzerBackend
const RandomForestClassifier = MianalyzerBackend.RandomForestClassifier

@testset "RandomForestClassifier" begin
  @testset ".feature_importances" begin
    actual = RandomForestClassifier.feature_importances([1 1 3 -3; 1 1.1 12 -12; 1 -1 100 -100], [3; 12; 100], ["l1", "l2", "l3", "l4"])
    @test actual.columns == ["l1", "l2", "l3", "l4"]
    @test size(actual.feature_importances) == (4,)
  end
end

