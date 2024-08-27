// Get index of max int16 out of 10 inps

module Max_int16(
    input clk,
    input reset,
    input enable,
    input [15:0] nums [0:9],

    output [3:0] max_ind,
    output done
    );

    localparam NUM_INP = 10;

    // Registers
    reg [3:0] index_max = 0;
    reg [15:0] max_val = 0;
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
        else if (enable) begin

            if (count_ff < NUM_INP) begin
                if (nums[count_ff] > max_val) begin
                    max_val <= nums[count_ff];
                    index_max <= count_ff;
                end
                count_ff <= count_ff + 1;
            end
            else begin
                done_ff <= 1;
            end

        end
    end

    assign done = done_ff;
    assign max_ind = index_max;

endmodule
