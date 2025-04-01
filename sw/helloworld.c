/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * main.c
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

/* INCLUDES */
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"
#include "xiic.h"
#include "power_monitor.h"
#include "hbridge_control.h"
#include "servo_motor_control.h"
#include "range_finder.h"
#include "display_ctrl/video.h"
#include "line_tracing.h"
#include "disp_overlay.h"

/* DEFINES */

/* DATA STRUCTURES */

int main()
{
	// Hbridge control peripherals
	XGpio h_bridge_gpio_inst;
	XTmrCtr h_bridge_tmr_inst;

	// Servo motor control peripherals
	XTmrCtr servo_tmr_inst;
	XSysMon servo_adc_inst;

	// Range finder peripherals
	XUartLite range_finder_uart_inst;

	// Hbridge control peripherals
	XGpio line_tracing_image_width_height_inst;
	XGpio line_tracing_start_width_height_inst;
	XGpio line_tracing_hue_inst;
	XGpio line_tracing_sat_val_inst;
	XGpio line_tracing_average_inst;
	XGpio disp_overlay_angle_inst;
	XGpio disp_overlay_voltage_current_inst;
	XGpio disp_overlay_pause_inst;

	// Setup GPIO for SW input
	XGpio switch_input_gpio_inst;
	XGpio_Initialize(&switch_input_gpio_inst, XPAR_GPIO_1_DEVICE_ID);
	XGpio_SetDataDirection(&switch_input_gpio_inst, 1, 0xFFFF); // Input

	// Init Platform - UART for serial port printing is configured here
    init_platform();

    init_video();

    // The range finder needs at least 400ms for power up and calibration
    usleep(400000);
    hbridge_control_init(&h_bridge_tmr_inst, &h_bridge_gpio_inst);
    servo_motor_control_init(&servo_tmr_inst, &servo_adc_inst);
    range_finder_init(&range_finder_uart_inst);
    power_monitor_init();

    line_tracing_init(
    		&line_tracing_image_width_height_inst,
			&line_tracing_start_width_height_inst,
			&line_tracing_hue_inst,
			&line_tracing_sat_val_inst,
			&line_tracing_average_inst);

    disp_overlay_init(
    		&disp_overlay_angle_inst,
			&disp_overlay_voltage_current_inst,
			&disp_overlay_pause_inst);

    while(1)
    {
    	u32 switch_data = XGpio_DiscreteRead(&switch_input_gpio_inst, 1);
    	xil_printf("switch_data: %d\n", switch_data);
    	float hbridge_duty_cycle = DEFAULT_PWM_DUTY_CYCLE;
    	if ((switch_data >> 4) & 0x1)
    	{
    		hbridge_duty_cycle = 0.99f;
    	}
    	else if ((switch_data >> 3) & 0x1)
    	{
    		hbridge_duty_cycle = 0.80f;
    	}
    	else if ((switch_data >> 2) & 0x1)
    	{
    		hbridge_duty_cycle = 0.60f;
    	}
    	else if ((switch_data >> 1) & 0x1)
    	{
    		hbridge_duty_cycle = 0.40f;
    	}

    	float angle_command = line_tracing_get_angle();
    	u8 range_finder_distance = range_finder_get_distance();

    	// DC motor control for now:
    	// SW7 controls direction (reverse or forward) and SW6 controls command (stop or go)
    	// SW5 is to enable control with range finder
    	u32 dc_motor_command = (switch_data >> 6) & 0x1;
    	u32 dc_motor_direction = (switch_data >> 7) & 0x1;
    	u32 distance_feedback_en = (switch_data) & 0x1;
    	hbridge_control_loop(
    			(motor_direction_E)dc_motor_direction,
				(motor_command_E)dc_motor_command,
				(u8)distance_feedback_en,
				range_finder_distance,
				hbridge_duty_cycle);

    	range_finder_read_distance();
        power_monitor_read_voltage_and_current();
        servo_motor_control_loop(angle_command);

        disp_overlay_loop((u32) (angle_command+0.5), (u32)(power_monitor_get_voltage_reading()+0.5), (u32)((power_monitor_get_current_reading()+0.005)*1000), (u32)range_finder_distance < 49);
//        disp_overlay_loop((u32) (angle_command+0.5), (u32)(power_monitor_get_voltage_reading()+0.5), (u32)range_finder_distance);
    }

    cleanup_platform();
    return 0;
}
