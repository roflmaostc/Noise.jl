module Noise
using PoissonRandom
using Random
using ImageCore

"""
    complex_copy(x)

If `x` is real, it returns `x + im * x`
If `x` is complex, it returns `x`,
"""
complex_copy(a::T) where T = (a + 1im * a)::Complex{T}
complex_copy(a::Complex{T}) where T= a::Complex{T} 


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


function apply_noise!(pixel_f, noise_f, X::Union{AbstractArray{Gray{T}}, AbstractArray{RGB{T}}, 
            AbstractArray{T}}, clip) where T
   
    f(x) = pixel_f(x, noise_f(x))
     # defining the core functions inside here, gives 6x speed improvement
     # core functions non clipping
    function core_f(x::RGB)
        return RGB(f(red(x)), 
                   f(green(x)),
                   f(blue(x)))
    end
    
    function core_f(x::Gray)
        return Gray(f(gray(x))) 
    end
    
    function core_f(x)
        return f(x)
    end
    
    
    function core_f_clip(x::RGB)
        return RGB(clip_v(f(red(x))), 
                   clip_v(f(green(x))),
                   clip_v(f(blue(x))))
    end
    
    function core_f_clip(x::Gray)
        return Gray(clip_v(f(gray(x))))
    end
    
    function core_f_clip(x)
        return clip_v(f(x))
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


 # function which use exactly the same noise for each color channel of a pixel
function apply_noise_chn!(pixel_f, noise_f, X::AbstractArray{RGB{T}}, clip) where T
    if T <: Normed || clip
        for i in eachindex(X)
            a = X[i]
            n = noise_f(red(a)*0)
            X[i] = RGB(clip_v(pixel_f(red(a), n)), 
                       clip_v(pixel_f(green(a), n)), 
                       clip_v(pixel_f(blue(a), n))) 
        end
    else
        for i in eachindex(X)
            a = X[i]
            n = noise_f(red(a)*0)
            X[i] = RGB(pixel_f(red(a), n), 
                       pixel_f(green(a), n), 
                       pixel_f(blue(a), n)) 
        end
    end
    return X
end


include("poisson.jl")
include("salt_pepper.jl")
include("white_noise_additive.jl")
include("quantization.jl")
include("multiplicative_noise.jl")

end 
