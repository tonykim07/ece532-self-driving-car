
#include "xil_types.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "xaxivdma.h"
#include <stdio.h>

#include "video.h"


void init_video()
{
	xil_printf("Configuring video now!\n");
	/*=== Write Channel Configuration === */
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0x30, 0x8B);
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0xAC, 0x80000000);

	// configure STRIDE and HSIZE
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0xA8, FRAME_W*3);
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0xA4, FRAME_W*3);


	// configure VSIZE
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0xA0, FRAME_H);

	/*=== Read Channel Configuration === */
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0x00, 0x8B);
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0x5C, 0x80000000);
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0x58, FRAME_W*3);
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0x54, FRAME_W*3);
	Xil_Out32(XPAR_VIDEO_SS_AXI_VDMA_0_BASEADDR + 0x50, FRAME_H);

	xil_printf("Done configuring video!\n");
}
