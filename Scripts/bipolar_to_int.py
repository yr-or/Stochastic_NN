import sys

def prob_to_bipolar(x):
	return (2*x)-1

def prob_int_to_bipolar(x):
	return prob_to_bipolar(x/256)

def bipolar_to_prob(y):
	return (y+1)/2

def bipolar_to_prob_int(y):
	return int(bipolar_to_prob(y)*256)

args = sys.argv
if len(args) == 2:
	val_bi = float(args[1])
	print(bipolar_to_prob_int(val_bi))
else:
	print("Wrong number of args")