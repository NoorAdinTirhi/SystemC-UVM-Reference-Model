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
    char compressed_out[COMPRESSED_IN_WIDTH];
    char decompressed_out[81];
    char response[3];
    char command[3];
    char data_in[81];
    char compressed_in[COMPRESSED_IN_WIDTH];
    bool reset;
    
}messageFromReporter;


typedef struct messageToDriver{
    long mesg_type;
    char command[3];
    char data_in[81];
    char compressed_in[COMPRESSED_IN_WIDTH];
    bool reset;
    
} messageToDriver;

