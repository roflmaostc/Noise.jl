# Noise 
```@meta
DocTestSetup = :(using TestImages, Images, ImageIO, Noise)
```

## Introduction
The purpose of this package is to provide several methods to add different kinds of noise to images or arrays.

## Installation
`Noise.jl` is available for all version equal or above Julia 1.0. It is mainly tested under Linux but should also work on Windows.
It and can be installed with the following command

```julia
julia> Pkt.update()
julia> Pkg.add("Noise")
```
    
## Usage
Currently, all methods are not working in place and return always a new array.
In general, if images like `Array{RGB{<:Normed}` `Array{Gray{<:Normed}}` are given to a method, a new image with same type will be returned.
The methods also work for normal Arrays like `Array{<:Number}`.
At the moment three different types of noise are possible: Additive white Gaussian, Salt and Pepper and Poisson noise.

```jldoctest; output=false
img = testimage("lena_gray_256")
img_color = testimage("lena_color_256")

img_gray_gauss = additive_white_gaussian(img, 0.1)
img_color_gauss = additive_white_gaussian(img_color, 0.1)
img_gray_sp = salt_pepper(img, 0.1)

save("images/img_gray_gauss_index.png", img_gray_gauss)
save("images/img_color_gauss_index.png", img_color_gauss)
save("images/img_gray_sp_index.png", img_gray_sp)
# output
0
```

The left gray image is affected by Gaussian noise with a standard deviation of $\sigma = 0.1$. 
In the image in the middle, we added Gaussian noise with the same standard deviation but to each individual color pixel giving the fluctuating color look.
The image on the right is affected by salt and pepper noise by a probability of $10\%$
![](../images/img_gray_gauss_index.png) ![](../images/img_color_gauss_index.png) ![](../images/img_gray_sp_index.png)


## Overview 
Look here for more details and arguments of each function.
```@contents
Pages = ["man/additive_white_gaussian.md", 
         "man/salt_pepper.md", 
         "man/poisson.md",
         "man/function_references.md"
        ]
Depth = 2
```



## Development

The package is developed at [GitHub](https://www.github.com/roflmaostc/Noise.jl).  There
you can submit bug reports, propose new types of noise with pull
requests, and make suggestions. We are very happy about new types of noise, which can be also very
specific for some applications. The aim is to provide with `Noise.jl` a central package which can 
be used by many different types of application from Biology to Astronomy and Electrical Engineering.
