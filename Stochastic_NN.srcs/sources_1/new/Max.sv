// Return index of maximum stochastic number in array
// Count 1s in bitstreams, most=max val
// Update: Changed STB to STB16

module Max (
    input clk,
    input reset,
    input enable,
    input stoch_array [0:9],         // 10 inputs
    output [3:0] max_ind,            // 4 bit needed to store vals 0-9
    output done
    );

    localparam NUM_INP = 10;

    // wires
    wire [15:0] stb_out [0:NUM_INP-1];
    wire [0:NUM_INP-1] done_stb_array;
    wire done_stb = &(done_stb_array);
    reg en_ctr;

    // Control logic
    PulseDet pulsedet(
        .clk                    (clk),
        .reset                  (reset),
        .pulse_wire             (done_stb),
        .one_detec              (en_ctr)
    );

    // Use STBs to count vals
    genvar i;
    generate
        for (i=0; i<NUM_INP; i=i+1) begin
                StochToBin16 stb(
                    .clk                (clk),
                    .reset              (reset),
                    .enable             (enable),
                    .bit_stream         (stoch_array[i]),
                    .bin_number         (stb_out[i]),
                    .done               (done_stb_array[i])
                );
        end
    endgenerate

    // Registers
    reg [3:0] index_max = 0;
    reg signed [15:0] max_val = 0;
    reg [3:0] count_ff = 4'b0;          // 4-bit up-counter from 0 to 9
    reg done_ff = 1'b0;

    always @(posedge clk) begin
        // Posedge synchronous reset
        if (reset) begin
            index_max <= 4'b0;
            max_val <= 8'b0;
            count_ff <= 4'b0;
            done_ff <= 0;
        end 
        else if (en_ctr) begin
            if (count_ff < NUM_INP) begin
                if (stb_out[count_ff] > max_val) begin
                    max_val <= stb_out[count_ff];
                    index_max <= count_ff;
                end
                count_ff <= count_ff + 1'b1;
            end else
                done_ff <= 1'b1;
        end
    end

    assign max_ind = index_max;
    assign done = done_ff;

endmodule
