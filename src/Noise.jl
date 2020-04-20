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


function apply_noise!(pixel_f, X::Union{AbstractArray{Gray{T}}, AbstractArray{RGB{T}}, 
            AbstractArray{T}}, clip) where T
    
     # defining the core functions inside here, gives 6x speed improvement
     # core functions non clipping
    function core_f(x::RGB)
        return RGB(pixel_f(red(x)), 
                   pixel_f(green(x)),
                   pixel_f(blue(x)))
    end
    
    function core_f(x::Gray)
        return Gray(pixel_f(gray(x))) 
    end
    
    function core_f(x)
        return pixel_f(x)
    end
    
    
    function core_f_clip(x::RGB)
        return RGB(clip_v(pixel_f(red(x))), 
                   clip_v(pixel_f(green(x))),
                   clip_v(pixel_f(blue(x))))
    end
    
    function core_f_clip(x::Gray)
        return Gray(clip_v(pixel_f(gray(x))))
    end
    
    function core_f_clip(x)
        return clip_v(pixel_f(x))
    end
    # if normed clip the values to be in [0, 1]
    if T <: Normed || clip
        for i in eachindex(X)
            X[i] = core_f_clip(X[i])
        end
    else
        for i in eachindex(X)
            X[i] = core_f(X[i])
        end
    end
    return X
end

 # just call the in-place function but copy it before
function apply_noise(pixel_f, X::Union{AbstractArray{Gray{T}}, AbstractArray{RGB{T}}, 
            AbstractArray{T}}, clip) where T
    return apply_noise!(pixel_f, copy(X), clip)
end



 # function which use exactly the same noise for each color channel of a pixel
function apply_noise_chn!(pixel_f, noise_f, X::AbstractArray{RGB{T}}, clip) where T
    if T <: Normed || clip
        for i in eachindex(X)
            n = noise_f()
            a = X[i]
            X[i] = RGB(clip_v(pixel_f(red(a), n)), 
                       clip_v(pixel_f(green(a), n)), 
                       clip_v(pixel_f(blue(a), n))) 
        end
    else
        for i in eachindex(X)
            n = noise_f()
            a = X[i]
            X[i] = RGB(pixel_f(red(a), n), 
                       pixel_f(green(a), n), 
                       pixel_f(blue(a), n)) 
        end
    end
    return X
end

function apply_noise_chn(pixel_f, noise_f, X::AbstractArray{<:RGB}, clip)
    return apply_noise_chn!(pixel_f, noise_f, copy(X), clip)
end


include("poisson.jl")
include("salt_pepper.jl")
include("white_noise_additive.jl")
include("quantization.jl")
include("multiplicative_noise.jl")

end 
