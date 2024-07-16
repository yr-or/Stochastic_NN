

// Perform regeneration of outputs of L2 and ReLU function

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module Regenerate_L2(
    input clk,
    input reset,
    input L2_outs_stoch [0:31],
    
    output L2_regen_stoch [0:31],
    output done,

    // Debug outputs
    output [15:0] L2_bias_out_bin [0:31],
    output [15:0] L2_relu_out_bin [0:31]
    );

    localparam NUM_NEUR = 32;

    // Wires
    wire [15:0] L2_stb_out_bin [0:NUM_NEUR-1];
    wire [NUM_NEUR-1:0] done_stb;

    // Regs
    reg [15:0] L2_relu_bin [0:NUM_NEUR-1];

    // Input all values to STBs
    genvar i;
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
            StochToBin16 STB(
                .clk                (clk),
                .reset              (reset),
                .enable             (1'b1),
                .bit_stream         (L2_outs_stoch[i]),
                .bin_number         (L2_stb_out_bin[i]),
                .done               (done_stb[i])
            );
        end
    endgenerate

    // Apply ReLU function, using int16 bipolar representation**
    integer j;
    always @(*) begin
        for (j=0; j<NUM_NEUR; j=j+1) begin
            if (L2_stb_out_bin[j] >= 16'd32768) begin
                L2_relu_bin[j] = L2_stb_out_bin[j];
            end else begin
                L2_relu_bin[j] = 16'b0;
            end
        end
    end


    // Output back in stochastic form
    reg [15:0] LFSR_seeds_regen [0:NUM_NEUR-1] = '{5316, 5970, 52892, 13882, 26082, 450, 57322, 62525, 29721, 53053, 49432, 26040, 58604, 27918, 14559, 36638, 50320, 16893, 2341, 45528, 42059, 47783, 35719, 3518, 18991, 1150, 16456, 58862, 761, 37439, 34275, 12522};
    generate
        for (i=0; i<NUM_NEUR; i=i+1) begin
            StochNumGen16 SNG(
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_seeds_regen[i]),
                .prob                   (L2_relu_bin[i]),
                .stoch_num              (L2_regen_stoch[i])
            );
        end
    endgenerate

    assign done = &(done_stb);
    assign L2_relu_out_bin = L2_relu_bin;
    assign L2_bias_out_bin = L2_stb_out_bin;

endmodule
