// 8-bit Galois LFSR, maximum length of loop = 255
// based on https://datacipy.cz/lfsr_table.pdf

module LFSR8_Galois(
    input clk,
    input reset,
    input [7:0] seed,
    output [7:0] parallel_out
    );

    reg [7:0] shift_reg;

    // 8-bit Galois LFSR with with taps at 8,6,5,4
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= seed;  // initial seed
        end 
        else begin
            shift_reg[7] <= shift_reg[0];
            shift_reg[6] <= shift_reg[7];
            shift_reg[5] <= shift_reg[6] ^ shift_reg[0];
            shift_reg[4] <= shift_reg[5] ^ shift_reg[0];
            shift_reg[3] <= shift_reg[4] ^ shift_reg[0];
            shift_reg[2] <= shift_reg[3];
            shift_reg[1] <= shift_reg[2];
            shift_reg[0] <= shift_reg[1];
        end
    end

    // Initial seed
    initial begin
        shift_reg = seed;
    end

assign parallel_out = shift_reg;

endmodule
