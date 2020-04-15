export poisson

 # get the maximum intensity of an image
mymax(X::AbstractArray{<:RGB}) = max_rgb(X)
mymax(X::AbstractArray{<:Gray}) = gray(maximum(X))
mymax(X::AbstractArray) = maximum(X)


 # noise function for poisson
function noise(x, scaling, max_intens)
    if scaling == Nothing
        return pois_rand(x)
    else
        # scale image to max_intensity and apply poisson noise
        # after Poisson noise scale it back
        return pois_rand(x * scaling / max_intens) * max_intens / scaling
    end
end

 # core function for RGB images which is called from within the loop 
function poisson_core(a::RGB, max_intens, scaling, clip)
    if clip
        return RGB(clip_v(noise(red(a), scaling, max_intens)),
                         clip_v(noise(green(a), scaling, max_intens)),
                         clip_v(noise(blue(a), scaling, max_intens)))
    else
        return RGB(noise(red(a), scaling, max_intens),
                         noise(green(a), scaling, max_intens),
                         noise(blue(a), scaling, max_intens))
    end
end

 # core for Gray Arrays
function poisson_core(a::Gray, max_intens, scaling, clip)
    if clip
        return Gray(clip_v(noise(gray(a), scaling, max_intens)))
    else
        return Gray(noise(gray(a), scaling, max_intens))
    end
end

 # core for arbitrary arrays, might fail sometimes
function poisson_core(a, max_intens, scaling, clip)
    if clip
        return clip_v(noise(a, scaling, max_intens))
    else
        return noise(a, scaling, max_intens)
    end
end

function poisson(X::AbstractArray, scaling=Nothing; clip=false)
    
    X_noisy, clip = prepare_array_clip(X, clip)
    
    #= if scaling != Nothing =#
    #=     scaling = float(scaling) =#
    #= end =#
    max_intens = mymax(X)
    
    for i in eachindex(X)
        X_noisy[i] = poisson_core(X[i], max_intens, scaling, clip) 
    end

    return X_noisy
end
"""
    poisson(X; scaling=1, clip=false)

Returns the array `X` affected by Poisson noise. 
At every position the Poisson noise affects the intensity individually 
and the values at the positions represent the expected value of the Poisson
Distribution. 
Since Poisson Noise due to discrete events you should
provide the optional argument `scaling`. This `scaling` connects
the highest value of the array with the discrete number of events.
The highest value will be then scaled and the poisson noise is applied
Afterwards we scale the whole array back so that the initial intensity
is preserved but with applied Poisson noise.
`clip` is a keyword argument. If given, it clips the values to [0, 1]
"""
poisson
