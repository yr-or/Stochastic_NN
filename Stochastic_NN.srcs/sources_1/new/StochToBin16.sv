// Stochastic to Binary converter with bitstream length of 2^16-1 = 65535


module StochToBin16 (
    input clk,
    input reset,
    input enable,
    input bit_stream,
    output [15:0] bin_number,
    output done
    );

    localparam BITSTR_LEN=65535;

    reg [15:0] ones_count = 0;
    reg [15:0] clk_count = 0;

    // Accumulate 1s in SN for 256 clk cycles, then reset
    always @(posedge clk) begin
        if (reset) begin
            clk_count <= 0;
            ones_count <= 0;
        end else begin
            // enable logic, if enable, do stuff, otherwise do nothing
            if (enable) begin
                // 256 clk cycles
                if (clk_count < BITSTR_LEN) begin
                    ones_count <= ones_count + bit_stream;
                    clk_count <= clk_count + 1;
                end else begin
                    // reset counter to 0 and ones_count to incoming bit
                    clk_count <= 0;
                    ones_count <= bit_stream;
                end
            end
        end
    end

    // Done logic
    assign done = (clk_count == BITSTR_LEN) ? 1 : 0;

    // Output
    assign bin_number = ones_count;

endmodule