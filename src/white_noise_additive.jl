export additive_white_gaussian, additive_white_gaussian_chn



 """
    additive_white_gaussian(X; clip=false[, σ=1.0, μ=0.0])

Returns the array `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added. 
`σ` and `μ` are optional arguments representing standard deviation and mean of Gaussian.
If keyword argument `clip` is provided the values are clipped to be in [0, 1].
If `X` is a RGB{Normed} or Gray{Normed} image, then the values will be automatically clipped and the keyword 
`clip` is meaningless.
"""
additive_white_gaussian

 # adds white gaussian noise to each pixel individually
function additive_white_gaussian(X::AbstractArray{P}, σ=0.1, μ=0.0; 
        clip=false) where {P}

    # copy if input
    X_noisy = zeros(size(X)) 
    # iterate over all values
    for i in eachindex(X)
        X_noisy[i] = X[i] .+ μ .+ σ .* randn()
    end

    # if clip then clip values to [0, 1]
    if clip
        clip_0_1!(X_noisy)
    end

    return X_noisy
end


 # additive_white_gaussian for Gray and RGB images
function additive_white_gaussian(X::Union{AbstractArray{RGB{P}}, AbstractArray{Gray{P}}}, 
        σ=0.1, μ=0.0; clip=false) where {P}
    if P <: Normed
        clip = true
    end
    # copy input
    X_noisy = copy(X)
    # iterate over pixels
    for i in eachindex(X)
        # for RGB each channel
        if eltype(X) <: RGB
            a = X[i]
            if clip
                X_noisy[i] = RGB(clip_v(red(a) .+ μ .+ σ .* randn()),
                                 clip_v(green(a) .+ μ .+ σ .* randn()),
                                 clip_v(blue(a) .+ μ .+ σ .* randn()))
            else
                X_noisy[i] = RGB(red(a) .+ μ .+ σ .* randn(),
                                 green(a) .+ μ .+ σ .* randn(),
                                 blue(a) .+ μ .+ σ .* randn())
            end
        # for Gray
        else 
            if clip
                X_noisy[i] = Gray(clip_v(gray(X[i]) .+ μ .+ σ .* randn()))
            else
                X_noisy[i] = Gray(gray(X[i]) .+ μ .+ σ .* randn())
            end
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
 # adds white gaussian noise to each pixel but for each channel the same amount
function additive_white_gaussian_chn(X::AbstractArray{C}, 
            σ::T=0.1, μ::T=0.0) where {P<:Number, T<:Number, C <: RGB}
    
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
