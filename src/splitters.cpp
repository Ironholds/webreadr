#include <Rcpp.h>
using namespace Rcpp;

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