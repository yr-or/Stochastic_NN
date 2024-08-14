import random 

for j in range(1):
	x = [random.randrange(0,65535) for i in range(6)]
	print("\t{", str(x)[1:-1], "},")


arr = []
while True:
	val = random.randrange(0,16)
	if val not in arr:
		arr.append(val)
	if len(arr) == 16:
		for x in arr:
			print(f"shift_reg[{x}], ", end="")
		break
