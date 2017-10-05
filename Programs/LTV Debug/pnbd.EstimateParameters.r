pnbd.EstimateParameters =
function (cal.cbs, par.start = c(1, 1, 1, 1), max.param.value = 10000) 
{
    dc.check.model.params(c("r", "alpha", "s", "beta"), par.start, 
        "pnbd.EstimateParameters")
    pnbd.eLL <- function(params, cal.cbs, max.param.value) {
        params <- exp(params)
        params[params > max.param.value] <- max.param.value
        return(-1 * pnbd.cbs.LL(params, cal.cbs))
    }
    logparams <- log(par.start)
    results <- optim(logparams, pnbd.eLL, cal.cbs = cal.cbs, 
        max.param.value = max.param.value, method = "CG")
    estimated.params <- exp(results$par)
    estimated.params[estimated.params > max.param.value] <- max.param.value
    return(estimated.params)
}



library(gsl)

pnbd.EstimateParameters.ori = 
function (cal.cbs, par.start = c(1, 1, 1, 1), max.param.value = 10000) 
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
                   max.param.value = max.param.value, method = "L-BFGS-B")
  estimated.params <- exp(results$par)
  estimated.params[estimated.params > max.param.value] <- max.param.value
  return(estimated.params)
}