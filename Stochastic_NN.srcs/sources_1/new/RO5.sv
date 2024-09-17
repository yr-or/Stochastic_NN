// Oscillator module
// Based on: https://ieeexplore.ieee.org/document/7195665 and https://github.com/stnolting/neoTRNG?tab=readme-ov-file

(* keep_hierarchy = "yes" *)
(* DONT_TOUCH = "yes" *)
(* keep = "true" *)
module RO5(
    output [4:0] parallel_out
);
    
    // Internal wires
    (* keep = "true" *) wire not1, not2, not3, not4, not5;

    // Create NOT gates
    assign not1 = ~not5;
    assign not2 = ~not1;
    assign not3 = ~not2;
    assign not4 = ~not3;
    assign not5 = ~not4;

    // Output
    assign parallel_out = {not1, not2, not3, not4, not5};


endmodule