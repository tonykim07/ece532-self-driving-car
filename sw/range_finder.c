/*
 * range_finder.c
 *
 *  Created on: Feb 19, 2025
 *      Author: kimtony5
 */

/* INCLUDES */
#include "range_finder.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xuartlite_l.h"

/* DEFINES */

/* DATA STRUCTURES */
static range_finder_vars_S range_finder_vars = { 0 };

/* FUNCTIONS */

void range_finder_init(XUartLite *uart_inst)
{
	range_finder_vars.uart_inst = uart_inst;
	XUartLite_Initialize(uart_inst, XPAR_PERIPHERAL_SS_RANGE_FINDER_UART_DEVICE_ID);
}

void range_finder_read_distance(void)
{
	// TODO: optimize this function
	u8 receive_buffer[5];
    if (!XUartLite_IsReceiveEmpty(range_finder_vars.uart_inst->RegBaseAddress))
    {
        u8 Byte;
        XUartLite_Recv(range_finder_vars.uart_inst, &Byte, 1);

        if (Byte == 234)
        {
        	receive_buffer[0] = Byte;
            u8 ReceivedBytes = 1;

            // Read the next 4 bytes
            while (ReceivedBytes < 5)
            {
                if (!XUartLite_IsReceiveEmpty(range_finder_vars.uart_inst->RegBaseAddress))
                {
                    XUartLite_Recv(range_finder_vars.uart_inst, &receive_buffer[ReceivedBytes], 1);
                    ReceivedBytes++;
                }
            }
            range_finder_vars.distance = receive_buffer[2];
//            range_finder_vars.distance = (receive_buffer[1] + receive_buffer[2] + receive_buffer[3]) / 3;
//            xil_printf("Distance Measurements: %d, %d %d\n\n\n\n\n", receive_buffer[1], receive_buffer[2], receive_buffer[3]);
            //            xil_printf("Distance: %d\n", range_finder_vars.distance);
        }
    }
}

u8 range_finder_get_distance(void)
{
	return range_finder_vars.distance;
}
