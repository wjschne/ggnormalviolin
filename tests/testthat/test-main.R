library(ggplot2)
library(ggnormalviolin)
library(testthat)
d <- data.frame(
  Distribution = c("A", "B"),
  Distribution_mean = c(80, 90),
  Distribution_sd = c(15, 10)
)

test_that("example", {
  expect_silent(ggplot(data = d, aes(x = Distribution)) +
                  geom_normalviolin(aes(mu = Distribution_mean,
                                        sigma = Distribution_sd)))
})


