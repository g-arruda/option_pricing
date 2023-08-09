library(tidyverse)
set.seed(123)

#' ===================================================================
#' A primeira forma de precificação de opções, será a forma analitica
#' essa forma é a partir da equação do modelo de Black-Scholes
#' ===================================================================


bsm <- function(x0, k, r, sigma, t, div.yield, type) {
  d1 <- (log(x0 / k) + (r - div.yield + sigma ^ 2 / 2) * t) / (sigma * sqrt(t))
  d2 <- d1 - sigma * sqrt(t)
  
  if (toupper(type) == "CALL") {
    return(x0 * exp(-div.yield*t) * pnorm(d1) - k * exp(-r * t) * pnorm(d2))
  } else if (toupper(type) == "PUT") {
    return(k * exp(-r * t) * pnorm(-d2) - x0 * exp(-div.yield*t) * pnorm(-d1))
  } else {
    return(print("seleciona o tipo da opção; put ou call"))
  }
  
}

#' Exemplo:
bsm(
  x = 76.5,
  k = 78.97,
  r = 0.1375,
  sigma = 0.35 ,
  t = 11 / 252,
  div.yield = 0.01,
  type = "CALL"
)



#' ======================================================================
#' A segunda forma sera calculada usando o método de monte carlo
#' aqui será calculado tbm o quanto esse método se difere do calculo
#' a partir da formula de Black-Scholes
#' ======================================================================

monte_carlo <-
  function(nsim, x0, k, sigma, t, r, div.yield = 0, type) {
    bsm <- bsm(x = x0, k, r, sigma, t, div.yield,  type)
    
    xt <- x0 * exp((r - div.yield - 0.5 * sigma ^ 2) * t - sigma * sqrt(t) * rnorm(nsim, mean = 0, sd = 1))
    
    if (toupper(type) == "PUT") {
      price <- exp(-r * t) * mean(pmax(k - xt, 0))
    }
    
    if (toupper(type) == "CALL") {
      price <- exp(-r * t) * mean(pmax(xt - k, 0))
    }
    
    lower_bound <- price - 1.96 * sd(exp(-r * t) * pmax(k - xt, 0)) / sqrt(nsim)
    upper_bound <- price + 1.96 * sd(exp(-r * t) * pmax(k - xt, 0)) / sqrt(nsim)
    
    error <- (abs(price - bsm) / price)*100
    
    df <- data.frame(
      n.simulado = nsim,
      monte.carlo = price,
      BSM = round(bsm, 6),
      erro_perc = round(error, 3),
      lower.bound = lower_bound,
      upper.bound = upper_bound
    )
    
    return(df)
  }


monte_carlo(
  nsim = 1000000,
  x0 = 30,
  k = 28,
  sigma = 0.25,
  t = 40 / 252,
  r = 0.035,
  div.yield = 0.01,
  type = "put"
)

#' Vamos plotar um gráfico para ver essa convergencia a medida que se aumenta
#' o numero de iterações


add_y_break <- function(plot, yval) {
  
  #' Esta função adiciona uma linha horizontal em um valor especifico
  #' @param plot deve ser um objeto ggplot
  #' @param yval deve ser o valor ao qual estará a linha horizontal
  
  p2 <- ggplot_build(plot)
  breaks <- p2$layout$panel_params[[1]]$y$breaks
  breaks <- breaks[!is.na(breaks)]
  
  plot +
    geom_hline(yintercept = yval) +
    scale_y_continuous(breaks = sort(c(yval, breaks)))
}


iterations <- seq(1000, 100000, by = 300)

df_sim <- purrr::map_dfr(
  iterations,
  ~ monte_carlo(
    .x,
    x0 = 30,
    k = 28,
    sigma = 0.25,
    t = 40 / 252,
    r = 0.035,
    div.yield = 0.01,
    type = "put"
  )
)

p <- df_sim[1:150, ] %>%
  ggplot(aes(x = n.simulado)) +
  geom_line(aes(y = monte.carlo)) +
  geom_line(aes(y = upper.bound),
            color = "blue",
            linetype = "twodash") +
  geom_line(aes(y = lower.bound),
            color = "red",
            linetype = "twodash") +
  labs(x = "Iteration", y = "price") +
  theme_light() +
  theme(axis.text = element_text(size = 10))

add_y_break(p, bsm(
  x0 = 30,
  k = 28,
  sigma = 0.25,
  t = 40 / 252,
  r = 0.035,
  div.yield = 0.01,
  type = "put")
)

