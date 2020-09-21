# Organically grows or reduces collectors and column names for Amazon CloudFront
# files to compensate for changes in the number of fields. Kind of icky but it
# works and looks great from the user end, so..

aws_header_select <- function(header_fields){
  
  field_names <- c("date", "time", "x-edge-location", "sc-bytes", "c-ip",
                   "cs-method", "cs(Host)", "cs-uri-stem", "sc-status",
                   "cs(Referer)", "cs(User-Agent)", "cs-uri-query", 
                   "cs(Cookie)", "x-edge-result-type", "x-edge-request-id", 
                   "x-host-header", "cs-protocol", "cs-bytes", "time-taken",
                   "x-forwarded-for", "ssl-protocol", "ssl-cipher", 
                   "x-edge-response-result-type", "cs-protocol-version",
                   "fle-status", "fle-encrypted-fields", "c-port", 
                   "time-to-first-byte", "x-edge-detailed-result-type",
                   "sc-content-type", "sc-content-len", "sc-range-start",
                   "sc-range-end")
  

  new_names <- c("date", "time", "edge_location", "bytes_sent", "ip_address",
                 "http_method", "host", "path", "status_code", "referer",
                 "user_agent", "query", "cookie", "result_type", "request_id",
                 "host_header", "protocol", "bytes_received", "time_elapsed",
                 "forwarded_for", "ssl_protocol", "ssl_cipher", 
                 "response_result_type", "protocol_version", "fle_status",
                 "fle_encrypted_fields", "port", "time_to_first_byte",
                 "detailed_result_type", "content_type", "content_length",
                 "content_range_start", "content_range_end")
  
  collectors <- list(col_character(), col_character(), col_character(),
                     col_integer(), col_character(), col_character(), 
                     col_character(), col_character(), col_integer(), 
                     col_character(), col_character(), col_character(),
                     col_character(), col_character(), col_character(),
                     col_character(), col_character(), col_character(),
                     col_number(), col_character(), col_character(), 
                     col_character(), col_character(), col_character(),
                     col_character(), col_integer(), col_integer(),
                     col_number(), col_character(), col_character(),
                     col_integer(), col_integer(), col_integer())
  
  if(length(header_fields) == length(field_names) &&
     all(header_fields == field_names)) {
    return(list(new_names, collectors))
  }
  
  out_names <- character()
  out_collectors <- list()
  
  for(field in header_fields){
    location <- which(field_names == field)[1]
    out_names <- append(out_names, new_names[location])
    out_collectors <- c(out_collectors, collectors[location])
  }
  if(anyNA(out_names)){
    stop("Your file contains unrecognised fields")
  }
  return(list(out_names, out_collectors))
}

unix_to_posix <- function(ts){
  return(as.POSIXct(ts, origin = '1970-01-01', tz = "UTC"))
}
