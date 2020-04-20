export quantization!, quantization


 # apply quantization and clipping
function quant(x, levels, minv, maxv)
    return clip_v(round((x - minv)/(maxv-minv) * levels) / levels * (maxv-minv) + minv, minv, maxv)
end

f_quant(levels, minv, maxv) = x -> quant(x, levels, minv, maxv)

quantization(X::AbstractArray, levels; minv=0, maxv=1) = 
    quantization!(copy(X), levels, minv=minv, maxv=maxv)

quantization!(X::AbstractArray, levels; minv=0, maxv=1) = 
    apply_noise!(f_quant(levels-1, minv, maxv), X, false)

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
