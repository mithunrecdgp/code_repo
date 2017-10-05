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
    spend.eLL <- function(params, m.x.vector, x.vector, max.param.value) {
        params <- exp(params)
        params[params > max.param.value] <- max.param.value
        return(-1 * sum(spend.LL(params, m.x.vector, x.vector)))
    }
    logparams <- log(par.start)
    results <- optim(logparams, spend.eLL, m.x.vector = m.x.vector, 
        x.vector = x.vector, max.param.value = max.param.value, 
        method = "L-BFGS-B")
    estimated.params <- exp(results$par)
    estimated.params[estimated.params > max.param.value] <- max.param.value
    return(estimated.params)
}