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
  CharacterVector holding(3);
  
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
  
  return DataFrame::create(_["method"] = method,
                           _["asset"]  = asset,
                           _["protocol"]  = protocol,
                           _["stringsAsFactors"] = false);
}

// The internal C++ code for reconstructing a data.frame from a split request entry
// [[Rcpp::export]]
List internal_split(std::list < std::vector < std::string > > requests, std::vector < std::string > names){
  int names_size = names.size();
  int in_size = requests.size();
  IntegerVector rownames = Rcpp::seq(1,in_size);
  List output;
   
  for(int i = 0; i < names_size; i++){
    std::list < std::vector < std::string > >::iterator iterator;
    std::vector < std::string > holding;
    for(iterator = requests.begin(); iterator != requests.end(); ++iterator){
      if((*iterator).size() == names_size){
        holding.push_back((*iterator)[i]);
      } else {
        holding.push_back("");
      }
    }
    output.push_back(holding);
  }
  output.attr("class") = "data.frame";
  output.attr("names") = names;
  output.attr("row.names") = rownames;
  return output;
}