export salt_pepper 
    

salt_or_pepper(salt_prob, salt, pepper) = rand() < salt_prob ? salt : pepper


 # salt and pepper for arbitrary arrays
function salt_pepper(X::AbstractArray{P, N}, prob::T=0.1;
        salt_prob::T=0.5,
        salt::T=1.0, pepper::T=0.0) where {T <: Number, P, N}
  
    # copy array
    X_noisy = copy(X)

    # apply salt and pepper to each value individually
    for i in eachindex(X)
        if rand() < prob
            X_noisy[i] = 
                convert(eltype(X), salt_or_pepper(salt_prob, salt, pepper)) 
        end
    end
    return X_noisy
end


 # salt_pepper for images is applied either to all channels or to none
function salt_pepper(X::AbstractArray{C, 2}, prob::T=0.1;
        salt_prob::T=0.5,
        salt::T=1.0, pepper::T=0.0) where {T <: Number, C <: Color{P, 3} where {P}}

    # view
    X_cv = channelview(copy(X))

    #iterate over all pixels
    for j = 1:size(X_cv)[3]
        for i = 1:size(X_cv)[2]
            if rand() < prob
                #sop is for all channels the same
                sop = salt_or_pepper(salt_prob, salt, pepper)
                for d = 1:size(X_cv)[1]
                    X_cv[d, i, j] = sop
                end 
            end
        end
    end
    
    # convert back to Array{Color} 
    return colorview(eltype(X), X_cv)
end

"""
    salt_pepper(X; salt_prob=0.5, salt=1.0, pepper=0.0[, prob])

Returns array `X` affected by salt and pepper noise.
`prob` is a optional argument for the probability that a pixel will be affected by the noise.
`salt_prob` is a keyword argument representing the probability for salt noise. 
The probability for pepper noise is therefore 1-`salt_prob`.
`salt` is a keyword argument for specifying the value of salt noise.
`pepper` is a keyword argument for specifying the value of pepper noise.
"""
salt_pepper
