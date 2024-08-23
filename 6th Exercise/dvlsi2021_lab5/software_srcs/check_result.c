#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xparameters_ps.h"
#include "xaxidma.h"
#include "xtime_l.h"


#define N 32

#define TX_DMA_ID                 XPAR_PS2PL_DMA_DEVICE_ID //PS2PL
#define TX_DMA_MM2S_LENGTH_ADDR  (XPAR_PS2PL_DMA_BASEADDR + 0x28) // Reports actual number of bytes transferred from PS->PL (use Xil_In32 for report)

#define RX_DMA_ID                 XPAR_PL2PS_DMA_DEVICE_ID //PL2PS
#define RX_DMA_S2MM_LENGTH_ADDR  (XPAR_PL2PS_DMA_BASEADDR + 0x58) // Reports actual number of bytes transferred from PL->PS (use Xil_In32 for report)

#define TX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x08000000) // 0 + 128MByte
#define RX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x10000000) // 0 + 256MByte
#define R_MEM_SIZE (XPAR_DDR_MEM_BASEADDR + 0x11000000)
#define G_MEM_SIZE (XPAR_DDR_MEM_BASEADDR + 0x12000000)
#define B_MEM_SIZE (XPAR_DDR_MEM_BASEADDR + 0x13000000)

/* User application global variables & defines */
XAxiDma TXAxiDma;
XAxiDma RXAxiDma;

