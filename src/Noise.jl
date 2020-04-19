module Noise
using PoissonRandom
using Random
using ColorTypes
using ImageCore

 # clipping a single value
function clip_v(x)
    return max(0.0, min(1.0, x))
end

function clip_v(x, minv, maxv)
    return max(minv, min(maxv, x))
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


include("poisson.jl")
include("salt_pepper.jl")
include("white_noise_additive.jl")
include("quantization.jl")

end 
