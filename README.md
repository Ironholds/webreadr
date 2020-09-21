## Read access log data in R

__Author:__ Oliver Keyes<br/>
__License:__ [MIT](http://opensource.org/licenses/MIT)<br/>
__Status:__ Stable

[![Travis-CI Build Status](https://travis-ci.org/Ironholds/webreadr.svg?branch=master)](https://travis-ci.org/Ironholds/webreadr) ![downloads](http://cranlogs.r-pkg.org/badges/grand-total/webreadr)

`webreadr` is an access log reader for R. It is capable of handling logs in
Squid, Apache, Varnish, NGINX or AWS's usual formats, and is based around Hadley Wickham's `readr` package for
maximum speed. See the [vignette](https://github.com/Ironholds/webtools/blob/master/vignettes/Introduction.Rmd)
for more information, and if you have requests for additional features, open an [issue](https://github.com/Ironholds/webtools/issues).

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/Ironholds/webreadr/blob/master/CONDUCT.md). By participating in this project you agree to abide by its terms.

### Installation

For the released version:

    install.packages("webreadr")
    
For the development version:

    library(devtools)
    install_github("ironholds/webreadr", INSTALL_opts = c("--no-multiarch"))
