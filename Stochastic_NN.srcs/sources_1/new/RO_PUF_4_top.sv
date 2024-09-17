

module RO_PUF_4_top(
    input clk,
    output reg [15:0] rand_num
    );

    wire [15:0] rand_num_wire;

    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin
            RO_PUF_4 ro_puf(
                .rand_bit               (rand_num_wire[i])
            );
        end
    endgenerate

    always @(posedge clk) begin
        rand_num <= rand_num_wire;
    end

endmodule
