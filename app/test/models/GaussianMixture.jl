using Test
using MianalyzerBackend
const GaussianMixture = MianalyzerBackend.GaussianMixture

@testset "GaussianMixture" begin
  @testset ".fit" begin
    actual = GaussianMixture.fit([100.0, 200.0, 300.0], 1)
    @test isapprox(actual.means_[:, 2][1], 200; atol=eps(Float32), rtol=0)
    @test isapprox(actual.covariances_[:, 2][1], 6666.6666676666; atol=eps(Float32), rtol=0)
    @test isapprox(actual.weights_[1], 1; atol=eps(Float32), rtol=0)
  end
end

