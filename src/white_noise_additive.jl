export additive_white_gaussian, additive_white_gaussian!, additive_white_gaussian_chn, additive_white_gaussian_chn!


 # function for a raw value
function f_awg(σ, μ)
    return x -> x + randn() * σ + μ
end

additive_white_gaussian(X, σ=0.1, μ=0; clip=false) = apply_noise(f_awg(σ, μ), X, clip)
additive_white_gaussian!(X, σ=0.1, μ=0; clip=false) = apply_noise!(f_awg(σ, μ), X, clip)
"""
    additive_white_gaussian(X; clip=false[, σ=0.1, μ=0.0])

Returns the array `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added. 
`σ` and `μ` are optional arguments representing standard deviation and mean of Gaussian.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
If `X` is a RGB{Normed} or Gray{Normed} image, then the values will be automatically clipped and the keyword 
`clip` is meaningless.
"""
additive_white_gaussian


 # function for a raw value
f_chn_awg() = (x, n)-> x + n
 # function to generate noise
noise_awg(σ, μ) = () -> randn() * σ + μ


additive_white_gaussian_chn(X, σ=0.1, μ=0; clip=false) = apply_noise_chn(f_chn_awg(), noise_awg(σ, μ), X, clip)
additive_white_gaussian_chn!(X, σ=0.1, μ=0; clip=false) = apply_noise_chn!(f_chn_awg(), noise_awg(σ, μ), X, clip)

"""
    additive_white_gaussian_chn(X; clip=false[, σ=0.1, μ=0.0])

Returns the RGB image `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added pixelwise. However, every channel of one pixel receives the same amount of noise.
The noise therefore acts roughly as intensity - but not color - changing noise.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
`σ` and `μ` are optional arguments representing standard deviation and mean of Gaussian.

"""
additive_white_gaussian_chn
