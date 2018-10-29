
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggnormalviolin <img src="man/figures/logo.png" align="right" height=140/>

[![CRAN
status](https://www.r-pkg.org/badges/version/ggnormalviolin)](https://cran.r-project.org/package=ggnormalviolin)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

The ggnormalviolin package uses ggplot2 to create normal violin plots
with specified means and standard deviations.

## Installation

To install the development version of ggnormalviolin, you need to check
if devtools is installed. If not, run this:

``` r
install.packages("devtools")
```

Once you are sure you have devtools installed, you can install the
development version of ggnormalviolin from GitHub by running this code:

``` r
devtools::install_github("wjschne/ggnormalviolin")
```

## Example

Suppose there are 4 hypothetically normal distributions with specific
means and standard deviations. They can be plotted like so:

``` r
library(ggplot2)
library(ggnormalviolin)

# Make data
d <- data.frame(
  dist = c("A", "B", "C", "D"),
  dist_mean = c(80, 90, 110, 130),
  dist_sd = c(15, 10, 20, 5)
)



# Make Plot
ggplot(data = d, aes(x = dist)) +
  geom_normalviolin(aes(mu = dist_mean, 
                      sigma = dist_sd,
                      fill = dist))
```

<img src="man/figures/README-example-1.svg" width="100%" />

Suppose we want to highlight the two tails of the distributions. Set the
`p_tails` to specify the total area of the tails. Thus, if `p_tail` =
0.05, each tail will represent the outermost 2.5% of the distributions
(i.e, 0.05 = 2 \&mult; 0.025).

``` r
ggplot(data = d, aes(x = dist)) +
  geom_normalviolin(aes(mu = dist_mean, 
                      sigma = dist_sd,
                      fill = dist), 
                  fill  = "dodgerblue",
                  p_tail = 0.05)
```

<img src="man/figures/README-example2-1.svg" width="100%" />

Suppose we want to highly only the upper tails. Set \`p\_upper\_tail to
the proportion desired.

``` r
ggplot(data = d, aes(x = dist)) +
  geom_normalviolin(aes(mu = dist_mean, 
                      sigma = dist_sd,
                      fill = dist), 
                  p_upper_tail = 0.05)
```

<img src="man/figures/README-unnamed-chunk-3-1.svg" width="100%" />

Analogously, we can highlight only the lower tails

``` r
ggplot(data = d, aes(x = dist)) +
  geom_normalviolin(aes(mu = dist_mean, 
                      sigma = dist_sd), 
                  p_lower_tail = 0.05)
```

<img src="man/figures/README-unnamed-chunk-4-1.svg" width="100%" />

We can set with width of each violin with `width`.

``` r
ggplot(data = d, aes(x = dist)) +
  geom_normalviolin(aes(mu = dist_mean, 
                      sigma = dist_sd), 
                  width = 0.3)
```

<img src="man/figures/README-unnamed-chunk-5-1.svg" width="100%" />

If you want the shape of the distribution to remain constant, map the
width parameter to a multiple of the standard deviation.

``` r
ggplot(data = d, aes(x = dist)) +
  geom_normalviolin(aes(mu = dist_mean, 
                      sigma = dist_sd,
                      width = dist_sd * 0.05 ))
```

<img src="man/figures/README-unnamed-chunk-6-1.svg" width="100%" />

## Code of Conduct

Please note that the ‘ggnormalviolin project’ is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
