using Documenter, Noise 

using Images, TestImages, ImageIO, Random
 # set seed fixed for documentation
Random.seed!(42)

DocMeta.setdocmeta!(Noise, :DocTestSetup, :(using Noise, Images, TestImages, ImageIO); recursive=true)
makedocs(modules = [Noise], 
         sitename = "Noise.jl", 
         pages = ["index.md",
                  "man/additive_white_gaussian.md", 
                  "man/mult_gauss.md", 
                  "man/salt_pepper.md", 
                  "man/poisson.md",
                  "man/quantization.md",
                  "man/function_references.md",
                 ]
        )

deploydocs(repo = "github.com/roflmaostc/Noise.jl.git")
