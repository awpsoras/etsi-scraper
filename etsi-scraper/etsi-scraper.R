library(rvest)
library(tidyverse)
library(jsonlite)
library(googlesheets4)
library(cli)

source('etsy_summary.R')
source('special_filters.R')
source('write_to_sheet.R')


#Stand-alone, Caitlyn only

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

etsysummary <- make_etsy_output(shopname = 'CaitsCurioCorner')

#special options
etsysummary$google_product_category <- specialfilters(etsysummary)
etsysummary$availability <- fixinstock(etsysummary)
etsysummary$fb_product_category <- fixfacebook(etsysummary)



write_to_sheet(etsysummary)




