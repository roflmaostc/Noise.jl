using Noise
using Test

using Random, Statistics

Random.seed!(42)
tpl = (500, 500)
arr = rand(Float64, tpl)
arr_ones = ones(tpl) 
arr_zeros = zeros(tpl) 
@testset "Salt and Pepper noise" begin
    #check 100% salt
    @test salt_pepper(arr, 1.0, salt_prob=1.0) == ones(tpl)
    #check 100% pepper
    @test salt_pepper(arr, 1.0, salt_prob=0.0) == zeros(tpl)
    #check 100% salt with custom value
    @test salt_pepper(arr, 1.0, salt_prob=1.0, salt=0.23) == 0.23 .* ones(tpl)
    #check 100% pepper with custom value
    @test salt_pepper(arr, 1.0, salt_prob=0.0, pepper=0.63) == 0.63 .* ones(tpl)
    #check average salt and pepper roughly 
    @test abs(sum(salt_pepper(arr, 1.0) .-0.5)/100/100) < 0.1
    #check that average salt and pepper are roughly 0.5 
    @test abs(sum(salt_pepper(arr, 0.1) .-0.5)/100/100) < 0.05
    
    @test abs(sum(salt_pepper(arr, 0.1, salt_prob=1.0) .-0.5)/100/100) > 0.001
    @test abs(sum(salt_pepper(arr, 0.1, salt_prob=0.0) .-0.5)/100/100) > 0.001

    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(sum(salt_pepper(arr, 0.1, pepper=1.0) .-0.5)/100/100) > 0.001
    @test abs(sum(salt_pepper(arr, 0.1, salt=0.0) .-0.5)/100/100) > 0.001

end


@testset "Additive white Gaussian" begin
    @test abs(std(additive_white_gaussian(arr_zeros, 13.0)) - 13.0) < 0.1
    @test abs(mean(additive_white_gaussian(arr_zeros, 1.0))) < 0.05
    @test abs(mean(additive_white_gaussian(arr_zeros, 1.0, 10.0)) - 10) < 0.05
    @test mean(additive_white_gaussian(arr_zeros, 0.5, -1.0, clip=false)) < 0
    @test mean(additive_white_gaussian(arr_zeros, 0.5, -1.0, clip=true)) >= 0
    @test mean(additive_white_gaussian(arr_zeros, 0.5, 2.0, clip=false)) > 1
    @test mean(additive_white_gaussian(arr_zeros, 0.5, 2.0, clip=true)) <= 1
end

@testset "Poisson Noise" begin
    #test std of poisson with clip and no clip
    @test abs(std(poisson(arr_ones .* 13.0)) - sqrt(13)) < 0.01
    @test abs(std(poisson(arr_ones .* 13.0, clip=true))) < 0.01
    #test mean with clip and no clip
    @test abs(mean(poisson(arr_ones .* 13.0)) - 13) < 0.05
    @test abs(mean(poisson(arr_ones .* 13.0, clip=true)) - 1) < 0.001
    #test mean with scaling
    @test abs(mean(poisson(arr, 1000))-0.5) < 0.005
    @test false
end
