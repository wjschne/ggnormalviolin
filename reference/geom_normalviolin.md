# Creates normal violins with specified means and standard deviations

Creates normal violins with specified means and standard deviations

## Usage

``` r
geom_normalviolin(
  mapping = NULL,
  data = NULL,
  mu = NULL,
  sigma = NULL,
  nsigma = 4,
  p_tail = NULL,
  p_lower_tail = NULL,
  p_upper_tail = NULL,
  tail_fill = "black",
  tail_alpha = 0.4,
  width = 0.6,
  upper_limit = NA,
  lower_limit = NA,
  face_left = TRUE,
  face_right = TRUE,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...
)
```

## Arguments

- mapping:

  Set of aesthetic mappings created by ggplot2::aes().

- data:

  The data to be displayed in this layer

- mu:

  A vector of means

- sigma:

  A vector of standard deviations

- nsigma:

  The number of standard deviations each violin should extend

- p_tail:

  The 2-tailed proportion that should be highlighted. Can be overridden
  with p_lower_tail and/or p_upper_tail

- p_lower_tail:

  The proportion of the distribution that should be highlighted in the
  lower tail. Defaults to half of \`p_tail\`.

- p_upper_tail:

  The proportion of the distribution that should be highlighted in the
  upper tail. Defaults to half of \`p_tail\`.

- tail_fill:

  fill color for tails

- tail_alpha:

  alpha value for tails

- width:

  Width of normal violin

- upper_limit:

  upper limit for polygons. Needed in case setting limits in
  scale_y_continuous or ylim distorts the polygons.

- lower_limit:

  lower limit for polygons. Needed in case setting limits in
  scale_y_continuous or ylim distorts the polygons.

- face_left:

  Display left half of violins. Defaults to \`TRUE\`

- face_right:

  Display right half of violins. Defaults to \`TRUE\`

- na.rm:

  If `FALSE`, the default, missing values are removed with a warning. If
  `TRUE`, missing values are silently removed.

- show.legend:

  logical. Should this layer be included in the legends? `NA`, the
  default, includes if any aesthetics are mapped. `FALSE` never
  includes, and `TRUE` always includes. It can also be a named logical
  vector to finely select the aesthetics to display. To include legend
  keys for all levels, even when no data exists, use `TRUE`. If `NA`,
  all levels are shown in legend, but unobserved levels are omitted.

- inherit.aes:

  If \`FALSE\`, overrides the default aesthetics, rather than combining
  with them.

- ...:

  Other arguments passed to \`ggplot2::layer\`

## Value

A ggplot2 layer that can be added to a plot created with
\[ggplot()\]\[ggplot2::ggplot()\].

## Aesthetics

`geom_normviolin` understands the following aesthetics (required
aesthetics are in bold):

- **x**

- **mu** (mean of the normal distribution)

- **sigma** (standard deviation of the normal distribution)

- width (width of violin)

- nsigma (number of standard deviations to which the violins extend)

- p_tail (2-tailed proportion of tails highlighted)

- p_upper_tail (proportion of upper tails highlighted)

- p_lower_tail (proportion of lower tails highlighted)

- face_left (display left half of violin?)

- face_right (display right half of violin?)

- color (of lines)

- fill

- alpha (of fills)

- group

- linetype

- linewidth

## Examples

``` r
library(ggplot2)
d <- data.frame(
  dist = c("A", "B"),
  dist_mean = c(80, 90),
  dist_sd = c(15, 10))

ggplot(data = d, aes(
  x = dist,
  mu = dist_mean,
  sigma = dist_sd,
  fill = dist)) +
  geom_normalviolin() +
  theme(legend.position = "none")
```
