library(rvest)
library(tidyverse)
library(jsonlite)
library(googlesheets4)
library(cli)

cat('------------------------------------------------------------------------')

source('etsy_summary.R')
source('special_filters.R')
source('write_to_sheet.R')


#Stand-alone, Caitlyn only

#try this instead of below:
clargs <- commandArgs(trailingOnly=TRUE)

#Check if we need everything, TRUE (everything) is default just in case
#in case someone supplies more than one argument

if(file.exists("etsysummary_prev.rds")){
  
  #looking for update arguments
  if(any(grepl('something similar', clargs, ignore.case = TRUE) == TRUE)){
    cat('\n\nYes, literally something similar works\n\n')
  }
  
  everything_arguments <- grepl('yes|y|something|similar', clargs, ignore.case = TRUE)
  
  if(any(everything_arguments == TRUE)){response <- TRUE}  else response <- FALSE
  
} else {response <- TRUE}



banner <- "                                                     
#    #  ####  #####     ####  # #####  #       ####  
#    # #    #   #      #    # # #    # #      #      
###### #    #   #      #      # #    # #       ####  
#    # #    #   #      #  ### # #####  #           # 
#    # #    #   #      #    # # #   #  #      #    # 
#    #  ####    #       ####  # #    # ######  ####  
                                                     
                                                                  
#####  ######   ##   #####     #####   ####   ####  #    #  ####  
#    # #       #  #  #    #    #    # #    # #    # #   #  #      
#    # #####  #    # #    #    #####  #    # #    # ####    ####  
#####  #      ###### #    #    #    # #    # #    # #  #        # 
#   #  #      #    # #    #    #    # #    # #    # #   #  #    # 
#    # ###### #    # #####     #####   ####   ####  #    #  ####  
                                                                  

(and wait for scripts)
"
cat(banner, sep = "\n")

etsysummary <- make_etsy_output(shopname = 'CaitsCurioCorner', everything = response)




#special options
etsysummary$google_product_category <- specialfilters(etsysummary)
etsysummary$availability <- fixinstock(etsysummary)
etsysummary$fb_product_category <- fixfacebook(etsysummary)


write_to_sheet(etsysummary)

Sys.sleep(3)





