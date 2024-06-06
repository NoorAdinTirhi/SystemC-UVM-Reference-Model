#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtb_top.h"
#include "Vtb_top__Dpi.h"


#include "includes.h"

#define MAX_SIM_TIME 1000
vluint64_t sim_time = 0;

int main(int argc, char **argv, char **env)
{
    Verilated::commandArgs(argc, argv);


    rMessage.mesg_type = 1;
    
    dMessage.mesg_type = 1;



    int dIpc_key = ftok(FTOK_PATH, DSEED+1);
    int rIpc_key = ftok(FTOK_PATH, RSEED+1);


    int DmsgQ = msgget(dIpc_key, 0666 | IPC_CREAT);
    int RmsgQ = msgget(rIpc_key, 0666 | IPC_CREAT);


    if (DmsgQ == -1 || RmsgQ == -1){
        perror("Dmsgget");
        exit(1);
    }

    pid_t PID = fork();

    if (PID == 0){
        cout << "Starting Reference Model" << endl;
        execl("src/ReferenceModel/bin", "bin", NULL);

    }else{
    
        Vtb_top *dut = new Vtb_top;
        Verilated::traceEverOn(true);
        VerilatedVcdC *m_trace = new VerilatedVcdC;
        dut->trace(m_trace, 5);
        m_trace->open("waveform.vcd");

        dut->clk = 0;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;

        while (sim_time < MAX_SIM_TIME)
        {
            dut->clk ^= 1;
            dut->eval();
            m_trace->dump(sim_time);
            if (dut->clk == 1){
                //read values from UVM
                dMessage.command = static_cast<unsigned char>(dut->command);
                memcpy(dMessage.data_in, dut->data_in.m_storage, 10*sizeof(char));
                dMessage.compressed_in = static_cast<unsigned char>(dut->compressed_in);
                dMessage.reset = dut->reset;
    
                //send to reference model
                msgsnd(DmsgQ, &dMessage, sizeof(dMessage), 0);
    
                //read values from reference model, and put into buffer readable from SV/UVM
                msgrcv(RmsgQ, &rMessage, sizeof(rMessage), 1, 0);
            }

            sim_time++;
        }

        m_trace->close();
        delete dut;

        kill(PID, SIGKILL);
        waitpid(PID, NULL, 0);

        msgctl(RmsgQ, IPC_RMID, NULL);
        msgctl(DmsgQ, IPC_RMID, NULL);

        exit(EXIT_SUCCESS);   
    }
}


