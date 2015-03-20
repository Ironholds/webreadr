#include <Rcpp.h>
#include "encoding.h"
using namespace Rcpp;

char encoding::from_hex (char x){
  if(x <= '9' && x >= '0'){
    x -= '0';
  } else if(x <= 'f' && x >= 'a'){
    x -= ('a' - 10);
  } else if(x <= 'F' && x >= 'A'){
    x -= ('A' - 10);
  } else {
    x = 0;
  }
  return x;
}

std::string encoding::internal_url_decode(std::string url){
  
  //Create output object
  std::string result;
  
  //For each character...
  for (std::string::size_type i = 0; i <  url.size(); ++i){
    
    //If it's a +, space
    if (url[i] == '+'){
      result += ' ';
    } else if (url[i] == '%' && url.size() > i+2){//Escaped? Convert from hex and includes
      char holding_1 = encoding::from_hex(url[i+1]);
      char holding_2 = encoding::from_hex(url[i+2]);
      char holding = (holding_1 << 4) | holding_2;
      result += holding;
      i += 2;
    } else { //Permitted? Include.
      result += url[i];
    }
  }
  
  //Return
  result + "\0";
  return result;
}