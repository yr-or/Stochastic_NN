// Return index of maximum stochastic number in array
// Count 1s in bitstreams, most=max val

module Max_comb (
    input clk,
    input reset,
    input stoch_array [0:9],         // 10 inputs
    output [3:0] max_ind,            // 4 bit needed to store vals 0-9
    output done
    );

    localparam NUM_INP = 10;

    // wires
    wire [7:0] stb_out [0:NUM_INP-1];
    wire [0:NUM_INP-1] done_stb_array;
    wire done_stb = &(done_stb_array);
    reg en_stb = 1;

    // Use STBs to count vals
    genvar i;
    generate
        for (i=0; i<NUM_INP; i=i+1) begin
                StochToBin stb(
                    .clk                (clk),
                    .reset              (reset),
                    .enable             (en_stb),
                    .bit_stream         (stoch_array[i]),
                    .bin_number         (stb_out[i]),
                    .done               (done_stb_array[i])
                );
        end
    endgenerate

    // Use combinational logic to get max index

    reg [7:0] max_value;
    reg [3:0] max_index = 0;

    integer j;
    always @(*) begin
        for (j=0; j<NUM_INP; j=j+1) begin
            if (stb_out[j] > max_value) begin
                max_value = stb_out[j];
                max_index = j;
            end
        end
    end

    assign max_ind = max_index;
    assign done = done_stb;

endmodule
