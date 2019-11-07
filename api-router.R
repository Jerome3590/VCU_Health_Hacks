library(plumber)

serializer_csv <- function(){
  function(val, req, res, errorHandler){
    tryCatch({
      res$setHeader("Content-Type", "text/plain")
      res$setHeader("Content-Disposition", 'attachment; filename="cpic_genes.csv"')
      res$body <- paste0(val, collapse="\n")
      return(res$toResponse())
    }, error=function(e){
      errorHandler(req, res, e)
    })
  }
}
plumber::addSerializer("csv", serializer_csv)
plumber::plumber$new("CPIC NPI Table Processor.R")$run(port = 8000)

