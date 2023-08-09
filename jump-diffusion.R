

#' ===================================================================
#' FORMA ANALITICA
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


jump_model <- function(x0, k, r, sigma, t, div.yield, lamb, nsim, type) {
  V <- 1
  for (j in 1:nsim) {
    sum_k <- exp(lamb * t) * (lamb ^ j * t ^ j) / factorial(j) * bsm(x0, k, r, sigma, t, div.yield, type)
    V <- V + sum_k
  }
  
  return(V)
}




