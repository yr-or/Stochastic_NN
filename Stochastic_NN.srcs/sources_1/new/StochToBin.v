// Stochastic to Binary converter
// Updated: removed second always block, caused issue with multiple drivers
// on done signal.

module StochToBin (
    input clk,
    input reset,
    input bit_stream,
    output [7:0] bin_number,
    output done
    );

    localparam BITSTR_LENGTH = 256;  // 8-bits, max length of LFSR loop

    reg [7:0] ones_count = 0;
    reg [7:0] clk_count = 0;

    // Accumulate 1s in SN for 256 clk cycles, then reset
    always @(posedge clk) begin
        if (reset) begin
            clk_count <= 0;
            ones_count <= 0;
        end else begin
            // 256 clk cycles
            if (clk_count < 8'd255) begin
                ones_count <= ones_count + bit_stream;
                clk_count <= clk_count + 1;
            end else begin
                // reset counter to 0 and ones_count to incoming bit
                clk_count <= 0;
                ones_count <= bit_stream;
            end
        end
    end

    // Done logic
    assign done = (clk_count == 8'd255) ? 1 : 0;

    // Output
    assign bin_number = ones_count;

endmodule