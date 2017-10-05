spend.LL
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