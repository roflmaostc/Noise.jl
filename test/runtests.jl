using Noise
using Test
using Statistics
using Random
using ImageCore
using ColorVectorSpace


@testset "Util functions" begin
    x = 1f0
    @test 1f0 + 1f0im == Noise.complex_copy(x) 
    
    x = 12f0 + 13f0im
    @test 12f0 + 13f0im == Noise.complex_copy(x) 
end



Random.seed!(42)
tpl = (1000, 1000)
arr = rand(Float64, tpl)
arr_ones = ones(tpl) 
arr_rand_int = convert(Array{Int64}, map(x -> round(1000*x), arr))
arr_zeros = zeros(tpl) 
img_zeros = colorview(RGB, zeros(Normed{UInt8, 8}, 3, 1000, 1000)) 
img_zeros_gray = colorview(Gray, zeros(Normed{UInt8, 8}, 1000, 1000)) 

img_rand = colorview(RGB, rand(Normed{UInt8, 8}, 3, 1000, 1000)) 
img_rand_gray = colorview(Gray, rand(Normed{UInt8, 8}, 1000, 1000))

img_12 = colorview(RGB, 0.5 .* ones(Normed{UInt8, 8}, 3, 1000, 1000)) 
img_12_gray= colorview(Gray, 0.5 .* ones(Normed{UInt8, 8}, 1000, 1000)) 

img = colorview(RGB, ones(Normed{UInt8, 8}, 3, 1000, 1000)) 
img_gray= colorview(Gray,  ones(Normed{UInt8, 8}, 1000, 1000)) 


img_zeros_float = colorview(RGB, zeros(Float64, 3, 1000, 1000)) 
img_zeros_gray_float = colorview(Gray, zeros(Float64, 1000, 1000)) 

img_rand_float = colorview(RGB, rand(Float64, 3, 1000, 1000)) 
img_rand_gray_float = colorview(Gray, rand(Float64, 1000, 1000))

img_12_float = colorview(RGB, 0.5 .* ones(Float64, 3, 1000, 1000)) 
img_12_gray_float = colorview(Gray, 0.5 .* ones(Float64, 1000, 1000)) 

img_float = colorview(RGB, ones(Float64, 3, 1000, 1000)) 
img_gray_float = colorview(Gray,  ones(Float64, 1000, 1000)) 



@testset "Clip functions" begin
    
    @test mean(Noise.clip_v(1.1)) ≈ 1.0
    @test mean(Noise.clip_v(1.0)) ≈ 1.0
    @test mean(Noise.clip_v(10.0)) ≈ 1.0
    @test mean(Noise.clip_v(0.1)) ≈ 0.1
    @test mean(Noise.clip_v(-1.0)) ≈ 0.0
    @test mean(Noise.clip_v(0.0)) ≈ 0.0

