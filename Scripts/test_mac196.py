import re
import matplotlib.pyplot as plt
import numpy as np

def bipolar_to_prob(y):
    return (y+1)/2

def prob_to_bipolar(x):
    return (2*x)-1

def bipolar_to_prob_int8(y):
    return int(bipolar_to_prob(y)*256)

def prob_int8_to_bipolar(x):
    return prob_to_bipolar(x/256)

def bipolar_to_prob_int16(y):
    return int(bipolar_to_prob(y)*65536)

def prob_int16_to_bipolar(x):
    return prob_to_bipolar(x/65536)

def prob_int16_to_unipolar(x):
    return x/65536



# Test data
test_inputs = [59515, 31128, 8548, 34814, 61633, 14650, 64936, 51980, 32088, 23611, 23680, 24313, 64751, 18374, 64626, 14668, 51708, 27976, 49513, 31126, 41181, 20890, 29148, 22957, 16825, 17732, 18344, 56667, 3050, 61664, 9407, 32876, 25881, 406, 50196, 53347, 44660, 52504, 15807, 61648, 31807, 45253, 148, 54800, 29782, 51418, 20423, 63867, 24468, 50360, 62976, 6943, 22109, 23804, 50049, 14525, 52506, 44163, 58966, 58079, 32206, 19649, 53951, 18782, 20237, 56134, 31871, 54746, 46385, 48314, 5580, 52057, 55472, 13286, 31517, 11490, 7624, 58271, 3806, 36172, 20068, 43934, 46255, 9652, 53548, 65343, 50007, 52365, 48693, 30741, 13814, 59189, 16257, 29561, 31560, 35384, 3889, 20401, 42976, 2537, 64958, 34691, 5501, 59066, 37999, 61945, 38791, 60705, 1781, 2291, 62318, 22025, 58049, 63456, 8069, 62182, 51652, 58257, 33478, 62158, 16689, 23740, 20036, 5003, 8104, 43923, 3681, 24988, 34726, 62561, 6889, 48333, 20090, 12613, 54109, 55823, 22780, 6863, 55456, 46549, 33537, 45063, 3169, 5545, 7890, 61168, 20231, 48828, 20654, 7356, 26520, 14187, 32535, 31732, 30124, 9943, 5179, 10938, 15237, 45288, 55386, 32326, 36931, 8411, 51735, 11281, 36151, 17660, 24974, 58110, 49287, 32634, 12267, 4160, 58354, 19773, 44279, 35388, 40160, 34391, 49639, 13463, 49248, 32644, 13204, 57487, 23845, 25618, 4087, 274, 34243, 15302, 23851, 45613, 29916, 31099]
test_weights = [22579, 55996, 65178, 52645, 15405, 45988, 31397, 32579, 63674, 27088, 15268, 64213, 18289, 56015, 38928, 7484, 45454, 45673, 18203, 25351, 25587, 14279, 60876, 26690, 35646, 8347, 59600, 57946, 39831, 61489, 33300, 23032, 15764, 59522, 41830, 40801, 56954, 1709, 44006, 32395, 25698, 30567, 20623, 8462, 41657, 27721, 59416, 36165, 10265, 2221, 60376, 53477, 44133, 51598, 8481, 44603, 15684, 171, 37971, 23355, 10642, 20824, 32404, 19401, 11115, 14977, 52221, 34168, 12823, 51260, 30489, 58796, 56481, 42314, 2371, 41874, 19382, 61376, 13592, 24876, 60805, 45436, 36024, 5986, 41631, 51704, 21305, 51708, 19335, 17425, 59894, 53442, 4441, 18411, 49397, 10749, 5340, 50424, 32937, 24968, 22983, 63818, 12816, 47003, 32124, 9153, 24462, 62113, 13575, 55519, 64607, 44395, 32984, 52373, 19803, 23554, 51036, 57465, 593, 24236, 62994, 41703, 18788, 9167, 23118, 55030, 33812, 57382, 51338, 47755, 42018, 3657, 33158, 25557, 15257, 38799, 55889, 46289, 55349, 17991, 52664, 28043, 58973, 52253, 45612, 25130, 61708, 55499, 5929, 18640, 16734, 4003, 37429, 746, 47356, 44142, 33341, 21718, 1265, 5538, 13272, 43250, 12612, 30171, 32964, 56153, 32526, 54296, 49106, 15009, 7028, 60778, 34584, 26863, 62072, 50556, 34003, 45239, 31501, 53983, 55335, 39423, 61848, 53184, 17957, 31471, 17794, 59416, 13931, 18707, 32573, 10804, 20451, 61325, 62147, 3311]

