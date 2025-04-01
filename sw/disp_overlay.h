/*
 * line_tracing.h
 *
 *  Created on: Mar 18, 2025
 *      Author: loeevan
 */

#ifndef SRC_DISP_OVERLAY_H_
#define SRC_DISP_OVERLAY_H_

#include "xgpio.h"

typedef struct
{
	XGpio *disp_angle_inst;
	XGpio *disp_voltage_current_inst;
	XGpio *disp_pause_inst;

} disp_overlay_vars_S;

void disp_overlay_init(XGpio *disp_angle_inst, XGpio *disp_voltage_current_inst, XGpio *disp_pause_inst);
void disp_overlay_loop(u32 angle, u32 voltage, u32 current, u32 stop);

#endif /* SRC_DISP_OVERLAY_H_ */
