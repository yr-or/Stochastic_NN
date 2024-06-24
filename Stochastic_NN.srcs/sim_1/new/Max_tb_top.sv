`timescale 1ns / 1ps


module Max_tb_top();

    // regs
    reg clk = 0;
    reg reset = 0;

    logic [7:0] values_tb [0:9] = '{53, 100, 25, 9, 204, 235, 63, 78, 99, 28};
    logic [3:0] result_tb;
    logic done_tb;

    Max_tb dut(
        .clk            (clk),
        .reset          (reset),
        .values_bin     (values_tb),

        .result         (result_tb),
        .done           (done_tb)
    );

    // Apply test data in order, change LFSR seed each time to test
    initial begin
        reset = 1;
        #10;

        for (int i=0; i<10; i=i+1) begin
            // Assign inputs
            reset = 1;

            // Hold reset for 2 clks
            #40;
            reset = 0;

            // Wait 256 clock cycles + 10 clk cycles for max module
            #5100;
            #200;

        end
    end

    // Clock gen
    always begin
        #10;
        clk = ~clk;
    end

endmodule
