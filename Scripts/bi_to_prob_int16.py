import sys

def bipolar_to_prob(y):
    return (y+1)/2

def bipolar_to_prob_int16(y):
    return int(bipolar_to_prob(y)*65536)

args = sys.argv
if len(args) == 2:
	val_int = int(args[1])
	print(bipolar_to_prob_int16(val_int))
else:
	print("Wrong number of args")