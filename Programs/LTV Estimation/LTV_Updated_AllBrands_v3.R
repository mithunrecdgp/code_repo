options(scipen=999)

pnbd.cbs.LL.ori = 
  function (params, cal.cbs) 
  {
    dc.check.model.params(c("r", "alpha", "s", "beta"), params, 
                          "pnbd.cbs.LL")
    tryCatch(x <- cal.cbs[, "x"], error = function(e) stop("Error in pnbd.cbs.LL: cal.cbs must have a frequency column labelled \"x\""))
    tryCatch(t.x <- cal.cbs[, "t.x"], error = function(e) stop("Error in pnbd.cbs.LL: cal.cbs must have a recency column labelled \"t.x\""))
    tryCatch(T.cal <- cal.cbs[, "T.cal"], error = function(e) stop("Error in pnbd.cbs.LL: cal.cbs must have a column for length of time observed labelled \"T.cal\""))
    if ("custs" %in% colnames(cal.cbs)) {
      custs <- cal.cbs[, "custs"]
    }
    else {
      custs <- rep(1, length(x))
    }
    return(sum(custs * pnbd.LL.ori(params, x, t.x, T.cal)))## changed
  }


pnbd.LL.ori  = 
  function (params, x, t.x, T.cal) 
  {
    max.length <- max(length(x), length(t.x), length(T.cal))
    if (max.length%%length(x)) 
      warning("Maximum vector length not a multiple of the length of x")
    if (max.length%%length(t.x)) 
      warning("Maximum vector length not a multiple of the length of t.x")
    if (max.length%%length(T.cal)) 
      warning("Maximum vector length not a multiple of the length of T.cal")
    dc.check.model.params(c("r", "alpha", "s", "beta"), params, "pnbd.LL")
    
    
    if (any(x < 0) || !is.numeric(x)) 
      stop("x must be numeric and may not contain negative numbers.")
    if (any(t.x < 0) || !is.numeric(t.x)) 
      stop("t.x must be numeric and may not contain negative numbers.")
    if (any(T.cal < 0) || !is.numeric(T.cal)) 
      stop("T.cal must be numeric and may not contain negative numbers.")
    
    x <- rep(x, length.out = max.length)
    t.x <- rep(t.x, length.out = max.length)
    T.cal <- rep(T.cal, length.out = max.length)
    r <- params[1]
    alpha <- params[2]
    s <- params[3]
    beta <- params[4]
    maxab <- max(alpha, beta)
    absab <- abs(alpha - beta)
    param2 <- s + 1
    if (alpha < beta) {
      param2 <- r + x
    }
    
    part1 <- r * log(alpha) + s * log(beta) - lgamma(r) + lgamma(r + x)
    part2 <- -(r + x) * log(alpha + T.cal) - s * log(beta + T.cal)
    
    if (absab == 0) 
    {
      F1 <- -(r + s + x) * log(maxab + t.x)
      F2 <- -(r + s + x) * log(maxab + T.cal)
      partF <- subLogs.ori(F1, F2)## changed
    }
    else 
    {
      F1 <- hyperg_2F1(r + s + x, param2, r + s + x + 1, absab/(maxab + 
                                                                  t.x))/((maxab + t.x)^(r + s + x))
      F2 <- hyperg_2F1(r + s + x, param2, r + s + x + 1, absab/(maxab + 
                                                                  T.cal))/((maxab + T.cal)^(r + s + x))
      partF <- log(F1 - F2)
    }
    
    part3 <- log(s) - log(r + s + x) + partF
    ## modified
    result = part1+ part2+ log(1 + exp(part3 - part2))
    return(result)
  }



subLogs.ori = 
  function (loga, logb) 
  {
    ## this function is modified
    myvec = loga - logb
    sel = myvec <30
    result = rep(0,length(myvec))
    result[sel] = logb[sel] + log(exp(loga[sel] - logb[sel]) - 1)
    result[!sel] = loga[!sel]
    return(result)
    
  }



library(gsl)

pnbd.EstimateParameters.ori = function (cal.cbs, par.start = c(1, 1, 1, 1), max.param.value = 10000) 
{
  dc.check.model.params(c("r", "alpha", "s", "beta"), par.start, 
                        "pnbd.EstimateParameters")
  pnbd.eLL <- function(params, cal.cbs, max.param.value) 
  {
    params <- exp(params)
    params[params > max.param.value] <- max.param.value
    return(-1 * pnbd.cbs.LL.ori(params, cal.cbs))## changed
  }
  logparams <- log(par.start)
  results <- optim(logparams, pnbd.eLL, cal.cbs = cal.cbs, 
                   max.param.value = max.param.value, method = "CG")
  estimated.params <- exp(results$par)
  estimated.params[estimated.params > max.param.value] <- max.param.value
  return(estimated.params)
}



params <- pnbd.EstimateParameters.ori(cal.cbs.compressed)