// SNG with rand num input for sharing

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module SNG16_noLFSR
    (
        input clk,
        input reset,
        input [15:0] rand_num,
        input [15:0] prob,       // 8-bit unsigned binary integer B indicating probability
        output stoch_num
    );

    // registers
    reg bit_stream_ff;

    // Comparator, R < B => 1, else 0
    always @(*) begin
        if (rand_num < prob)
            bit_stream_ff = 1'b1;
        else
            bit_stream_ff = 1'b0;
    end

    assign stoch_num = bit_stream_ff;

endmodule
