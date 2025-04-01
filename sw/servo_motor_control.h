/*
 * servo_motor_control.h
 *
 *  Created on: Feb 19, 2025
 *      Author: kimtony5
 */

#ifndef SRC_SERVO_MOTOR_CONTROL_H_
#define SRC_SERVO_MOTOR_CONTROL_H_

/* INCLUDES */
#include "xtmrctr.h"
#include "xsysmon.h"
#include "pi_control.h"

/* DEFINES */

/* DATA STRUCTURES */
typedef struct
{
	XTmrCtr *tmr_inst;
	u32 pwm_period;
	float duty;

	XSysMon *adc_inst;
	u8 sampling_timer;
	u8 adc_channel;
	u16 servo_feedback_adc_data;

	pi_control_vars_S *pi_control_vars;
} servo_motor_control_vars_S;

/* FUNCTIONS */
void servo_motor_control_init(XTmrCtr *tmr_inst, XSysMon* adc_inst);
void servo_motor_control_loop(float angle_reference);
float servo_control_vars_duty(void);

#endif /* SRC_SERVO_MOTOR_CONTROL_H_ */
