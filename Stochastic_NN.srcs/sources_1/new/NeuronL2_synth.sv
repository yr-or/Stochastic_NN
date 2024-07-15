

module NeuronL2_synth(
    input clk
    );

    localparam NUM_INPS = 196;

    // Generic conns
    wire reset;
    wire [3:0] digit_sel;


    logic [15:0] test_data_zero [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 43520, 62208, 55296, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33024, 43520, 64256, 62976, 59136, 46848, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47360, 65280, 58624, 64256, 46080, 59904, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 40704, 64000, 56064, 35584, 37376, 32768, 64768, 39680, 32768, 32768, 32768, 32768, 32768, 34816, 62720, 44800, 34304, 32768, 32768, 32768, 65280, 45312, 32768, 32768, 32768, 32768, 32768, 49408, 58624, 32768, 32768, 32768, 32768, 32768, 65280, 43776, 32768, 32768, 32768, 32768, 32768, 54272, 48128, 32768, 32768, 32768, 33024, 49664, 56320, 33280, 32768, 32768, 32768, 32768, 32768, 54528, 44544, 32768, 32768, 36352, 55296, 51712, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 54272, 61696, 49408, 57344, 62464, 49408, 34560, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 40960, 61184, 65280, 54016, 37376, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_one [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35072, 39168, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 50688, 50944, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 50688, 52992, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 50176, 57600, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44544, 58880, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44544, 62464, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 39168, 65280, 33792, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35328, 64512, 38912, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 57856, 33024, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 61440, 36864, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 45056, 33792, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_two [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35328, 47104, 49152, 49152, 41728, 35328, 33280, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 54528, 65280, 65280, 65280, 65280, 63232, 61952, 56576, 34560, 32768, 32768, 32768, 32768, 32768, 59648, 60928, 52992, 59648, 64000, 65280, 65280, 65280, 62720, 34816, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 36096, 40192, 49664, 62208, 65280, 43264, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33280, 60160, 63488, 36352, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 36096, 53760, 65024, 48128, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 43776, 60160, 64768, 48640, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 50944, 64000, 61184, 42240, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33024, 63744, 65280, 55552, 43776, 43264, 35072, 33024, 32768, 32768, 32768, 32768, 32768, 32768, 35328, 58368, 64512, 65280, 65280, 65280, 63488, 55296, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 37632, 41472, 49152, 44800, 35840, 36608, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_three [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 34048, 37632, 49152, 48896, 48896, 38656, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 39936, 60672, 64256, 65280, 65024, 65024, 62208, 35072, 32768, 32768, 32768, 32768, 32768, 32768, 36352, 50688, 45056, 41216, 43520, 64256, 62464, 34816, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44288, 64768, 54016, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33792, 43008, 45056, 58624, 65024, 59904, 40448, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 49920, 65280, 65280, 65280, 65280, 48896, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33792, 38400, 35584, 35584, 54016, 53760, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35328, 33024, 32768, 32768, 35840, 59392, 53760, 32768, 32768, 32768, 32768, 32768, 32768, 41472, 62976, 42752, 41472, 44288, 59648, 62976, 45312, 32768, 32768, 32768, 32768, 32768, 32768, 40960, 61952, 65024, 65024, 62464, 54272, 37888, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 36352, 48384, 41472, 33536, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_four [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 42752, 34048, 32768, 32768, 32768, 32768, 47104, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 54784, 35328, 32768, 32768, 32768, 32768, 58368, 32768, 32768, 32768, 32768, 32768, 32768, 39680, 59136, 32768, 32768, 32768, 32768, 38400, 60160, 32768, 32768, 32768, 32768, 32768, 32768, 47872, 52480, 32768, 32768, 32768, 32768, 43264, 55808, 32768, 32768, 32768, 32768, 33280, 41472, 63488, 43520, 32768, 32768, 32768, 32768, 43008, 60416, 46592, 49664, 55040, 57088, 56576, 47616, 65280, 34048, 32768, 32768, 32768, 32768, 32768, 42752, 44544, 44544, 37888, 32768, 32768, 41728, 61696, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44032, 53504, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44032, 56064, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44032, 59904, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35840, 46336, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_five [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 45056, 57088, 65280, 65280, 59136, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 43008, 63232, 57088, 50944, 47104, 40960, 32768, 32768, 32768, 32768, 32768, 32768, 49152, 45056, 34816, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 43008, 63232, 36864, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 45056, 65280, 59136, 47104, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 36864, 47104, 63232, 43008, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 34816, 59136, 45056, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 49152, 57088, 49152, 59136, 63232, 36864, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 61184, 61184, 59136, 49152, 36864, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_six [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 41728, 64256, 56832, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 43008, 65024, 54016, 60672, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 36608, 63232, 57600, 34560, 34048, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 54272, 63488, 37632, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 36864, 63744, 54784, 42240, 45312, 40192, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 46336, 65280, 60928, 62976, 58880, 64512, 39680, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47360, 65280, 62464, 38912, 36352, 65280, 44544, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47360, 62464, 43008, 33024, 53760, 63744, 35584, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 38912, 64512, 55808, 56320, 65280, 43520, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 41472, 57344, 57856, 48384, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_seven [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35328, 32768, 32768, 32768, 32768, 32768, 35840, 44544, 48384, 51456, 36864, 32768, 32768, 32768, 33024, 32768, 32768, 32768, 40192, 56064, 63232, 53760, 46336, 65280, 45568, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 41984, 48128, 36096, 35328, 60416, 56064, 33536, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35328, 60416, 57344, 34048, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35072, 59136, 56064, 34048, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33792, 57856, 59136, 34048, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 50688, 57856, 34816, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 43008, 38656, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_eight [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 34048, 43520, 46592, 40448, 33280, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 44544, 65280, 61184, 60416, 57600, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47360, 62464, 33536, 38144, 64000, 50176, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47360, 64768, 51712, 63488, 64256, 47104, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 48896, 65280, 65280, 51200, 33792, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 33792, 47616, 64256, 60160, 39680, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 34304, 57088, 65280, 62720, 53504, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 50688, 55808, 40704, 57856, 53504, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35840, 64000, 43008, 38144, 65024, 46592, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 37888, 64512, 62464, 64256, 57344, 33280, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 41728, 49152, 46848, 34816, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] test_data_nine [0:195] = '{ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 39168, 48896, 42496, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 37888, 53504, 60928, 52480, 65280, 39680, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 38656, 61696, 41472, 33024, 50176, 58624, 33024, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47616, 46080, 32768, 37120, 62720, 49408, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 47872, 62976, 56320, 59392, 65280, 37120, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 39168, 40704, 51968, 52736, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 37120, 60928, 35072, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 35072, 59392, 46080, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 51712, 50432, 33024, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 40448, 62976, 34304, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 37888, 40448, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 };
    logic [15:0] input_data_bin [0:195];

    // Weights
    reg [15:0] W_ARRAY_L2_N0 [0:NUM_INPS-1] = '{ 35072, 32512, 33792, 37120, 38656, 43776, 40448, 34560, 23296, 32768, 41216, 36096, 35072, 31232, 33280, 35328, 24832, 33792, 33024, 35584, 32512, 33792, 26880, 25856, 32000, 39936, 39168, 31744, 29696, 31232, 39680, 36096, 38144, 27648, 27904, 27904, 31232, 40704, 38144, 36864, 22272, 26112, 35584, 31744, 35584, 35584, 33792, 37376, 32768, 20480, 39936, 45312, 37120, 36864, 25344, 28672, 43264, 29440, 34816, 32256, 39424, 35584, 28160, 19968, 49408, 41216, 34816, 32768, 23296, 11008, 41728, 37120, 26368, 32000, 35584, 35584, 17920, 26368, 44800, 37632, 35072, 35072, 23552, 17664, 40960, 31232, 28672, 35584, 37888, 30720, 19456, 28928, 38400, 29440, 28928, 35072, 41216, 29184, 37120, 30720, 33024, 41984, 36096, 28672, 26624, 28416, 33792, 24576, 30976, 38144, 35584, 32512, 32256, 21248, 32512, 34816, 37376, 28672, 26112, 29952, 30208, 32000, 34560, 34560, 36608, 38144, 39936, 31232, 24576, 32768, 39424, 38400, 29696, 27392, 34560, 33280, 40704, 36608, 33536, 25088, 34560, 34304, 32000, 33280, 38144, 44288, 33024, 29696, 32000, 33024, 36864, 34560, 31744, 40704, 33792, 22016, 38400, 41216, 39424, 38144, 33280, 31488, 33024, 29440, 33792, 29184, 21760, 29440, 33280, 31744, 41728, 39680, 33024, 30208, 34816, 27136, 33280, 17408, 22016, 22016, 24832, 32256, 35072, 25600, 24576, 33280, 34816, 31744, 31232, 31488, 34560, 36352, 26624, 40704, 27648, 30976 };

    // Bias
    reg [15:0] B_L2_N0 = 15'd32768;

    // Combinational block to select digit
    always @(*) begin
        case (digit_sel)
            4'h0    :   input_data_bin = test_data_zero;
            4'h1    :   input_data_bin = test_data_one;
            4'h2    :   input_data_bin = test_data_two;
            4'h3    :   input_data_bin = test_data_three;
            4'h4    :   input_data_bin = test_data_four;
            4'h5    :   input_data_bin = test_data_five;
            4'h6    :   input_data_bin = test_data_six ;
            4'h7    :   input_data_bin = test_data_seven;
            4'h8    :   input_data_bin = test_data_eight;
            4'h9    :   input_data_bin = test_data_nine;
            default :   input_data_bin = test_data_zero;
        endcase
    end

    // Inputs to SNGs
    reg [15:0] LFSR_inps_seed = 15'd3784;
    reg [15:0] LFSR_wghts_seed = 15'd29384;
    reg [15:0] LFSR_bias_seed = 15'd37483;

    // SNGs -> Neuron
    wire input_data_stoch [0:NUM_INPS-1];
    wire weights_stoch [0:NUM_INPS-1];
    wire bias_stoch;

    // Neuron -> STBs
    wire macc_out_stoch;
    wire bias_out_stoch;

    // STB outputs
    wire [15:0] macc_out_bin;
    wire [15:0] bias_out_bin;
    wire done;


    ///////////////////// SNGs /////////////////////////////
    // SNGs for inputs
    genvar i;
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            StochNumGen16 SNG_inps(
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_inps_seed),
                .prob                   (input_data_bin[i]),
                .stoch_num              (input_data_stoch[i])
            );
        end
    endgenerate

    // SNGs for weights
    generate
        for (i=0; i<NUM_INPS; i=i+1) begin
            StochNumGen16 SNG_wghts(
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_wghts_seed),
                .prob                   (W_ARRAY_L2_N0[i]),
                .stoch_num              (weights_stoch[i])
            );
        end
    endgenerate

    // SNG for bias
    StochNumGen16 SNG_bias(
        .clk                    (clk),
        .reset                  (reset),
        .seed                   (LFSR_bias_seed),
        .prob                   (B_L2_N0),
        .stoch_num              (bias_stoch)
    );
    ///////////////////////////////////////////////////////////


    // Neuron_L2
    Neuron196_L2 neuron(
        .clk                    (clk),
        .reset                  (reset),
        .input_data             (input_data_stoch),
        .weights                (weights_stoch),
        .bias                   (bias_stoch),

        .macc_out               (macc_out_stoch),
        .bias_out               (bias_out_stoch)
    );



    // STBs
    StochToBin16 STB_macc (
        .clk                    (clk),
        .reset                  (reset),
        .enable                 (1'b1),
        .bit_stream             (macc_out_stoch),
        .bin_number             (macc_out_bin),
        .done                   (done)
    );
    StochToBin16 STB_bias (
        .clk                    (clk),
        .reset                  (reset),
        .enable                 (1'b1),
        .bit_stream             (bias_out_stoch),
        .bin_number             (bias_out_bin)
    );


    /////////////////////// VIO and ILA ///////////////////////
    vio_1 vio(
        .clk                    (clk),
        .probe_out0             (reset),
        .probe_out1             (digit_sel)
    );
    ila_1 ila(
        .clk                    (clk),
        .probe0                 (reset),
        .probe1                 (done),
        .probe2                 (macc_out_bin),
        .probe3                 (bias_out_bin)
    );



endmodule
