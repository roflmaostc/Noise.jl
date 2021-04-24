export add_gauss, add_gauss!, add_gauss_chn, add_gauss_chn!




 # function for a raw value
function f_awg(σ, μ, σ_c, μ_c)
    f(x::Real) = randn() * σ + μ

    function f(x::Complex{T}) where T
        return ((randn() * real(σ_c) + real(μ_c)
                + randn() * 1im * imag(σ_c) + 1im * imag(μ_c)))
    end
    return f
end

@inline function comb_add_gauss(x, n)
    return x + n
end

add_gauss(X, σ=0.1, μ=0; clip=false) = add_gauss!(copy(X), σ, μ, clip=clip)
add_gauss!(X, σ=0.1, μ=0; clip=false) = apply_noise!(comb_add_gauss, f_awg(σ, μ, complex_copy(σ), complex_copy(μ)), X, clip)
"""
    add_gauss(X; clip=false[, σ=0.1, μ=0.0])

Returns the array `X` with gauss noise (standard deviation `σ` and mean `μ`) 
added. 
`σ` and `μ` are optional arguments representing standard deviation and mean of gauss.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
If `X` is a RGB{Normed} or Gray{Normed} image, then the values will be automatically clipped and the keyword 
`clip` is meaningless.
"""
add_gauss



add_gauss_chn(X, σ=0.1, μ=0; clip=false) = add_gauss_chn!(copy(X), σ, μ, clip=clip)
add_gauss_chn!(X, σ=0.1, μ=0; clip=false) = apply_noise_chn!(comb_add_gauss, f_awg(σ, μ, complex_copy(σ), complex_copy(μ)), X, clip)

"""
    add_gauss_chn(X; clip=false[, σ=0.1, μ=0.0])

Returns the RGB image `X` with gauss noise (standard deviation `σ` and mean `μ`) 
added pixelwise. However, every channel of one pixel receives the same amount of noise.
The noise therefore acts roughly as intensity - but not color - changing noise.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
`σ` and `μ` are optional arguments representing standard deviation and mean of gauss.

"""
add_gauss_chn
