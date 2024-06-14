import re

def prob_to_bipolar(x):
	return (2*x)-1

def prob_int_to_bipolar(x):
	return prob_to_bipolar(x/256)

def bipolar_to_prob(y):
	return (y+1)/2

def bipolar_to_prob_int(y):
	return int(bipolar_to_prob(y)*256)




# Test data
test_inputs = [184, 205, 19, 47, 138, 44, 137, 202, 48, 34, 248, 143, 223, 160, 166, 154, 86, 202, 175, 72, 184, 91, 202, 224, 166, 196, 4, 136, 143, 195, 63, 146, 131, 51, 200, 33, 19, 100, 28, 35, 228, 166, 165, 136, 44, 125, 76, 25, 176, 88, 56, 228, 204, 149, 149, 120, 253, 42, 240, 30, 48, 185, 55, 5, 177, 229, 159, 206, 160, 87, 129, 169, 187, 148, 142, 106, 166, 78, 218, 166, 212, 193, 15, 111, 6, 30, 68, 184, 78, 139, 59, 88, 16, 123, 92, 70, 13, 229, 25, 199, 156, 98, 198, 106, 153, 250, 179, 37, 106, 238, 50, 12, 27, 118, 179, 190, 255, 65, 97, 51, 252, 195, 15, 2, 210, 62, 88, 6, 102, 152, 209, 154, 117, 208, 150, 73, 6, 214, 15, 162, 237, 75, 159, 26, 37, 253, 78, 45, 210, 156, 159, 25, 54, 74, 50, 76, 36, 12, 117, 43, 8, 83, 136, 206, 48, 205, 214, 40, 173, 130, 151, 54, 197, 178, 41, 194, 178, 211, 106, 197, 223, 12, 194, 12, 96, 16, 93, 233, 46, 63, 159, 216, 31, 10, 28, 58]

test_weights = [65, 19, 188, 71, 161, 31, 88, 23, 2, 49, 112, 219, 133, 131, 60, 138, 87, 142, 14, 51, 85, 244, 42, 85, 219, 103, 214, 35, 144, 54, 170, 4, 136, 65, 31, 12, 196, 149, 76, 174, 104, 108, 10, 147, 201, 76, 93, 34, 145, 22, 165, 251, 143, 48, 202, 13, 50, 31, 253, 134, 123, 55, 52, 76, 202, 1, 42, 245, 62, 54, 94, 243, 58, 105, 12, 152, 151, 11, 224, 68, 85, 144, 185, 14, 87, 163, 121, 52, 26, 75, 71, 192, 34, 82, 109, 7, 69, 108, 198, 247, 156, 169, 250, 211, 253, 172, 102, 196, 9, 228, 198, 226, 206, 182, 63, 58, 65, 234, 221, 145, 214, 18, 120, 116, 203, 119, 205, 128, 183, 219, 58, 50, 93, 64, 214, 166, 34, 206, 146, 97, 209, 40, 253, 63, 5, 175, 205, 89, 228, 156, 62, 96, 35, 43, 79, 27, 130, 233, 40, 126, 198, 56, 195, 22, 30, 85, 137, 159, 207, 197, 152, 42, 85, 6, 205, 28, 35, 229, 117, 212, 111, 43, 217, 83, 176, 230, 66, 198, 120, 62, 84, 144, 45, 206, 254, 137]

# Set test data
x = test_inputs
w = test_weights
print(x)
print(w)

# Get bipolar values
x_bi = [prob_int_to_bipolar(i) for i in x]
w_bi = [prob_int_to_bipolar(i) for i in w]

print("x_bi = ", x_bi)
print("w_bi = ", w_bi)

# Multiply
mul = [x_bi[i]*w_bi[i] for i in range(len(x_bi))]
print("mul = ", mul)

def add_stoch(inps):
	return [ (inps[i*2]+inps[(i*2)+1])/2 for i in range(int(len(inps)/2)) ]

# Sum pairs and /2
add_1 = add_stoch(mul) 		# 98
add_2 = add_stoch(add_1)	# 49
add_3 = add_stoch(add_2)	# 24R1, last value of add_2 needs to be added
add_4 = add_stoch(add_3)
add_5 = add_stoch(add_4)
add_6 = add_stoch(add_5)
# Last stage, add remainder of add_3
add_7_1 = (add_6[0] + add_6[1])/2
add_7_2 = (add_6[2] + add_2[48])/2

print("add1 = ", len(add_1))
print("add2 = ", len(add_2))
print("add3 = ", len(add_3))

result = (add_7_1 + add_7_2)/2
print(f"Result: {result}, bipolar_int: {bipolar_to_prob_int(result)}")

# Compare to normal result to find adder error
result_normal = sum(mul)
print(f"Result normal: {result_normal}, error = {result_normal-result}")


# Read test file from Vivado
data_vivado = {"Test": [], "Result": []}

regexp = re.compile(r"Test:\s+(?P<test>\d+), Result:\s+(?P<num>\d+),")

# Read vivado simulation file
with open("C:\\Users\\Rory\\Documents\\HDL\\Stochastic_NN\\Stochastic_NN.sim\\sim_1\\behav\\xsim\\Macc196_test.txt", "r+") as f:
	for line in f:
		m = regexp.search(line)
		data_vivado["Test"].append(int(m.group('test')))
		result_num = int(m.group('num'))
		data_vivado["Result"].append(result_num)

result_vals = data_vivado["Result"]
print("\n---Vivado test file---")
print(f"Results: {result_vals}")
print(f"Average value = {sum(result_vals)/len(result_vals)}")
