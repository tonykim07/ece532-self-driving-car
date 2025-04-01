/*
 * line_tracing.c
 *
 *  Created on: Mar 18, 2025
 *      Author: loeevan
 */


#ifndef SRC_LINE_TRACING_C_
#define SRC_LINE_TRACING_C_

#include "line_tracing.h"

static line_tracing_vars_S line_tracing_vars = { 0 };

void line_tracing_init(XGpio *image_wh_inst, XGpio *start_wh_inst, XGpio *hue_inst, XGpio *sat_val_inst, XGpio *avg_inst)
{
	line_tracing_vars.image_wh_inst = image_wh_inst;
	line_tracing_vars.start_wh_inst = start_wh_inst;
	line_tracing_vars.hue_inst = hue_inst;
	line_tracing_vars.sat_val_inst = sat_val_inst;
	line_tracing_vars.avg_inst = avg_inst;

	XGpio_Initialize(image_wh_inst, XPAR_VIDEO_SS_USER_IMAGE_WIDTH_HEIGHT_GPIO_DEVICE_ID);
	XGpio_SetDataDirection(image_wh_inst, 1, 0x0);
	XGpio_SetDataDirection(image_wh_inst, 2, 0x0);

	XGpio_Initialize(start_wh_inst, XPAR_VIDEO_SS_USER_WIDTH_HEIGHT_START_GPIO_DEVICE_ID);
	XGpio_SetDataDirection(start_wh_inst, 1, 0x0);
	XGpio_SetDataDirection(start_wh_inst, 2, 0x0);

	XGpio_Initialize(hue_inst, XPAR_VIDEO_SS_USER_HUE_GPIO_DEVICE_ID);
	XGpio_SetDataDirection(hue_inst, 1, 0x0);

	XGpio_Initialize(sat_val_inst, XPAR_VIDEO_SS_USER_SAT_VAL_GPIO_DEVICE_ID);
	XGpio_SetDataDirection(sat_val_inst, 1, 0x0);
	XGpio_SetDataDirection(start_wh_inst, 2, 0x0);

	XGpio_Initialize(avg_inst, XPAR_VIDEO_SS_READ_AVERAGE_GPIO_DEVICE_ID);
	XGpio_SetDataDirection(avg_inst, 1, 0xFFFF);
	XGpio_SetDataDirection(avg_inst, 2, 0xFFFF);

	XGpio_DiscreteWrite(image_wh_inst, 1, (u32)1024);
	XGpio_DiscreteWrite(start_wh_inst, 1, (u32)250);
	XGpio_DiscreteWrite(start_wh_inst, 2, (u32)500);

}

float line_tracing_get_angle(void)
{
	// value is expected to be from 0 to 90 (based on image start and size though, we will tune it later)
	u32 avg_data = XGpio_DiscreteRead(line_tracing_vars.avg_inst, 1);
	u32 line_detected = XGpio_DiscreteRead(line_tracing_vars.avg_inst, 2);
//	xil_printf("Average: %d\n", avg_data);
//	xil_printf("line_detected: %0d", line_detected);

	// TODO: update this
	// linearly map angle: 30 to 150 degrees
	// 150 is 0, 30 is 90
	float angle = (-15.0/128)*avg_data + 150.0;

	return angle;
}

void line_tracing_loop(void)
{
	u32 avg_data = XGpio_DiscreteRead(line_tracing_vars.avg_inst, 1);

//	xil_printf("Average: %0d", avg_data);
}

#endif /* SRC_LINE_TRACING_C_ */
