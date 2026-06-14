# ggnormalviolin

Suppose there are 4 hypothetically normal distributions with specific
means and standard deviations. They can be plotted like so:

``` r

library(ggplot2)
library(ggnormalviolin)

# Make data
d <- data.frame(
  dist = c("A", "B", "C", "D"),
  dist_mean = c(80, 90, 110, 130),
  dist_sd = c(15, 10, 20, 5),
  cp = c(0.5, 0.8, 0.2, 0.1)
)

# Make base plot
p <- ggplot(data = d,
            aes(x = dist,
                mu = dist_mean,
                sigma = dist_sd,
                fill = dist)) +
  theme_light() +
  theme(legend.position = "none") +
  labs(x = NULL, y = NULL)

# Add normal violins
p + geom_normalviolin()
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations](ggnormalviolin_files/figure-html/fig-example-1.png)

Figure 1: Example of a how to use ggnormalviolin

## Tail Highlighting

Suppose you want to highlight the two tails of the distributions. Set
the `p_tails` to specify the total area of the tails. Thus, if `p_tail`
= 0.05, each tail will represent the outermost 2.5% of the distributions
(i.e, 0.05 = 2 &mult; 0.025).

``` r

p + geom_normalviolin(p_tail = 0.05)
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with 2.5 percent of each tail
shaded.](ggnormalviolin_files/figure-html/fig-example2-1.png)

Figure 2: How to shade both violin tails

Suppose you want to highly only the upper tails. Set `p_upper_tail` to
the proportion desired.

``` r

p + geom_normalviolin(p_upper_tail = 0.05)
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with 5 percent of the upper tails
shaded.](ggnormalviolin_files/figure-html/fig-uppertail-1.png)

Figure 3: How to shade the upper tails only

Analogously, you can highlight only the lower tails by setting the
`p_lower_tail` parameter.

``` r

p + geom_normalviolin(p_lower_tail = 0.05)
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with 5 percent of the lower tails
shaded.](ggnormalviolin_files/figure-html/fig-lowertail-1.png)

Figure 4: How to shade the lower tails only

The `p_tail`, `p_lower_tail`, and `p_upper_tail` can be different for
each violin by mapping them to a variable.

``` r

p + geom_normalviolin(aes(p_upper_tail = cp))
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with different proportions of the lower tails
shaded.](ggnormalviolin_files/figure-html/fig-shadedifferent-1.png)

Figure 5: How to shade the lower tails differently for each grid

The defaults for highlighting is accomplished by selecting a subset of
the whole distribution, setting `tail_fill` to black, and then making
the black fill transparent by setting `tail_alpha` = 0.4. Setting these
values to other colors and levels of transparency can dramatically
change the look of the plot.

``` r

p +
  geom_normalviolin(
    p_tail = 0.05,
    tail_fill = "white",
    tail_alpha = 0.8,
    color = "gray20",
    linewidth = 0.1
  )
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with white tails, and gray
outlines.](ggnormalviolin_files/figure-html/fig-style-1.png)

Figure 6: How to style normal violins

## Direction of Violin

If you want to omit the left or right side of the violins, you can set
the `face_left` or `face_right` parameters to `FALSE`.

``` r

p + geom_normalviolin(face_right = FALSE, p_tail = 0.05)
```

![Plot of 4 normal half-violin shapes of different fill colors, means,
and standard deviations, with 5 percent of the upper tails
shaded.](ggnormalviolin_files/figure-html/fig-faceright-1.png)

Figure 7: How make half-violins

## Violin Width

You can set the `width` of the violin to any size desired.

``` r

p + geom_normalviolin(width = 1)
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with width set to
1.](ggnormalviolin_files/figure-html/fig-setwidth-1.png)

Figure 8: How to set violin width to a constant value

If you want the shape of the distribution to remain constant, map the
`width` parameter to a multiple of the standard deviation.

``` r

p + geom_normalviolin(aes(width = dist_sd * 0.05))
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with width set to be proportional to the standard
deviation](ggnormalviolin_files/figure-html/fig-setsdwidth-1.png)

Figure 9: How to set violin width to be proportional to the standard
deviation

## Setting Limits

By default, the normal violins extend 4 standard deviations in both
directions. Use the `nsigma` parameter to set a different value.

``` r

p + geom_normalviolin(nsigma = 1.5)
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with height set to plus or minus 1.5 standard
deviations.](ggnormalviolin_files/figure-html/fig-nsigma-1.png)

Figure 10: How to set violin height

If you set limits on the y scale, it is possible that some of the
violins will be distorted or cut in pieces.

``` r

p +
  geom_normalviolin() +
  ylim(50, 140)
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with limits set too narrowly, which distors the
violin shapes.](ggnormalviolin_files/figure-html/fig-ylim-1.png)

Figure 11: A distorted plot due to limits set too narrowly

This occurs because data outside the limits is discarded, breaking up
the polygons that compose the violins into smaller pieces. To prevent
such behavior, set the `upper_limit` and `lower_limit` parameters equal
to the same limits you have specified for the y scale (or any other
values you wish).

``` r

p +
  geom_normalviolin(lower_limit = 50, upper_limit = 140) +
  ylim(50, 140)
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with limits set appropriately wide using the ylim
function.](ggnormalviolin_files/figure-html/fig-upperlowerlimits-1.png)

Figure 12: How to set plot limits to prevent image distortion

Alternately, you can set the limits in
[`ggplot2::coord_cartesian`](https://ggplot2.tidyverse.org/reference/coord_cartesian.html)
(or any of the `coord_*` functions), which will zoom the plot instead of
discarding the data.

``` r

p +
  geom_normalviolin() +
  coord_cartesian(ylim = c(50, 140))
```

![Plot of 4 normal violin shapes of different fill colors, means, and
standard deviations, with limits set appropriately wide using the
coord_cartesian function's ylim
parameter.](ggnormalviolin_files/figure-html/fig-coordcartesian-1.png)

Figure 13: How to set zooming limits using a `coord_*` function
