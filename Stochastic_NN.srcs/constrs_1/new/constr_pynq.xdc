create_clock -add -name clk_pin -period 20.00 -waveform {0 10} [get_ports { clk }];
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk