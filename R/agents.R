#'@title parse an R user agent
#'@description takes a vector of R user agents and parses them, extracting R version,
#'architecture and platform.
#'
#'@param agents a vector of user agents
#'
#'@return a data.frame containing "r_version" (the version of R the user agent refers
#'to), "architecture" (the processor architecture used) and "platform" (windows,
#'linux or apple). If any of these cannot be identified, they will be represented
#'by an NA value instead.
#'
#'@importFrom stringi stri_extract_first
#'@importFrom urltools url_decode
#'@export
parse_r_agent <- function(agents){
  agents <- urltools::url_decode(agents)
  results <- data.frame(r_version = stri_extract_first(agents, regex = "(?<=^R \\()\\d\\.\\d{1,2}\\.\\d"),
                        architecture = stri_extract_first(agents, regex = "(i386|x86_64|i686|i486)"),
                        platform = stri_extract_first(agents, regex = "(mingw32|linux|apple)"),
                        stringsAsFactors = FALSE)
  results$platform[results$platform == "mingw32"] <- "windows"
  return(results)
}