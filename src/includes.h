#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/msg.h>
#include <fcntl.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>
#include <errno.h>
#include <vector>

using namespace std;

#define DSEED 'G'
#define RSEED 'H'

#define FTOK_PATH "/root/Documents/Github/BZU_ENCS5337_Project"
#define COMPRESSED_IN_WIDTH 8

typedef struct messageFromReporter
{
    long mesg_type;     
    unsigned char compressed_out;       // 8 bit
    unsigned char decompressed_out[10]; // 80 bit
    unsigned char response;             // 2 bit
    unsigned char command;              // 2 bit
    unsigned char data_in[10];          // 80 bit
    unsigned char compressed_in;        // 8 bit
    bool reset;                         // 1 bit
    
}messageFromReporter;


typedef struct messageToDriver{
    long mesg_type;
    unsigned char command;              // 2 bit
    unsigned char data_in[10];          // 80 bit
    unsigned char compressed_in;        // 8 bit
    bool reset;                         // 1 bit
    
} messageToDriver;

// typedef char unsigned byte_arr_t [9:0];

messageToDriver dMessage;

messageFromReporter rMessage;


// char getReset(){
//     return dMessage.reset;
// }

// char getCommand(){
//     return dMessage.command[0];
// }
