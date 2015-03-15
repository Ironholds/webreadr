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
#'@examples
#'#Read in an example CLF-formatted file provided with \code{webtools}
#'data <- read_clf(system.file("extdata/log.clf", package = "webtools"))
#'@export
read_clf <- function(file, has_header = FALSE){
  names <- c("ip_address", "remote_user_ident", "local_user_ident", "timestamp",
             "request", "status_code")
  col_types <- list(col_character(),
                    col_character(),
                    col_character(),
                    col_datetime("[%d/%b/%Y:%H:%M:%S %z]"),
                    col_character(),
                    col_integer(),
                    col_integer())
  if(has_header){
    return(read_delim(file = file, delim = " ", escape_backslash = FALSE, col_names = names,
                      col_types = col_types, skip = 1))
  }
  return(read_delim(file = file, delim = " ", escape_backslash = FALSE, col_names = names,
                    col_types = col_types))
}