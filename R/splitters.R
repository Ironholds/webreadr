split_clf <- function(requests){
  internal_split(requests = strsplit(x = requests, split = " ", fixed = TRUE),
                 names = c("method", "asset", "protocol"))
}