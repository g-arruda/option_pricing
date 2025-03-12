

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


jump_diffusion_merton <- function(x0, k, r, sigma, t, div.yield, lambda, mu_j, sigma_j, nsim, type) {


  V <- 0
  
  k_adjustment <- exp(mu_j) - 1
  r_adjusted <- r - lambda * k_adjustment
  
  for (j in 0:nsim) {
    poisson_prob <- dpois(j, lambda * t)
    
    sigma_total_squared <- sigma^2 + j * sigma_j^2 / t
    
    mean_adjustment <- j * mu_j
    
    bs_price <- bsm(
      x0 = x0 * exp(mean_adjustment), 
      k = k, 
      r = r_adjusted, 
      sigma = sqrt(sigma_total_squared), 
      t = t, 
      div.yield = div.yield, 
      type = type
    )
    
    V <- V + poisson_prob * bs_price
  }
  
  return(V)
}




