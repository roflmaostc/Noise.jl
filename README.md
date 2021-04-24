# Noise.jl
Noise.jl is a Julia package to add different kinds of noise to a digital signal like a array or images.

| **Documentation**                       | **Build Status**                          | **Code Coverage**               |
|:---------------------------------------:|:-----------------------------------------:|:-------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][CI-img]][CI-url] | [![][codecov-img]][codecov-url] |

## Documentation
The complete manual of Noise.jl is available at [the documentation page][docs-stable-url].
It has more detailed explanations of the methods and contains examples for data arrays and images.


## Installation
`Noise.jl` is available for all version equal or above Julia 1.3.
It can be installed with the following command

```julia
julia> ] add Noise
```
    
## Usage
Currently, all methods are provided with trailing `!` (like `poisson!`), so there is a in-place method available. 
In general, if images like `Array{RGB{<:Normed}` or `Array{Gray{<:Normed}}` are given to a method, an image with same type will be returned.
The methods also work for normal Arrays like `Array{<:Number}`.
At the moment five different types of noise are possible: Additive and multiplicative Gaussian, Salt and Pepper, Poisson and Quantization noise.

```julia
using Noise, TestImages, Images, Plots
img = testimage("fabio_gray_256")
img_color = testimage("fabio_color_256")

img_gray_gauss = add_gauss(img, 0.1)
img_color_gauss = add_gauss(img_color, 0.1)
img_gray_sp = salt_pepper(img, 0.1)

# 1D array
x = LinRange(0.0, 10.0, 300)
y = sin.(x)
# small noise
y_noise = add_gauss(y, 0.1)


plot(x,y) # hide
plot!(x, y_noise) # hide
savefig("images/series_index.png") # hide

save("images/img_gray_gauss_index.png", img_gray_gauss) # hide
save("images/img_color_gauss_index.png", img_color_gauss) # hide
save("images/img_gray_sp_index.png", img_gray_sp) # hide
nothing # hide
```

The left gray image is affected by Gaussian noise with a standard deviation of ![\sigma = 0.1](https://render.githubusercontent.com/render/math?math=%5Csigma%20%3D%200.1). 
In the image in the middle, we added Gaussian noise with the same standard deviation but to each individual color channel. Therefore the image has a fluctuating color look.
The image on the right is affected by salt and pepper noise by a probability of 10%.

| Gray image with noise               | RGB image with noise                  | Gray image with salt and pepper noise |
|:------------------------------------|:------------------------------------- |:--------------------------------------|
|![](images/img_gray_gauss_index.png) | ![](images/img_color_gauss_index.png) | ![](images/img_gray_sp_index.png)     |


This 1D array is affected by a additive gaussian white noise (![\sigma=0.1, \mu=0](https://render.githubusercontent.com/render/math?math=%5Csigma%3D0.1%2C%20%5Cmu%3D0)).
![](images/series_index.png)


## Development

The package is developed at [GitHub](https://www.github.com/roflmaostc/Noise.jl).  There
you can submit bug reports, propose new types of noise with pull
requests, and make suggestions. We are very happy about new types of noise, which can be also very
specific for some applications. The aim is to provide via `Noise.jl` a central package which can 
be used by many different types of application from Biology to Astronomy and Electrical Engineering.





[docs-dev-img]: https://img.shields.io/badge/docs-dev-pink.svg 
[docs-dev-url]: https://roflmaostc.github.io/Noise.jl/dev/ 

[docs-stable-img]: https://img.shields.io/badge/docs-stable-darkgreen.svg 
[docs-stable-url]: https://roflmaostc.github.io/Noise.jl/stable/

[CI-img]: https://github.com/roflmaostc/Noise.jl/workflows/CI/badge.svg
[CI-url]: https://github.com/roflmaostc/Noise.jl/actions?query=workflow%3ACI 

[codecov-img]: https://codecov.io/gh/roflmaostc/Noise.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/roflmaostc/Noise.jl
