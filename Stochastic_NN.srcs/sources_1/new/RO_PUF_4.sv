// RNG PUF intended for high randomness not low area
// Based on https://ieeexplore.ieee.org/abstract/document/4016501

module RO_PUF_4(
    output rand_bit
    );

    // Internal wires
    wire [4:0] par_out5;
    wire [6:0] par_out7;
    

    // Ring oscillators 5
    RO5 ro1(
        .parallel_out       (par_out5)
    );

    // Ring oscillators 7
    RO7 ro2(
        .parallel_out       (par_out7)
    );

    // XOR outputs together to create random bit
    assign rand_bit = par_out5[4] ^ par_out7[6];

endmodule
