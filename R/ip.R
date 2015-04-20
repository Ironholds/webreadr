#'@title convert IP addresses to their numeric representation
#'@description \code{ip_to_numeric} takes IP addresses stored
#'in their human-readable representation ("192.168.0.1")
#'and converts it to a numeric representation (3232235521).
#'
#'It's fully vectorised (yay!) and C++ based (woo!) but
#'doesn't yet support IPv6 addresses for a variety of
#'reasons (awww). Invalid IP addresses, including
#'IPv6 addresses, will have 0 returned.
#'
#'@param ip_addresses a vector of human-readable IP addresses
#'
#'@return the numeric representation of \code{ip_addresses}, with
#'invalid IPv4 IPs represented with a 0.
#'
#'@examples
#'#Convert your local, internal IP to its numeric
#'#representation.
#'ip_to_numeric("192.168.0.1")
#'
#'@export
ip_to_numeric <- function(ip_addresses){
  
  if(!length(ip_addresses)){
    return(stop("You provided an empty vector"))
  }
  
  ip_addresses <- strsplit(ip_addresses, split = ".", fixed = TRUE)
  
  return(ip_to_numeric_(ip_addresses))
}