#packages are defined in app.R

make_etsy_output <- function(shopname) {
  
  shopurl <- paste0('https://www.etsy.com/shop/', shopname)
  
  
  makepagelink <- function(url, pagenum) {
    return(paste0(url, "/", "?ref=items-pagination&page=", pagenum))
  }
  
  getlistingids <- function(html) {
    return(html %>%
             html_nodes("[data-listings-container] a") %>%
             html_attr("data-listing-id"))
  }
  
  #conveniently, this becomes vectorized
  makelistinglink <- function(id) {
    return(paste0('http://www.', shopname, ".etsy.com/listing/", id))
  }
  
  getlistingjson <- function(listing_html) {
    listing_html %>%
      html_element("script[type='application/ld+json']") %>% 
      html_text() %>% 
      fromJSON()
  }
  
  
  #getting all valid listings---------------------------------------------------------------------
  
  isend <- FALSE
  all_ids <- character(0)
  page_num <- 1
  
  cli_progress_bar("Looking for shop pages:")
  while(isend == FALSE) {
    current_page <- read_html(makepagelink(shopurl, page_num))
    current_ids <- getlistingids(current_page)
    
    all_ids <- c(all_ids, current_ids)
    if(length(current_ids) == 0) {isend <- TRUE}
    page_num <- page_num + 1
    
    cli_progress_update()
    
  }
  cli_progress_done()
  
  #make all the links
  all_links <- makelistinglink(all_ids)
  
  #get all the html, this takes a long time in R
  all_html <- vector("list", length = length(all_links))
  
  cli_progress_bar("Grabbing listings:", total = length(all_links))
  for (link in 1:length(all_links)) {
    all_html[[link]] <- read_html(all_links[link])
    cli_progress_update()
  }
  cli_progress_done()
  
  #all_html <- lapply(all_links, read_html)
  
  
  #get json
  all_json <- lapply(all_html, getlistingjson)
  
  
  #parsing json------------------------------------------------------------------------------
  
  
  #AggregateOffer > low/highPrice, offerCount
  #Offer > price, eligibleQuantity
  #there might be more going on
  
  
  #those dependent on offer type
  all_prices <- vector("list", length = length(all_links))
  all_quantities <- vector("list", length = length(all_links))
  
  all_prices <- sapply(all_json, function(x){
    if(x$offers$`@type` == "AggregateOffer"){return(x$offers$lowPrice)}
    else {return(x$offers$price)}
  })
  
  all_quantities <- sapply(all_json, function(x){
    if(x$offers$`@type` == "AggregateOffer"){return(x$offers$offerCount)}
    else {return(x$offers$eligibleQuantity)}
  })
  
  
  #those independent
  all_titles <- vector("list", length = length(all_links))
  all_descriptions <- vector("list", length = length(all_links))
  all_images <- vector("list", length = length(all_links))
  all_currencies <- vector("list", length = length(all_links))
  all_brands <- vector("list", length = length(all_links))
  all_availabilites <- vector("list", length = length(all_links))
  all_categories <- vector("list", length = length(all_links))
  
  all_titles <- sapply(all_json, function(x){x$name %>% str_squish()})
  all_descriptions <- sapply(all_json, function(x){x$description %>% str_squish()})
  #all_images <- sapply(all_json, function(x){x$image$contentURL[1]})
  all_brands <- sapply(all_json, function(x){x$brand$name})
  all_currencies <- sapply(all_json, function(x){x$offers$priceCurrency})
  all_availabilites <- sapply(all_json, function(x){
    x$offers$availability %>% word(-1, sep = fixed("/"))
  })
  all_categories <- sapply(all_json, function(x){x$category})
  
  
  #unfortunately, the full size images from json are bad for insta
  #will revert to the html scraped version from the listing
  #this is the medium size, the thumbnail size resides in json and 
  #also the main listings container
  all_images <- sapply(all_html, function(x){
    x %>% 
      html_element("[data-carousel-first-image]") %>% 
      html_attr("src")
  })
  
  
  #So, to have a final thing------------------------------------------------------------
  etsysummary <- tibble(
    id = all_ids,
    title = all_titles,
    description = all_descriptions,
    availability = all_availabilites,
    condition = "new",  #still unsure about that one, maybe answers in https://schema.org
    price = paste(all_prices, all_currencies, sep = " "),
    link = all_links,
    image_link = all_images,
    brand = all_brands,
    google_product_category = all_categories,  #who knows if matches etsy
    fb_product_category = all_categories,  #same, who knows
    quantity_to_sell_on_facebook = all_quantities
  )
  

}




