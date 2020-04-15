module Noise
using PoissonRandom
using Random
using ColorTypes
using ImageCore

 # clipping a array
function clip_0_1!(X)
    map!(x -> max(0.0, min(1.0, x)), X, X)
    return X
end

 # clipping a single value
function clip_v(x)
    return max(0.0, min(1.0, x))
end


 # get the maximum single value of a RGB image
function max_rgb(X::AbstractArray{RGB{T}}) where T
    max_v = -Inf
    for i in eachindex(X)
        max_v = max(red(X[i]), max_v)
        max_v = max(green(X[i]), max_v)
        max_v = max(blue(X[i]), max_v)
    end
    return max_v
end

 # prepare array and clip
function prepare_array_clip(X::Union{AbstractArray{Gray{T}}, 
        AbstractArray{RGB{T}}, AbstractArray{T}}, clip) where T
    clip = T <: Normed ? true : clip
    return similar(X), clip
end


include("poisson.jl")
include("salt_pepper.jl")
include("white_noise_additive.jl")

end 
