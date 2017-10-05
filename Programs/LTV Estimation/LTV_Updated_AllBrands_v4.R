library(optimx)

#'Nelder-Mead', 'BFGS', 'L-BFGS-B', 'CG'
methodlist.optimx.spend  <- c('L-BFGS-B')
methodlist.optimx.trans  <- c('L-BFGS-B')

pnbd.EstimateParameters =
function (cal.cbs, par.start = c(runif(4, 0, 1)), max.param.value = 100000) 
{
  dc.check.model.params(c("r", "alpha", "s", "beta"), par.start, 
                        "pnbd.EstimateParameters")
  pnbd.eLL <- function(params, cal.cbs, max.param.value) 
  {
    params <- exp(params)
    params[params > max.param.value] <- max.param.value
    return(-1 * pnbd.cbs.LL(params, cal.cbs))
  }
  logparams <- log(par.start)
  results <- optimx(logparams, pnbd.eLL, cal.cbs = cal.cbs,
                   upper=Inf, lower=-Inf, itnmax=1000,
                   max.param.value = max.param.value, 
                   method = methodlist.optimx.trans)
  print(results <- summary(results, order=value))
  estimated.params <- (exp(coef(results)))[1,]
  estimated.params[estimated.params > max.param.value] <- max.param.value
  return(estimated.params)
}


pnbd.cbs.LL
function (params, cal.cbs) 
{
  dc.check.model.params(c("r", "alpha", "s", "beta"), params, "pnbd.cbs.LL")
  tryCatch(x <- cal.cbs[, "x"], error = function(e) stop("Error in pnbd.cbs.LL: cal.cbs must have a frequency column labelled \"x\""))
  tryCatch(t.x <- cal.cbs[, "t.x"], error = function(e) stop("Error in pnbd.cbs.LL: cal.cbs must have a recency column labelled \"t.x\""))
  tryCatch(T.cal <- cal.cbs[, "T.cal"], error = function(e) stop("Error in pnbd.cbs.LL: cal.cbs must have a column for length of time observed labelled \"T.cal\""))
  if ("custs" %in% colnames(cal.cbs)) 
  {
    custs <- cal.cbs[, "custs"]
  }
  else 
  {
    custs <- rep(1, length(x))
  }
  return(sum(custs * pnbd.LL(params, x, t.x, T.cal)))
}



pnbd.LL =
function (params, x, t.x, T.cal) 
{
  h2f1 <- function(a, b, c, z) 
  {
    lenz <- length(z)
    j = 0
    uj <- 1:lenz
    uj <- uj/uj
    y <- uj
    lteps <- 0
    while (lteps < lenz) 
    {
      lasty <- y
      j <- j + 1
      uj <- uj * (a + j - 1) * (b + j - 1)/(c + j - 1) * z/j
      y <- y + uj
      lteps <- sum(y == lasty)
    }
    return(y)
  }
  
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
  if (alpha < beta) 
  {
    param2 <- r + x
  }
  part1 <- r * log(alpha) + s * log(beta) - lgamma(r) + lgamma(r + x)
  part2 <- -(r + x) * log(alpha + T.cal) - s * log(beta + T.cal)
  if (absab == 0) 
  {
    partF <- -(r + s + x) * log(maxab + t.x) + log(1 - ((maxab + t.x)/(maxab + T.cal))^(r + s + x))
  }
  else 
  {
    F1 = h2f1(r + s + x, param2, r + s + x + 1, absab/(maxab + t.x))
    F2 = h2f1(r + s + x, param2, r + s + x + 1, absab/(maxab + T.cal)) * ((maxab + t.x)/(maxab + T.cal))^(r + s + x)
    partF = -(r + s + x) * log(maxab + t.x) + log(F1 - F2)
  }
  part3 <- log(s) - log(r + s + x) + partF
  return(part1 + log(exp(part2) + exp(part3)))
}




spend.EstimateParameters =
function (m.x.vector, x.vector, par.start = c(1, 1, 1), max.param.value = 10000) 
{
  if (any(m.x.vector < 0) || !is.numeric(m.x.vector)) 
    stop("m.x must be numeric and may not contain negative numbers.")
  if (any(x.vector < 0) || !is.numeric(x.vector)) 
    stop("x must be numeric and may not contain negative numbers.")
  if (any(x.vector == 0) || any(m.x.vector == 0)) {
    warning("Customers with 0 transactions or 0 average spend in spend.LL")
  }
  if (length(m.x.vector) != length(x.vector)) {
    stop("m.x.vector and x.vector must be the same length.")
  }
  spend.eLL <- function(params, m.x.vector, x.vector, max.param.value) 
  {
    params <- exp(params)
    params[params > max.param.value] <- max.param.value
    return(-1 * sum(spend.LL(params, m.x.vector, x.vector)))
  }
  logparams <- log(par.start)
  results <- optimx(logparams, spend.eLL, m.x.vector = m.x.vector,
                   upper=Inf, lower=-Inf, itnmax=1000,
                   x.vector = x.vector, max.param.value = max.param.value, 
                   method = methodlist.optimx.spend)
  print(results <- summary(results, order=value))
  estimated.params <- (exp(coef(results)))[1,]
  estimated.params[estimated.params > max.param.value] <- max.param.value
  return(estimated.params)
}


