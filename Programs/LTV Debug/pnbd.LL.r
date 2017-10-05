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









pnbd.LL.ori =
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
    if (alpha < beta) 
	{
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
      F1 <- hyperg_2F1(r + s + x, param2, r + s + x + 1, absab/(maxab + t.x))/((maxab + t.x)^(r + s + x))
      F2 <- hyperg_2F1(r + s + x, param2, r + s + x + 1, absab/(maxab + T.cal))/((maxab + T.cal)^(r + s + x))
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