export poisson, poisson!

 # get the maximum intensity of an image
mymax(X::AbstractArray{<:RGB}) = max_rgb(X)
mymax(X::AbstractArray{<:Gray}) = gray(maximum(X))
mymax(X::AbstractArray) = maximum(X)


 # noise function for poisson
function noise_f(x, scaling, max_intens)
    # scale image to max_intensity and apply poisson noise
    # after Poisson noise scale it back
    return pois_rand(x * scaling / max_intens) * max_intens / scaling
end

f_pois(scaling, max_intens) = x -> scaling == nothing ? pois_rand(x) : noise_f(x, scaling, max_intens) 

comb_pois(x, n) = n

poisson(X::AbstractArray, scaling=nothing; clip=false) = poisson!(copy(X), scaling, clip=clip)
function poisson!(X::AbstractArray, scaling=nothing; clip=false)
    max_intens = convert(Float64, mymax(X))
    return apply_noise!(comb_pois, f_pois(scaling, max_intens), X, clip)
end

"""
    poisson(X, scaling=nothing; clip=false)

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
