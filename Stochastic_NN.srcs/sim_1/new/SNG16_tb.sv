

module SNG16_tb();

    reg clk = 0;
    reg reset = 0;

    wire sng_out;

    // DUT
    StochNumGen16 sng(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd24415),
        .prob               (16'd32768),        // 0.5
        .stoch_num          (sng_out)
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
