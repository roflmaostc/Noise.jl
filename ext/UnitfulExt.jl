module UnitfulExt
import Noise

using Unitful, ImageCore
using Unitful: Gain, uconvertp

"""
   add_gauss(X, SNR; clip=false)

Returns the array `X` with gauss noise with the signal-to-noise ratio `SNR`

`SNR` must explicitly be a `Unitful.Gain`
```julia
using Unitful
add_gauss(X, 50u"dB")

```
"""
Noise.add_gauss!(X::AbstractArray{<:Gray}, SNR::T; clip=false) where {T<:Gain} = Noise.add_gauss!(X, sum(gray.(X) .^ 2) / (length(X) * uconvertp(Unitful.NoUnits, SNR)), clip=clip)
Noise.add_gauss(X::AbstractArray{<:Gray}, SNR::T; clip=false) where {T<:Gain} = Noise.add_gauss!(copy(X), SNR; clip=clip)

end
