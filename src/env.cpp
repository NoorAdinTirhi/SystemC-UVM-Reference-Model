#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "includes.h"
#include "Vtb_top.h"

#define MAX_SIM_TIME 4
vluint64_t sim_time = 0;

int main(int argc, char **argv, char **env)
{
    Verilated::commandArgs(argc, argv);

    messageFromReporter rMessage;
    rMessage.mesg_type = 1;
    
    messageToDriver dMessage;
    dMessage.mesg_type = 1;



    int dIpc_key = ftok(FTOK_PATH, DSEED+1);
    int rIpc_key = ftok(FTOK_PATH, RSEED+1);


    int DmsgQ = msgget(dIpc_key, 0666 | IPC_CREAT);
    int RmsgQ = msgget(rIpc_key, 0666 | IPC_CREAT);

    cout << "env sees DQ: " << DmsgQ << endl;
    cout << "env sees RQ: " << RmsgQ << endl;

    if (DmsgQ == -1 || RmsgQ == -1){
        perror("Dmsgget");
        exit(1);
    }

    pid_t PID = fork();

    if (PID == 0){
        cout << "Starting Reference Model" << endl;
        execl("./ReferenceModel/bin", NULL);
    }else{
    
        Vtb_top *dut = new Vtb_top;
        Verilated::traceEverOn(true);
        VerilatedVcdC *m_trace = new VerilatedVcdC;
        dut->trace(m_trace, 5);
        m_trace->open("waveform.vcd");

        cout << "Simulation of ALU started" << endl;

        while (sim_time < MAX_SIM_TIME)
        {
            dut->clk ^= 1;
            dut->reset = 0;
            if (dut->clk == 1)
            {
                dut->eval();
                m_trace->dump(sim_time);
            }
            //read values from UVM and send to reference model
            strncpy(dMessage.command, "01", 2);
            strncpy(dMessage.data_in, "1101001110110001010001010011", 80);
            strncpy(dMessage.compressed_in, "11010011", 8);
            dMessage.reset = false;


            msgsnd(DmsgQ, &dMessage, sizeof(dMessage), 0);

            //read values from reference model and send to UVM
            msgrcv(RmsgQ, &rMessage, sizeof(rMessage), 1, 0);

            //TODO: send to UVM

            //print out rMessage results
            cout << "Compressed Out: " << rMessage.compressed_out << endl;
            cout << "Decompressed Out: " << rMessage.decompressed_out << endl;
            cout << "Response: " << rMessage.response << endl;
            cout << "Command: " << rMessage.command << endl;
            cout << "Data In: " << rMessage.data_in << endl;
            cout << "Compressed In: " << rMessage.compressed_in << endl;
            cout << "Reset: " << rMessage.reset << endl;

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
