

module Max_int16_synth(
    input sys_clk
    );

    wire reset;
    wire clk;
    wire enable;
    wire fast_clk;
    wire locked;

    clk_wiz_0 clkwiz (
        .clk_in1            (sys_clk),
        .reset              (1'b0),
        .clk_out1           (clk),
        .clk_out2           (fast_clk),
        .locked             (locked)
    );

    wire [3:0] max_ind;
    wire done;
    wire [15:0] nums [0:9];

    Max_int16 max(
        .clk                (clk),
        .reset              (reset),
        .enable             (enable),
        .nums               (nums),

        .max_ind            (max_ind),
        .done               (done)
    );

    vio_max vio(
        .clk                (fast_clk),
        .probe_out0         (reset),
        .probe_out1         (enable),
        .probe_out2         (nums[0]),
        .probe_out3         (nums[1]),
        .probe_out4         (nums[2]),
        .probe_out5         (nums[3]),
        .probe_out6         (nums[4]),
        .probe_out7         (nums[5]),
        .probe_out8         (nums[6]),
        .probe_out9         (nums[7]),
        .probe_out10         (nums[8]),
        .probe_out11         (nums[9])
    );

    ila_5 ila(
        .clk                (fast_clk),
        .probe0             (reset),
        .probe1             (done),
        .probe2             (max_ind)
    );

endmodule
