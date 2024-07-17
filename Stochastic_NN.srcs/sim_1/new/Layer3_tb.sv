// Testbench for layer 3, using precomputed values from layer2

module Layer3_tb();

    reg clk = 0;
    reg reset = 0;

    // Input data to L3
    logic [15:0] L2_relu_out [0:31] = '{32768, 32768, 32768, 32768, 32830, 32832, 32915, 32821, 32928, 32768, 32793, 32814, 32768, 32819, 32940, 32852, 32817, 32768, 32768, 32862, 32777, 32850, 32820, 32768, 32842, 32803, 32940, 32768, 32768, 32778, 32807, 32768};
    wire L2_relu_out_stoch [0:31];

    // Outputs from L3
    wire [15:0] results_L3_bin [0:9];
    wire done;

    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin
            StochNumGen16 SNG_inps(
                .clk                (clk),
                .reset              (reset),
                .seed               (16'd58473),
                .prob               (L2_relu_out[i]),
                .stoch_num          (L2_relu_out_stoch[i])
            );
        end
    endgenerate


    Layer3 layer3(
        .clk                        (clk),
        .reset                      (reset),
        .data_in_stoch              (L2_relu_out_stoch),
        
        .results_bin                (results_L3_bin),
        .done                       (done)
    );

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
