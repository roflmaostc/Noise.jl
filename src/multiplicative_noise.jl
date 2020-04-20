export mult_gauss, mult_gauss!, mult_gauss_chn, mult_gauss_chn!

 # function for a raw value
function f_mg(σ, μ)
    return x -> x * (randn() * σ + μ)
end

mult_gauss!(X, σ=0.1, μ=1; clip=false) = apply_noise!(f_mg(σ, μ), X, clip)
mult_gauss(X, σ=0.1, μ=1; clip=false) = mult_gauss!(copy(X), σ, μ, clip=clip)

"""
    mult_gauss(X; clip=false[, σ=0.1, μ=1])

Returns the array `X` with the array value multiplied with a gauss distribution (standard deviation `σ` and mean `μ`) . 
`σ` and `μ` are optional arguments representing standard deviation and mean of gauss.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
If `X` is a RGB{Normed} or Gray{Normed} image, then the values will be automatically clipped and the keyword 
`clip` is meaningless.
"""
mult_gauss

 # function for a raw value
f_chn_mg() = (x, n)-> x * n
 # function to generate noise
noise_mg(σ, μ) = () -> randn() * σ + μ

mult_gauss_chn(X, σ=0.1, μ=1; clip=false) = mult_gauss_chn!(copy(X), σ, μ, clip=clip)
mult_gauss_chn!(X, σ=0.1, μ=1; clip=false) = apply_noise_chn!(f_chn_mg(), noise_mg(σ, μ), X, clip)

"""
    mult_gauss_chn(X; clip=false[, σ=0.1, μ=0.0])

Returns the RGB image `X` with the values of the pixel multiplied with a
gauss distribution (standard deviation `σ` and mean `μ`) pixelwise. 
However, every channel of one pixel receives the same amount of noise.
The noise therefore acts roughly as intensity - but not color - changing noise.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
`σ` and `μ` are optional arguments representing standard deviation and mean of gauss.
"""
mult_gauss_chn
