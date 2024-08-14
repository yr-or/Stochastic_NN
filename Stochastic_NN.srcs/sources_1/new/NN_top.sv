// Top-level module for Neural Network
// contains each layer and max module, as well as SNGs to generate inputs

// Equivalent to Test_L2_regen.sv for whole L2+L3

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module NN_top(
    input clk,
    input reset,
    input [15:0] input_data_bin      [0:195],    // 196 8-bit values

    output [15:0] L2_res_bin [0:31],    // Upscaled
    output [15:0] L3_res_bin [0:9],
    output done_regen,
    output done,
    output [3:0] max_ind,
    output or_out_dbg,
    output [9:0] one_detec_dbg
    );

    // Consts
    localparam NUM_NEUR_L2 = 32;
    localparam NUM_NEUR_L3 = 10;
    localparam NUM_INP_L2 = 196;

    // Stoch wires inputs
    wire inps_stoch         [0:NUM_INP_L2-1];

    // Stoch output wires of Layer 2 (before regen)
    wire L2_out_stoch       [0:NUM_NEUR_L2-1]; 
    
    // Stoch output wires of Regen module
    wire L2_regen_stoch [0:NUM_NEUR_L2-1];

    // Stoch outputs of Layer3
    wire L3_out_stoch       [0:NUM_NEUR_L3-1]; 

    // Generate stoachastic inputs - 196 SNGs
    genvar i;
    generate
        for (i=0; i<NUM_INP_L2; i=i+1) begin
            StochNumGen16 SNG_inps(
                .clk                (clk),
                .reset              (reset),
                .seed               (16'd25645),
                .prob               (input_data_bin[i]),
                .stoch_num          (inps_stoch[i])
            );
        end
    endgenerate

    // Connect to Layer2
    Layer2 L2(
        .clk                    (clk),
        .reset                  (reset),
        .data_in_stoch          (inps_stoch),
        .results                (L2_out_stoch)
    );

    /////////////////////////////////////////////////////////
    ////////// Enable logic for STB_L2 and STB_L3 ///////////
    reg en_regen;

    // Use DFF to create a continuous signal from done pulse
    always @(posedge clk) begin
        if (reset) begin
            en_regen <= 1;         // Reset into enable state
        end
        else if (done_regen) begin
            en_regen <= 0;
        end
    end
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////

    // Regen module
    Regenerate_L2 regen(
        .clk                    (clk),
        .reset                  (reset),
        .enable                 (en_regen),
        .L2_outs_stoch          (L2_out_stoch),

        .L2_regen_stoch         (L2_regen_stoch),
        .done                   (done_regen),
        // Debug ports
        .L2_relu_out_bin        (L2_res_bin)
    );

    // Layer 3
    Layer3 L3(
        .clk                    (clk),
        .reset                  (reset),
        .data_in_stoch          (L2_regen_stoch),
        .results                (L3_out_stoch)
    );

    // STBs for outputs of L3
    wire [9:0] done_STB_L3;
    generate
        for (i=0; i<NUM_NEUR_L3; i=i+1) begin
            StochToBin16 STB_L3 (
                .clk                (clk),
                .reset              (reset),
                .enable             (~en_regen),
                .bit_stream         (L3_out_stoch[i]),
                .bin_number         (L3_res_bin[i]),
                .done               (done_STB_L3[i])
            );
        end
    endgenerate

    // Get max value
    Max_Stoch max_stoch(
        .clk                    (clk),
        .reset                  (reset),
        .L3_out_stoch           (L3_out_stoch),
        .max                    (max_ind),
        .or_out_dbg             (or_out_dbg),
        .one_detec_dbg          (one_detec_dbg)
    );


    assign done = &(done_STB_L3);

endmodule
