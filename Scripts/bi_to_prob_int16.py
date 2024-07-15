import sys

def bipolar_to_prob(y):
    return (y+1)/2

def bipolar_to_prob_int16(y):
    return int(bipolar_to_prob(y)*65536)

args = sys.argv
if len(args) == 2:
	val_float = float(args[1])
	res = bipolar_to_prob_int16(val_float)
	print("Decimal:", res)
	print("Hex:\t", hex(res))
else:
	print("Wrong number of args")