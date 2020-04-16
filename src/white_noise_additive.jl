export additive_white_gaussian, additive_white_gaussian_chn


 # core function for additive white_gaussian core for RGB
function additive_white_gaussian_core(a::RGB, σ, μ, clip)
    if clip
        return RGB(clip_v(red(a) .+ μ .+ σ .* randn()),
                   clip_v(green(a) .+ μ .+ σ .* randn()),
                   clip_v(blue(a) .+ μ .+ σ .* randn()))
    else
        return RGB(red(a) .+ μ .+ σ .* randn(),
                   green(a) .+ μ .+ σ .* randn(),
                   blue(a) .+ μ .+ σ .* randn())
    end
end

 # core function for additive white_gaussian core for Gray
function additive_white_gaussian_core(a::Gray, σ, μ, clip)
    if clip
        return Gray(clip_v(gray(a) .+ μ .+ σ .* randn()))
    else
        return Gray(gray(a) .+ μ .+ σ .* randn())
    end
end

 # core function for additive white_gaussian core for differen types
function additive_white_gaussian_core(a, σ, μ, clip)
    if clip 
        return clip_v(a .+ μ .+ σ .* randn())
    else
        return a .+ μ .+ σ .* randn()
    end
end


function additive_white_gaussian(X, σ=0.1, μ=0.0; clip=false)
    # clip will be set to true if data type of array is somehow normed
    X_noisy, clip = prepare_array_clip(X, clip)
    
    # iterate over pixels
    for i in eachindex(X)
        X_noisy[i] = additive_white_gaussian_core(X[i], σ, μ, clip)
    end
    
    return X_noisy

end
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



 # adds white gaussian noise to each pixel but for each channel the same amount
function additive_white_gaussian_chn(X::AbstractArray{<:RGB}, σ=0.1, μ=0.0)
    # copy of input
    X_noisy = copy(X)
    
    # all channels of one pixel are affected the same
    for i in eachindex(X_noisy)
            noise = μ .+ σ .* randn()
            a = X_noisy[i]
            X_noisy[i] = RGB(clip_v(red(a) + noise), 
                                clip_v(green(a) + noise), 
                                clip_v(blue(a) + noise))
    end
    return X_noisy
end
"""
    additive_white_gaussian_chn(X[, σ=0.1, μ=0.0])

Returns the RGB image `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added pixelwise. However, every channel of one pixel receives the same amount of noise.
The noise therefore acts roughly as intensity - but not color - changing noise.
`σ` and `μ` are optional arguments representing standard deviation and mean of Gaussian.

"""
additive_white_gaussian_chn
