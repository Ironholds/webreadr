#include "normalise_ips.h"
#include "encoding.h"
#include <Rcpp.h>
using namespace Rcpp;

//'@title Take vectors of IPs and X-Forwarded-For headers and produce single, normalised
//'IP addresses.
//'@description \code{normalise_ips} takes IP addresses and x_forwarded_for
//'values and, in the event that x_forwarded_for is non-null, attempts to
//'extract the "real" IP closest to the client.
//'
//'@param ip_addresses a vector of IP addresses
//'
//'@param x_forwarded_fors an equally-sized vector of X-Forwarded-For header
//'contents.
//'
//'@return a vector of IP addresses, incorporating the XFF header value
//'where appropriate
//'
//'@export
// [[Rcpp::export]]
std::vector < std::string > sanitise_ips(std::vector < std::string > ip_addresses,
                                         std::vector < std::string > x_forwarded_fors){
  normalise_ips norm_inst;
  std::vector < std::string> non_xffs = {"", "-"};
  
  if(ip_addresses.size() != x_forwarded_fors.size()){
    throw std::range_error("The two input vectors must be the same length");
  }
  for(int i = 0; i < ip_addresses.size(); i++){
    if(std::find(non_xffs.begin(), non_xffs.end(), x_forwarded_fors[i]) == non_xffs.end()){
      ip_addresses[i] = norm_inst.extract_origin(x_forwarded_fors[i]);
    }
  }
  return ip_addresses;
}

//'@title Encode or decode a URI
//'@description encodes or decodes a URI/URL
//'
//'@param urls a vector of URLs to decode or encode.
//'
//'@details
//'URL encoding and decoding is an essential prerequisite to proper web interaction
//'and data analysis around things like server-side logs. The
//'\href{http://tools.ietf.org/html/rfc3986}{relevant IETF RfC} mandates the percentage-encoding
//'of non-Latin characters, including things like slashes, unless those are reserved.
//'
//'Base R provides \code{\link{URLdecode}} and \code{\link{URLencode}}, which handle
//'URL encoding - in theory. In practise, they have a set of substantial problems
//'that the urltools implementation solves:
//'
//'\itemize{
//' \item{No vectorisation: }{Both base R functions operate on single URLs, not vectors of URLs.
//'       This means that, when confronted with a vector of URLs that need encoding or
//'       decoding, your only option is to loop from within R. This can be incredibly
//'       computationally costly with large datasets. url_encode and url_decode are
//'       implemented in C++ and entirely vectorised, allowing for a substantial
//'       performance improvement.}
//' \item{No scheme recognition: }{encoding the slashes in, say, http://, is a good way
//'       of making sure your URL no longer works. Because of this, the only thing
//'       you can encode in URLencode (unless you refuse to encode reserved characters)
//'       is a partial URL, lacking the initial scheme, which requires additional operations
//'       to set up and increases the complexity of encoding or decoding. url_encode
//'       detects the protocol and silently splits it off, leaving it unencoded to ensure
//'       that the resulting URL is valid.}
//' \item{ASCII NULs: }{Server side data can get very messy and sometimes include out-of-range
//'       characters. Unfortunately, URLdecode's response to these characters is to convert
//'       them to NULs, which R can't handle, at which point your URLdecode call breaks.
//'       \code{url_decode} simply ignores them.}
//'}
//'
//'@return a character vector containing the encoded (or decoded) versions of "urls".
//'
//'@examples
//'
//'url_decode("https://en.wikipedia.org/wiki/File:Vice_City_Public_Radio_%28logo%29.jpg")
//'url_encode("https://en.wikipedia.org/wiki/File:Vice_City_Public_Radio_(logo).jpg")
//'
//'\dontrun{
//'#A demonstrator of the contrasting behaviours around out-of-range characters
//'URLdecode("%gIL")
//'url_decode("%gIL")
//'}
//'@rdname encoder
//'@export
// [[Rcpp::export]]
std::vector < std::string > url_decode(std::vector < std::string > urls){
  
  //Measure size, instantiate class
  int input_size = urls.size();
  encoding enc_inst;
  
  //Decode each string in turn.
  for (int i = 0; i < input_size; ++i){
    urls[i] = enc_inst.internal_url_decode(urls[i]);
  }
  
  //Return
  return urls;
}

//'@rdname encoder
//'@export
// [[Rcpp::export]]
std::vector < std::string > url_encode(std::vector < std::string > urls){
  
  //Measure size, instantiate class
  int input_size = urls.size();
  encoding enc_inst;
  
  //For each string..
  for (int i = 0; i < input_size; ++i){
    
    //Extract the protocol. If you can't find it, just encode the entire thing.
    size_t indices = urls[i].find("://");
    if(indices == std::string::npos){
      urls[i] = enc_inst.internal_url_encode(urls[i]);
    } else {
      //Otherwise, split out the protocol and encode !protocol.
      urls[i] = urls[i].substr(0,indices+3) + enc_inst.internal_url_encode(urls[i].substr(indices+3));
    }
  }
  
  //Return
  return urls;
}