end


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
    @test abs(mean(salt_pepper(arr, 1.0) .-0.5)) < 0.1
    #check that average salt and pepper are roughly 0.5 
    @test abs(mean(salt_pepper(arr, 0.1) .-0.5)) < 0.05
    
    @test abs(mean(salt_pepper(arr, 0.1, salt_prob=1.0) .-0.5)) > 0.001
    @test abs(mean(salt_pepper(arr, 0.1, salt_prob=0.0) .-0.5)) > 0.001

    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(mean(salt_pepper(arr, 0.1, pepper=1.0) .-0.5)) > 0.001
    @test abs(mean(salt_pepper(arr, 0.1, salt=0.0) .-0.5)) > 0.001


    # check images chn
    @test abs(mean(channelview(salt_pepper_chn(img_zeros, 1.0))) - 0.5)< 0.001 
    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(sum(channelview(salt_pepper_chn(img_zeros, 0.1, pepper=1.0)) .-0.5)/100/100) > 0.001
    @test abs(sum(channelview(salt_pepper_chn(img_rand, 0.1, salt=0.0)) .-0.5)/100/100) > 0.001

    # check RGB images
    @test abs(mean(channelview(salt_pepper(img_zeros, 1.0))) - 0.5)< 0.001 
    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(mean(channelview(salt_pepper(img_zeros, 0.1, pepper=1.0)) .-0.5)) > 0.001
    @test abs(mean(channelview(salt_pepper(img_rand, 0.1, salt=0.0)) .-0.5)) > 0.001
    # check std
    @test abs(std(channelview(salt_pepper(img_rand, 1.0, salt=0.0, pepper=0.5))) -0.25) < 0.001
    @test abs(std(channelview(salt_pepper(img_rand, 1.0, salt=0.4, pepper=0.5))) -0.05) < 0.001
    
    # check gray images
    @test abs(mean(channelview(salt_pepper(img_zeros_gray, 1.0))) - 0.5)< 0.001 
    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(mean(channelview(salt_pepper(img_zeros_gray, 0.1, pepper=1.0)) .-0.5)) > 0.001
    @test abs(mean(channelview(salt_pepper(img_rand_gray, 0.1, salt=0.0)) .-0.5)) > 0.001
    # check std
    @test abs(std(channelview(salt_pepper(img_rand_gray, 1.0, salt=0.0, pepper=0.5))) -0.25) < 0.001
    @test abs(std(channelview(salt_pepper(img_rand_gray, 1.0, salt=0.4, pepper=0.5))) -0.05) < 0.001


    # check images but with float
    @test abs(mean(channelview(salt_pepper_chn(img_zeros_float, 1.0))) - 0.5)< 0.001 
    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(sum(channelview(salt_pepper_chn(img_zeros_float, 0.1, pepper=1.0)) .-0.5)/100/100) > 0.001
    @test abs(sum(channelview(salt_pepper_chn(img_rand_float, 0.1, salt=0.0)) .-0.5)/100/100) > 0.001

    # check RGB images
    @test abs(mean(channelview(salt_pepper(img_zeros_float, 1.0))) - 0.5)< 0.001 
    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(mean(channelview(salt_pepper(img_zeros_float, 0.1, pepper=1.0)) .-0.5)) > 0.001
    @test abs(mean(channelview(salt_pepper(img_rand_float, 0.1, salt=0.0)) .-0.5)) > 0.001
    # check std
    @test abs(std(channelview(salt_pepper(img_rand_float, 1.0, salt=0.0, pepper=0.5))) -0.25) < 0.001
    @test abs(std(channelview(salt_pepper(img_rand_float, 1.0, salt=0.4, pepper=0.5))) -0.05) < 0.001
    
    # check gray images
    @test abs(mean(channelview(salt_pepper(img_zeros_gray_float, 1.0))) - 0.5)< 0.001 
    #check that average is different to 0.5 if salt or pepper are not 1.0 or 0.0
    @test abs(mean(channelview(salt_pepper(img_zeros_gray_float, 0.1, pepper=1.0)) .-0.5)) > 0.001
    @test abs(mean(channelview(salt_pepper(img_rand_gray_float, 0.1, salt=0.0)) .-0.5)) > 0.001
    # check std
    @test abs(std(channelview(salt_pepper(img_rand_gray_float, 1.0, salt=0.0, pepper=0.5))) -0.25) < 0.001
    @test abs(std(channelview(salt_pepper(img_rand_gray_float, 1.0, salt=0.4, pepper=0.5))) -0.05) < 0.001


end



