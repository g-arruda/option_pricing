# Options Pricing Models in R

This repository contains implementations of various option pricing models in R, including the Black-Scholes model and Merton's Jump Diffusion model.

## Contents

- `black-scholes.R`: Implementation of the Black-Scholes model with Monte Carlo simulation
- `jump-diffusion.R`: Implementation of Merton's Jump Diffusion model

## Models

### Black-Scholes Model

The Black-Scholes model is implemented using both:
1. An analytical solution using the Black-Scholes formula
2. A Monte Carlo simulation approach

The implementation includes:
- Pricing for both call and put options
- Support for dividend yields
- Confidence interval calculation for Monte Carlo simulations
- Error analysis comparing Monte Carlo results to the analytical solution
- Visualization tools to analyze Monte Carlo convergence

### Merton's Jump Diffusion Model

This model extends the Black-Scholes framework by incorporating price jumps based on a Poisson process:
- Supports both call and put options
- Accounts for jump intensity (lambda)
- Handles jump size mean (mu_j) and volatility (sigma_j)
- Incorporates dividend yields

## Usage Examples

### Black-Scholes Analytical Solution

```r
bsm(
  x0 = 76.5,  # Current price
  k = 78.97,   # Strike price
  r = 0.1375,  # Risk-free rate
  sigma = 0.35, # Volatility
  t = 11 / 252, # Time to maturity in years
  div.yield = 0.01, # Dividend yield
  type = "CALL"  # Option type
)
```

### Monte Carlo Simulation

```r
monte_carlo(
  nsim = 1000000,  # Number of simulations
  x0 = 30,         # Current price
  k = 28,          # Strike price
  sigma = 0.25,    # Volatility
  t = 40 / 252,    # Time to maturity in years
  r = 0.035,       # Risk-free rate
  div.yield = 0.01, # Dividend yield
  type = "put"     # Option type
)
```

### Jump Diffusion Model

```r
jump_diffusion_merton(
  x0 = 100,         # Current price
  k = 100,          # Strike price
  r = 0.05,         # Risk-free rate
  sigma = 0.2,      # Base volatility
  t = 1,            # Time to maturity in years
  div.yield = 0.01, # Dividend yield
  lambda = 1,       # Jump intensity
  mu_j = -0.1,      # Jump size mean
  sigma_j = 0.2,    # Jump size volatility
  nsim = 10,        # Number of jump terms to consider
  type = "CALL"     # Option type
)
```


## Requirements

- R
- tidyverse package