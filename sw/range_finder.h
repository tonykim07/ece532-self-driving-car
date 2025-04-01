/*
 * range_finder.h
 *
 *  Created on: Feb 19, 2025
 *      Author: kimtony5
 */

#ifndef SRC_RANGE_FINDER_H_
#define SRC_RANGE_FINDER_H_

/* INCLUDES */
#include "xuartlite.h"

/* DATA STRUCTURES */
typedef struct
{
	XUartLite *uart_inst;
	u8 distance;

} range_finder_vars_S;


void range_finder_init(XUartLite *uart_inst);
void range_finder_read_distance(void);
u8 range_finder_get_distance(void);

#endif /* SRC_RANGE_FINDER_H_ */

