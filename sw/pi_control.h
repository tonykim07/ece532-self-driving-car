/*
 * pi_control.h
 *
 *  Created on: Feb 20, 2025
 *      Author: kimtony5
 */

#ifndef SRC_PI_CONTROL_H_
#define SRC_PI_CONTROL_H_

typedef struct {

	/* Controller gains */
	float Kp;
	float Ki;

	/* Output limits */
	float limMin;
	float limMax;

	/* Integrator limits */
	float limMinInt;
	float limMaxInt;

	/* Sample time (in seconds) */
	float sample_time;

	/* Controller "memory" */
	float integrator;
	float prev_error;

	/* Controller output */
	float out;

} pi_control_vars_S;

void  pi_controller_init(pi_control_vars_S *pi_control);
float pi_controller_update(pi_control_vars_S *pi_control, float setpoint, float measurement);

#endif /* SRC_PI_CONTROL_H_ */
