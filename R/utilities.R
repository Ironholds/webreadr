#Organically grows or reduces collectors and column names for Amazon CloudFront files to compensate for changes
#in the number of fields. Kind of icky but it works and looks great from the user end, so..
aws_header_select <- function(header_fields){
  field_names <- c("date", "time", "x-edge-location", "sc-bytes", "c-ip", "cs-method",
                   "cs(Host)", "cs-uri-stem", "sc-status", "cs(Referer)", "cs(User-Agent)", "cs-uri-query",
                   "cs(Cookie)", "x-edge-result-type", "x-edge-request-id", "x-host-header", "cs-protocol", "cs-bytes",
                   "time-taken")
  
  new_names <- c("date", "time", "edge_location", "bytes_sent", "ip_address", "http_method", "host", "path",
                 "status_code", "referer", "user_agent", "query", "cookie", "result_type", "request_id",
                 "host_header", "protocol", "bytes_received", "time_elapsed")
  
  collectors <- list(col_character(), col_character(), col_character(), col_integer(), col_character(),
                     col_character(), col_character(), col_character(), col_integer(), col_character(),
                     col_character(), col_character(), col_character(), col_character(), col_character(),
                     col_character(), col_character(), col_character(), col_number())
  if(length(header_fields) == length(field_names) && all(header_fields == field_names)){
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
