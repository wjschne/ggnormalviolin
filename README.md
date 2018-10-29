
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

## Using ggnormalviolin

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

# Make base plot
p <- ggplot(data = d, 
            aes(x = dist,
                mu = dist_mean,
                sigma = dist_sd,
                fill = dist)) +
  theme(legend.position = "none")


# Make Plot
p + geom_normalviolin()
```

<img src="man/figures/README-example-1.svg" width="100%" />

## Tail Highlighting

Suppose we want to highlight the two tails of the distributions. Set the
`p_tails` to specify the total area of the tails. Thus, if `p_tail` =
0.05, each tail will represent the outermost 2.5% of the distributions
(i.e, 0.05 = 2 \&mult; 0.025).

``` r
p + geom_normalviolin(p_tail = 0.05)
```

<img src="man/figures/README-example2-1.svg" width="100%" />

Suppose we want to highly only the upper tails. Set \`p\_upper\_tail to
the proportion desired.

``` r
p + geom_normalviolin(p_upper_tail = 0.05)
```

<img src="man/figures/README-unnamed-chunk-3-1.svg" width="100%" />

Analogously, we can highlight only the lower tails

``` r
p + geom_normalviolin(p_lower_tail = 0.05)
```

<img src="man/figures/README-unnamed-chunk-4-1.svg" width="100%" />

The defaults for highlighting is accomplished by selecting a subset of
the whole distribution, setting `tail_fill` to black, and making the
then making the black fill transparent by setting `tail_alpha` = 0.4.
Setting these values to other colors and levels of tranparency can
dramatically change the look of the plot.

``` r
p + geom_normalviolin(
  p_tail = 0.05, 
  tail_fill = "white", 
  tail_alpha = 0.8,
  color = "gray20",
  size = 0.1
  )
```

<img src="man/figures/README-unnamed-chunk-5-1.svg" width="100%" />

## Violin Width

We can set the width of each violin.

``` r
p + geom_normalviolin(width = 1)
```

<img src="man/figures/README-unnamed-chunk-6-1.svg" width="100%" />

If you want the shape of the distribution to remain constant, map the
width parameter to a multiple of the standard deviation.

``` r
p + geom_normalviolin(aes(width = dist_sd * 0.05))
```

<img src="man/figures/README-unnamed-chunk-7-1.svg" width="100%" />

# Setting Limits

By default, the normal violins extend 4 standard deviations in both
directions. Use the `nsigma` parameter to set a different value.

``` r
p + geom_normalviolin(nsigma = 1.5)
```

<img src="man/figures/README-unnamed-chunk-8-1.svg" width="100%" />

If you set limits on the y scale, it is possible that some of the
violins will be distorted or cut in pieces.

``` r
p + 
  geom_normalviolin() +
  ylim(50,140)
```

<img src="man/figures/README-unnamed-chunk-9-1.svg" width="100%" />

This occurs because data outside the limits is discarded, breaking up
the polygons that compose the violins into smaller pieces. To prevent
such behavior, set the `upper_limit` and `lower_limit` parameters equal
to the same limits you have specified for the y scale (or any other
values you wish).

``` r
p + 
  geom_normalviolin(lower_limit = 50, upper_limit = 140) +
  ylim(50,140)
```

<img src="man/figures/README-unnamed-chunk-10-1.svg" width="100%" />

## Code of Conduct

Please note that the ‘ggnormalviolin project’ is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
