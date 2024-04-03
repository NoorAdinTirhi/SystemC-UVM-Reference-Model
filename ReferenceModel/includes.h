#include <systemc>
#include <stdio.h>  
#include <stdlib.h> 
#include <time.h>
#include "constants.h"

using namespace sc_core;
int boolArrtoInt(sc_port<sc_signal_in_if<bool>, COMPRESSED_IN_WIDTH, SC_ALL_BOUND> bus){
    int sum = 0;
    for (int i = 0; i < COMPRESSED_IN_WIDTH; i++){
        sum += (bus -> read()) ? std::pow(2,i) : 0;
    }
    return sum;
}

std::vector<bool> intToBoolArr(int x){
    int mask = 1;
    std::vector<bool> boolArr;
    for (int i = 0; i < 32; i++){
        boolArr[i] = ( ( (1<<i) & x )>>i == 1 );
    }
    return boolArr;
}