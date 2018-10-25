#' StatNormViolin
#'
#' @keywords internal
#' @usage NULL
#' @export
StatNormViolin <- ggplot2::ggproto(
  `_class` = "StatNormViolin",
  `_inherit` = ggplot2::Stat,
  compute_group = function(
    data,
    scales,
    nsigma = 4,
    width = 0.4,
    p_tail = NULL,
    upper_bound = data$mu + nsigma * data$sigma,
    lower_bound = data$mu - nsigma * data$sigma) {
    signx <- c(rep(1, length(seq(0, nsigma,0.01))),
               rep(-1, length(seq(nsigma, -1 * nsigma,-0.01))),
               rep(1, length(seq(-1 * nsigma, 0,0.01)))
               )
    y <- c(seq(0, nsigma,0.01),
           seq(nsigma, -1 * nsigma,-0.01),
           seq(-1 * nsigma, 0,0.01)) *  data$sigma + data$mu
    xpos <- signx * width * dnorm(y, data$mu,  data$sigma) / dnorm( data$mu,  data$mu,  data$sigma) +  data$x
    d <- data.frame(x = xpos, y = y)
    d <- dplyr::filter(d, y <= upper_bound & y >= lower_bound)
    if (!is.null(p_tail)) {
      d[(d$y <= -1 * qnorm(p_tail / 2) * data$sigma + data$mu) &
        (d$y >= qnorm(p_tail / 2) * data$sigma + data$mu),"y"] <- NA
    }
    d
  },
  required_aes = c("x","mu","sigma")
)
# GeomNormViolin <- ggplot2::ggproto(
#   `_class` = "GeomNormViolin",
#   `_inherit` = ggplot2::Geom,
#   default_aes = ggplot2::aes(
#     width = 0.4,
#     linetype = "solid",
#     fontsize = 5,
#     shape = 16,
#     colour = NA,
#     size = .1,
#     fill = "black",
#     alpha = 1,
#     stroke = 0.1,
#     linewidth = .1,
#     weight = 1,
#     x = NULL,
#     y = NULL,
#     conds = NULL,
#     nsigma = 4
#   ),
#   setup_data = function(
#     data,
#     params) {
#     y <- seq(-1 * params$nsigma, params$nsigma,0.01) *  data$sigma + data$mu
#     xpos <- params$width * dnorm(y, data$mu,  data$sigma) / dnorm( data$mu,  data$mu,  data$sigma)
#     xpos <- c(xpos,-rev(xpos)) +  data$x
#     y <- c(y, rev(y))
#     data.frame(x = xpos, y = y)
#   },
#   draw_group = ggplot2::GeomPolygon$draw_group,
#   required_aes = c("x","mu","sigma")
# )

#' Creates normal violins with specified means and standard deviations
#'
#' @inheritParams  ggplot2::layer
#' @inheritParams ggplot2::geom_polygon
#' @section Aesthetics:
#' \code{geom_normviolin} understands the following aesthetics (required aesthetics are in bold):
#' \itemize{
#'   \item \strong{x}
#'   \item \strong{mu} (mean of the normal distribution)
#'   \item \strong{sigma} (standard deviation of the normal distribution)
#'   \item alpha
#'   \item color
#'   \item fill
#'   \item group
#'   \item linetype
#'   \item size
#' }
#' @export
geom_normviolin <- function(
  mapping = NULL,
  data = NULL,
  geom = "polygon",
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...) {
  ggplot2::layer(
    stat = StatNormViolin,
    data = data,
    mapping = mapping,
    geom = "polygon",
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )

}
