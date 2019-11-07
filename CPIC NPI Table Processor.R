
library(readxl)
library(plumber)
library(dplyr)
library(readr)
library(tidyverse)
library(stringr)
require(data.table)
library(reticulate)
library(aws.s3)
library(readr)


#* @apiTitle CPIC/NPI Table Processor

#Get files from AWS S3 
#(must have AWS access Keys loaded to environment)

obj <-get_object("s3://medicaid-devops/UPDATED.csv")  
csvcharobj <- rawToChar(obj)  
con <- textConnection(csvcharobj)  
exclusion_list <- read.csv(file = con)


VARIABLES <- list(
  bus_name = "Name of Business",
  bus_address = "Address of Business")



#* Return query of exclusion list
#* @param bus_name Business Name
#* @param bus_address Business Address
#* @get /query
function(bus_name, bus_address) {
  
    hits <- filter(exclusion_list, BUSNAME == bus_name | ADDRESS == bus_address)
    
    return(hits)

}



#* Return query of any business names on exclusion list
#* @param bus_name Business Name
#* @get /BusinessName
function(bus_name) {
  
  hits <- filter(exclusion_list, BUSNAME == bus_name)
  
  return(hits)
  
}



#* Return query of any business addresses on exclusion list
#* @param bus_address Business Address
#* @get /BusinessAddress
function(bus_address) {
  
  hits <- filter(exclusion_list, ADDRESS == bus_address)
  
  return(hits)
  
}



#* @post /cpic_upload
#* @param req
function(req){
  
  result <- as.data.frame(req$postBody)
  write.table(result, file="CPIC_upload.csv", sep=",", row.names=FALSE, col.names=TRUE, append = T)
  
  wd <- getwd()
  
  file_path <- paste0(wd,"/CPIC_upload.csv")
  file_size <- file.size('CPIC_upload.csv')
  file_created <- file.mtime('CPIC_upload.csv')
  file_success <- file.exists('CPIC_upload.csv')
  

  newlist <- list(file_path,file_size,file_created, file_success)
  
  newlist
  
}



#* @get /process_cpic
function(){
  
 
  CPIC_upload <- fread("CPIC_upload.csv", skip = 6)


  CPIC_genes <- CPIC_upload[,1]
  write.table(CPIC_genes, file="CPIC_genes.csv", sep=",", row.names=FALSE, col.names=TRUE, append = T)
  
  wd <- getwd()
  
  file_path <- paste0(wd,"/CPIC_genes.csv")
  file_size <- file.size('CPIC_genes.csv')
  file_created <- file.mtime('CPIC_genes.csv')
  file_success <- file.exists('CPIC_genes.csv')
  
  
  newlist <- list(file_path, file_size, file_created, file_success)
  
  newlist

}



#* @serializer csv
#* @get /cpic_genes
function(){
  
  cpic <- read_csv("CPIC_genes.csv")
  csv_file <- tempfile(fileext = ".csv")
  
  on.exit(unlink(csv_file), add = TRUE)
  write.csv(cpic, file = csv_file)
  
  readLines(csv_file, warn = FALSE)
  
  
}