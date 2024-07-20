import numpy as np
import matplotlib.pyplot as plt

def prob_to_bipolar(x):
    return (2*x)-1


def prob_int_to_bipolar(x):
    return prob_to_bipolar(x/256)

def bipolar_to_prob(y):
    return (y+1)/2

def bipolar_to_prob_int(y):
    return int(bipolar_to_prob(y)*256)

def unipolar_to_int(x):
    return int(x*256)

def int_to_unipolar(x):
    return x/256

def signed_int_to_bi_prob(x):
    return prob_int_to_bipolar(x+128)

def signed_int_arr_to_bi_prob(x_arr):
    arr = [signed_int_to_bi_prob(x) for x in x_arr]
    return arr

def prob_int12_to_bipolar(x):
    return prob_to_bipolar(x/4096)

def prob_int16_to_unipolar(x):
    return x/16384

def prob_int16_to_bipolar(x):
    return prob_to_bipolar(x/65536)

def bipolar_to_prob_int16(y):
    return int(bipolar_to_prob(y)*65536)



# Layer 2 Bias values from colab notebook
B_ARRAY_L2 = [ 11, 1, 0, 9, 13, 12, -2, 1, 3, 19, -7, 12, 4, 17, 29, 37, -5, 20, -5, 15, 16, 11, 13, 20, 6, 26, -19, -7, 45, -4, -16, 5 ]

# Layer 3 weights
W_ARRAY_L3 = (
    [ 27, -12, -32, -5, -36, -7, 2, -11, -13, -35, 30, 3, -40, -30, 8, -32, -17, 40, 23, 7, -62, -35, 19, 28, -12, 24, 18, 0, -31, 5, 26, 23 ],
    [ 74, 80, 37, -4, -36, -36, 34, -22, -13, 63, -32, -42, 44, -31, -3, 14, -36, 7, 10, 28, 27, 27, 10, 19, -43, -61, 4, 8, -18, 20, -50, -47 ],
    [ -26, -14, 4, 83, 12, -19, -22, 15, 20, 22, 22, -10, -7, -43, -113, 11, 33, 2, -18, -36, 31, 29, 29, 4, 60, -25, 40, 1, 0, 23, -21, 19 ],
    [ -29, 0, -8, -2, 19, -9, 23, -18, 3, 3, 6, 9, 22, 29, -29, -17, 25, -15, 31, -29, 17, 28, -18, -70, -15, -25, 30, 55, 4, -28, 24, -31 ],
    [ 32, -106, -82, -17, -25, -34, -34, 42, 5, -11, -57, 18, 42, 37, -29, 23, 24, -40, -35, 17, 23, -41, -5, 24, -33, 5, -100, -56, 36, -66, -51, 39 ],
    [ -44, 61, 44, -11, -75, 16, -11, -37, -28, -47, -32, 16, -18, 4, 60, 5, 6, 32, -63, -14, 3, -20, 9, -74, 32, 17, -49, 21, 39, -22, -16, -43 ],
    [ 19, -19, 26, 6, 49, -30, 4, -26, 18, 18, -66, 31, -54, -32, 5, 9, -101, -34, 34, 9, 12, -96, -8, 15, -30, 30, -64, -11, -106, 29, -22, -5 ],
    [ 36, -38, -33, 8, 36, -4, -66, -21, -18, 83, 36, -25, -17, 0, 17, -29, 12, 30, 1, 30, 14, 16, -26, 22, 30, -34, -13, -39, 30, 8, 21, -7 ],
    [ -58, -75, -20, -73, -48, 36, 14, 13, 13, -44, -26, 13, -4, 8, -4, 18, 25, -67, -53, 26, -18, -11, 26, 1, -3, 6, 2, -46, -58, 25, 18, -48 ],
    [ -23, 0, -28, -88, 13, 4, 1, 26, -50, -85, 24, 10, -52, 14, 17, 24, -15, 7, -1, 5, -97, 30, 7, 26, -127, -15, 14, -20, 33, -98, 8, 36 ]
)

# Layer 3 biases
B_ARRAY_L3 = [ -16, 2, 2, -19, 11, 14, -3, -10, 8, 4 ]



######################## Debug Vars ###############################
###################################################################
USE_STOCH_ADD = 1
USE_SCALED_ADD = 0
USE_RELU = 1
###################################################################



######################## Neurons ###################################
###################################################################
## Stochastic Neuron Functions ##
def sigmoid(x):
    # Scale value by 256
    y = 1 / (1 + np.exp(-4*x))
    # Scale back to integer
    return y

def relu(x):
    if x > 0:
        return x
    else:
        return 0

# Accumulate
def add_stoch(inps):
    return [ (inps[i*2]+inps[(i*2)+1])/2 for i in range(int(len(inps)/2)) ]


