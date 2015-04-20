#include <Rcpp.h>
#include <iostream>
#include <sstream>
#include "ip_handlers.h"
using namespace Rcpp;

unsigned long ip_handlers::ip4_to_numeric(std::vector < std::string > ip_address){
  std::vector<int> ip_as_int(ip_address.size());
  unsigned long output = 0;
  try {
    std::transform(ip_address.begin(), ip_address.end(), ip_as_int.begin(), [](const std::string& val) {return stod(val);});
  }
  catch(...){
    return output;
  }
  
  //If it didn't blow up converting to a numeric value, we can play the converting game!
  output += (ip_as_int[0] * 16777216);
  output += (ip_as_int[1] * 65536);
  output += (ip_as_int[2] * 256);
  output +=  ip_as_int[3];
  
  return output;
}

std::string ip_handlers::lowercase_ip(std::string ip){
  std::transform(ip.begin(), ip.end(), ip.begin(), ::tolower);
  return ip;
}

std::vector < std::string > ip_handlers::tokenise(std::string xff){
  xff = lowercase_ip(xff);
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

unsigned long ip_handlers::ip_to_numeric_internal(std::vector < std::string > ip_address){
  if(ip_address.size() == 4){
    return ip4_to_numeric(ip_address);
  }
  return 0;
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