# Set test data
x = test_inputs
w = test_weights
print(x)
print(w)

# Get bipolar values
x_bi = [prob_int16_to_bipolar(i) for i in x]
w_bi = [prob_int16_to_bipolar(i) for i in w]

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
add_7_2 = (add_6[2] + add_2[48]/16)/2
add_7 = [add_7_1, add_7_2]

print("add1 = ", len(add_1))
print("add2 = ", len(add_2))
print("add3 = ", len(add_3))

result = (add_7_1 + add_7_2)/2
print(f"Result: {result}, bipolar_int: {bipolar_to_prob_int16(result)}")

# Compare to normal result to find adder error
result_normal = sum(mul)
print(f"Result normal: {result_normal}, error = {result_normal-result}")


# Vivado sim results - 16-bit - BEFORE RTL CHANGE
add1_viv_int16 = [28025, 21408, 21467, 32044, 33227, 31136, 20590, 42753, 35486, 29231, 35191, 32117, 37673, 36044, 42230, 32561, 21345, 37695, 27811, 29690, 32452, 30634, 30927, 29354, 27418, 37332, 28342, 23061, 21946, 31211, 35344, 35495, 30570, 32968, 33017, 41377, 38141, 30388, 49036, 40843, 29491, 42889, 44989, 35411, 29977, 33263, 40605, 31581, 41530, 36391, 28875, 46777, 22204, 44515, 31254, 45218, 42030, 33519, 47631, 28586, 24112, 45480, 40199, 29381, 40132, 22204, 34915, 29193, 23900, 37472, 32113, 12838, 24577, 32796, 43205, 42453, 33261, 28220, 36207, 35992, 25971, 32453, 25169, 27789, 23956, 26222, 34775, 40693, 33486, 33152, 36622, 40043, 36706, 31893, 47981, 38621, 40035, 32248]
add2_viv_int16 = [24717, 26751, 32179, 31671, 32355, 33653, 36855, 37400, 29517, 28754, 31538, 30141, 32378, 25700, 26583, 35424, 31772, 37197, 34263, 44940, 36190, 40198, 31619, 36097, 38964, 37826, 33358, 38239, 37771, 38105, 34791, 34787, 31170, 32048, 30693, 22473, 28692, 42833, 30741, 36103, 29216, 26480, 25094, 37731, 33322, 38335, 34294, 43301, 36145]
add3_viv_int16 = [25733, 31930, 33003, 37121, 29131, 30839, 29036, 31008, 34492, 39599, 38199, 33857, 38401, 35796, 37939, 34790, 31607, 26583, 35763, 33421, 27852, 31416, 35827, 38791]
add4_viv_int16 = [28839, 35065, 29985, 30020, 37040, 36017, 37097, 36369, 29090, 34598, 29624, 37307]
add5_viv_int16 = [31961, 29986, 36545, 36728, 31836, 33469]
add6_viv_int16 = [30977, 36633, 32646]
add7_viv_int16 = [33801, 34396]
macc_out_viv_int16 = 34094