spend.LL = 
function (params, m.x, x) 
{
  max.length <- max(length(m.x), length(x))
  if (max.length%%length(m.x)) 
    warning("Maximum vector length not a multiple of the length of m.x")
  if (max.length%%length(x)) 
    warning("Maximum vector length not a multiple of the length of x")
  dc.check.model.params(c("p", "q", "gamma"), params, "spend.LL")
  if (any(m.x < 0) || !is.numeric(m.x)) 
    stop("m.x must be numeric and may not contain negative numbers.")
  if (any(x < 0) || !is.numeric(x)) 
    stop("x must be numeric and may not contain negative numbers.")
  if (any(x == 0) || any(m.x == 0)) {
    warning("Customers with 0 transactions or 0 average spend in spend.LL")
  }
  m.x <- rep(m.x, length.out = max.length)
  x <- rep(x, length.out = max.length)
  p <- params[1]
  q <- params[2]
  gamma <- params[3]
  ll <- rep(0, max.length)
  non.zero <- which(x > 0 & m.x > 0)
  p <- params[1]
  q <- params[2]
  gamma <- params[3]
  ll[non.zero] <- (-lbeta(p * x[non.zero], q) + q * log(gamma) + 
                     (p * x[non.zero] - 1) * log(m.x[non.zero]) + (p * x[non.zero]) * 
                     log(x[non.zero]) - (p * x[non.zero] + q) * log(gamma + 
                                                                      m.x[non.zero] * x[non.zero]))
  return(ll)
}



dc.check.model.params =
function (printnames, params, func) 
{
  if (length(params) != length(printnames)) {
    stop("Error in ", func, ": Incorrect number of parameters; there should be ", 
         length(printnames), ".", call. = FALSE)
  }
  if (!is.numeric(params)) {
    stop("Error in ", func, ": parameters must be numeric, but are of class ", 
         class(params), call. = FALSE)
  }
  if (any(params < 0)) {
    stop("Error in ", func, ": All parameters must be positive. Negative parameters: ", 
         paste(printnames[params < 0], collapse = ", "), call. = FALSE)
  }
}



pnbd.compress.cbs =
function (cbs, rounding = 3) 
{
  if (!("x" %in% colnames(cbs))) 
    stop("Error in pnbd.compress.cbs: cbs must have a frequency column labelled \"x\"")
  if (!("t.x" %in% colnames(cbs))) 
    stop("Error in pnbd.compress.cbs: cbs must have a recency column labelled \"t.x\"")
  if (!("T.cal" %in% colnames(cbs))) 
    stop("Error in pnbd.compress.cbs: cbs must have a column for length of time observed labelled \"T.cal\"")
  orig.rows <- nrow(cbs)
  if (!("custs" %in% colnames(cbs))) {
    custs <- rep(1, nrow(cbs))
    cbs <- cbind(cbs, custs)
  }
  other.colnames <- colnames(cbs)[!(colnames(cbs) %in% c("x", 
                                                         "t.x", "T.cal"))]
  cbs[, c("x", "t.x", "T.cal")] <- round(cbs[, c("x", "t.x", 
                                                 "T.cal")], rounding)
  cbs <- as.matrix(aggregate(cbs[, !(colnames(cbs) %in% c("x", 
                                                          "t.x", "T.cal"))], by = list(x = cbs[, "x"], t.x = cbs[, 
                                                                                                                 "t.x"], T.cal = cbs[, "T.cal"]), sum))
  colnames(cbs) <- c("x", "t.x", "T.cal", other.colnames)
  final.rows <- nrow(cbs)
  message("Data reduced from ", orig.rows, " rows to ", final.rows, 
          " rows.")
  return(cbs)
}





pnbd.cbs.LL =
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
  return(sum(custs * pnbd.LL(params, x, t.x, T.cal)))
}



