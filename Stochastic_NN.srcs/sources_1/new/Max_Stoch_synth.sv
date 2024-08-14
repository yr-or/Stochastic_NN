
module Max_Stoch_synth(
    input sys_clk
    );

    wire reset;
    wire clk;
    wire fast_clk;
    wire reset_clk;
    wire locked;

    clk_wiz_0 clkwiz (
        .clk_in1            (sys_clk),
        .reset              (reset_clk),
        .clk_out1           (clk),
        .clk_out2           (fast_clk),
        .locked             (locked)
    );

    reg [15:0] values_bin [0:9] = '{19403, 58492, 4835, 2839, 48395, 10375, 49384, 64403, 3823, 3849};
    wire stoch_nums [0:9];
    wire [3:0] max;
    wire or_out_dbg;
    wire [9:0] one_detec_dbg;

    // Generate stochastic numbers
    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin
            StochNumGen16 SNG (
                .clk                (clk),
                .reset              (reset),
                .seed               (16'd48364),
                .prob               (values_bin[i]),
                .stoch_num          (stoch_nums[i])
            );
        end
    endgenerate

    // Input to Max module
    Max_Stoch max (
        .clk                (clk),
        .reset              (reset),
        .L3_out_stoch       (stoch_nums),
        .max                (max),
        .or_out_dbg         (or_out_dbg),
        .one_detec_dbg      (one_detec_dbg)
    );

    // VIO
    wire [3:0] digit_sel;
    vio_0 vio_NN(
        .clk                    (fast_clk),
        .probe_out0             (reset),
        .probe_out1             (reset_clk),
        .probe_out2             (digit_sel)
    );

    
    ila_5 ila(
        .clk                    (clk),
        .probe0                 (max),
        .probe1                 (or_out_dbg),
        .probe2                 (one_detec_dbg)
    );

endmodule
