#include <Rcpp.h>
#include <iostream>
#include <sstream>
using namespace Rcpp;

#ifndef __NORMALISE_INCLUDED__
#define __NORMALISE_INCLUDED__

/**
 * A class for normalising IP addresses that are provided
 * with an accompanying x_forwarded_for field
 */
class ip_handlers{
  
  private:
    
    /**
     * Lower-case an xff field
     * 
     * @param xff a string representing a standard x_forwarded_for
     * field - in other words, a series of comma-separated IP addresses.
     * 
     * @return the same field, but lower-cased, thus avoiding problems
     * when matching XFF subsets against RfC-reserved test ranges.
     */
    std::string lowercase_xff(std::string xff);
    
    /**
     * A function for tokenising an x_forwarded_for field.
     * 
     * @param xff a string representing a standard x_forwarded_for
     * field - in other words, a series of comma-separated IP addresses.
     * 
     * @return a vector containing the x_forwarded_for IPs as distinct
     * strings.
     */
    std::vector < std::string > tokenise(std::string xff);
    
    /**
     * A function for taking an IP address and identifying whether it's
     * a "real" IPv6 or IPv4 address; in other words, whether it contains
     * : or . and whether the IP falls within one of the IETF RfC reserved
     * IP spaces for testing.
     * 
     * @param possible_ip a possible IP address
     * 
     * @return a boolean - true if the IP looks real, false if it doesn't.
     */
    bool is_real_ip(std::string possible_ip);
    
  public:
  
    /**
     * The public member of this class - takes an XFF field, tokenises it,
     * and identifies the first element that looks "real". If no elements
     * look real, the first element, full stop, is returned.
     * 
     * @param x_forwarded_for an XFF field
     * 
     * @return the first IP that appears "real" (or the first IP).
     */
    std::string extract_origin(std::string x_forwarded_for);
    
};
#endif