pnbd.ConditionalExpectedTransactions =
function (params, T.star, x, t.x, T.cal) 
{
  max.length <- max(length(T.star), length(x), length(t.x), 
                    length(T.cal))
  if (max.length%%length(T.star)) 
    warning("Maximum vector length not a multiple of the length of T.star")
  if (max.length%%length(x)) 
    warning("Maximum vector length not a multiple of the length of x")
  if (max.length%%length(t.x)) 
    warning("Maximum vector length not a multiple of the length of t.x")
  if (max.length%%length(T.cal)) 
    warning("Maximum vector length not a multiple of the length of T.cal")
  dc.check.model.params(c("r", "alpha", "s", "beta"), params, 
                        "pnbd.ConditionalExpectedTransactions")
  if (any(T.star < 0) || !is.numeric(T.star)) 
    stop("T.star must be numeric and may not contain negative numbers.")
  if (any(x < 0) || !is.numeric(x)) 
    stop("x must be numeric and may not contain negative numbers.")
  if (any(t.x < 0) || !is.numeric(t.x)) 
    stop("t.x must be numeric and may not contain negative numbers.")
  if (any(T.cal < 0) || !is.numeric(T.cal)) 
    stop("T.cal must be numeric and may not contain negative numbers.")
  T.star <- rep(T.star, length.out = max.length)
  x <- rep(x, length.out = max.length)
  t.x <- rep(t.x, length.out = max.length)
  T.cal <- rep(T.cal, length.out = max.length)
  r <- params[1]
  alpha <- params[2]
  s <- params[3]
  beta <- params[4]
  P1 <- (r + x) * (beta + T.cal)/((alpha + T.cal) * (s - 1))
  P2 <- (1 - ((beta + T.cal)/(beta + T.cal + T.star))^(s - 
                                                         1))
  P3 <- pnbd.PAlive(params, x, t.x, T.cal)
  return(P1 * P2 * P3)
}




pnbd.PAlive = 
function (params, x, t.x, T.cal) 
{
  h2f1 <- function(a, b, c, z) {
    lenz <- length(z)
    j = 0
    uj <- 1:lenz
    uj <- uj/uj
    y <- uj
    lteps <- 0
    while (lteps < lenz) {
      lasty <- y
      j <- j + 1
      uj <- uj * (a + j - 1) * (b + j - 1)/(c + j - 1) * 
        z/j
      y <- y + uj
      lteps <- sum(y == lasty)
    }
    return(y)
  }
  max.length <- max(length(x), length(t.x), length(T.cal))
  if (max.length%%length(x)) 
    warning("Maximum vector length not a multiple of the length of x")
  if (max.length%%length(t.x)) 
    warning("Maximum vector length not a multiple of the length of t.x")
  if (max.length%%length(T.cal)) 
    warning("Maximum vector length not a multiple of the length of T.cal")
  dc.check.model.params(c("r", "alpha", "s", "beta"), params, 
                        "pnbd.PAlive")
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
  A0 <- 0
  if (alpha >= beta) {
    F1 <- h2f1(r + s + x, s + 1, r + s + x + 1, (alpha - 
                                                   beta)/(alpha + t.x))
    F2 <- h2f1(r + s + x, s + 1, r + s + x + 1, (alpha - 
                                                   beta)/(alpha + T.cal))
    A0 <- F1/((alpha + t.x)^(r + s + x)) - F2/((alpha + T.cal)^(r + 
                                                                  s + x))
  }
  else {
    F1 <- h2f1(r + s + x, r + x, r + s + x + 1, (beta - alpha)/(beta + t.x))
    F2 <- h2f1(r + s + x, r + x, r + s + x + 1, (beta - alpha)/(beta + T.cal))
    A0 <- F1/((beta + t.x)^(r + s + x)) - F2/((beta + T.cal)^(r + s + x))
  }
  return((1 + s/(r + s + x) * (alpha + T.cal)^(r + x) * (beta + T.cal)^s * A0)^(-1))
}





spend.expected.value = 
function (params, m.x, x) 
{
  max.length <- max(length(m.x), length(x))
  if (max.length%%length(m.x)) 
    warning("Maximum vector length not a multiple of the length of m.x")
  if (max.length%%length(x)) 
    warning("Maximum vector length not a multiple of the length of x")
  dc.check.model.params(c("p", "q", "gamma"), params, "spend.expected.value")
  if (any(m.x < 0) || !is.numeric(m.x)) 
    stop("m.x must be numeric and may not contain negative numbers.")
  if (any(x < 0) || !is.numeric(x)) 
    stop("x must be numeric and may not contain negative numbers.")
  m.x <- rep(m.x, length.out = max.length)
  x <- rep(x, length.out = max.length)
  p <- params[1]
  q <- params[2]
  gamma <- params[3]
  M <- (gamma + m.x * x) * p/(p * x + q - 1)
  return(M)
}