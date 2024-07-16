import random 

for j in range(1):
	x = [random.randrange(0,65535) for i in range(8)]
	print("\t{", str(x)[1:-1], "},")
