

module SNG_synth(
    input clk
    );

    wire stoch_num;
    wire reset;
    wire [15:0] input_prob;


    StochNumGen16 SNG(
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (input_prob),
        .prob                   (16'd32768),     // 0.5
        .stoch_num              (stoch_num)
    );

    /////////////////////// VIO and ILA ///////////////////////
    vio_2 vio(
        .clk                    (clk),
        .probe_out0             (reset),
        .probe_out1             (input_prob)
    );
    ila_2 ila(
        .clk                    (clk),
        .probe0                 (reset),
        .probe1                 (stoch_num)
    );

endmodule
