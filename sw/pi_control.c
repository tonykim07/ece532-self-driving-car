/*
 * pi_control.c
 *
 *  Created on: Feb 20, 2025
 *      Author: kimtony5
 */

#ifndef SRC_PI_CONTROL_C_
#define SRC_PI_CONTROL_C_

#include "pi_control.h"
#include "xil_printf.h"

static int fraction_to_int(float FloatNum)
{
	float Temp;

	Temp = FloatNum;
	if (FloatNum < 0) {
		Temp = -(FloatNum);
	}

	return( ((int)((Temp -(float)((int)Temp)) * (1000.0f))));
}

void pi_controller_init(pi_control_vars_S *pi_control)
{
	pi_control->integrator = 0.0f;
	pi_control->prev_error = 0.0f;
	pi_control->out = 0.0f;
}

float pi_controller_update(pi_control_vars_S *pi_control, float setpoint, float measurement)
{
	float error = setpoint - measurement;

	// Proportional
	float proportional = pi_control->Kp * error;

	// Integral
	pi_control->integrator = pi_control->integrator + 0.5f * pi_control->Ki * pi_control->sample_time * (error + pi_control->prev_error);
	// Anti-wind-up via integrator clamping
    if (pi_control->integrator > pi_control->limMaxInt)
    {
        pi_control->integrator = pi_control->limMaxInt;
    }
    else if (pi_control->integrator < pi_control->limMinInt)
    {
        pi_control->integrator = pi_control->limMinInt;
    }

    // Result
    pi_control->out = proportional + pi_control->integrator;

    if (pi_control->out > pi_control->limMax)
    {
        pi_control->out = pi_control->limMax;
    }
    else if (pi_control->out < pi_control->limMin)
    {
        pi_control->out = pi_control->limMin;
    }

//    xil_printf("controller output %0d.%03d \n", (int)pi_control->out, fraction_to_int(pi_control->out));
//    xil_printf("controller error: %0d.%03d \n", (int)error, fraction_to_int(error));

    pi_control->prev_error = error;

    return pi_control->out;
}

#endif /* SRC_PI_CONTROL_C_ */
