`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     CDU-LSP
// Engineer:    CDU-LSP
// 
// Create Date: 2020/11/07 19:50:33
// Design Name: NCSSK
// Module Name: NCSSK_top
// Project Name: NCSSK
// Target Devices: PYNQ-Z2
// Tool Versions: 2018.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.0.1 - File Created
// Revision 1.0.0 (2020/11/08 05:38)
//               - Solve one-dimensional pitch angle
// Revision 1.1.0 (2020/11/13/ 02:38)
//               - Fixed timing error
//               - Add ability to calculate azimuth angle from 2 stations
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// NCSSK_top NCSSK_top_inst
// (
//     .sys_clk_PS_100M (sys_clk_PS_100M),
//     .sys_rst_n       (sys_rst_n),
//     .in_delay_point  (delay_point),
//     .rom_fft_rst_n   (rom_fft_rst_n),
//     .out_angle       (angle),
//     .angle_valid     (angle_valid) 
// );

module NCSSK_top
(
    input   wire                    sys_clk_PS_100M ,
    input   wire                    sys_rst_n       ,
    input   wire            [31:0]  in_delay_point  ,
    input   wire                    rom_fft_rst_n   ,

    output  wire            [31:0]  out_angle       ,
    output  wire                    angle_valid      
);

//var
wire    [6:0]   delay_point;
wire    [21:0]  angle;
assign delay_point = in_delay_point[6:0];
assign out_angle = {9'b0, angle};

//clock_distrb_inst
wire                    sys_clk                 ;
wire                    locked                  ;

//read_signal_inst
wire            [7:0]   signal_out              ;
wire            [10:0]  cnt                     ;

//fft_signal_inst
wire            [21:0]  fft_max_img             ;
wire            [21:0]  fft_max_real            ;
wire            [15:0]  m_axis_data_tuser       ;

//get_phase_inst
wire            [13:0]  arctan_result           ;
wire                    m_axis_dout_tvalid      ;

//get_phase_difference_inst
wire            [13:0]  phase_difference_a      ;
wire            [13:0]  phase_difference_b      ;
wire                    phase_out_valid         ;
wire                    pulse                   ;

//phase_diff_times_kesai_inst
wire            [19:0]  mult_out                ;
wire                    mult_out_valid          ;

//get_angle_inst
// ...

// assign  pitch_angle = arccos_result             ;

clk_wiz_0   clock_dist_inst
(
    // Clock out ports
    .sys_clk    (sys_clk        ),  // output sys_clk

    // Status and control signals
    .resetn     (sys_rst_n      ),  // input resetn
    .locked     (locked         ),  // output locked

    // Clock in ports
    .clk_in_PS  (sys_clk_PS_100M)   // input clk_in_PS
);

rom_read_signal read_signal_inst
(
    .Clk         (sys_clk      ),
    .Rst_n       (rom_fft_rst_n),
    .delay_point (delay_point  ),
    .locked      (locked       ),

    .signal_out  (signal_out   ),
    .cnt         (cnt          ) 
);

fft_signal  fft_signal_inst
(
    .Clk                (sys_clk          ),
    .Rst_n              (rom_fft_rst_n    ), // at least two cycles ;
    .delay_point        (delay_point      ),
    .cnt                (cnt              ),
    .locked             (locked           ),
    .fft_input_real     (signal_out       ),

    .fft_max_img        (fft_max_img      ),
    .fft_max_real       (fft_max_real     ),
    .m_axis_data_tuser  (m_axis_data_tuser)
);

get_phase   get_phase_inst
(
    .Clk                 (sys_clk           ),
    .Rst_n               (sys_rst_n         ),
    .m_axis_data_tuser   (m_axis_data_tuser ),
    .fft_max_img         (fft_max_img       ),
    .fft_max_real        (fft_max_real      ),
    .lock                (locked            ),

    .arctan_result       (arctan_result     ),
    .m_axis_dout_tvalid  (m_axis_dout_tvalid)
);

get_phase_difference    get_phase_difference_inst
(
    .sys_clk                 (sys_clk             ),
    .sys_rst_n               (sys_rst_n           ),
    .din_valid               (m_axis_dout_tvalid  ),
    .locked                  (locked              ),
    .phase                   (arctan_result       ),

    .phase_difference_a      (phase_difference_a  ),
    .phase_difference_b      (phase_difference_b  ),
    .phase_out_valid         (phase_out_valid     ),
    .pulse                   (pulse               ) 
);

phase_diff_times_kesai  phase_diff_times_kesai_inst
(
    .sys_clk         (sys_clk           ),
    .sys_rst_n       (sys_rst_n         ),
    .multiplier_a    (phase_difference_a),
    .locked          (locked            ),
    .pulse           (pulse             ),

    .mult_out_reg2   (mult_out          ),
    .mult_out_valid  (mult_out_valid    )
);

get_angle get_angle_inst
(
    .Clk                (sys_clk       ),
    .Rst_n              (sys_rst_n     ),
    .clock_lock         (locked        ),
    .data_in_valid      (mult_out_valid),
    .data_in            (mult_out      ),

    .add_result         (angle         ),
    .arccos_result_valid(angle_valid   )
);

endmodule
