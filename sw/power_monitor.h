/*
 * power_monitor.h
 *
 *  Created on: Feb 15, 2025
 *      Author: kimtony5
 */

#ifndef SRC_POWER_MONITOR_H_
#define SRC_POWER_MONITOR_H_

#include "xiic.h"

typedef struct
{
	u8 sampling_timer;
	float voltage;
	float current;
} power_monitor_vars_S;

void power_monitor_init(void);
void power_monitor_read_voltage_and_current(void);
float power_monitor_get_current_reading(void);
float power_monitor_get_voltage_reading(void);

#endif /* SRC_POWER_MONITOR_H_ */
