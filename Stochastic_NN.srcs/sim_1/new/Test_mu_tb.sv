`timescale 1ns / 1ps

module Test_mu_tb();

    reg clk = 0;
    reg reset = 0;

    reg [15:0] test_data_num1 [0:99] = '{62304, 26811, 1712, 65034, 51975, 59168, 60247, 9421, 35430, 33138, 42687, 35101, 29988, 45388, 19520, 35819, 29822, 47092, 23249, 1230, 31663, 349, 19364, 30601, 51418, 28084, 33669, 57056, 33976, 35295, 19858, 12844, 36598, 52443, 27092, 64337, 14606, 19361, 56859, 5656, 17126, 44689, 48587, 59408, 21050, 8569, 59091, 42942, 1836, 31640, 47563, 23389, 30301, 16376, 36333, 50389, 9856, 55854, 26205, 12909, 40639, 26464, 57875, 29263, 25166, 22609, 14594, 17022, 20481, 21680, 38744, 51319, 11636, 58515, 6045, 13511, 40222, 37809, 18279, 17005, 3109, 57803, 36248, 65283, 27116, 57547, 46399, 6253, 7880, 25182, 40644, 18617, 41746, 42864, 34033, 30833, 20147, 3019, 46749, 61418};
    reg [15:0] test_data_num2 [0:99] = '{62499, 2267, 24782, 52510, 41881, 18988, 65375, 55186, 6987, 61889, 62720, 47020, 14333, 44455, 11210, 47934, 49257, 52027, 10969, 37453, 24881, 8387, 52999, 39493, 9709, 33591, 16336, 31757, 8100, 26954, 50586, 42970, 52868, 50710, 48812, 8001, 4552, 40733, 52838, 1220, 36097, 12513, 61776, 31216, 56560, 8500, 63934, 24437, 61548, 38043, 53169, 32777, 24221, 28784, 36078, 53278, 14463, 21366, 38364, 21975, 50564, 1495, 34951, 4355, 22192, 2754, 38655, 43539, 64336, 17778, 18239, 32978, 18962, 5101, 49493, 12993, 14743, 38218, 55034, 11872, 33066, 13251, 10052, 17965, 24388, 53545, 34640, 50768, 12195, 51590, 51927, 56765, 31594, 46137, 56639, 617, 41276, 57683, 31685, 42786};
    reg [15:0] num1_bin;
    reg [15:0] num2_bin;

    logic [7:0] test_mul_res_256 [0:99];
    logic [8:0] test_mul_res_512 [0:99];
    logic [9:0] test_mul_res_1024 [0:99];
    logic [10:0] test_mul_res_2048 [0:99];
    logic [11:0] test_mul_res_4096 [0:99];

    logic [7:0] mul_res_256bit;
    logic [8:0] mul_res_512bit;
    logic [9:0] mul_res_1024bit;
    logic [10:0] mul_res_2048bit;
    logic [11:0] mul_res_4096bit;

    // DUT
    Test_mu test_mu(
        .clk                (clk),
        .reset              (reset),
        .num1_bin           (num1_bin),
        .num2_bin           (num2_bin),

        .mul_res_256bit     (mul_res_256bit),
        .mul_res_512bit     (mul_res_512bit),
        .mul_res_1024bit    (mul_res_1024bit),
        .mul_res_2048bit    (mul_res_2048bit),
        .mul_res_4096bit    (mul_res_4096bit)
    );

    integer i;
    initial begin
        reset = 1;
        # 30;
        reset = 0;

        // Set inputs
        for (i=0; i<100; i=i+1) begin
            num1_bin = test_data_num1[i];
            num2_bin = test_data_num2[i];
            // Wait 4096 clk cycles
            #81920;
        end
    end

    // 256-bit STB
    initial begin
        #30;
        for (int j=0; j<100; j=j+1) begin
            #5120;
            test_mul_res_256[j] = mul_res_256bit;
        end
    end
    // 512-bit STB
    initial begin
        #30;
        for (int j=0; j<100; j=j+1) begin
            #10240;
            test_mul_res_512[j] = mul_res_512bit;
        end
    end
    // 1024-bit STB
    initial begin
        #30;
        for (int j=0; j<100; j=j+1) begin
            #20480;
            test_mul_res_1024[j] = mul_res_1024bit;
        end
    end
    // 2048-bit STB
    initial begin
        #30;
        for (int j=0; j<100; j=j+1) begin
            #40960;
            test_mul_res_2048[j] = mul_res_2048bit;
        end
    end
    // 4096-bit STB
    initial begin
        #30;
        for (int j=0; j<100; j=j+1) begin
            #81920;
            test_mul_res_4096[j] = mul_res_4096bit;
        end
    end

    always begin
        #10;
        clk = ~clk;
    end

endmodule
