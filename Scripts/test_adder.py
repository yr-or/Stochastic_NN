"""
Compare python and vivado simulations for adder
"""
import re
import matplotlib.pyplot as plt

def bipolar_to_prob(y):
    return (y+1)/2

def bipolar_to_prob_int(y):
    return int(bipolar_to_prob(y)*256)

def bipolar_to_prob_int10(y):
    return int(bipolar_to_prob(y)*4096)

def prob_to_bipolar(x):
    return (2*x)-1

def prob_int_to_bipolar(x):
    return prob_to_bipolar(x/256)

def prob_int16_to_bipolar(x):
    return prob_to_bipolar(x/65536)

def prob_int12_to_bipolar(x):
    return prob_to_bipolar(x/4096)

def prob_int16_to_unipolar(x):
    return x/65536



num1_test = [6707, 4547, 21507, 52747, 58388, 24024, 24080, 14340, 463, 55809, 57431, 56264, 62965, 63022, 58799, 6593, 56733, 12962, 60441, 38077, 33917, 23725, 21828, 55679, 21520, 46396, 1608, 14321, 9528, 4098, 3955, 8258, 36948, 4536, 18203, 10471, 33491, 39114, 34203, 50744, 58871, 50331, 7812, 48163, 40498, 58129, 24909, 13684, 53661, 28819, 47140, 16660, 28107, 33731, 52011, 17084, 35579, 165, 1063, 37955, 58836, 63441, 52402, 8621, 27491, 47750, 48508, 58655, 25145, 24823, 53037, 60595, 9085, 34636, 23074, 23200, 23691, 57834, 19071, 34554, 38532, 8470, 61710, 52259, 36395, 31932, 38660, 49947, 14518, 26543, 31494, 40946, 44932, 50374, 40923, 28653, 29466, 26604, 15271, 57491]
num2_test = [48197, 52809, 46153, 53181, 30344, 44375, 19577, 58117, 51965, 1006, 40024, 19777, 40103, 37134, 28280, 62459, 25824, 55110, 53283, 19982, 10968, 42015, 15442, 55946, 61614, 9624, 5232, 37032, 56369, 41630, 20419, 63967, 55064, 18021, 19292, 49609, 24559, 24073, 25922, 12261, 55413, 26512, 29232, 28693, 63454, 61145, 21803, 35070, 33520, 16132, 25601, 62060, 47915, 13712, 56349, 58171, 2199, 31316, 42811, 16235, 15276, 63902, 7760, 58414, 7600, 37774, 24494, 49347, 39515, 31949, 183, 5352, 13888, 45126, 38144, 806, 60741, 20224, 58788, 62648, 62455, 41599, 58412, 62628, 27128, 49844, 1758, 18001, 12172, 25147, 16041, 32539, 54833, 42323, 22207, 57862, 58554, 1420, 23693, 52916]

# Create expected output data float
pyt_res_float = []
for i in range(30):
     pyt_res_float.append( (prob_int16_to_bipolar(num1_test[i]) + prob_int16_to_bipolar(num2_test[i]))/2 )


regexp = re.compile(r"Test:\s+(?P<test>\d+), Result:\s+(?P<result>\d+)")

# Read vivado simulation file
viv_res_int16 = []
with open("C:\\Users\\Rory\\Documents\\HDL\\Stochastic_NN\\Stochastic_NN.sim\\sim_1\\behav\\xsim\\Adder_test.txt", "r+") as f:
	for line in f:
		m = regexp.search(line)
		viv_res_int16.append(int(m.group('result')))
        
# Convert vivado values to floats
print(viv_res_int16)
viv_res_float = [prob_int16_to_bipolar(x) for x in viv_res_int16]

print(viv_res_float)
print(pyt_res_float)


# Plot python data against vivado
plt.figure(1)
plt.scatter(pyt_res_float, viv_res_float)
plt.xlabel("Python data")
plt.ylabel("Vivado data")
plt.title("Adder result")
plt.grid(True)

# Plot vivado data against its inputs

plt.show()