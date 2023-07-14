#must be assigned to google_product_category
specialfilters <- function(output){
  case_when(
    grepl("sweatshirt", output$description) ~ "Apparel & Accessories > Clothing",
    grepl("shirt", output$description) ~ "Apparel & Accessories > Clothing > Shirts & Tops",
    grepl("tote", output$description) ~ "Apparel & Accessories > Handbag & Wallet Accessories",
    grepl("sticker", output$description) ~ "Apparel & Accessories",
    grepl(" hat ", output$description) ~ "Apparel & Accessories",
    .default = "Apparel & Accessories > Clothing"  #defaulting to clothing if unknown
  )

}

fixfacebook <- function(output){
  "Clothing & Accessories"
}

fixinstock <- function(output){
  ifelse(output$availability == "InStock", "In Stock", output$availability)
}
