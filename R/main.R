#' StatNormViolin
#'
#' @keywords internal
#' @usage NULL
#' @export
StatNormalViolin <- ggplot2::ggproto(
  `_class` = "StatNormalViolin",
  `_inherit` = ggplot2::Stat,
  required_aes = c("x","mu","sigma"),
  default_aes = ggplot2::aes(
    width = 0.6,
    nsigma = 4,
    p_tail = 0,
    p_lower_tail = 0,
    p_upper_tail = 0),
  setup_data = function(data, params) {
    if (is.null(data$width))
      data$width = params$width
    if (is.null(data$nsigma))
      data$nsigma = params$nsigma
    if (is.null(data$p_tail)) {
      data$p_tail = params$p_tail
      if (all(params$p_upper_tail == 0))
        data$p_upper_tail = params$p_tail / 2
      if (all(params$p_lower_tail == 0))
        data$p_lower_tail = params$p_tail / 2
    }

    if (is.null(data$p_upper_tail))
      data$p_upper_tail = params$p_upper_tail
    if (is.null(data$p_lower_tail))
      data$p_lower_tail = params$p_lower_tail

    data$group <- 1:nrow(data)

    data
  },
  compute_group = function(
    data,
    scales,
    lower_limit = NA,
    upper_limit = NA,
    width = 0.6,
    nsigma = 4,
    p_tail = 0,
    p_upper_tail = 0,
    p_lower_tail = 0
  ) {
    # The y values start at right side at 0, go up to the positive tail,
    # reverse to left side, go to the negative tail,
    # reverse again to right side, and then return to 0.
    # This seemingly odd sequence was needed to make
    # polygons clipped with p_tail appear correctly.

    y <- c(seq(0, data$nsigma, by = 0.01),
           seq(data$nsigma,-1 * data$nsigma, by = -0.01),
           seq(-1 * data$nsigma, 0, by = 0.01)) *  data$sigma + data$mu

    # Which direction the violin should deviate?
    signx <- c(rep(1, length(seq(0, data$nsigma,0.01))),
               rep(-1, length(seq(data$nsigma, -1 * data$nsigma,-0.01))),
               rep(1, length(seq(-1 * data$nsigma, 0,0.01)))
    )

    # Set x position of violin
    xpos <- 0.5 * signx * data$width * dnorm(y, data$mu,  data$sigma) / dnorm( data$mu,  data$mu,  data$sigma) +  data$x

    # Make data.frame
    d <- data.frame(x = xpos,
                    y = y,
                    group = data$group,
                    mu = data$mu,
                    sigma = data$sigma)

    if (!is.na(upper_limit)) d <- dplyr::filter(d, y <= upper_limit)
    if (!is.na(lower_limit)) d <- dplyr::filter(d, y >= lower_limit)
    d
  }
)

#' GeomNormalViolin
#'
#' @format NULL
#' @keywords internal
#' @usage NULL
#' @export
GeomNormalViolin <- ggplot2::ggproto(
  `_class` = "GeomNormalViolin",
  `_inherit` = ggplot2::Geom,
  required_aes = c("x", "mu", "sigma"),
  default_aes = ggplot2::aes(
    shape = 16,
    colour = NA,
    size = 0.5,
    linetype = 1,
    fill = "gray70",
    alpha = 1,
    stroke = 0.5,
    tail_fill = "black",
    tail_alpha = 1
  ),
  draw_key = ggplot2::draw_key_polygon,
  draw_panel = function(
    data,
    panel_scales,
    coord) {

    # Parameters for each violin
    d_param <- data %>%
      dplyr::group_by(group) %>%
      dplyr::summarise_all(.funs = list(dplyr::first))
    # Violin points transformed for grid coordinates
    dpoints <- coord$transform(data, panel_scales)

    # Violin polygons
    gbody <- grid::polygonGrob(
      default.units = "native",
      x = dpoints$x,
      y = dpoints$y,
      id = dpoints$group,
      gp = grid::gpar(col = d_param$colour,
                      fill = scales::alpha(d_param$fill,
                                           d_param$alpha),
                      lty = d_param$linetype,
                      lwd = d_param$size * .pt)
    )

    # Filter data for upper tail
    data_uppertail <- data %>%
      dplyr::mutate(UB = qnorm(1 - p_upper_tail) * sigma + mu) %>%
      dplyr::filter(y >= UB)

    if (nrow(data_uppertail) > 0) {
      # Transform upper tail data for grid coordinates
      duppertail <- coord$transform(data_uppertail, panel_scales)

      # Make upper tail polygon
      g_upper_tail <- grid::polygonGrob(
        default.units = "native",
        x = duppertail$x,
        y = duppertail$y,
        id = duppertail$group,
        gp = grid::gpar(
          col = d_param$colour,
          fill = scales::alpha(d_param$tail_fill,
                               d_param$tail_alpha),
          lty = d_param$linetype,
          lwd = d_param$size * .pt

        )
      )
    } else {
      g_upper_tail <- grid::nullGrob()
    }

    # Filter data for lower tail
    data_lowertail <- data %>%
      dplyr::mutate(LB = qnorm(p_lower_tail) * sigma + mu) %>%
      dplyr::filter(y <= LB)

    if (nrow(data_lowertail) > 0) {
      # Transform lower tail data for grid coordinates
      dlowertail <- coord$transform(data_lowertail, panel_scales)

      # Make lower tail polygon
      g_lower_tail <- grid::polygonGrob(
        default.units = "native",
        x = dlowertail$x,
        y = dlowertail$y,
        id = dlowertail$group,
        gp = grid::gpar(
          col = d_param$colour,
          fill = scales::alpha(d_param$tail_fill,
                               d_param$tail_alpha),
          lty = d_param$linetype,
          lwd = d_param$size * .pt
        )
      )
    } else {
      g_lower_tail <- grid::nullGrob()
    }
    grid::gTree(children = grid::gList(gbody, g_upper_tail, g_lower_tail))
  }
)




