#include <Rcpp.h>
using namespace Rcpp;

#ifdef _WIN32
  #include <Ws2tcpip.h>
#else
  #include <arpa/inet.h>
#endif