int *r_sw = R_MEM_SIZE;
int *g_sw = G_MEM_SIZE;
int *b_sw = B_MEM_SIZE;
int main()
{
	XAxiDma_Config *PS2PLptr,*PL2PSptr;
	//XAxiDma PS2PLDMA,PL2PSDMA;
	Xil_DCacheDisable();

	XTime preExecCyclesFPGA = 0;
	XTime postExecCyclesFPGA = 0;
	XTime preExecCyclesSW = 0;
	XTime postExecCyclesSW = 0;

	int Status;
	u8 *TxBufferPtr;
	u32 *RxBufferPtr;
	TxBufferPtr = (u8 *)TX_BUFFER; //8bit data to accelerator
	RxBufferPtr = (u32 *)RX_BUFFER; //32bit data from accelerator

	print("Stage 1\r\n");
	// User application local variables

	init_platform();

    // Step 1: Initialize TX-DMA Device (PS->PL)
	PS2PLptr = XAxiDma_LookupConfig(XPAR_PS2PL_DMA_DEVICE_ID);
	if (!PS2PLptr) {
			//xil_printf("No config found for %d\r\n", XPAR_PS2PL_DMA_DEVICE_ID);
			return XST_FAILURE;
		}
	//xil_printf("config found for %d\r\n", XPAR_PS2PL_DMA_DEVICE_ID);
	if(XAxiDma_CfgInitialize(&TXAxiDma,PS2PLptr)!= XST_SUCCESS){
		//xil_printf("initialized for PS to PL \r\n");
		return XST_FAILURE;
	}
	//else{
	//	xil_printf("error in init for PS to PL \r\n");
	//}
	xil_printf("Stage 2\r\n");

    // Step 2: Initialize RX-DMA Device (PL->PS)
	PL2PSptr = XAxiDma_LookupConfig(XPAR_PL2PS_DMA_DEVICE_ID);
		if (!PL2PSptr) {
				//xil_printf("No config found for %d\r\n", XPAR_PL2PS_DMA_DEVICE_ID);
				return XST_FAILURE;
			}
		//xil_printf("config found for %d\r\n", XPAR_PL2PS_DMA_DEVICE_ID);
		if(XAxiDma_CfgInitialize(&RXAxiDma,PL2PSptr) != XST_SUCCESS){
				return XST_FAILURE;
				//xil_printf("initialized for PL to PS \r\n");
			}
			//else{
			//	xil_printf("error in init for PL to PS \r\n");
			//}

		memset(RxBufferPtr,0,N*N*4);
		for(int i=1; i<N*N+1; i++){
			TxBufferPtr[i-1] = rand()%256;
		}
	    //xil_printf("TXDATA RANDOM=%d\r\n",TxBufferPtr[0]);
	    //xil_printf("RXDATA_RANDOM=%d\r\n",RxBufferPtr[0]);

    XTime_GetTime(&preExecCyclesFPGA);
    xil_printf("Stage 3\r\n");
    // Step 3 : Perform FPGA processing
    //      3a: Setup RX-DMA transaction
    //      3b: Setup TX-DMA transaction
    //      3c: Wait for TX-DMA & RX-DMA to finish
    Status = XAxiDma_SimpleTransfer(&RXAxiDma,(UINTPTR) RxBufferPtr,N*N*4, XAXIDMA_DEVICE_TO_DMA);
    if(Status){
    	//xil_printf("Fail on transfering from Rx with status %d\r\n",Status);
    	return XST_FAILURE;
    }
    //xil_printf("Rx status OK\r\n");

    Status = XAxiDma_SimpleTransfer(&TXAxiDma,(UINTPTR) TxBufferPtr,N*N, XAXIDMA_DMA_TO_DEVICE);
        if(Status){
        	//xil_printf("Fail on transfering from Tx\r\n");
        	return XST_FAILURE;
        }
        //xil_printf("Tx status OK\r\n");



    while ((XAxiDma_Busy(&TXAxiDma,XAXIDMA_DMA_TO_DEVICE)));
    print("Tx Send OK\r\n");
    while((XAxiDma_Busy(&RXAxiDma,XAXIDMA_DEVICE_TO_DMA)));
    print("Rx Send OK\r\n");



    /*if(s_bytes==N*N && r_bytes==N*N*4){
    	xil_printf("Tranfer Completed\r\n");
    }*/


   /* for(int i=0; i<N*N; i++){
        r1 = (u8) ((RxBufferPtr[i] >> 16) & 0xff);
        g1 = (u8) ((RxBufferPtr[i] >> 8) & 0xff);
        b1 = (u8) ((RxBufferPtr[i]) & 0xff);
        xil_printf("%d %d %d\r\n",r1,g1,b1);
}*/


    XTime_GetTime(&postExecCyclesFPGA);
    XTime_GetTime(&preExecCyclesSW);
    // Step 5: Perform SW processing


    //DEBAYERING CODE
    for(int i=0; i<N; i++){
        for(int j=0; j<N; j++){
            int current_pixel = i*N + j;
            if(i%2==0){                   //Green Blue Line
                if(i==0){                 //First Line
                    if(j%2==0){           //Color is Green
                        g_sw[current_pixel] = TxBufferPtr[current_pixel];
                        r_sw[current_pixel] = TxBufferPtr[current_pixel+N]/2;
                        if(j==0) b_sw[current_pixel] = TxBufferPtr[current_pixel+1]/2;                      //Upper Left Green
                        else b_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel+1])/2;
                    }else{                //Color is Blue
                        b_sw[current_pixel] = TxBufferPtr[current_pixel];
                        if(j==N-1){       //Upper Right Blue
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel + N])/4;
                            r_sw[current_pixel] = TxBufferPtr[current_pixel + N-1]/4;
                        }else{
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel+1] + TxBufferPtr[current_pixel + N])/4;
                            r_sw[current_pixel] = (TxBufferPtr[current_pixel + N-1] + TxBufferPtr[current_pixel + N+1])/4;
                        }
                    }
                }else {                   //Other Green Blue Lines
                    if(j%2==0){           //Color is Green
                        g_sw[current_pixel] = TxBufferPtr[current_pixel];
                        r_sw[current_pixel] = (TxBufferPtr[current_pixel+N] + TxBufferPtr[current_pixel-N])/2;
                        if(j==0) b_sw[current_pixel] = TxBufferPtr[current_pixel+1]/2;                      //Left Green
                        else b_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel+1])/2;
                    }else{                //Color is Blue
                        b_sw[current_pixel] = TxBufferPtr[current_pixel];
                        if(j==N-1){       //Right Blue
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel + N] + TxBufferPtr[current_pixel - N])/4;
                            r_sw[current_pixel] = (TxBufferPtr[current_pixel + N-1] + TxBufferPtr[current_pixel - N-1])/4;
                        }else{
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel + N] + TxBufferPtr[current_pixel - N] + TxBufferPtr[current_pixel + 1])/4;
                            r_sw[current_pixel] = (TxBufferPtr[current_pixel + N-1] + TxBufferPtr[current_pixel - N-1] + TxBufferPtr[current_pixel + N+1] + TxBufferPtr[current_pixel - N+1])/4;
                        }
                    }
                }
            }else{                       //Red Green Lines
                if(i==N-1){              //Last Line
                    if(j%2==0){          //Color is Red
                        r_sw[current_pixel] = TxBufferPtr[current_pixel];
                        if(j==0){        //Bottom Left
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel - N] + TxBufferPtr[current_pixel + 1])/4;
                            b_sw[current_pixel] = TxBufferPtr[current_pixel -N +1]/4;
                        }else{
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel - N] + TxBufferPtr[current_pixel + 1] + TxBufferPtr[current_pixel - 1])/4;
                            b_sw[current_pixel] = (TxBufferPtr[current_pixel -N +1] + TxBufferPtr[current_pixel -N -1])/4;
                        }
                    }else{             //Color is Green
                        g_sw[current_pixel] = TxBufferPtr[current_pixel];
                        b_sw[current_pixel] = TxBufferPtr[current_pixel-N]/2;
                        if(j==N-1) r_sw[current_pixel] = TxBufferPtr[current_pixel-1]/2;                      //Upper Left Green
                        else r_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel+1])/2;
                    }
                }else{                //Other Red Green Lines
                    if(j%2==0){       //Color is Red
                        r_sw[current_pixel] = TxBufferPtr[current_pixel];
                        if(j==0){     //Left Red
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel+1] + TxBufferPtr[current_pixel + N] + TxBufferPtr[current_pixel - N])/4;
                            b_sw[current_pixel] = (TxBufferPtr[current_pixel + N+1] + TxBufferPtr[current_pixel - N+1])/4;
                        }else{
                            g_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel + N] + TxBufferPtr[current_pixel - N] + TxBufferPtr[current_pixel + 1])/4;
                            b_sw[current_pixel] = (TxBufferPtr[current_pixel + N-1] + TxBufferPtr[current_pixel - N-1] + TxBufferPtr[current_pixel + N+1] + TxBufferPtr[current_pixel - N+1])/4;
                        }
                    }else{
                        g_sw[current_pixel] = TxBufferPtr[current_pixel];
                        b_sw[current_pixel] = (TxBufferPtr[current_pixel-N] + TxBufferPtr[current_pixel+N])/2;
                        if(j==N-1) r_sw[current_pixel] = TxBufferPtr[current_pixel-1]/2;                      //Upper Left Green
                        else r_sw[current_pixel] = (TxBufferPtr[current_pixel-1] + TxBufferPtr[current_pixel+1])/2;
                    }
                }
            }

        }
    }




    XTime_GetTime(&postExecCyclesSW);

    // Step 6: Compare FPGA and SW results
    u8 r1,g1,b1;
    int errors=0;
    for(int i; i<N*N; i++){
       	r1 = (u8) ((RxBufferPtr[i] >> 16)&0xff);
       	g1 = (u8) ((RxBufferPtr[i] >> 8)&0xff);
       	b1 = (u8) (RxBufferPtr[i]&0xff);
       	if(r1 != r_sw[i] || g1 != g_sw[i] || b1 != b_sw[i]){
//       		printf("Error i=%d in line %d and column %d\r\n", i, i/N, i%N);
//       		printf("Up:%d Right:%d Up-Right:%d\r\n", TxBufferPtr[i-N], TxBufferPtr[i+1], TxBufferPtr[i-N+1]);
//       		printf("%d %d %d |--| %d %d %d\r\n",r1,g1,b1,r_sw[i], g_sw[i],b_sw[i]);
       		errors ++;
       	}
       }
       float err_fpga,speedup;
       int fpga_cycles, sw_cycles;
       printf("First Results \r\n");
       //int random = rand()%(N*N);
       for(int i = 0; i<150; i++){
    	   printf("%d %d %d |--| %d %d %d\r\n",(u8) (RxBufferPtr[i]>>16) & 0xff,(u8)(RxBufferPtr[i]>>8) & 0xff,(u8) RxBufferPtr[i] & 0xff,r_sw[i],g_sw[i],b_sw[i]);
       }
       u32 s_bytes,r_bytes;
       s_bytes = Xil_In32(TX_DMA_MM2S_LENGTH_ADDR);
       r_bytes = Xil_In32(RX_DMA_S2MM_LENGTH_ADDR);
       printf("Sent = %d bytes Received = %d bytes\r\n",s_bytes,r_bytes);
    //     6a: Report total percentage error
       err_fpga = (((float) errors/(float)(N*N))*100);
       printf("Total Percentage Error is= %0.2f %% (%d total errors)\r\n",err_fpga,errors);
    //     6b: Report FPGA execution time in cycles (use preExecCyclesFPGA and postExecCyclesFPGA)
       fpga_cycles = postExecCyclesFPGA - preExecCyclesFPGA;
       printf("FPGA Execution time in cycles is = %d \r\n", fpga_cycles);
    //     6c: Report SW execution time in cycles (use preExecCyclesSW and postExecCyclesSW)
       sw_cycles = postExecCyclesSW - preExecCyclesSW;
       printf("SW Execution time in cycles is = %d \r\n", sw_cycles);
    //     6d: Report speedup (SW_execution_time / FPGA_exection_time)
       speedup = (float)sw_cycles/(float)fpga_cycles;
       printf("Speedup is = %0.2f \r\n", speedup);


    cleanup_platform();
    return 0;
}
