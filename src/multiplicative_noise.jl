export mult_gaussian, mult_gaussian!, mult_gaussian_chn, mult_gaussian_chn!

 # function for a raw value
function f_mg(σ, μ)
    return x -> x * (randn() * σ + μ)
end

mult_gaussian(X, σ=0.1, μ=1, clip=false) = apply_noise(f_mg(σ, μ), X, clip)
mult_gaussian!(X, σ=0.1, μ=1, clip=false) = apply_noise!(f_mg(σ, μ), X, clip)


 # function for a raw value
f_chn_mg() = (x, n)-> x * n
 # function to generate noise
noise_mg(σ, μ) = () -> randn() * σ + μ


mult_gaussian_chn(X, σ=0.1, μ=1; clip=false) = apply_noise_chn(f_chn_mg(), noise_mg(σ, μ), X, clip)
mult_gaussian_chn!(X, σ=0.1, μ=1; clip=false) = apply_noise_chn!(f_chn_mg(), noise_mg(σ, μ), X, clip)
