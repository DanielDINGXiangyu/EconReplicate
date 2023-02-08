
Please notice a few things:

	1. We may use over 2000 words in total, but actually, net of those in the footnotes (which I can actually put here)
and those as title of charts, we use less than 2000 words. We don't break the maximum requirement!

	2. In our test, sometimes if we write vectorized inputs, the file will run too slow, so we leave somewhere just scalar
inputs and reader who is interested can modify himself/herself!

	3. In 2.4, we have also tried secant and fixed point theorem, but they don't work here. We think bisection is already
good enough!

	4. We choose our bump size in 2.7 and 2.8 by multiple choices! It may not be best, but it's OK!

	5. In 2.8, we have tried several numerical integration methods, like Simpson, Richardson, midpoint-rule, we have 
compared and also provided the code with suffix of the corresponding name of method!

	6. In 2.8, we choose h = 1e-4, it's more like a cutoff; if we choose something smaller, the result is similar and 
the file runs too slow; if we choose something a little bit bigger, the result is different up to the 4th decimal point, and 
it's much faster. Here we tradeoff and choose 1e-4 for one more digit accuracy without much loss of time!

	7. We write the document according function and may not follow the structure suggested by "num_project.pdf",
but we think this is a better way to illustrate our work. We also highlight some keywords like "test","curve","output". 





