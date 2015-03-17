#'@title split requests from a CLF-formatted file
#'@description CLF (Combined/Common Log Format) files store the HTTP method, protocol
#'and asset requested in the same field. \code{split_clf} takes this field as a vector
#'and returns a data.frame containing these elements in distinct columns.
#'
#'@param requests the "request" field from a CLF-formatted file, read in with
#'\code{\link{read_clf}} or \code{\link{read_combined}}.
#'
#'@return a data.frame of three columns - "method", "asset" and "protocol" - 
#'representing, respectively, the HTTP method used ("GET"), the asset requested
#'("/favicon.ico") and the protocol used ("HTTP/1.0").
#'
#'@seealso \code{\link{read_clf}} and \code{\link{read_combined}} for reading
#'in these files.
#'
#'@examples
#'#Grab CLF data and split out the request.
#'data <- read_combined(system.file("extdata/combined_log.clf", package = "webtools"))
#'requests <- split_clf(data$request)
#'@export
split_clf <- function(requests){
  internal_split(requests = strsplit(x = requests, split = " ", fixed = TRUE),
                 names = c("method", "asset", "protocol"))
}

#'@title split the "status_code" field in a Squid-formatted dataset.
#'@description the Squid data format (which can be read in with
#'\code{\link{read_squid}}) stores the squid response and the HTTP status
#'code as a single field. \code{\link{split_squid}} allows you to split
#'these into a data.frame of two distinct columns.
#'
#'@param status_codes a \code{status_code} column from a Squid file read in
#'with \code{\link{read_squid}}
#'
#'@return a data.frame of two columns - "squid_code" and "http_status" -
#'representing, respectively, the Squid response to the request and the
#'HTTP status of it.
#'
#'@seealso \code{\link{read_squid}} for reading these files in,
#'and \code{\link{split_clf}} for similar parsing of multi-field
#'columns in Common/Combined Log Format (CLF) data.
#'
#'@examples
#'#Read in an example Squid file provided with the webtools package, then split out the codes
#'data <- read_squid(system.file("extdata/log.squid", package = "webtools"))
#'status_splot <- split_squid(data$status_code)
#'
#'@export
split_squid <- function(status_codes){
  internal_split(requests = strsplit(x = requests, split = "/", fixed = TRUE),
                 names = c("squid_code", "http_status"))
}