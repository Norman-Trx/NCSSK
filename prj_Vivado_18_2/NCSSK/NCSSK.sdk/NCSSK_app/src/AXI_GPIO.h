/*
 * AXI_GPIO.h
 *
 *  Created on: 2020年11月13日
 *      Author: benjia
 */

#ifndef SRC_AXI_GPIO_H_
#define SRC_AXI_GPIO_H_

#include "xgpio.h"
#include "sleep.h"

#define GPIO_ANGLE_ID           XPAR_GPIO_0_DEVICE_ID
#define GPIO_ANGLE_VALID_ID     XPAR_GPIO_1_DEVICE_ID
#define GPIO_DELAY_POINT_ID     XPAR_GPIO_2_DEVICE_ID
#define GPIO_ROM_FFT_RST_N_ID   XPAR_GPIO_3_DEVICE_ID
#define GPIO_SYS_RST_N_ID       XPAR_GPIO_4_DEVICE_ID

void init_i_gpio_angle(void);
void init_i_gpio_angle_valid(void);
void init_o_gpio_delay_point(void);
void init_o_gpio_rom_fft_rst_n(void);
void init_o_gpio_sys_rst_n(void);
void reset_ROM_FFT(void);
void reset_PL(void);

#endif /* SRC_AXI_GPIO_H_ */
