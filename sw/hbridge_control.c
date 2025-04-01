/*
 * hbridge_control.c
 *
 *  Created on: Feb 19, 2025
 *      Author: kimtony5
 */

/* INCLUDES */

#include "hbridge_control.h"
#include "power_monitor.h"

/* DEFINES */
#define DEFAULT_PWM_PERIOD (1000000)
#define DEFAULT_CURRENT_LIMIT (1.5)

/* DATA STRUCTURES */

static hbridge_control_vars_S hbridge_control_vars =
{
	.pwm_period = DEFAULT_PWM_PERIOD,
	.duty = 0.0,
};

/* FUNCTIONS */

static void update_hbridge_pwm_pattern(hbridge_control_vars_S *handler)
{
	XTmrCtr_PwmDisable(handler->tmr_inst);
	u32 period = handler->pwm_period;
	u32 high_time = (u32)((float)period * handler->duty);
	XTmrCtr_PwmConfigure(handler->tmr_inst, period, high_time);

	// Enable PWM
	XTmrCtr_PwmEnable(handler->tmr_inst);
}

void hbridge_control_init(XTmrCtr *tmr_inst, XGpio *gpio_inst)
{
	hbridge_control_vars.tmr_inst = tmr_inst;
	hbridge_control_vars.gpio_inst = gpio_inst;

	XGpio_Initialize(gpio_inst, XPAR_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(gpio_inst, 1, 0x0);

	XTmrCtr_Initialize(tmr_inst, XPAR_PERIPHERAL_SS_H_BRIDGE_PWM_DEVICE_ID);
	XTmrCtr_PwmDisable(tmr_inst);
}

void hbridge_control_loop(motor_direction_E direction, motor_command_E motor_command, u8 distance_feedback_en, u8 distance, float duty_cycle)
{
	float duty = 0.0;
	float prev_duty = hbridge_control_vars.duty;
	float current = power_monitor_get_current_reading();

	if (distance_feedback_en)
	{
		if (distance < 49)
		{
			motor_command = STOP;
		}
		else
		{
			motor_command = GO;
		}
	}

	// software current protection - we can add some filtering to this if current measurements are noisy
	if (current > DEFAULT_CURRENT_LIMIT)
	{
		motor_command = STOP;
	}

	// Current control loop only includes stopping and going
	switch(motor_command)
	{
		case STOP:
			hbridge_control_vars.duty = 0.0;
			XTmrCtr_PwmDisable(hbridge_control_vars.tmr_inst);
			XGpio_DiscreteWrite(hbridge_control_vars.gpio_inst, 1, (u32)direction);
			break;

		case GO:
			duty = duty_cycle;
			if (duty != prev_duty)
			{
				hbridge_control_vars.duty = duty;
				update_hbridge_pwm_pattern(&hbridge_control_vars);
			}
			break;

		default:
			break;
	}
}



