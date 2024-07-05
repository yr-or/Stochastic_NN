
module LFSR16_Galois_tb();

    reg clk = 0;
    reg reset = 0;

    wire [15:0] lfsr_out;

    // DUT
    LFSR16_Galois lfsr(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd2938),
        .parallel_out       (lfsr_out)
    );

    initial begin
        reset = 1;
        #30;
        reset = 0;
    end


    always begin
        #10;
        clk = ~clk;
    end


endmodule
