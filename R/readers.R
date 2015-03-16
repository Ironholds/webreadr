#'@title read CLF-formatted logs
#'@description Read a file of request logs stored in the
#'\href{https://en.wikipedia.org/wiki/Common_Log_Format}{Common Log Format}.
#'
#'@details the CLF is a standardised format for web request logs. It consists of the fields:
#'
#'\itemize{
#'  \item{ip_address:} {the IP address of the remote host that made the request. The CLF
#'  does not (by default) include the de-facto standard X-Forwarded-For header}
#'  \item{remote_user_ident:} {the \href{https://tools.ietf.org/html/rfc1413}{RFC 1413} remote
#'  user identifier.}
#'  \item{local_user_ident:} {the identifier the user has authenticated with locally.}
#'  \item{timestamp:} {the timestamp associated with the request, stored as
#'  "[08/Apr/2001:17:39:04 -0800]", where "-0800" represents the time offset (minus
#'  eight hours) of the timestamp from UTC.}
#'  \item{request:} {the actual user request, containing the HTTP method used, the
#'  asset requested, and the HTTP Protocol version used.}
#'  \item{status_code:} {the HTTP status code returned.}
#'  \item{bytes_sent:} {the number of bytes sent}
#'}
#'
#'While outdated as a standard, systems using the CLF are still around. \code{read_clf}
#'allows you to conveniently read these files, parsing the timestamps as it goes.
#'
#'@param file the full path to the CLF-formatted file you want to read.
#'
#'@param has_header whether or not the file has a header row. Set to FALSE by
#'default.
#'
#'@return a data.frame consisting of seven fields, as discussed above, with normalised
#'timestamps.
#'
#'@seealso \code{\link{read_combined}} for the /Combined/ Log Format, and
#'\code{\link{split_clf_requests}} for splitting out the "requests" field.
#'@examples
#'#Read in an example CLF-formatted file provided with \code{webtools}
#'data <- read_clf(system.file("extdata/log.clf", package = "webtools"))
#'@export
read_clf <- function(file, has_header = FALSE){
  names <- c("ip_address", "remote_user_ident", "local_user_ident", "timestamp",
             "timestamp_junk","request", "status_code","bytes_sent")
  col_types <- list(col_character(),
                    col_character(),
                    col_character(),
                    col_character(),
                    col_character(),
                    col_character(),
                    col_integer(),
                    col_integer())

  data <- read_delim(file = file, delim = " ", escape_backslash = FALSE, col_names = names,
                    col_types = col_types, skip = ifelse(has_header, 1, 0))
  
  #This is ugly. Due to CDF silliness ("oh, it's space separated! Except that one space that
  #isn't a separator") we can't take full advantage of readr's awesome and have to do a fragment of it manually.
  data$timestamp <- strptime(paste0(data$timestamp,data$timestamp_junk), format = "[%d/%b/%Y:%H:%M:%S %z]")
  return(data[,!names(data) == "timestamp_junk"])
}

#'@title read Combined Log Format files
#'@description read requests logs following the Combined Log Format.
#'
#'@details the Combined Log Format (CLF) is the same as the Common Log Format (CLF, because
#'software engineers and naming go together like chalk and cheese), which
#'is documented at \code{\link{read_clf}}. In addition to the fields described there,
#'the Combined Log Format also includes:
#'
#'\itemize{
#'  \item{referer:} {the referer associated with the request.}
#'  \item{user_agent:} {the user agent of the user that made the request.}
#'}
#'
#'\code{read_combined} handles these fields, as well as the CLF-standard ones. This is (amongst
#'other things) the default logging format for \href{http://nginx.org/}{nginx} servers
#'
#'@seealso \code{\link{read_clf}} for the /Common/ Log Format, and
#'\code{\link{split_clf_requests}} for splitting out the "requests" field.
#'
#'@examples
#'#Read in an example Combined-formatted file provided with \code{webtools}
#'data <- read_combined(system.file("extdata/combined_log.clf", package = "webtools"))
#'@export
read_combined <- function(file, has_header = FALSE){
  names <- c("ip_address", "remote_user_ident", "local_user_ident", "timestamp",
             "timestamp_junk","request", "status_code","bytes_sent","referer","user_agent")
  col_types <- list(col_character(),
                    col_character(),
                    col_character(),
                    col_character(),
                    col_character(),
                    col_character(),
                    col_integer(),
                    col_integer(),
                    col_character(),
                    col_character())
  
  data <- read_delim(file = file, delim = " ", escape_backslash = FALSE, col_names = names,
                     col_types = col_types, skip = ifelse(has_header, 1, 0))
  #See read_clf()
  data$timestamp <- strptime(paste0(data$timestamp,data$timestamp_junk), format = "[%d/%b/%Y:%H:%M:%S %z]")
  return(data[,!names(data) == "timestamp_junk"])
}

read_squid <- function(file, has_header = FALSE){
  #Timestamp Elapsed Client Action/Code Size Method URI Ident Hierarchy/From Content
}

read_varnish <- function(file, has_header = FALSE){
  
}

read_aws <- function(file, has_header){
  
}