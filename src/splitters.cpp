#include <Rcpp.h>
using namespace Rcpp;

// Split a single entry.
CharacterVector split_single(std::string entry, int expected_entries, std::string separator){
  
  CharacterVector output;
  
  size_t start = 0;
  size_t location = entry.find(separator);
  int delim_size = separator.size();
  
  if(location == std::string::npos){
    output.push_back(entry.substr(start));
  } else {
    while(location != std::string::npos){
      output.push_back(entry.substr(start, location - start));
      start = location + delim_size;
      location = entry.find(separator, start);
      
      if(location == std::string::npos){
        output.push_back(entry.substr(start));
      }
    }
  }
  
  while(output.size() < expected_entries){
    output.push_back(NA_STRING);
  }
  
  if(output.size() > expected_entries){
    output.erase(expected_entries, (output.size()-1));
  }
  
  return output;
  
}

// Split for CLF files
//[[Rcpp::export]]
DataFrame internal_split_clf(CharacterVector requests){
  
  // Prepare output objects
  int expected_entries = 3;
  int input_length = requests.length();
  CharacterVector method(input_length);
  CharacterVector asset(input_length);
  CharacterVector protocol(input_length);
  CharacterVector holding(expected_entries);
  
  for(unsigned int i = 0; i < input_length; i++){
    
    // Handle the case where the input is an NA
    if(requests[i] == NA_STRING){
      
      method[i]   = NA_STRING;
      asset[i]    = NA_STRING;
      protocol[i] = NA_STRING;
      
    } else {
      
      // Otherwise, split and copy across
      holding = split_single(Rcpp::as<std::string>(requests[i]), expected_entries, " ");
      method[i]   = holding[0];
      asset[i]    = holding[1];
      protocol[i] = holding[2];
    }
  }
  
  return DataFrame::create(_["method"]           = method,
                           _["asset"]            = asset,
                           _["protocol"]         = protocol,
                           _["stringsAsFactors"] = false);
}

//[[Rcpp::export]]
DataFrame internal_split_squid(CharacterVector requests){
  
  // Prepare output objects
  int expected_entries = 2;
  int input_length = requests.length();
  CharacterVector squid_code(input_length);
  CharacterVector http_status(input_length);
  CharacterVector holding(expected_entries);
  
  for(unsigned int i = 0; i < input_length; i++){
    
    // Handle the case where the input is an NA
    if(requests[i] == NA_STRING){
      
      squid_code[i]   = NA_STRING;
      http_status[i]  = NA_STRING;

    } else {
      
      // Otherwise, split and copy across
      holding = split_single(Rcpp::as<std::string>(requests[i]), expected_entries, "/");
      squid_code[i]   = holding[0];
      http_status[i]  = holding[1];
    }
  }
  
  return DataFrame::create(_["squid_code"]       = squid_code,
                           _["http_status"]      = http_status,
                           _["stringsAsFactors"] = false);
}