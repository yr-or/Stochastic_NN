import re

def inc_int(str1):
    regexp = re.compile(r"\d+")
    str2 = regexp.sub(lambda s: str(int(s.group())+1), str1)
    return str2

text = r"""// Adders stage 5 - 6 MUXes
    reg [7:0] LFSR_add4_seed = 8'99;
    generate
        for (i=0; i<NUM_ADDS_4; i=i+1) begin
            Adder add (
                .clk                    (clk),
                .reset                  (reset),
                .seed                   (LFSR_add4_seed),
                .stoch_num1             (add4_res[i*2]),
                .stoch_num2             (add4_res[(i*2)+1]),
                .result_stoch           (add5_res[i])
            );
        end
    endgenerate"""


exps_to_inc = [r"LFSR_add\d_seed", r"stage \d", r"NUM_ADDS_\d", r"add\d_res"]
NUM_ITERS = 5

regexp = re.compile("|".join(exps_to_inc))

new_text = regexp.sub(lambda s: inc_int(s.group()), text)
print(new_text)

for i in range(NUM_ITERS-1):
    new_text = regexp.sub(lambda s: inc_int(s.group()), new_text)
    print("\n", new_text)