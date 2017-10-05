pnbd.cbs.LL
function (params, cal.cbs) 
{
    dc.check.model.params(c("r", "alpha", "s", "beta"), params, "pnbd.cbs.LL")
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



function (params, cal.cbs) 
  {
    dc.check.model.params(c("r", "alpha", "s", "beta"), params, "pnbd.cbs.LL")
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