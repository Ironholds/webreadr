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
#'requests <- split_clf_requests(data$request)
#'@export
split_clf_requests <- function(requests){
  internal_split(requests = strsplit(x = requests, split = " ", fixed = TRUE),
                 names = c("method", "asset", "protocol"))
}