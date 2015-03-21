#include <Rcpp.h>
#include <iostream>
#include <sstream>
#include "ip_handlers.h"
using namespace Rcpp;

std::string ip_handlers::lowercase_xff(std::string xff){
  std::transform(xff.begin(), xff.end(), xff.begin(), ::tolower);
  return xff;
}

std::vector < std::string > ip_handlers::tokenise(std::string xff){
  xff = lowercase_xff(xff);
  xff.erase(remove_if(xff.begin(), xff.end(), isspace), xff.end());
  std::vector < std::string > output;
  std::string holding;
  std::stringstream strm(xff);
  while(strm.good()){
    getline(strm, holding, ',');
    output.push_back(holding);
  }
  return output;
}

bool ip_handlers::is_real_ip(std::string possible_ip){
  std::vector < std::string > bad_ipv4s {"192.0.2", "198.51.100","203.0.113"};
  size_t ipv4_match = possible_ip.rfind(".");
  if(ipv4_match != std::string::npos){
    std::string holding = possible_ip.substr(0,ipv4_match);
    if(std::find(bad_ipv4s.begin(), bad_ipv4s.end(), holding) == bad_ipv4s.end()){
      return true;
    }
  } else {
    size_t ipv6_match = possible_ip.find(":");
    if(ipv6_match != std::string::npos){
      ipv6_match = possible_ip.find(":",ipv6_match+1);
      if(ipv6_match != std::string::npos){
        std::string holding = possible_ip.substr(0,ipv6_match);
        if(holding != "2001:0db8"){
          return true;
        }
      }
    }
  }
  return false;
}

std::string ip_handlers::extract_origin(std::string xff){
  
  std::vector < std::string > holding = tokenise(xff);
  int hold_size = holding.size();
  if(hold_size == 1){
    return holding[0];
  }
  
  for(int i = 0; i < hold_size; i++){
    if(is_real_ip(holding[i])){
      return holding[i];
    }
  }
  return holding.front();
}