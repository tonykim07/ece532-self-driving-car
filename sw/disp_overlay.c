/*
* disp_overlay.c
*
*  Created on: Mar 18, 2025
*      Author: loeevan
*/


#ifndef SRC_DISP_OVERLAY_C_
#define SRC_DISP_OVERLAY_C_

#include "disp_overlay.h"

static disp_overlay_vars_S disp_overlay_vars = { 0 };

void disp_overlay_init(XGpio *disp_angle_inst, XGpio *disp_voltage_current_inst, XGpio *disp_pause_inst)
{
  disp_overlay_vars.disp_angle_inst = disp_angle_inst;
  disp_overlay_vars.disp_voltage_current_inst = disp_voltage_current_inst;
  disp_overlay_vars.disp_pause_inst = disp_pause_inst;

  XGpio_Initialize(disp_angle_inst, XPAR_VIDEO_SS_DISPLAY_ANGLE_GPIO_DEVICE_ID);
  XGpio_SetDataDirection(disp_angle_inst, 1, 0x0);
  
  XGpio_Initialize(disp_voltage_current_inst, XPAR_VIDEO_SS_DISP_VOLTAGE_CURRENT_GPIO_DEVICE_ID);
  XGpio_SetDataDirection(disp_voltage_current_inst, 1, 0x0);
  XGpio_SetDataDirection(disp_voltage_current_inst, 2, 0x0);

  XGpio_Initialize(disp_pause_inst, XPAR_VIDEO_SS_DISP_PAUSE_GPIO_DEVICE_ID);
  XGpio_SetDataDirection(disp_pause_inst, 1, 0x0);
}

void disp_overlay_loop(u32 angle, u32 voltage, u32 current, u32 stop)
{
  u32 angle_hun = angle / 100;
  u32 angle_ten = (angle % 100) / 10;
  u32 angle_one = angle % 10;
  u32 voltage_hun = voltage / 100;
  u32 voltage_ten = (voltage % 100) / 10;
  u32 voltage_one = voltage % 10;
  u32 current_hun = current / 100;
  u32 current_ten = (current % 100) / 10;
  u32 current_one = current % 10;
  u32 angle_digits = (angle_hun << 8) | (angle_ten << 4) | angle_one;
  u32 voltage_digits = (voltage_hun << 8) | (voltage_ten << 4) | voltage_one;
  u32 current_digits = (current_hun << 8) | (current_ten << 4) | current_one;
  XGpio_DiscreteWrite(disp_overlay_vars.disp_angle_inst, 1, (u32) angle_digits);
  XGpio_DiscreteWrite(disp_overlay_vars.disp_voltage_current_inst, 1, (u32) voltage_digits);
  XGpio_DiscreteWrite(disp_overlay_vars.disp_voltage_current_inst, 2, (u32) current_digits);
  XGpio_DiscreteWrite(disp_overlay_vars.disp_pause_inst, 1, (u32) stop);
  // xil_printf("Angle: %d, Voltage: %d, Current: %d\n", angle, voltage, current);
}

#endif /* SRC_DISP_OVERLAY_C_ */
