//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Tue Apr  1 02:13:03 2025
//Host        : sweetpotato running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (Vaux0_0_v_n,
    Vaux0_0_v_p,
    Vaux1_0_v_n,
    Vaux1_0_v_p,
    ddr3_sdram_addr,
    ddr3_sdram_ba,
    ddr3_sdram_cas_n,
    ddr3_sdram_ck_n,
    ddr3_sdram_ck_p,
    ddr3_sdram_cke,
    ddr3_sdram_dm,
    ddr3_sdram_dq,
    ddr3_sdram_dqs_n,
    ddr3_sdram_dqs_p,
    ddr3_sdram_odt,
    ddr3_sdram_ras_n,
    ddr3_sdram_reset_n,
    ddr3_sdram_we_n,
    h_bridge_dir_gpio,
    h_bridge_pwm,
    hdmi_in_clk_n,
    hdmi_in_clk_p,
    hdmi_in_data_n,
    hdmi_in_data_p,
    hdmi_in_ddc_scl_io,
    hdmi_in_ddc_sda_io,
    hdmi_in_hpd,
    hdmi_out_clk_n,
    hdmi_out_clk_p,
    hdmi_out_data_n,
    hdmi_out_data_p,
    hdmi_rx_txen,
    power_monitor_iic_scl_io,
    power_monitor_iic_sda_io,
    rangefinder_uart_rxd,
    rangefinder_uart_txd,
    reset,
    reset_0,
    servo_pwm_1,
    switch_input,
    sys_clk,
    usb_uart_rxd,
    usb_uart_txd,
    vp_vn_v_n,
    vp_vn_v_p);
  input Vaux0_0_v_n;
  input Vaux0_0_v_p;
  input Vaux1_0_v_n;
  input Vaux1_0_v_p;
  output [14:0]ddr3_sdram_addr;
  output [2:0]ddr3_sdram_ba;
  output ddr3_sdram_cas_n;
  output [0:0]ddr3_sdram_ck_n;
  output [0:0]ddr3_sdram_ck_p;
  output [0:0]ddr3_sdram_cke;
  output [1:0]ddr3_sdram_dm;
  inout [15:0]ddr3_sdram_dq;
  inout [1:0]ddr3_sdram_dqs_n;
  inout [1:0]ddr3_sdram_dqs_p;
  output [0:0]ddr3_sdram_odt;
  output ddr3_sdram_ras_n;
  output ddr3_sdram_reset_n;
  output ddr3_sdram_we_n;
  output [0:0]h_bridge_dir_gpio;
  output h_bridge_pwm;
  input hdmi_in_clk_n;
  input hdmi_in_clk_p;
  input [2:0]hdmi_in_data_n;
  input [2:0]hdmi_in_data_p;
  inout hdmi_in_ddc_scl_io;
  inout hdmi_in_ddc_sda_io;
  output [0:0]hdmi_in_hpd;
  output hdmi_out_clk_n;
  output hdmi_out_clk_p;
  output [2:0]hdmi_out_data_n;
  output [2:0]hdmi_out_data_p;
  output [0:0]hdmi_rx_txen;
  inout power_monitor_iic_scl_io;
  inout power_monitor_iic_sda_io;
  input rangefinder_uart_rxd;
  output rangefinder_uart_txd;
  input reset;
  input reset_0;
  output servo_pwm_1;
  input [7:0]switch_input;
  input sys_clk;
  input usb_uart_rxd;
  output usb_uart_txd;
  input vp_vn_v_n;
  input vp_vn_v_p;

  wire Vaux0_0_v_n;
  wire Vaux0_0_v_p;
  wire Vaux1_0_v_n;
  wire Vaux1_0_v_p;
  wire [14:0]ddr3_sdram_addr;
  wire [2:0]ddr3_sdram_ba;
  wire ddr3_sdram_cas_n;
  wire [0:0]ddr3_sdram_ck_n;
  wire [0:0]ddr3_sdram_ck_p;
  wire [0:0]ddr3_sdram_cke;
  wire [1:0]ddr3_sdram_dm;
  wire [15:0]ddr3_sdram_dq;
  wire [1:0]ddr3_sdram_dqs_n;
  wire [1:0]ddr3_sdram_dqs_p;
  wire [0:0]ddr3_sdram_odt;
  wire ddr3_sdram_ras_n;
  wire ddr3_sdram_reset_n;
  wire ddr3_sdram_we_n;
  wire [0:0]h_bridge_dir_gpio;
  wire h_bridge_pwm;
  wire hdmi_in_clk_n;
  wire hdmi_in_clk_p;
  wire [2:0]hdmi_in_data_n;
  wire [2:0]hdmi_in_data_p;
  wire hdmi_in_ddc_scl_i;
  wire hdmi_in_ddc_scl_io;
  wire hdmi_in_ddc_scl_o;
  wire hdmi_in_ddc_scl_t;
  wire hdmi_in_ddc_sda_i;
  wire hdmi_in_ddc_sda_io;
  wire hdmi_in_ddc_sda_o;
  wire hdmi_in_ddc_sda_t;
  wire [0:0]hdmi_in_hpd;
  wire hdmi_out_clk_n;
  wire hdmi_out_clk_p;
  wire [2:0]hdmi_out_data_n;
  wire [2:0]hdmi_out_data_p;
  wire [0:0]hdmi_rx_txen;
  wire power_monitor_iic_scl_i;
  wire power_monitor_iic_scl_io;
  wire power_monitor_iic_scl_o;
  wire power_monitor_iic_scl_t;
  wire power_monitor_iic_sda_i;
  wire power_monitor_iic_sda_io;
  wire power_monitor_iic_sda_o;
  wire power_monitor_iic_sda_t;
  wire rangefinder_uart_rxd;
  wire rangefinder_uart_txd;
  wire reset;
  wire reset_0;
  wire servo_pwm_1;
  wire [7:0]switch_input;
  wire sys_clk;
  wire usb_uart_rxd;
  wire usb_uart_txd;
  wire vp_vn_v_n;
  wire vp_vn_v_p;

  design_1 design_1_i
       (.Vaux0_0_v_n(Vaux0_0_v_n),
        .Vaux0_0_v_p(Vaux0_0_v_p),
        .Vaux1_0_v_n(Vaux1_0_v_n),
        .Vaux1_0_v_p(Vaux1_0_v_p),
        .ddr3_sdram_addr(ddr3_sdram_addr),
        .ddr3_sdram_ba(ddr3_sdram_ba),
        .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
        .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
        .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
        .ddr3_sdram_cke(ddr3_sdram_cke),
        .ddr3_sdram_dm(ddr3_sdram_dm),
        .ddr3_sdram_dq(ddr3_sdram_dq),
        .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
        .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
        .ddr3_sdram_odt(ddr3_sdram_odt),
        .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
        .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
        .ddr3_sdram_we_n(ddr3_sdram_we_n),
        .h_bridge_dir_gpio(h_bridge_dir_gpio),
        .h_bridge_pwm(h_bridge_pwm),
        .hdmi_in_clk_n(hdmi_in_clk_n),
        .hdmi_in_clk_p(hdmi_in_clk_p),
        .hdmi_in_data_n(hdmi_in_data_n),
        .hdmi_in_data_p(hdmi_in_data_p),
        .hdmi_in_ddc_scl_i(hdmi_in_ddc_scl_i),
        .hdmi_in_ddc_scl_o(hdmi_in_ddc_scl_o),
        .hdmi_in_ddc_scl_t(hdmi_in_ddc_scl_t),
        .hdmi_in_ddc_sda_i(hdmi_in_ddc_sda_i),
        .hdmi_in_ddc_sda_o(hdmi_in_ddc_sda_o),
        .hdmi_in_ddc_sda_t(hdmi_in_ddc_sda_t),
        .hdmi_in_hpd(hdmi_in_hpd),
        .hdmi_out_clk_n(hdmi_out_clk_n),
        .hdmi_out_clk_p(hdmi_out_clk_p),
        .hdmi_out_data_n(hdmi_out_data_n),
        .hdmi_out_data_p(hdmi_out_data_p),
        .hdmi_rx_txen(hdmi_rx_txen),
        .power_monitor_iic_scl_i(power_monitor_iic_scl_i),
        .power_monitor_iic_scl_o(power_monitor_iic_scl_o),
        .power_monitor_iic_scl_t(power_monitor_iic_scl_t),
        .power_monitor_iic_sda_i(power_monitor_iic_sda_i),
        .power_monitor_iic_sda_o(power_monitor_iic_sda_o),
        .power_monitor_iic_sda_t(power_monitor_iic_sda_t),
        .rangefinder_uart_rxd(rangefinder_uart_rxd),
        .rangefinder_uart_txd(rangefinder_uart_txd),
        .reset(reset),
        .reset_0(reset_0),
        .servo_pwm_1(servo_pwm_1),
        .switch_input(switch_input),
        .sys_clk(sys_clk),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd),
        .vp_vn_v_n(vp_vn_v_n),
        .vp_vn_v_p(vp_vn_v_p));
  IOBUF hdmi_in_ddc_scl_iobuf
       (.I(hdmi_in_ddc_scl_o),
        .IO(hdmi_in_ddc_scl_io),
        .O(hdmi_in_ddc_scl_i),
        .T(hdmi_in_ddc_scl_t));
  IOBUF hdmi_in_ddc_sda_iobuf
       (.I(hdmi_in_ddc_sda_o),
        .IO(hdmi_in_ddc_sda_io),
        .O(hdmi_in_ddc_sda_i),
        .T(hdmi_in_ddc_sda_t));
  IOBUF power_monitor_iic_scl_iobuf
       (.I(power_monitor_iic_scl_o),
        .IO(power_monitor_iic_scl_io),
        .O(power_monitor_iic_scl_i),
        .T(power_monitor_iic_scl_t));
  IOBUF power_monitor_iic_sda_iobuf
       (.I(power_monitor_iic_sda_o),
        .IO(power_monitor_iic_sda_io),
        .O(power_monitor_iic_sda_i),
        .T(power_monitor_iic_sda_t));
endmodule
