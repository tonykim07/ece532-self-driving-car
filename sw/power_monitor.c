/*
 * power_monitor.c
 *
 *  Created on: Feb 15, 2025
 *      Author: kimtony5
 */

/* INCLUDES */
#include "power_monitor.h"
#include "xparameters.h"
#include "xiic.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "sleep.h"

/* DEFINES */

// I2C interface
#define IIC_BASE_ADDRESS	XPAR_IIC_0_BASEADDR

// Power Monitor PMOD interface

// Whether to run EEPROM write related code for the potentiometer
#define FIRST_TIME_FLASHED (0U)

// Potentiometer:
#define I2C_POTENTIOMETER_SLAVE_ADDR (0b0101111)
#define WRITE_RDAC_VAL_TO_EEPROM_COMMAND (0b001)
#define WRITE_TO_RDAC_COMMAND (0b010)
#define SOFTWARE_SHUTDOWN_CTRL_COMMAND (0b011)
#define SOFTWARE_RESET_COMMAND (0b100)
#define READ_FROM_RDAC_COMMAND (0b101)
#define READ_FROM_EEPROM_COMMAND (0b110)

#define I2C_POWER_MONITOR_SLAVE_ADDR (0b0110000)
// Registers on Power Monitor IC
#define ALERT_EN_REG_ADDR (0b10000001)
#define ALERT_TH_REG_ADDR (0b10000010)
#define CONTROL_REG_ADDR (0b10000011)

#define VOLTAGE_CURRENT_READBACK_COMMAND (0b00001001)
#define STATUS_READBACK_COMMAND			 (0b10000000)

/* DATA STRUCTURES */

static power_monitor_vars_S power_monitor_vars = { 0 };

/* FUNCTIONS */

static int fraction_to_int(float FloatNum)
{
	float Temp;

	Temp = FloatNum;
	if (FloatNum < 0) {
		Temp = -(FloatNum);
	}

	return( ((int)((Temp -(float)((int)Temp)) * (1000.0f))));
}

static void power_monitor_potentiometer_write_to_rdac(u8 value)
{
	u8 byte_to_send[2] = {WRITE_TO_RDAC_COMMAND, value};

	XIic_Send(IIC_BASE_ADDRESS, I2C_POTENTIOMETER_SLAVE_ADDR, (u8*)&byte_to_send, 2, XIIC_STOP);
}

static u8 power_monitor_potentiometer_read_rdac_value_from_eeprom(void)
{
	u8 byte_to_send[2] = { READ_FROM_EEPROM_COMMAND, 0x0 };
	XIic_Send(IIC_BASE_ADDRESS, I2C_POTENTIOMETER_SLAVE_ADDR, (u8*)&byte_to_send, 2, XIIC_STOP);

	// Read data bytes
	u8 buffer[2];
	XIic_Recv(IIC_BASE_ADDRESS, I2C_POTENTIOMETER_SLAVE_ADDR, buffer, 2, XIIC_STOP);
	return buffer[0];
}

static void power_monitor_potentiometer_write_rdac_reg_to_eeprom(void)
{
	u8 byte_to_send[2] = {WRITE_RDAC_VAL_TO_EEPROM_COMMAND, 0x0};

	XIic_Send(IIC_BASE_ADDRESS, I2C_POTENTIOMETER_SLAVE_ADDR, (u8*)&byte_to_send, 2, XIIC_STOP);
}

static void power_monitor_potentiometer_init(void)
{
#if FIRST_TIME_FLASHED
	power_monitor_potentiometer_write_to_rdac(40U); // should be 4 usually but I don't want any faults
	power_monitor_potentiometer_write_rdac_reg_to_eeprom();
	// Write to eeprom stops the I2C during the write process
	usleep(5000);
#endif
}

static void power_monitor_sensor_init(void)
{
	u8 command_byte = VOLTAGE_CURRENT_READBACK_COMMAND;
	XIic_Send(IIC_BASE_ADDRESS, I2C_POWER_MONITOR_SLAVE_ADDR, (u8*)&command_byte, 1, XIIC_STOP);
}


void power_monitor_init(void)
{
	power_monitor_potentiometer_init();
	power_monitor_sensor_init();
}

void power_monitor_read_voltage_and_current(void)
{
	// TODO: tune this timer to specify our sampling rate for voltage and current
	if (power_monitor_vars.sampling_timer > 50U)
	{
		u8 buffer[3];
		XIic_Recv(IIC_BASE_ADDRESS, I2C_POWER_MONITOR_SLAVE_ADDR, buffer, 3, XIIC_STOP);

		u16 voltage_bytes = ((u16)buffer[0] << 4) | (buffer[2] >> 4);
		u16 current_bytes = ((u16)buffer[1] << 4) | (buffer[2] & 0xf);

		power_monitor_vars.voltage = (26.52 / 4096.0) * (float)voltage_bytes;
		power_monitor_vars.current = (105.84e-3 / 4096.0) * (float)current_bytes;
		power_monitor_vars.sampling_timer = 0U;

//		xil_printf("voltage bytes: %d current bytes: %d\n", voltage_bytes, current_bytes);

//		xil_printf("voltage reading %0d.%03d \n", (int)power_monitor_vars.voltage, fraction_to_int(power_monitor_vars.voltage));
//		xil_printf("current reading: %0d.%03d \n", (int)power_monitor_vars.current, fraction_to_int(power_monitor_vars.current));
	}
	else
	{
		power_monitor_vars.sampling_timer++;
	}
}

float power_monitor_get_current_reading(void)
{
	return power_monitor_vars.current;
}

float power_monitor_get_voltage_reading(void)
{
	return power_monitor_vars.voltage;
}
