## webtools

Utilities for reading, cleaning and parsing access log data. Read in Squid, Apache, Varnish or NGINX access logs,
filter them, normalise them for geolocation, decode the URLs - all in one package. If you have requests
for additional features, open an [issue](https://github.com/Ironholds/webtools/issues)!

__Author:__ Oliver Keyes<br/>
__License:__ [MIT](http://opensource.org/licenses/MIT)<br/>
__Status:__ In development

### Installation

For the development version:

    library(devtools)
    install_github("ironholds/webtools")
    
A CRAN release will come when it's stable.

### Dependencies
* R. Doy.
* [readr](https://github.com/hadley/readr)
* [Rcpp](http://cran.rstudio.com/web/packages/Rcpp/)
