export poisson

function noise(x, scaling, max_intens)
    if scaling == Nothing
        return pois_rand(x)
    else
        return pois_rand(x * scaling / max_intens) * max_intens / scaling
    end
end


function poisson(X::Union{AbstractArray{Gray{T}}, AbstractArray{RGB{T}}, AbstractArray{T}}, 
        scaling=Nothing; clip=false) where {P, T}

    # depending on the element type we either copy or create a new array
    if eltype(X) <: Union{Gray, RGB}
        X_noisy = copy(X)
        # if it's a normed type we should clip it
        if T <: Normed
            clip = true
        end
    else
        X_noisy = zeros(size(X))
    end


    if eltype(X) <: RGB
        e_type = eltype(red(X[1]))
        max_intens = max_rgb(X)
    elseif eltype(X) <: Gray
        e_type = eltype(gray(X[1]))
        max_intens = maximum(X)
    else
        max_intens = maximum(X)
    end
    
    

        # scale image to max_intensity and apply poisson noise
        # after Poisson noise scale it back
    #= print(noise(0.5), "\n") =#
    if eltype(X) <: RGB
        for i in eachindex(X)
        # for RGB each channel independently
            a = X[i]
            if clip
                X_noisy[i] = RGB(clip_v(noise(red(a), scaling, max_intens)),
                                 clip_v(noise(green(a), scaling, max_intens)),
                                 clip_v(noise(blue(a), scaling, max_intens)))
            else
                X_noisy[i] = RGB(noise(red(a), scaling, max_intens),
                                 noise(green(a), scaling, max_intens),
                                 noise(blue(a), scaling, max_intens))
            end
        end
    # for Gray
    elseif eltype(X) <: Gray
        for i in eachindex(X)
            if clip
                X_noisy[i] = Gray(clip_v(noise(gray(X[i]), scaling, max_intens)))
            else
                X_noisy[i] = Gray(noise(gray(X[i]), scaling, max_intens))
            end
        end
    else
        for i in eachindex(X)
            if clip
                X_noisy[i] = clip_v(noise(X[i], scaling, max_intens))
            else
                X_noisy[i] = noise(X[i], scaling, max_intens)
            end
        end
    end

    return X_noisy
end


"""
    poisson(X; scaling=1, clip=false)

Returns the array `X` affected by Poisson noise. 
At every position the Poisson noise affects the intensity individually 
and the values at the positions represent the expected value of the Poisson
Distribution. 

`scaling` is a optional argument to scale the highest value of the 
array to `scaling`. This can be used if the maximum intensity
corresponds to a number of photons for example.

`clip` is a keyword argument. If given, it clips the values to [0, 1]

Please keep in mind that a Poisson Distribution returns integers therefore a image 
with intensity [0, 1] and scaling=1.0 will only return integers (0, 1, 2, ...).
"""
poisson
