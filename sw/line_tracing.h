/*
 * line_tracing.h
 *
 *  Created on: Mar 18, 2025
 *      Author: loeevan
 */

#ifndef SRC_LINE_TRACING_H_
#define SRC_LINE_TRACING_H_

#include "xgpio.h"

typedef struct
{
	XGpio *image_wh_inst;
	XGpio *start_wh_inst;
	XGpio *hue_inst;
	XGpio *sat_val_inst;
	XGpio *avg_inst;

} line_tracing_vars_S;

void line_tracing_init(XGpio *image_wh_inst, XGpio *start_wh_inst, XGpio *hue_inst, XGpio *sat_val_inst, XGpio *avg_inst);
void line_tracing_loop(void);
float line_tracing_get_angle(void);

#endif /* SRC_LINE_TRACING_H_ */
