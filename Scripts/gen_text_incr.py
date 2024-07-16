import re

def inc_int(str1):
    regexp = re.compile(r"\d+")
    str2 = regexp.sub(lambda s: str(int(s.group())+1), str1)
    return str2

text = r"""// Adder stage 4
    StochNumGen16 SNG_add4_sel(
        .clk                (clk),
        .reset              (reset),
        .seed               (16'd12538),
        .prob               (16'h8000),
        .stoch_num          (add4_sel_stoch)
    );"""


exps_to_inc = [r"stage \d", r"add\d"]
NUM_ITERS = 4

regexp = re.compile("|".join(exps_to_inc))

new_text = regexp.sub(lambda s: inc_int(s.group()), text)
print(new_text)

for i in range(NUM_ITERS-1):
    new_text = regexp.sub(lambda s: inc_int(s.group()), new_text)
    print(new_text)