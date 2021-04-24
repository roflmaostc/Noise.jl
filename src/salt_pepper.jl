export salt_pepper, salt_pepper_chn 
    
salt_or_pepper(salt_prob, salt, pepper) = rand() < salt_prob ? salt : pepper

 # function for a raw value
function f_sp(prob, salt_prob, salt, pepper)
    return x -> rand() < prob ? salt_or_pepper(salt_prob, salt, pepper) : x
end

@inline function comb_sp(x, n)
    return n
end


function salt_pepper(X, prob=0.1; salt_prob=0.5, salt=1, pepper=0)
    return salt_pepper!(copy(X), prob, salt_prob=salt_prob, salt=salt, pepper=pepper)
end


 # for arbitrary array, RGB and Gray images
function salt_pepper!(X, prob=0.1; salt_prob=0.5, salt=1, pepper=0)
        
    # type conversion of salt & pepper makes it faster
    a = X[1]
    salt = convert(eltype(a), salt)
    pepper = convert(eltype(a), pepper)

    return apply_noise!(comb_sp, f_sp(prob, salt_prob, salt, pepper), X, false)
end


"""
    salt_pepper(X; salt_prob=0.5, salt=1.0, pepper=0.0[, prob=0.1])

Returns array `X` affected by salt and pepper noise.
`X` can be an array or an RGB or Gray image
`prob` is a optional argument for the probability that a pixel will be affected by the noise.
`salt_prob` is a keyword argument representing the probability for salt noise. 
The probability for pepper noise is therefore 1-`salt_prob`.
`salt` is a keyword argument for specifying the value of salt noise.
`pepper` is a keyword argument for specifying the value of pepper noise.
"""
salt_pepper


function salt_pepper_chn(X, prob=0.1; salt_prob=0.5, salt=1.0, pepper=0.0)
    return salt_pepper_chn!(copy(X), prob, salt_prob=salt_prob, salt=salt, pepper=pepper)
end

function salt_pepper_chn!(X, prob=0.1; salt_prob=0.5, salt=1.0, pepper=0.0)
    return apply_noise_chn!(comb_sp, f_sp(prob, salt_prob, salt, pepper), X, false)
end


"""
    salt_pepper_chn(X; salt_prob=0.5, salt=1.0, pepper=0.0[, prob=0.1])

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
