import random 

for j in range(1):
	x = [random.randrange(0,256) for i in range(30)]
	print("\t{", str(x)[1:-1], "},")
