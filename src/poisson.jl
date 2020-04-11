
export poisson

function poisson(X::AbstractArray, scaling=nothing; clip::Bool=false)
    type_arr = eltype(X[1])
   
    # if scaling is not provided we simply use the values
    if scaling == nothing
        X_noisy = map(x -> pois_rand(x), X)

    # if scaling is provided we scale the highest value to scaling
    else
        scaling = float(scaling)
        max_intens = float(maximum(X))
        # scale image to max_intensity and apply poisson noise
        # after Poisson noise scale it back
        X_noisy = max_intens ./scaling .*
            map(x -> pois_rand(x / max_intens * scaling), X)
    end

    if clip
        X_noisy = map(x -> max(0.0, min(1.0, x)), X_noisy)
    end
    
    # round properly if integer
    if type_arr <: Integer
        X_noisy = map(x -> round(x), X_noisy)
    end
    X_noisy = convert(Array{type_arr}, X_noisy)
    
    return X_noisy
end


"""
    poisson(X; scaling=1, clip=false)

Returns the array `X` affected by Poisson noise. 
At every position the Poisson noise affects the intensity individually 
where the values at the positions represent the expected value of the Poisson
Distribution.

`scaling` is a optional argument to scale the highest value of the 
array to `scaling`. This can be used if the maximum intensity
corresponds to a number of photons for example.

`clip` is a keyword argument. If given, it clips the values to [0, 1]

Please keep in mind that a Poisson Distribution returns integers therefore a image 
with intensity [0, 1] and scaling=1.0 will only return integers.
"""
