// Testbench for layer 3, using precomputed values from layer2

module Layer3_tb();

    reg clk = 0;
    reg reset = 0;

    // Input data to L3
    logic [15:0] L2_res_bin [0:31] = '{43776, 33408, 32768, 32768, 32768, 50560, 43008, 32768, 39552, 41856, 39808, 51456, 32768, 36224, 34176, 45952, 35072, 45568, 32768, 38912, 32768, 32768, 40576, 32768, 36736, 59392, 47488, 44672, 32768, 32768, 41728, 58240};
    wire L2_res_stoch [0:31];

    // Outputs from L3
    wire L3_res_stoch [0:9];
    wire [15:0] L3_res_bin [0:9];
    wire done;

    reg [15:0] LFSR_seeds_regen [0:31] = '{5316, 5970, 52892, 13882, 26082, 450, 57322, 62525, 29721, 53053, 49432, 26040, 58604, 27918, 14559, 36638, 50320, 16893, 2341, 45528, 42059, 47783, 35719, 3518, 18991, 1150, 16456, 58862, 761, 37439, 34275, 12522};
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin
            StochNumGen16 SNG_inps(
                .clk                (clk),
                .reset              (reset),
                .seed               (LFSR_seeds_regen[i]),
                .prob               (L2_res_bin[i]),
                .stoch_num          (L2_res_stoch[i])
            );
        end
    endgenerate


    Layer3 layer3(
        .clk                        (clk),
        .reset                      (reset),
        .data_in_stoch              (L2_res_stoch),
        
        .results                    (L3_res_stoch)
    );

    // STBs for outputs of L3
    wire [9:0] done_STB_L3;
    generate
        for (i=0; i<10; i=i+1) begin
            StochToBin16 STB_L3 (
                .clk                (clk),
                .reset              (reset),
                .enable             (1),
                .bit_stream         (L3_res_stoch[i]),
                .bin_number         (L3_res_bin[i]),
                .done               (done_STB_L3[i])
            );
        end
    endgenerate
    assign done = &(done_STB_L3);

    // Input test stimulus
    //   can test different inputs here
    initial begin
        reset = 1;
        #30;
        reset = 0;

        // Wait for 65535 clk cycles
        #1310700;
    end


    always begin
        #10;
        clk = ~clk;
    end 

endmodule
