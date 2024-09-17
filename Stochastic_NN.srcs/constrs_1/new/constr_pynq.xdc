set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sys_clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sys_clk }];

# inps puf
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets NN_top/rng_inps/genblk*[*].ro_puf*/ro*/not*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets NN_top/L2/rng_l2/genblk*[*].ro_puf*/ro*/not*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets NN_top/regen/rng_regen/genblk*[*].ro_puf*/ro*/not*]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets NN_top/L3/rng_l3/genblk*[*].ro_puf*/ro*/not*]