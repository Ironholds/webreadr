#'@title split requests from a CLF-formatted file
#'@description CLF (Combined/Common Log Format) files store the HTTP method, protocol
#'and asset requested in the same field. \code{split_clf} takes this field as a vector
#'and returns a data.frame containing these elements in distinct columns. The function
#'also works nicely with the \code{uri} field from Amazon S3 files (see
#'\code{\link{read_s3}}).
#'
#'@param requests the "request" field from a CLF-formatted file, read in with
#'\code{\link{read_clf}} or \code{\link{read_combined}}.
#'
#'@return a data.frame of three columns - "method", "asset" and "protocol" - 
#'representing, respectively, the HTTP method used ("GET"), the asset requested
#'("/favicon.ico") and the protocol used ("HTTP/1.0"). In cases where
#'the request is not intact (containing, for example, just the protocol
#'or just the asset) a row of empty strings will currently be returned.
#'In the future, this will be somewhat improved.
#'
#'@seealso \code{\link{read_clf}} and \code{\link{read_combined}} for reading
#'in these files.
#'
#'@examples
#'# Grab CLF data and split out the request.
#'data <- read_combined(system.file("extdata/combined_log.clf", package = "webreadr"))
#'requests <- split_clf(data$request)
#'
#'# An example using S3 files
#'s3_data <- read_s3(system.file("extdata/s3.log", package = "webreadr"))
#'s3_requests <- split_clf(s3_data$uri)
#'
#'@export
split_clf <- function(requests){
  internal_split_clf(requests)
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
#'HTTP status of it.  In cases where the status code is not intact (containing, 
#'for example, just the squid_code) a row of empty strings will currently be returned.
#'In the future, this will be somewhat improved.
#'
#'@seealso \code{\link{read_squid}} for reading these files in,
#'and \code{\link{split_clf}} for similar parsing of multi-field
#'columns in Common/Combined Log Format (CLF) data.
#'
#'@examples
#'#Read in an example Squid file provided with the webtools package, then split out the codes
#'data <- read_squid(system.file("extdata/log.squid", package = "webreadr"))
#'statuses <- split_squid(data$status_code)
#'
#'@export
split_squid <- function(status_codes){
  internal_split_squid(status_codes)
}