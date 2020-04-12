module Noise

using PoissonRandom
using Random
using ColorTypes
using ImageCore

function clip_0_1!(X)
    map!(x -> max(0.0, min(1.0, x)), X, X)
    return X
end

include("poisson.jl")
include("salt_pepper.jl")
include("white_noise_additive.jl")

end # module
