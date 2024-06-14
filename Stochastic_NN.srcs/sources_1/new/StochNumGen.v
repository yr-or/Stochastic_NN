// Stochastic number generator, including RNG source

module StochNumGen
    (
        input clk,
        input reset,
        input [7:0] seed,
        input [7:0] prob,       // 8-bit unsigned binary integer B indicating probability
        output stoch_num
    );

    // registers
    reg bit_stream_ff;
    wire [7:0] rand_num;

    // LFSR
    LFSR8_Galois lfsr(
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (seed),
        .parallel_out           (rand_num)
    );

    // Comparator, R < B => 1, else 0
    always @(*) begin
        if (rand_num < prob)
            bit_stream_ff = 1'b1;
        else
            bit_stream_ff = 1'b0;
    end

    assign stoch_num = bit_stream_ff;

endmodule
