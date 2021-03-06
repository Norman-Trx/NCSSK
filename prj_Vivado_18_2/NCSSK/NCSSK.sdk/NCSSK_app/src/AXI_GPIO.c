/*
 * AXI_GPIO.c
 *
 *  Created on: 2020年11月13日
 *      Author: benjia
 */

#include "AXI_GPIO.h"

XGpio i_gpio_angle, i_gpio_angle_valid, o_gpio_delay_point, o_gpio_rom_fft_rst_n, o_gpio_sys_rst_n;

void init_i_gpio_angle(void)
{
    XGpio_Initialize(&i_gpio_angle, GPIO_ANGLE_ID);
    XGpio_SetDataDirection(&i_gpio_angle, 1, 0XFFFF);
}

void init_i_gpio_angle_valid(void)
{
    XGpio_Initialize(&i_gpio_angle_valid, GPIO_ANGLE_VALID_ID);
    XGpio_SetDataDirection(&i_gpio_angle_valid, 1, 0XFFFF);
}

void init_o_gpio_delay_point(void)
{
    XGpio_Initialize(&o_gpio_delay_point, GPIO_DELAY_POINT_ID);
    XGpio_SetDataDirection(&o_gpio_delay_point, 1, 0X0);
}

void init_o_gpio_rom_fft_rst_n(void)
{
    XGpio_Initialize(&o_gpio_rom_fft_rst_n, GPIO_ROM_FFT_RST_N_ID);
    XGpio_SetDataDirection(&o_gpio_rom_fft_rst_n, 1, 0X0);
}

void init_o_gpio_sys_rst_n(void)
{
    XGpio_Initialize(&o_gpio_sys_rst_n, GPIO_SYS_RST_N_ID);
    XGpio_SetDataDirection(&o_gpio_sys_rst_n, 1, 0X0);
}

void reset_ROM_FFT(void)
{
    XGpio_DiscreteWrite(&o_gpio_rom_fft_rst_n, 1, 0x0);
    usleep(10);
    XGpio_DiscreteWrite(&o_gpio_rom_fft_rst_n, 1, 0xFFFF);
}

void reset_PL(void)
{
    XGpio_DiscreteWrite(&o_gpio_sys_rst_n, 1, 0x0);
    usleep(10);
    XGpio_DiscreteWrite(&o_gpio_sys_rst_n, 1, 0xFFFF);
}
