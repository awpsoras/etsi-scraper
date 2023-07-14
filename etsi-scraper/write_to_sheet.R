
write_to_sheet <- function(output){
  
  gs4_auth(email = "caitscuriocorner@gmail.com")
  ssid <- '1yWb0vg9aLQTN4QpQISwtVObn-H6MqvduvIUFw6WAsz8'  #current sheet, to change see below
  sheet_write(output, ss = ssid, sheet = "Etsy Catalog")
  
  cat("\n***Written to google sheet!***")
}


