ip_to_numeric <- function(ip_addresses){
  
  if(!length(ip_addresses)){
    return(stop("You provided an empty vector"))
  }
  
  ip_addresses <- strsplit(ip_addresses, split = "(\\.|\\:)")
  
  return(ip_to_numeric_(ip_addresses))
}