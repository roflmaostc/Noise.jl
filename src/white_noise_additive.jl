export additive_white_gaussian

function additive_white_gaussian(X::AbstractArray{P, N}, σ::T=1.0, μ::T=0.0; 
        clip=false) where {P<:Number, N, T<:Number}
    X_noisy = X .+ μ .+ σ .* randn(size(X))
    
    if clip
        clip_0_1!(X_noisy)
    end

    return X_noisy
end
"""
    additive_white_gaussian(X[, σ=1.0, μ=0.0]; clip=false)

Returns the array `X` with Gaussian noise (standard deviation `σ` and mean `μ`) 
added. If `clip` is provided the values are clipped to be in [0, 1].
"""
additive_white_gaussian
