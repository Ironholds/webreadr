<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{webreadr}
-->

# Reading web access logs
R, as a language, is used for analysing pretty much everything from genomic data to financial information. It's also
used to analyse website access logs, and R lacks a good framework for doing that; the URL decoder isn't vectorised,
the file readers don't have convenient defaults, and good luck normalising IP addresses at scale.

Enter <code>webreadr</code>, which contains convenient wrappers and functions for reading, munging and formatting
data from access logs and other sources of web request data.

### File reading
Base R has read.delim, which is convenient but much slower for file reading than Hadley's new [readr](https://github.com/hadley/readr)
package. <code>webtools</code> defines a set of wrapper functions around readr's <code>read_delim</code>, designed
for common access log formats.

The most common historical log format is the [Combined Log Format](http://httpd.apache.org/docs/1.3/logs.html#combined); this is used as one of the default formats for [nginx](http://nginx.org/) and the [Varnish caching system](https://www.varnish-cache.org/docs/trunk/reference/varnishncsa.html). <code>webtools</code>
lets you read it in trivially with <code>read\_combined</code>:


```r
library(webtools)
```

```
## 
## Attaching package: 'webtools'
## 
## The following objects are masked from 'package:webreadr':
## 
##     read_aws, read_clf, read_combined, read_squid, split_clf,
##     split_squid
```

```r
#read in an example file that comes with the webtools package
data <- read_combined(system.file("extdata/combined_log.clf", package = "webtools"))
#And if we look at the format...
str(data)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	12 obs. of  9 variables:
##  $ ip_address       : chr  "127.0.0.1" "123.123.123.123" "123.123.123.123" "123.123.123.123" ...
##  $ remote_user_ident: chr  NA NA NA NA ...
##  $ local_user_ident : chr  "frank" NA NA NA ...
##  $ timestamp        : POSIXct, format: "2000-10-10 20:55:36" "2000-04-26 04:23:48" ...
##  $ request          : chr  "GET /apache_pb.gif HTTP/1.0" "GET /pics/wpaper.gif HTTP/1.0" "GET /asctortf/ HTTP/1.0" "GET /pics/5star2000.gif HTTP/1.0" ...
##  $ status_code      : int  200 200 200 200 200 200 200 200 200 200 ...
##  $ bytes_sent       : int  2326 6248 8130 4005 1031 4282 36 10801 11179 887 ...
##  $ referer          : chr  "http://www.example.com/start.html" "http://www.jafsoft.com/asctortf/" "http://search.netscape.com/Computers/Data_Formats/Document/Text/RTF" "http://www.jafsoft.com/asctortf/" ...
##  $ user_agent       : chr  "Mozilla/4.08 [en] (Win98; I ;Nav)" "Mozilla/4.05 (Macintosh; I; PPC)" "Mozilla/4.05 (Macintosh; I; PPC)" "Mozilla/4.05 (Macintosh; I; PPC)" ...
```

As you can see, the types have been appropriately set, the date/times have been parsed, and sensible header names have been set.
The same thing can be done with the Common Log Format, used by Apache default configurations and as one of the defaults for
Squid caching servers, using <code>read\_clf</code>. The other squid default format can be read with <code>read\_squid</code>.

### Splitting combined fields

One of the things you'll notice about the example above is the "request" field - it contains not only the actual asset
requested, but also the HTTP method used and the protocol used. That's pretty inconvenient for people looking to do something
productive with the data.

Normally you'd split each field out into a list, and then curse and recombine them into a data.frame and hope that
doing so didn't hit R's memory limit during the "unlist" stage, and it'd take an absolute age. Or, you could just split them
up directly into a data frame using <code>split\_clf</code>:


```r
requests <- split_clf(data$request)
str(requests)
```

```
## 'data.frame':	12 obs. of  3 variables:
##  $ method  : chr  "GET" "GET" "GET" "GET" ...
##  $ asset   : chr  "/apache_pb.gif" "/pics/wpaper.gif" "/asctortf/" "/pics/5star2000.gif" ...
##  $ protocol: chr  "HTTP/1.0" "HTTP/1.0" "HTTP/1.0" "HTTP/1.0" ...
```
This is faster than manual splitting-and-data.frame-ing, easier on the end user, and less likely to end in unexpected segfaults with
large datasets. A similar function, <code>split\_squid</code>, exists for the status_code field in files read in with
<code>read_squid</code>, which suffer from a similar problem.

## Other ideas
If you have ideas for other URL handlers that would make access log processing easier, the best approach
is to either [request it](https://github.com/Ironholds/webtools/issues) or [add it](https://github.com/Ironholds/webtools/pulls)!

