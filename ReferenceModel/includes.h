#include <systemc>
#include <stdio.h>  
#include <stdlib.h> 
#include <time.h>
#include "constants.h"


std::string nZeroString(int n){
    std::string zeros = "";
    for (int i = 0; i < n; i ++){
        zeros.append("0");
    }
    return zeros;
}