@testset "Additive white Gaussian" begin
    # check array with white gaussian noise
    @test abs(std(add_gauss(arr_zeros, 13.0)) - 13.0) < 0.1
    @test abs(mean(add_gauss(arr_zeros, 1.0))) < 0.05
    @test abs(mean(add_gauss(arr_zeros, 1.0, 10.0)) - 10) < 0.05
    @test mean(add_gauss(arr_zeros, 0.5, -1.0, clip=false)) < 0
    @test mean(add_gauss(arr_zeros, 0.5, -1.0, clip=true)) >= 0
    @test mean(add_gauss(arr_zeros, 0.5, 2.0, clip=false)) > 1
    @test mean(add_gauss(arr_zeros, 0.5, 2.0, clip=true)) <= 1


    # check images for gaussian white noise
    # check mean offset channelwise
    @test abs(mean(channelview(add_gauss_chn(img_zeros, 0.1, 0.5))) - 0.5) < 0.05
    @test abs(mean(channelview(add_gauss_chn(img_zeros, 0.2, 0.3))) - 0.3) < 0.05

    # check mean offset with clip
    @test abs(mean(channelview(add_gauss(img_zeros, 0.1, 0.5))) - 0.5) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros, 0.2, 0.3))) - 0.3) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros, 0.0, 10))) - 1.0) < 0.005
    
    # check mean offet with gray
    @test abs(mean(channelview(add_gauss(img_zeros_gray, 0.1, 0.5))) - 0.5) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros_gray, 0.2, 0.3))) - 0.3) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros_gray, 0.0, 10))) - 1.0) < 0.005

    
    # check the same but with float images
    # check images for gaussian white noise
    # check mean offset channelwise
    @test abs(mean(channelview(add_gauss_chn(img_zeros_float, 0.1, 0.5))) - 0.5) < 0.05
    @test abs(mean(channelview(add_gauss_chn(img_zeros_float, 0.2, 0.3))) - 0.3) < 0.05

    # check mean offset, now it's not clipped
    @test abs(mean(channelview(add_gauss(img_zeros_float, 0.1, 0.5))) - 0.5) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros_float, 0.2, 0.3))) - 0.3) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros_float, 0.0, 10))) - 10.0) < 0.005
    
    # check mean offet with gray
    @test abs(mean(channelview(add_gauss(img_zeros_gray_float, 0.1, 0.5))) - 0.5) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros_gray_float, 0.2, 0.3))) - 0.3) < 0.05
    @test abs(mean(channelview(add_gauss(img_zeros_gray_float, 0.0, 10))) - 10.0) < 0.005


end

@testset "Poisson Noise" begin
    #test std of poisson with clip and no clip
    @test abs(std(poisson(arr_ones .* 13.0)) - sqrt(13)) < 0.01
    @test abs(std(poisson(arr_ones .* 13.0, clip=true))) < 0.01
    #test mean with clip and no clip
    @test abs(mean(poisson(arr_ones .* 13.0)) - 13) < 0.05
    @test abs(mean(poisson(arr_ones .* 13.0, clip=true)) - 1) < 0.001
    #test mean with scaling
    @test abs(mean(poisson(arr, 1000.0))-0.5) < 0.005
    #test mean int
    @test abs(mean(poisson(arr_rand_int)))-500<1


    @test abs(std(channelview(poisson(img_12_gray, 100.0))) - 0.5 .* sqrt(100.0)./100.0) < 0.005
    @test abs(std(channelview(poisson(img_12, 100.0))) - 0.5 .* sqrt(100.0)./100.0) < 0.005
    @test abs(std(channelview(poisson(img_12_gray, 4200.0))) - 0.3 .* sqrt(4200.0)./4200.0) < 0.005
    @test abs(std(channelview(poisson(img_12, 4200.0))) - 0.3 .* sqrt(4200.0)./4200.0) < 0.005


    @test abs(std(channelview(poisson(img_gray, 10000.0, clip=true))))< 0.02
    @test abs(std(channelview(poisson(img, 10000.0, clip=true)))) < 0.02
    @test abs(mean(channelview(poisson(img_gray, 10000.0, clip=true)))-1.0)< 0.02
    @test abs(mean(channelview(poisson(img, 10000.0, clip=true))) -1.0) < 0.02


    @test abs(std(channelview(poisson(img_12_gray_float, 100.0))) - 0.5 .* sqrt(100.0)./100.0) < 0.005
    @test abs(std(channelview(poisson(img_12_float, 100.0))) - 0.5 .* sqrt(100.0)./100.0) < 0.005
    @test abs(std(channelview(poisson(img_12_gray_float, 4200.0))) - 0.3 .* sqrt(4200.0)./4200.0) < 0.005
    @test abs(std(channelview(poisson(img_12_float, 4200.0))) - 0.3 .* sqrt(4200.0)./4200.0) < 0.005
    
    @test abs(std(channelview(poisson(img_gray_float, 10000.0, clip=true))))< 0.02
    @test abs(std(channelview(poisson(img_float, 10000.0, clip=true)))) < 0.02
    @test abs(mean(channelview(poisson(img_gray_float, 10000.0, clip=true)))-1.0)< 0.02
    @test abs(mean(channelview(poisson(img_float, 10000.0, clip=true))) -1.0) < 0.02

