// 16-bit Galois LFSR, maximum length of loop = 65535
// based on https://datacipy.cz/lfsr_table.pdf

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module LFSR16_Galois(
    input clk,
    input reset,
    input [15:0] seed,
    output [15:0] parallel_out
    );

    reg [15:0] shift_reg;
    wire xor1;
    wire xor2;
    wire xor3;

    assign xor1 = shift_reg[14] ^ shift_reg[0];
    assign xor2 = shift_reg[13] ^ shift_reg[0];
    assign xor3 = shift_reg[11] ^ shift_reg[0];

    // 8-bit Galois LFSR with with taps at 16,14,13,11
    // i.e. the inputs to 13,12,10 are xord with 0
    // values are shifted from high to low, i.e. right-shifted
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= seed;  // initial seed
        end
        else begin
            shift_reg[15] <= shift_reg[0];
            shift_reg[14] <= shift_reg[15];
            shift_reg[13] <= xor1;
            shift_reg[12] <= xor2;
            shift_reg[11] <= shift_reg[12];
            shift_reg[10] <= xor3;
            shift_reg[9:0] <= {shift_reg[10], shift_reg[9:1]};
        end
    end

assign parallel_out = shift_reg;

endmodule
