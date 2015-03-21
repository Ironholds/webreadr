#include "ip_handlers.h"
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
std::vector < std::string > normalise_ips(std::vector < std::string > ip_addresses,
                                         std::vector < std::string > x_forwarded_fors){
  ip_handlers ip_inst;
  std::vector < std::string> non_xffs = {"", "-"};
  
  if(ip_addresses.size() != x_forwarded_fors.size()){
    throw std::range_error("The two input vectors must be the same length");
  }
  for(int i = 0; i < ip_addresses.size(); i++){
    if(std::find(non_xffs.begin(), non_xffs.end(), x_forwarded_fors[i]) == non_xffs.end()){
      ip_addresses[i] = ip_inst.extract_origin(x_forwarded_fors[i]);
    }
  }
  return ip_addresses;
}

//'@title decodes a vector of URLs
//'@description Takes a vector of URLs and consistently decodes them, in
//'a vectorised way and handling out-of-range characters (unlike \code{\link{URLdecode}})).
//'
//'@param urls a vector of URLs to decode.
//'
//'@return a character vector containing the decoded versions of urls.
//'
//'@examples
//'
//'decode_url("https://en.wikipedia.org/wiki/File:Vice_City_Public_Radio_%28logo%29.jpg")
//'
//'\dontrun{
//'#A demonstrator of the contrasting behaviours around out-of-range characters
//'URLdecode("%gIL")
//'decode_url("%gIL")
//'}
//'@export
// [[Rcpp::export]]
std::vector < std::string > decode_url(std::vector < std::string > urls){
  
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