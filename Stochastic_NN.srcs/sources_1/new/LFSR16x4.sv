// Block of 4 LFSR16s Galois
// Using single seed input, rearranging wires

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module LFSR16x4(
    input clk,
    input reset,
    input [15:0] seed,
    output [15:0] parallel_out [0:3]
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

assign parallel_out[0] = shift_reg;
assign parallel_out[1] = {shift_reg[4], shift_reg[15], shift_reg[11], shift_reg[6], shift_reg[8], shift_reg[13], shift_reg[9], shift_reg[2], shift_reg[12], shift_reg[1], shift_reg[5], shift_reg[10], shift_reg[3], shift_reg[7], shift_reg[14], shift_reg[0]};
assign parallel_out[2] = {shift_reg[0], shift_reg[15], shift_reg[2], shift_reg[3], shift_reg[6], shift_reg[7], shift_reg[1], shift_reg[9], shift_reg[11], shift_reg[5], shift_reg[13], shift_reg[8], shift_reg[14], shift_reg[10], shift_reg[12], shift_reg[4]};
assign parallel_out[3] = {shift_reg[15], shift_reg[5], shift_reg[14], shift_reg[4], shift_reg[6], shift_reg[3], shift_reg[0], shift_reg[13], shift_reg[9], shift_reg[11], shift_reg[10], shift_reg[12], shift_reg[2], shift_reg[8], shift_reg[7], shift_reg[1]};

endmodule
