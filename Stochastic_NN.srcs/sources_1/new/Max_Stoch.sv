// Stoch max index module

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module Max_Stoch(
    input clk,
    input reset,
    input L3_out_stoch [0:9],
    output [3:0] max,
    // debug outputs
    output or_out_dbg,
    output [9:0] one_detec_dbg
    );

    

    // OR all inputs to get max value biststream
    wire [9:0] L3_packed;
    assign L3_packed = {L3_out_stoch[0], L3_out_stoch[1], L3_out_stoch[2], L3_out_stoch[3], L3_out_stoch[4], L3_out_stoch[5], L3_out_stoch[6], L3_out_stoch[7], L3_out_stoch[8], L3_out_stoch[9]};
    (* keep = "true" *) wire or_out;
    assign or_out = |L3_packed;

    // XOR each input with OR result to get stream of zeros for same result, or stream with ones for wrong
    reg xor_out [0:9];
    integer i;
    always @(*) begin
        for (i=0; i<10; i=i+1) begin
            xor_out[i] = (L3_out_stoch[i] ^ or_out);
        end
    end

    // Detect zero
    genvar j;
    wire [9:0] one_detec;
    generate
        for (j=0; j<10; j=j+1) begin
            PulseDet pulsedet(
                .clk                (clk),
                .reset              (reset),
                .pulse_wire         (xor_out[j]),
                .one_detec          (one_detec[j])
            );
        end
    endgenerate

    // Decode result into digit
    reg [3:0] max_ff;
    always @(*) begin
        case (one_detec)
            10'b0111111111     :       max_ff = 4'd9;
            10'b1011111111     :       max_ff = 4'd8;
            10'b1101111111     :       max_ff = 4'd7;
            10'b1110111111     :       max_ff = 4'd6;
            10'b1111011111     :       max_ff = 4'd5;
            10'b1111101111     :       max_ff = 4'd4;
            10'b1111110111     :       max_ff = 4'd3;
            10'b1111111011     :       max_ff = 4'd2;
            10'b1111111101     :       max_ff = 4'd1;
            10'b1111111110     :       max_ff = 4'd0;
            default            :       max_ff = 4'd0;
        endcase
    end

    assign max = max_ff;

    assign or_out_dbg = or_out;
    assign one_detec_dbg = one_detec;


endmodule
