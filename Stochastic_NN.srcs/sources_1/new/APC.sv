

module APC #(parameter NUM_INPS=32) (
    input clk,
    input reset,
    input enable,
    input input_data_stoch [0:NUM_INPS-1],

    output [15:0] sum_bin
    );

    // wires
    wire [15:0] sums_bin [0:NUM_INPS-1];

    // regs
    reg done_stb;

    // Sum up all input bitstreams
    genvar i;
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            StochToBin stb(
                .clk                    (clk),
                .reset                  (reset),
                .enable                 (enable),
                .bit_stream             (input_data_stoch[i]),
                .bin_number             (sums_bin[i]),
                .done                   (done)
            );    
        end
    endgenerate


endmodule