# Vivado sim results - 16-bit - AFTER RTL CHANGE
add1_viv_int16  = [28025, 21408, 21467, 32044, 33227, 31136, 20590, 42753, 35486, 29231, 35191, 32117, 37673, 36044, 42230, 32561, 21345, 37695, 27811, 29690, 32452, 30634, 30927, 29354, 27418, 37332, 28342, 23061, 21946, 31211, 35344, 35495, 30570, 32968, 33017, 41377, 38141, 30388, 49036, 40843, 29491, 42889, 44989, 35411, 29977, 33263, 40605, 31581, 41530, 36391, 28875, 46777, 22204, 44515, 31254, 45218, 42030, 33519, 47631, 28586, 24112, 45480, 40199, 29381, 40132, 22204, 34915, 29193, 23900, 37472, 32113, 12838, 24577, 32796, 43205, 42453, 33261, 28220, 36207, 35992, 25971, 32453, 25169, 27789, 23956, 26222, 34775, 40693, 33486, 33152, 36622, 40043, 36706, 31893, 47981, 38621, 40035, 32248 ]
add2_viv_int16  = [24717, 26751, 32179, 31671, 32355, 33653, 36855, 37400, 29517, 28754, 31538, 30141, 32378, 25700, 26583, 35424, 31772, 37197, 34263, 44940, 36190, 40198, 31619, 36097, 38964, 37826, 33358, 38239, 37771, 38105, 34791, 34787, 31170, 32048, 30693, 22473, 28692, 42833, 30741, 36103, 29216, 26480, 25094, 37731, 33322, 38335, 34294, 43301, 36145 ]
add3_viv_int16  = [25733, 31930, 33003, 37121, 29131, 30839, 29036, 31008, 34492, 39599, 38199, 33857, 38401, 35796, 37939, 34790, 31607, 26583, 35763, 33421, 27852, 31416, 35827, 38791 ]
add4_viv_int16  = [28839, 35065, 29985, 30020, 37040, 36017, 37097, 36369, 29090, 34598, 29624, 37307 ]
add5_viv_int16  = [31961, 29986, 36545, 36728, 31836, 33469 ]
add6_viv_int16  = [30977, 36633, 32646 ]
add7_viv_int16  = [33801, 32800 ]
macc_out_viv_int16 =  33283



# Convert vivado values to floats
add1_viv_float = [prob_int16_to_bipolar(x) for x in add1_viv_int16]
add2_viv_float = [prob_int16_to_bipolar(x) for x in add2_viv_int16]
add3_viv_float = [prob_int16_to_bipolar(x) for x in add3_viv_int16]
add4_viv_float = [prob_int16_to_bipolar(x) for x in add4_viv_int16]
add5_viv_float = [prob_int16_to_bipolar(x) for x in add5_viv_int16]
add6_viv_float = [prob_int16_to_bipolar(x) for x in add6_viv_int16]
add7_viv_float = [prob_int16_to_bipolar(x) for x in add7_viv_int16]


# Convert outputs to floats
macc_out_viv_float = prob_int16_to_bipolar(macc_out_viv_int16)





####### Plot and compare outputs ########
plt.figure(1)
## Add1
assert(len(add_1) == len(add1_viv_float))
x_values = [i for i in range(len(add_1))]
plt.subplot(3,3,1)
plt.title("adder stage 1 output")
plt.bar(x_values, add_1, label="python values")
plt.scatter(x_values, add1_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add2
assert(len(add_2) == len(add2_viv_float))
x_values = [i for i in range(len(add_2))]
plt.subplot(3,3,2)
plt.title("adder stage 2 output")
plt.bar(x_values, add_2, label="python values")
plt.scatter(x_values, add2_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add3
assert(len(add_3) == len(add3_viv_float))
x_values = [i for i in range(len(add_3))]
plt.subplot(3,3,3)
plt.title("adder stage 3 output")
plt.bar(x_values, add_3, label="python values")
plt.scatter(x_values, add3_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add4
assert(len(add_4) == len(add4_viv_float))
x_values = [i for i in range(len(add_4))]
plt.subplot(3,3,4)
plt.title("adder stage 4 output")
plt.bar(x_values, add_4, label="python values")
plt.scatter(x_values, add4_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add5
assert(len(add_5) == len(add5_viv_float))
x_values = [i for i in range(len(add_5))]
plt.subplot(3,3,5)
plt.title("adder stage 5 output")
plt.bar(x_values, add_5, label="python values")
plt.scatter(x_values, add5_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add6
assert(len(add_6) == len(add6_viv_float))
x_values = [i for i in range(len(add_6))]
plt.subplot(3,3,6)
plt.title("adder stage 6 output")
plt.bar(x_values, add_6, label="python values")
plt.scatter(x_values, add6_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add7
assert(len(add_7) == len(add7_viv_float))
x_values = [i for i in range(len(add_7))]
plt.subplot(3,3,7)
plt.title("adder stage 7 output")
plt.bar(x_values, add_7, label="python values")
plt.scatter(x_values, add7_viv_float, label="vivado values")
plt.legend()
plt.grid()

plt.show()