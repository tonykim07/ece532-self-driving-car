/*
 * servo_motor_control.c
 *
 *  Created on: Feb 19, 2025
 *      Author: kimtony5
 */

/* INCLUDES */
#include "servo_motor_control.h"

#include "hbridge_control.h"

/* DEFINES */
#define DEFAULT_SERVO_PWM_PERIOD (20000000) // 50Hz
#define MIN_SERVO_PWM_DUTY_CYCLE (0.03)
#define MAX_SERVO_PWM_DUTY_CYCLE (0.11)
#define MID_SERVO_PWM_DUTY_CYCLE ((MAX_SERVO_PWM_DUTY_CYCLE + MIN_SERVO_PWM_DUTY_CYCLE) / 2)

#define ADC_READING_TO_ANGLE(adc_reading) ((2.99e-3 * adc_reading) - (22.6))

/* DATA STRUCTURES */

static pi_control_vars_S pi_control_vars = {
	.Kp = 0.00035,
	.Ki = 0.00505,
	.limMin = MIN_SERVO_PWM_DUTY_CYCLE,
	.limMax = MAX_SERVO_PWM_DUTY_CYCLE,
	.limMinInt = -100,
	.limMaxInt = 100,
	.sample_time = 0.01,
};

static servo_motor_control_vars_S servo_control_vars = {
	.pwm_period = DEFAULT_SERVO_PWM_PERIOD,
	.duty = MID_SERVO_PWM_DUTY_CYCLE,
	.sampling_timer = 0,
	.adc_channel = 1,
	.servo_feedback_adc_data = 0,

	.pi_control_vars = &pi_control_vars,
};

/* FUNCTIONS */

static void read_servo_feedback(void)
{
	u16 raw_data = XSysMon_GetAdcData(servo_control_vars.adc_inst, XSM_CH_AUX_MIN + servo_control_vars.adc_channel);;
	servo_control_vars.servo_feedback_adc_data = raw_data;
//	xil_printf("Servo Feedback Raw: %d\n", raw_data);
}

static void update_servo_motor_pwm_pattern(servo_motor_control_vars_S *handler)
{
	XTmrCtr_PwmDisable(handler->tmr_inst);
	u32 period = handler->pwm_period;
	u32 high_time = (u32)((float)period * handler->duty);
	XTmrCtr_PwmConfigure(handler->tmr_inst, period, high_time);

	// Enable PWM
	XTmrCtr_PwmEnable(handler->tmr_inst);
}

void servo_motor_control_init(XTmrCtr *tmr_inst, XSysMon* adc_inst)
{
	servo_control_vars.tmr_inst = tmr_inst;
	servo_control_vars.adc_inst = adc_inst;

	XTmrCtr_Initialize(tmr_inst, XPAR_PERIPHERAL_SS_SERVO_PWM_1_DEVICE_ID);
	XTmrCtr_PwmDisable(tmr_inst);

	XSysMon_Config *ConfigPtr;
	ConfigPtr = XSysMon_LookupConfig(XPAR_SYSMON_0_DEVICE_ID);
	XSysMon_CfgInitialize(adc_inst, ConfigPtr, ConfigPtr->BaseAddress);
}

void servo_motor_control_loop(float angle_reference)
{
	if (servo_control_vars.sampling_timer > 1U)
	{
		read_servo_feedback();
		// Input: Position, Output: Duty Cycle
		float feedback = ADC_READING_TO_ANGLE(servo_control_vars.servo_feedback_adc_data);
		servo_control_vars.duty = pi_controller_update(servo_control_vars.pi_control_vars, angle_reference, feedback);
		update_servo_motor_pwm_pattern(&servo_control_vars);
		servo_control_vars.sampling_timer = 0U;
	}
	else
	{
		servo_control_vars.sampling_timer++;
	}
}