def Neuron_L3(inputs, weights, bias):
    """
    Inputs: float values representing stoch probs.
    Outputs: float values repr. stoch. prob.
    """

    # Multiply
    mul = [inputs[i]*weights[i] for i in range(len(inputs))]
    
    # Accumulate
    if USE_STOCH_ADD:
        # Sum pairs and /2, total = /32
        add_1 = add_stoch(mul)      # 16
        add_2 = add_stoch(add_1)    # 8
        add_3 = add_stoch(add_2)    # 4
        add_4 = add_stoch(add_3)    # 2
        macc_out = (add_4[0] + add_4[1])/2
    
        # Add bias
        bias_out = (macc_out + (bias/8192) )/2
    elif USE_SCALED_ADD:
        macc_out = sum(mul)/32
        bias_out = (macc_out + (bias/8192) ) / 2
    else:
        macc_out = sum(mul)
        bias_out = macc_out + bias

    if USE_RELU:
        neur_out = relu(bias_out)
    else:
        neur_out = sigmoid(bias_out)

    neur_out = bias_out

    return (macc_out, bias_out, neur_out)


######################## Neural Network ###########################
###################################################################


L2_bias_out_viv_int16 = [32786, 32667, 32735, 32767, 32833, 32835, 32932, 32845, 32992, 32607, 32839, 32841, 32767, 32792, 32994, 32795, 32886, 32663, 32620, 32810, 32779, 32888, 32743, 32619, 32790, 32814, 32972, 32733, 32789, 32823, 32801, 32721]

# results from another trial with changed RTL
L2_bias_out_viv_int16_trial2 = [32758, 32661, 32695, 32729, 32830, 32832, 32915, 32821, 32928, 32541, 32793, 32814, 32728, 32819, 32940, 32852, 32817, 32638, 32721, 32862, 32777, 32850, 32820, 32620, 32842, 32803, 32940, 32737, 32762, 32778, 32807, 32732]

# trial 3 - ILA
L2_macc_out_3 = [33878, 33239, 38417, 37084, 37789, 36364, 34935, 36080, 36890, 34382, 39444, 31901, 30958, 33651, 34048, 32870, 36157, 34919, 40231, 26182, 35548, 35212, 32498, 24153, 33773, 38554, 38524, 44816, 34888, 35502, 36389, 33934]

# Convert to floats
L2_bias_out_viv_float = [prob_int16_to_bipolar(x) for x in L2_bias_out_viv_int16]
L2_bias_out_viv_float_trial2 = [prob_int16_to_bipolar(x) for x in L2_bias_out_viv_int16_trial2]

#print(L2_bias_out_viv_float)

# Apply relu
L2_relu_out = [relu(x) for x in L2_bias_out_viv_float]
L2_relu_out_trial2 = [relu(x) for x in L2_bias_out_viv_float_trial2]


fpga_relu_out_trial1 = [0.00054931640625, 0, 0, 0, 0.001983642578125, 0.002044677734375, 0.0050048828125, 0.002349853515625, 0.0068359375, 0, 0.002166748046875, 0.002227783203125, 0, 0.000732421875, 0.00689697265625, 0.000823974609375, 0.00360107421875, 0, 0, 0.00128173828125, 0.000335693359375, 0.003662109375, 0, 0, 0.00067138671875, 0.00140380859375, 0.0062255859375, 0, 0.000640869140625, 0.001678466796875, 0.001007080078125, 0]

# Select test data here
fpga_relu_out = L2_relu_out
print(fpga_relu_out)

pyt_relu_out =  [4.947185516357422e-05, 0, 0, 0, 0.0019184350967407227, 0.0025833845138549805, 0.004719853401184082, 0.0016952753067016602, 0.005514621734619141, 0, 0.0013564825057983398, 0.0011587142944335938, 0, 0.0020524263381958008, 0.0064629316329956055, 0.0034962892532348633, 0.0017713308334350586, 0, 0, 0.002988457679748535, 0.0005317926406860352, 0.0028287172317504883, 0.0019246339797973633, 0, 0.001986384391784668, 0.0010368824005126953, 0.0059413909912109375, 0, 0, 0, 0.002078413963317871, 0]

x_vals = [i for i in range(len(fpga_relu_out))]
plt.bar(x_vals, pyt_relu_out, label="Python values")
plt.scatter(x_vals, fpga_relu_out, label="FPGA values")
plt.title("Simulated vs. expected output values of Layer2")
plt.legend()
plt.xlabel("Neuron")
plt.ylabel("Value (real)")
plt.show()

### MODIFY THIS TO CHANGE TEST ###
test_data_float = fpga_relu_out


NUM_NEUR_L2 = 32
NUM_NEUR_L3 = 10
NUM_INP_L2 = 196
NUM_INP_L3 = 32


## Convert weights and biases to floats
B_ARRAY_L3_float = signed_int_arr_to_bi_prob(B_ARRAY_L3)
W_ARRAY_L3_float = [signed_int_arr_to_bi_prob(w_arr) for w_arr in W_ARRAY_L3]



#### Calculate layer3 outputs ###
L3_results = []
L3_macc_out = []
L3_bias_out = []

for i in range(NUM_NEUR_L3):
    result = Neuron_L3(test_data_float, W_ARRAY_L3_float[i], B_ARRAY_L3_float[i])

    L3_macc_out.append(result[0])
    L3_bias_out.append(result[1])
    L3_results.append(result[2])
    
#### Get Max Index ####
max_index = L3_results.index(max(L3_results))

print(max_index)



############# DEBUG TESTS ##############
########################################














