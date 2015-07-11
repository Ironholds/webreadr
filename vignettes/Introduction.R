## ------------------------------------------------------------------------
library(webtools)
#read in an example file that comes with the webtools package
data <- read_combined(system.file("extdata/combined_log.clf", package = "webtools"))
#And if we look at the format...
str(data)

## ------------------------------------------------------------------------
requests <- split_clf(data$request)
str(requests)

