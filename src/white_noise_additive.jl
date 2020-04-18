export additive_white_gaussian, additive_white_gaussian!, additive_white_gaussian_chn, additive_white_gaussian_chn!


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


 # in place
function additive_white_gaussian!(X::Union{AbstractArray{Gray{T}}, 
        AbstractArray{RGB{T}}, AbstractArray{T}}, σ=0.1, μ=0.0; clip=false) where T
    # clip will be set to true if data type of array is somehow normed
    clip = T <: Normed ? true : clip
    for i in eachindex(X)
        X[i] = additive_white_gaussian_core(X[i], σ, μ, clip)
    end
    return X
end


function additive_white_gaussian(X, σ=0.1, μ=0.0; clip=false)
    X_noisy = copy(X)
    return additive_white_gaussian!(X_noisy, σ, μ, clip=clip)
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






 # in place
function additive_white_gaussian_chn!(X::AbstractArray{RGB{T}}, σ=0.1, μ=0.0; clip=false) where T
    clip = T <: Normed ? true : clip
    for i in eachindex(X)
            noise = μ .+ σ .* randn()
            a = X[i]
            if clip
                X[i] = RGB(clip_v(red(a) + noise), 
                                 clip_v(green(a) + noise), 
                                 clip_v(blue(a) + noise))
            else
                X[i] = RGB(red(a) + noise, 
                           green(a) + noise, 
                           blue(a) + noise)
            end
    end
    return X
end


 # adds white gaussian noise to each pixel but for each channel the same amount
function additive_white_gaussian_chn(X::AbstractArray{<:RGB}, σ=0.1, μ=0.0; clip=false)
    # copy of input
    X_noisy = copy(X)
    return additive_white_gaussian_chn!(X_noisy, σ, μ, clip=clip)
end
"""
    additive_white_gaussian_chn(X; clip=false[, σ=0.1, μ=0.0])

Returns the RGB image `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added pixelwise. However, every channel of one pixel receives the same amount of noise.
The noise therefore acts roughly as intensity - but not color - changing noise.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
`σ` and `μ` are optional arguments representing standard deviation and mean of Gaussian.

"""
additive_white_gaussian_chn