#' Creates normal violins with specified means and standard deviations
#'
#' @inheritParams  ggplot2::layer
#' @inheritParams ggplot2::geom_polygon
#' @param nsigma The number of standard deviations each violin should extend
#' @param p_tail The 2-tailed proportion that should be highlighted. Can be overridden with p_lower_tail and/or p_upper_tail
#' @param p_upper_tail The proportion of the distribution that should be highlighted in the upper tail. Defaults to half of `p_tail`.
#' @param p_lower_tail The proportion of the distribution that should be highlighted in the lower tail. Defaults to half of `p_tail`.
#' @param tail_fill fill color for tails
#' @param tail_alpha alpha value for tails
#' @param upper_limit upper limit for polygons. Needed in case setting limits in scale_y_continuous or ylim distorts the polygons.
#' @param lower_limit lower limit for polygons. Needed in case setting limits in scale_y_continuous or ylim distorts the polygons.
#' @param width Width of normal violin
#' @section Aesthetics:
#' \code{geom_normviolin} understands the following aesthetics (required aesthetics are in bold):
#' \itemize{
#'   \item \strong{x}
#'   \item \strong{mu} (mean of the normal distribution)
#'   \item \strong{sigma} (standard deviation of the normal distribution)
#'   \item width (width of violin)
#'   \item nsigma (number of standard deviations to which the violins extend)
#'   \item p_tail (2-tailed proportion of tails highlighted)
#'   \item p_upper_tail (proportion of upper tails highlighted)
#'   \item p_lower_tail (proportion of lower tails highlighted)
#'   \item color
#'   \item fill
#'   \item alpha (of fills)
#'   \item group
#'   \item linetype
#'   \item size (of lines)
#' }

#' @examples
#' library(ggplot2)
#' library(ggnormalviolin)
#'
#' d <- data.frame(
#'   Distribution = c("A", "B"),
#'   Distribution_mean = c(80, 90),
#'   Distribution_sd = c(15, 10)
#' )
#'
#' ggplot(data = d, aes(x = Distribution)) +
#'   geom_normalviolin(aes(mu = Distribution_mean,
#'                       sigma = Distribution_sd))
#' @export
geom_normalviolin <- function(
  mapping = NULL,
  data = NULL,
  nsigma = 4,
  p_tail = 0,
  p_lower_tail = p_tail / 2,
  p_upper_tail = p_tail / 2,
  tail_fill = "black",
  tail_alpha = 0.4,
  width = 0.6,
  upper_limit = NA,
  lower_limit = NA,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...
) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatNormalViolin,
    geom = GeomNormalViolin,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
     params = list(
      na.rm = na.rm,
      nsigma = nsigma,
      p_tail = p_tail,
      p_lower_tail = p_lower_tail,
      p_upper_tail = p_upper_tail,
      tail_fill = tail_fill,
      tail_alpha = tail_alpha,
      upper_limit = upper_limit,
      lower_limit = lower_limit,
      width = width,
      ...
    )
  )
}

