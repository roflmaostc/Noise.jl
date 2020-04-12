export additive_white_gaussian, additive_white_gaussian_chn


 # adds white gaussian noise to each pixel individually
function additive_white_gaussian(X::AbstractArray{P, N}, σ::T=0.1, μ::T=0.0; 
        clip=false) where {P<:Number, N, T<:Number}

    # copy if input 
    X_noisy = zeros(size(X)) 

    # iterate over all values
    for i in eachindex(X)
        X_noisy[i] = X[i] .+ μ .+ σ .* randn()
    end

    # if clip then clip values to [0, 1]
    if clip
        clip_0_1!(X_noisy)
        X_noisy = convert(Array{eltype(X)}, X_noisy)
    end

    return X_noisy
end

"""
    additive_white_gaussian(X; clip=false[, σ=1.0, μ=0.0])

Returns the array `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added. 
`σ` and `μ` are optional arguments representing standard deviation and mean of Gaussian.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
"""
additive_white_gaussian


 # adds white gaussian noise to each pixel but for each channel the same amount
function additive_white_gaussian_chn(X::AbstractArray{C, 2}, σ::T=0.1, μ::T=0.0) where {P<:Number, T<:Number, C <: RGB}
    
    # clip function 
    cf(x) = max(0.0, min(1.0, x)) 

    # copy of input
    X_noisy = copy(X)
    
    # all channels of one pixel are affected the same
    for i = 1:size(X)[1]
        for j = 1:size(X)[2]
                noise = μ .+ σ .* randn()
                a = X_noisy[i, j]
                X_noisy[i, j] = RGB(cf(red(a) + noise), 
                                    cf(green(a) + noise), 
                                    cf(blue(a) + noise))
        end
    end

    return X_noisy
end

"""
    additive_white_gaussian_chn(X[, σ=1.0, μ=0.0])

Returns the RGB image `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added pixelwise. However, every channel of one pixel receives the same amount of noise.
The noise therefore acts roughly as intensity - but not color - changing noise.
`σ` and `μ` are optional arguments representing standard deviation and mean of Gaussian.

"""
additive_white_gaussian_chn