end



@testset "Quantization" begin
    @test quantization(img_gray, 10000) ≈ img_gray
    @test quantization(img_gray, 255) ≈ img_gray
    @test abs(sum(quantization(img_gray, 255)) - sum(img_gray)) < 0.01 * sum(img_gray)
    
    @test quantization(img, 10000) ≈ img
    @test quantization(img, 255) ≈ img

    @test quantization(img_float, 1000) ≈ img_float
    @test quantization(img_float, 255) ≈ img_float


    @test abs((quantization(img_12_gray_float, 100) |> channelview |> mean) - 0.5) < 0.01
    @test abs((quantization(img_12_gray_float, 50) |> channelview |> mean) - 0.5) < 0.05
    @test abs(sum(quantization(img_12_gray_float, 255)) - sum(img_12_gray_float)) < 0.01 * sum(img_12_gray_float)


    @test abs((quantization(arr , 100) |> mean) - 0.5) < 0.01
    @test abs((quantization(arr, 50) |> mean) - 0.5) < 0.05
    @test abs(sum(quantization(arr, 255)) - sum(arr)) < 0.01 * sum(arr)

    
    @test minimum(quantization(img_rand_gray_float, 2, minv=0.32, maxv=0.98)) ≈ 0.32
    @test maximum(quantization(img_rand_gray_float, 2, minv=0.32, maxv=0.98)) ≈ 0.98

    @test minimum(quantization(img_rand_gray, 5, minv=0.1, maxv=0.96)) ≈ Gray{N0f8}(0.1)
    @test maximum(quantization(img_rand_gray, 2, minv=0.32, maxv=0.98)) ≈ Gray{N0f8}(0.98)
end


@testset "Multiplicative gauss Noise" begin

    # check array with white gauss noise
    @test abs(std(mult_gauss(arr_zeros, 13.0)) - 0) < 0.1
    @test mean(mult_gauss(arr_zeros, 0.5, -1.0, clip=false)) ≈ 0
    @test mean(mult_gauss(arr_zeros, 0.5, -1.0, clip=true)) ≈ 0


    # check images for gauss white noise
    # check mean offset channelwise
    @test abs(mean(channelview(mult_gauss_chn(img_zeros, 0.1, 0.5)))) ≈ 0
    @test abs(mean(channelview(mult_gauss_chn(img_zeros, 0.2, 0.3)))) ≈ 0

    # check mean offset with clip
    @test abs(mean(channelview(mult_gauss(img_zeros, 0.1, 0.5)))) ≈  0
    @test abs(mean(channelview(mult_gauss(img_zeros, 0.2, 0.3)))) ≈ 0
    @test abs(mean(channelview(mult_gauss(img_zeros, 0.0, 10)))) ≈ 0
    

    # check mean offset with clip
    @test abs(mean(channelview(mult_gauss(img, 0.1, 0.5))) - 0.5) < 0.05
    @test abs(std(channelview(mult_gauss(img, 0.2, 0.3))) - 0.2) < 0.05
    @test abs(mean(channelview(mult_gauss(img, 0.01, 0.2))) - 0.2) < 0.05
    @test abs(std(channelview(mult_gauss(img, 0.1, 0.5))) - 0.1) < 0.05

end
