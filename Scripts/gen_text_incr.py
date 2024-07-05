import re

def inc_int(str1):
    regexp = re.compile(r"\d+")
    str2 = regexp.sub(lambda s: str(int(s.group())+1), str1)
    return str2

text = r"""MAE_add1 = mean_absolute_error(add1_pyt_float, add1_viv_float)"""


exps_to_inc = [r"\d"]
NUM_ITERS = 7

regexp = re.compile("|".join(exps_to_inc))

new_text = regexp.sub(lambda s: inc_int(s.group()), text)
print(new_text)

for i in range(NUM_ITERS-1):
    new_text = regexp.sub(lambda s: inc_int(s.group()), new_text)
    print(new_text)