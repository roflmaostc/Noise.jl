export salt_pepper 

function salt_pepper(X::AbstractArray{P, N}, prob::T=0.5;
        salt_prob::T=0.5,
        salt::T=1.0, pepper::T=0.0) where {T <: Number, P, N}
    
    salt_or_pepper() = rand() < salt_prob ? salt : pepper
    map_f(x) = rand() < prob ? salt_or_pepper() : x
    X_noisy = map(map_f, X)
    X_noisy = convert(Array{eltype(X)}, X_noisy)
    return X_noisy
end


"""
    salt_pepper(X; salt=0.0, pepper=1.0[, probability, ratio])

Returns array `X` affected by salt and pepper noise.
`prob` is a optional argument for the probability that a pixel will be affected by the noise.
`salt_prob` is a keyword argument representing the probability for salt noise. 
The probability for pepper noise is therefore 1-`salt_prob`.
`salt` is a keyword argument for specifying the value of salt noise.
`pepper` is a keyword argument for specifying the value of pepper noise.
"""
salt_pepper
