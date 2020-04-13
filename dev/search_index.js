var documenterSearchIndex = {"docs":
[{"location":"#Noise-1","page":"Noise","title":"Noise","text":"","category":"section"},{"location":"#","page":"Noise","title":"Noise","text":"Example Julia package repo.","category":"page"},{"location":"#","page":"Noise","title":"Noise","text":"Modules = [Noise]","category":"page"},{"location":"#Noise.additive_white_gaussian","page":"Noise","title":"Noise.additive_white_gaussian","text":"additive_white_gaussian(X; clip=false[, σ=1.0, μ=0.0])\n\nReturns the array X with Gaussian noise (standard deviation σ and mean μ)  added.  σ and μ are optional arguments representing standard deviation and mean of Gaussian. If keyword argument clip is provided the values are clipped to be in [0, 1].\n\n\n\n\n\n","category":"function"},{"location":"#Noise.additive_white_gaussian_chn","page":"Noise","title":"Noise.additive_white_gaussian_chn","text":"additive_white_gaussian_chn(X[, σ=1.0, μ=0.0])\n\nReturns the RGB image X with Gaussian noise (standard deviation σ and mean μ)  added pixelwise. However, every channel of one pixel receives the same amount of noise. The noise therefore acts roughly as intensity - but not color - changing noise. σ and μ are optional arguments representing standard deviation and mean of Gaussian.\n\n\n\n\n\n","category":"function"},{"location":"#Noise.poisson","page":"Noise","title":"Noise.poisson","text":"poisson(X; scaling=1, clip=false)\n\nReturns the array X affected by Poisson noise.  At every position the Poisson noise affects the intensity individually  and the values at the positions represent the expected value of the Poisson Distribution. \n\nscaling is a optional argument to scale the highest value of the  array to scaling. This can be used if the maximum intensity corresponds to a number of photons for example.\n\nclip is a keyword argument. If given, it clips the values to [0, 1]\n\nPlease keep in mind that a Poisson Distribution returns integers therefore a image  with intensity [0, 1] and scaling=1.0 will only return integers (0, 1, 2, ...).\n\n\n\n\n\n","category":"function"},{"location":"#Noise.salt_pepper","page":"Noise","title":"Noise.salt_pepper","text":"salt_pepper(X; salt_prob=0.5, salt=1.0, pepper=0.0[, prob])\n\nReturns array X affected by salt and pepper noise. prob is a optional argument for the probability that a pixel will be affected by the noise. salt_prob is a keyword argument representing the probability for salt noise.  The probability for pepper noise is therefore 1-salt_prob. salt is a keyword argument for specifying the value of salt noise. pepper is a keyword argument for specifying the value of pepper noise.\n\n\n\n\n\n","category":"function"},{"location":"#Noise.salt_pepper_chn","page":"Noise","title":"Noise.salt_pepper_chn","text":"salt_pepper_chn(X; salt_prob=0.5, salt=1.0, pepper=0.0[, prob])\n\nReturns a RGB Image X affected by salt and pepper noise. When a salt or pepper occurs, it is applied to all channels of the RGB making a real salt and pepper on the whole image. prob is a optional argument for the probability that a pixel will be affected by the noise. salt_prob is a keyword argument representing the probability for salt noise.  The probability for pepper noise is therefore 1-salt_prob. salt is a keyword argument for specifying the value of salt noise. pepper is a keyword argument for specifying the value of pepper noise.\n\n\n\n\n\n","category":"function"}]
}
