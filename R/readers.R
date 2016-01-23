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
#'While outdated as a standard, systems using the CLF are still around; the Squid caching
#'system, for example, uses the CLF as one of its default log formats (the other,
#'the squid "native" format, can be read with \code{\link{read_squid}}).
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
#'\code{\link{split_clf}} for splitting out the "requests" field.
#'@examples
#'#Read in an example CLF-formatted file provided with the webreadr package.
#'data <- read_clf(system.file("extdata/log.clf", package = "webreadr"))
#'@export
read_clf <- function(file, has_header = FALSE){
  names <- c("ip_address", "remote_user_ident", "local_user_ident", "timestamp"
             ,"request", "status_code","bytes_sent")
  col_types <- list(col_character(),
                    col_character(),
                    col_character(),
                    col_datetime(format = "%d/%b/%Y:%H:%M:%S %z"),
                    col_character(),
                    col_integer(),
                    col_integer())

  data <- read_log(file = file, col_names = names, col_types = col_types, skip = ifelse(has_header, 1, 0))
  return(data)
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
#'@param file the full path to the CLF-formatted file you want to read.
#'
#'@param has_header whether or not the file has a header row. Set to FALSE by
#'default.
#'
#'@seealso \code{\link{read_clf}} for the /Common/ Log Format, and
#'\code{\link{split_clf}} for splitting out the "requests" field.
#'
#'@examples
#'#Read in an example Combined-formatted file provided with the webreadr package.
#'data <- read_combined(system.file("extdata/combined_log.clf", package = "webreadr"))
#'@export
read_combined <- function(file, has_header = FALSE){
  names <- c("ip_address", "remote_user_ident", "local_user_ident", "timestamp",
             "request", "status_code","bytes_sent","referer","user_agent")
  col_types <- list(col_character(),
                    col_character(),
                    col_character(),
                    col_datetime("%d/%b/%Y:%H:%M:%S %z"),
                    col_character(),
                    col_integer(),
                    col_integer(),
                    col_character(),
                    col_character())
  
  data <- read_log(file = file, col_names = names, col_types = col_types, skip = ifelse(has_header, 1, 0))
  return(data)
}

#'@title read Squid files
#'@description the Squid default log formats are either the CLF - for which, use
#'\code{\link{read_clf}} - or the "native" Squid format, which is described in more detail
#'below. \code{read_squid} allows you to read the latter.
#'
#'@details
#'
#'The log format for Squid servers can be custom-set, but by default follows one of two
#'patterns; it's either the Common Log Format (CLF), which you can read in with
#'\code{\link{read_clf}}, or the "native log format", a Squid-specific format handled
#'by this function. It consists of the fields:
#'
#'\itemize{
#'  \item{timestamp:} {the timestamp identifying when the request was received. This is
#'  stored (from the file's point of view) as a count of seconds, in UNIX time:
#'  \code{read_squid} turns them into POSIXlt timestamps, assuming UTC as an
#'  origin timezone.}
#'  \item{time_elapsed:} the amount of time (in milliseconds) that the connection and fulfilment
#'  of the request lasted for.
#'  \item{ip_address:} {the IP address of the remote host making the request.}
#'  \item{status_code:} {the status code and Squid response code associated with that request,
#'  stored as a single field. This can be split into two distinct fields with \code{\link{split_squid}}}
#'  \item{bytes_sent:} {the number of bytes sent}
#'  \item{http_method:} {the HTTP method (POST, GET, etc) used.}
#'  \item{url: }{the URL of the requested asset.}
#'  \item{remote_user_ident:} {the \href{https://tools.ietf.org/html/rfc1413}{RFC 1413} remote
#'  user identifier.}
#'  \item{peer_info:} {the status of how forwarding to a peer server was handled and, if the
#'  request was forwarded, the server it was sent to.}
#'}
#'
#'@param file the full path to the CLF-formatted file you want to read.
#'
#'@param has_header whether or not the file has a header row. Set to FALSE by
#'default.
#'
#'@seealso \code{\link{read_clf}} for the Common Log Format (also used by Squids), and
#'\code{\link{split_squid}} for splitting the "status_code" field into its component parts.
#'
#'@examples
#'#Read in an example Squid file provided with the webreadr package.
#'data <- read_squid(system.file("extdata/log.squid", package = "webreadr"))
#'@export
read_squid <- function(file, has_header = FALSE){
  names <- c("timestamp", "time_elapsed", "ip_address", "status_code",
             "bytes_sent","http_method", "url","remote_user_ident","peer_info")
  col_types <- list(col_number(),
                    col_integer(),
                    col_character(),
                    col_character(),
                    col_integer(),
                    col_character(),
                    col_character(),
                    col_character(),
                    col_character())
  data <- read_log(file = file, col_names = names, col_types = col_types, skip = ifelse(has_header, 1, 0))
  data$timestamp <- as.POSIXct(data$timestamp, origin = "1970-01-01", tz = "UTC")
  return(data)
}

#'@title read Amazon CloudFront access logs
#'@description Amazon CloudFront uses access logs with a standard format described
#'\href{http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html}{
#'on their website}. \code{read_aws} reads these files in; due to the Amazon treatment of header lines,
#'it is capable of organically detecting whether files lack common fields, and compensating for that. See
#'"Details"
#'
#'@param file the full path to the AWS file you want to read.
#'
#'@details
#'Amazon CloudFront uses tab-separated files with 
#'\href{http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html}{
#'Amazon-specific fields}. This can be changed by individual CloudFront users, however, to exclude particular fields,
#'and historically has contained fewer fields than it now does. Luckily, Amazon's insistence on standardisation in field
#'names means that we can organically detect if fields are missing, and compensate for that before reading in the file.
#'
#'If no fields are missing, the fields returned will be:
#'
#'\itemize{
#'  \item{date:} {the date and time when the request was \emph{completed}}
#'  \item{time_elapsed:} {the amount of time (in milliseconds) that the connection and fulfilment
#'  of the request lasted for.}
#'  \item{edge_location:} {the Amazon edge location that served the request, identified by a three-letter
#'  code. See the Amazon documentation for more details.}
#'  \item{bytes_sent:} {a count of the number of bytes sent by the server to the client, including headers,
#'  to fulfil the request.}
#'  \item{ip_address:} {the IP address of the client making the request.}
#'  \item{http_method:} {the HTTP method (POST, GET, etc) used.}
#'  \item{host:} {the CloudFront host name.}
#'  \item{path:} {the path to the requested asset.}
#'  \item{status_code:} {the HTTP status code associated with the request.}
#'  \item{referer:} {the referer associated with the request.}
#'  \item{user_agent:} {the user agent of the client that made the request.}
#'  \item{query:} {the query string associated with the request; if there is no query string,
#'  this will be a dash.}
#'  \item{cookie:} {the cookie header from the request, stored as name-value pairs. When no
#'  cookie header is provided, or it is empty, this will be a dash.}
#'  \item{result_type:} {the result of the request. This is similar to Squid response codes (
#'  see \code{\link{read_squid}}) but Amazon-specific; their documentation contains details on
#'  what each code means.}
#'  \item{request_id:} {A hashed unique identifier for each request.}
#'  \item{host_header: }{the host header of the requested asset. While \code{host} will always
#'  be the CloudFront host name, \code{host_header} contains alternate domain names (or 'CNAMES')
#'  when the CloudFront distribution is using them}.
#'  \item{protocol: } {the protocol used in the request (http/https).}
#'  \item{bytes_received: }{client-to-server bytes, including headers.}
#'  \item{time_elapsed:} {the time elapsed, in seconds, between the time the request was received and
#'  the time the server completed responding to it.}
#'}
#'
#'@seealso \code{\link{read_s3}}, for Amazon S3 files,
#'\code{\link{read_clf}} for the Common Log Format, \code{\link{read_squid}} and
#'\code{\link{read_combined}}.
#'
#'@examples
#'#Read in an example CloudFront file provided with the webreadr package.
#'data <- read_aws(system.file("extdata/log.aws", package = "webreadr"))
#'@export
read_aws <- function(file){
  header_fields <- unlist(strsplit(read_lines(file, n_max = 2)[2], " "))[-1]
  formatters <- aws_header_select(header_fields)
  data <- read_delim(file = file, delim = "\t", escape_backslash = FALSE, col_names = formatters[[1]],
                     col_types = formatters[[2]], skip = 2)
  if(all(c("date","time") %in% names(data))){
    data$date <- as.POSIXct(paste(data$date, data$time), tz = "UTC")
    return(data[,!names(data) == "time"])
  }
  return(data)
}

#'@title Read Amazon S3 Access Logs
#'@description \code{read_s3} provides a reader for Amazon's S3 service's access logs, described
#'\href{http://docs.aws.amazon.com/AmazonS3/latest/dev/LogFormat.html}{here}.
#'
#'@param file the full path to the S3 file you want to read.
#'
#'@details S3 access logs contain information about requests to S3 buckets, and follow
#'a standard format described
#'\href{http://docs.aws.amazon.com/AmazonS3/latest/dev/LogFormat.html}{here}.
#'
#'The fields for S3 files are:
#'
#'\itemize{
#'  \item{owner:} {the owner of the S3 bucket; a hashed user ID}
#'  \item{bucket:} {the bucket that processed the request.}
#'  \item{request_time:} {the time that a request was received. Formatted as POSIXct
#'  timestamps.}
#'  \item{remote_ip:} {the IP address that made the request.}
#'  \item{requester:} {the user ID of the person making the request; \code{Anonymous}
#'  if the request was not authenticated.}
#'  \item{operation:} {the actual operation performed with the request.}
#'  \item{key:} {the request's key, normally an encoded URL fragment or NA if
#'  the operation did not contain a key.}
#'  \item{uri:} {the full URI for the request, as well as the HTTP method and
#'  version. \code{\link{split_clf}} works to split this into a data.frame of 3
#'  columns.}
#'  \item{status:} {the HTTP status code associated with the request.}
#'  \item{error:} {the error code, if an error occurred; NA otherwise. See
#'  \href{http://docs.aws.amazon.com/AmazonS3/latest/dev/ErrorCode.html}{here} for
#'  more information about S3 error codes.}
#'  \item{sent:} {the number of bytes returned in response to the request.}
#'  \item{size:} {the total size of the returned object.}
#'  \item{time:} {the number of milliseconds between the request being sent and
#'  the response being sent, from the server's perspective.}
#'  \item{turn_around:} {the number of milliseconds the S3 bucket spent processing
#'  the request.}
#'  \item{referer:} {the referer associated with the request.}
#'  \item{user_agent:} {the user agent associated with the request.}
#'  \item{version_id:} {the version ID of the request; NA if the requested operation
#'  does not involve a version ID.}
#'}
#'
#'@seealso \code{\link{read_aws}} for reading Amazon Web Services (AWS) access log files,
#'and \code{\link{split_clf}}, which works well on the \code{uri} field from S3 files.
#'
#'@examples
#'# Using the inbuilt testing dataset
#'s3_data <- read_s3(system.file("extdata/s3.log", package = "webreadr"))
#'
#'@export
read_s3 <- function(file){
  names <- c("owner", "bucket", "request_time", "remote_ip", "requester", "request_id", "operation",
             "key", "uri", "status", "error", "sent", "size", "time", "turn_around", "referer",
             "user_agent", "version_id")
  types <- "cccccccccicnniiccc"
  data <- readr::read_log(file = file, col_types = types, col_names = names)
  data$request_time <- readr::parse_datetime(data$request_time, format = "%d/%b/%Y:%H:%M:%S %z")
  return(data)
}