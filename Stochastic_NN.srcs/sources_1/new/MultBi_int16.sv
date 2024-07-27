// Multiply bipolar int16 by a value such that the actual number gets mutliplied
// Inputs: bipolar int16
// Ouputs: bipolar int16 multiplied by k

module MultBi_int16 (
    input [15:0] in_val,
    input [15:0] k,

    output [15:0] out_val
    );


    // Convert from bipolar to unipolar
    // uni_int16 = 2x(bi_int16) - 2^16

    reg [16:0] in_1;
    reg [15:0] in_2;
    reg [16:0] in_3;
    reg [16:0] in_4;
    reg [16:0] in_5;

    always @(*) begin
        // Convert to unipolar
        
        in_1 = 2*in_val;
        in_2 = in_1 - 16'd65536;

        // Multiply
        in_3 = in_2 * k;

        // Convert back to bipolar
        in_4 = in_3 + 17'd65536;
        in_5 = in_4 / 2;
        
    end

    assign out_val = in_5;

endmodule