export salt_pepper, salt_pepper_chn 
    
 # function which decides whether salt or pepper
salt_or_pepper(salt_prob, salt, pepper) = rand() < salt_prob ? salt : pepper


 # core noise function for RGB
function salt_pepper_core(a::RGB, prob, salt_prob, salt, pepper)
    return RGB(rand() < prob ? salt_or_pepper(salt_prob, salt, pepper) : red(a),
               rand() < prob ? salt_or_pepper(salt_prob, salt, pepper) : green(a),
               rand() < prob ? salt_or_pepper(salt_prob, salt, pepper) : blue(a))
end

 # core noise function for Gray
function salt_pepper_core(a::Gray, prob, salt_prob, salt, pepper)
    if rand() < prob
        return Gray(salt_or_pepper(salt_prob, salt, pepper))
    else
        return Gray(a)
    end
end

 # core noise function for different types
function salt_pepper_core(a, prob, salt_prob, salt, pepper)
    if rand() < prob
        return salt_or_pepper(salt_prob, salt, pepper)
    else
        return a
    end
end



 # for arbitrary array, RGB and Gray images
function salt_pepper(X, prob=0.1; salt_prob=0.5, salt=1, pepper=0)
    
    # type conversion of salt & pepper makes it faster
    a = X[1]
    salt = convert(eltype(a), salt)
    pepper = convert(eltype(a), pepper)

    # copy array
    X_noisy = copy(X)

    # iterate over array
    for i in eachindex(X)
        X_noisy[i] = salt_pepper_core(X[i], prob, salt_prob, salt, pepper)
    end
    return X_noisy
end
"""
    salt_pepper(X; salt_prob=0.5, salt=1.0, pepper=0.0[, prob])

Returns array `X` affected by salt and pepper noise.
`X` can be an array or an RGB or Gray image
`prob` is a optional argument for the probability that a pixel will be affected by the noise.
`salt_prob` is a keyword argument representing the probability for salt noise. 
The probability for pepper noise is therefore 1-`salt_prob`.
`salt` is a keyword argument for specifying the value of salt noise.
`pepper` is a keyword argument for specifying the value of pepper noise.
"""
salt_pepper



 # salt_pepper for images is applied either to all channels or to none
function salt_pepper_chn(X::AbstractArray{C}, prob::T=0.1;
        salt_prob::T=0.5,
        salt::T=1.0, pepper::T=0.0) where {T <: Number, C <: RGB}

    # view
    X_noisy = copy(X)

    #iterate over all pixels
    for i in eachindex(X_noisy)
            if rand() < prob
                #sop is for all channels the same
                sop = salt_or_pepper(salt_prob, salt, pepper)
                X_noisy[i] = RGB(sop, sop, sop)
            end
    end
    
    return X_noisy 
end
"""
    salt_pepper_chn(X; salt_prob=0.5, salt=1.0, pepper=0.0[, prob])

Returns a RGB Image `X` affected by salt and pepper noise.
When a salt or pepper occurs, it is applied to all channels of the RGB making a real salt
and pepper on the whole image.
`prob` is a optional argument for the probability that a pixel will be affected by the noise.
`salt_prob` is a keyword argument representing the probability for salt noise. 
The probability for pepper noise is therefore 1-`salt_prob`.
`salt` is a keyword argument for specifying the value of salt noise.
`pepper` is a keyword argument for specifying the value of pepper noise.
"""
salt_pepper_chn
