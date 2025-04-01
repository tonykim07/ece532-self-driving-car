/*
 * hbridge_control.h
 *
 *  Created on: Feb 19, 2025
 *      Author: kimtony5
 */

#ifndef SRC_HBRIDGE_CONTROL_H_
#define SRC_HBRIDGE_CONTROL_H_

/* INCLUDES */
#include "xtmrctr.h"
#include "xgpio.h"

/* DEFINES */
#define DEFAULT_PWM_DUTY_CYCLE (0.70)

/* DATA STRUCTURES */

typedef enum
{
	REVERSE = 0U,
	FORWARD,

	NUM_OF_MOTOR_DIRECTIONS,
} motor_direction_E;

typedef enum
{
	 STOP = 0U,
	 GO,

	 NUM_OF_MOTOR_COMMANDS,
} motor_command_E;

typedef struct
{
	XTmrCtr *tmr_inst;
	XGpio *gpio_inst;

	u32 pwm_period;
	float duty;

} hbridge_control_vars_S;

/* FUNCTIONS */

void hbridge_control_init(XTmrCtr *tmr_inst, XGpio *gpio_inst);
void hbridge_control_loop(motor_direction_E direction, motor_command_E motor_command, u8 distance_feedback_en, u8 distance, float duty_cycle);

#endif /* SRC_HBRIDGE_CONTROL_H_ */
