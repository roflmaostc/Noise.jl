export quantization!, quantization


 # apply quantization and clipping
function quant(x, levels, minv, maxv)
    return clip_v(round((x - minv)/(maxv-minv) * levels) / levels * (maxv-minv) + minv, minv, maxv)
end

function quantization!(X::AbstractArray{<:RGB}, levels=5; minv=0, maxv=1)
    levels -= 1
    for i in eachindex(X)
        a = X[i]
        X[i] = RGB(quant(red(X[i]), levels, minv, maxv),
                   quant(green(X[i]), levels, minv, maxv),
                   quant(blue(X[i]), levels, minv, maxv))
    end
    return X
end


function quantization!(X::AbstractArray{<:Gray}, levels=5; minv=0, maxv=1)
    levels -= 1
    for i in eachindex(X)
        X[i] = Gray(quant(gray(X[i]), levels, minv, maxv))
    end
    return X
end

function quantization!(X::AbstractArray, levels; minv=0, maxv=1)
    levels -= 1
    for i in eachindex(X)
        X[i] = quant(X[i], levels, minv, maxv)
    end
    return X
end


"""
    quantization(X, levels; minv=0, maxv=1)

Returns array `X` discretized to `levels` different values.
Therefore the array is discretized.
`levels` describes how many different value steps the resulting image has.
`minv=0` and `maxv` indicate the minimum and maximum possible values of the images.
In RGB and Gray images this is usually 0 and 1.
There is also `quantization!` available.
"""
quantization


function quantization(X::AbstractArray, levels; minv=0, maxv=1)
    X_noisy = copy(X)
    return quantization!(X_noisy, levels, minv=minv, maxv=maxv)
end
