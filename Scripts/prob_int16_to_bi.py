import sys

def prob_to_bipolar(x):
    return (2*x)-1

def prob_int16_to_bipolar(x):
    return prob_to_bipolar(x/65536)

args = sys.argv
if len(args) == 2:
	val_int = int(args[1])
	res = prob_int16_to_bipolar(val_int)
	print("Bipolar val:", res)
else:
	print("Wrong number of args")