// Pulse detector

module PulseDet(
    input clk,
    input reset,
    input pulse_wire,
    output one_detec
    );

    reg one_det;

    // Use DFF to create a continuous signal from done pulse
    always @(posedge clk) begin
        if (reset) begin
            one_det <= 0;
        end
        else if (pulse_wire) begin
            one_det <= 1;
        end
    end

    assign one_detec = one_det;

endmodule
