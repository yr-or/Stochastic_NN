import re

def inc_int(str1):
    regexp = re.compile(r"\d+")
    str2 = regexp.sub(lambda s: str(int(s.group())+1), str1)
    return str2

text = r"""\"set_property -dict [list CONFIG.C_NUM_OF_PROBES {66} CONFIG.C_PROBE2_WIDTH {16}] [get_ips ila_0]\""""


exps_to_inc = [r"ila_\d"]
NUM_ITERS = 64

regexp = re.compile("|".join(exps_to_inc))

new_text = regexp.sub(lambda s: inc_int(s.group()), text)
print(new_text)

for i in range(NUM_ITERS-1):
    new_text = regexp.sub(lambda s: inc_int(s.group()), new_text)
    print(new_text)