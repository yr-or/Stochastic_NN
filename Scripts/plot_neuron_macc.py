import matplotlib.pyplot as plt
from sklearn.metrics import mean_absolute_error
import numpy as np

def bipolar_to_prob(y):
    return (y+1)/2

def bipolar_to_prob_int(y):
    return int(bipolar_to_prob(y)*256)

def prob_to_bipolar(x):
    return (2*x)-1

def prob_int_to_bipolar(x):
    return prob_to_bipolar(x/256)

def prob_int16_to_bipolar(x):
    return prob_to_bipolar(x/65536)



# Vivado results - 8-bit
add1_viv_int = [127,127,125,125,128,126,127,127,127,126,127,126,128,127,126,125,127,128,125,128,129,127,126,128,102,160,133,126,127,126,125,94,128,126,129,128,127,126,104,158,134,127,126,126,127,109,126,130,126,126,127,124,110,130,128,126,127,124,125,109,128,126,129,126,124,137,113,126,127,129,126,132,126,123,127,126,128,126,145,150,127,126,126,126,128,131,126,132,128,127,126,128,126,127,128,126,128,126]
add2_viv_int = [126,127,129,126,127,128,129,125,128,126,130,126,134,129,130,109,127,131,126,132,127,126,115,131,128,128,121,125,128,115,128,128,134,120,129,127,125,127,125,147,125,124,130,133,125,129,129,127,127]
add3_viv_int = [126,128,128,128,126,129,132,118,129,130,126,121,127,122,120,129,129,128,128,135,126,132,126,127]
add4_viv_int = [126,129,126,126,127,128,126,128,129,130,130,127]
add5_viv_int = [128,126,124,129,133,130]
add6_viv_int = [130,123,127]
add7_viv_int = [126,136]

# Vivado results - 16-bit - BEFORE LFSR FIX
"""
add1_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 31873, 33373, 32809, 32767, 32767, 32767, 32767, 26671, 41167, 34415, 32767, 32767, 32767, 32767, 25943, 33657, 33743, 32767, 32767, 32767, 32767, 26335, 38525, 34379, 32767, 32767, 32767, 32767, 27585, 34627, 32707, 32767, 32767, 32767, 31891, 27997, 32875, 32767, 32767, 32767, 32815, 32443, 28835, 32767, 32767, 32767, 32767, 32767, 35791, 29891, 32767, 32767, 32767, 32767, 32975, 34553, 32245, 32767, 32767, 32767, 32767, 37299, 38367, 32949, 32767, 32767, 32767, 32767, 33711, 32283, 32831, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767]
add2_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32323, 33093, 32767, 32767, 33917, 33591, 32767, 29355, 33697, 32767, 32767, 32431, 33571, 32767, 30175, 33665, 32767, 32327, 30435, 32767, 32791, 30639, 32767, 32767, 34279, 31329, 32767, 32869, 33399, 32767, 32767, 37837, 32859, 32767, 33241, 32557, 32767, 32767, 32767, 32767, 32767]
add3_viv_int16 = [32767, 32767, 32767, 32767, 32713, 32767, 33755, 31061, 33233, 32599, 33169, 31921, 32547, 31601, 31713, 32767, 32803, 32819, 33081, 35301, 32811, 32899, 32767, 32767]
add4_viv_int16 = [32767, 32767, 32741, 32409, 32913, 32547, 32073, 32243, 32811, 34191, 32855, 32767]
add5_viv_int16 = [32767, 32579, 32727, 32157, 33505, 32813]
add6_viv_int16 = [32699,32163,33403]
add7_viv_int16 = [32441, 33075]
macc_out_viv_int16 = 32763
bias_out_viv_int16 = 32764
neur_out_viv_int16 = 32618
"""

# Vivado sim results - 16-bit - AFTER LFSR CHANGE
add1_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 31875, 33373, 32809, 32767, 32767, 32767, 32767, 26671, 41167, 34417, 32767, 32767, 32767, 32767, 25941, 33657, 33743, 32767, 32767, 32767, 32767, 26337, 38525, 34379, 32767, 32767, 32767, 32767, 27587, 34625, 32707, 32767, 32767, 32767, 31891, 27995, 32875, 32767, 32767, 32767, 32815, 32445, 28833, 32767, 32767, 32767, 32767, 32767, 35789, 29889, 32767, 32767, 32767, 32767, 32975, 34551, 32245, 32767, 32767, 32767, 32767, 37299, 38365, 32949, 32767, 32767, 32767, 32767, 33713, 32281, 32831, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767]
add2_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32389, 33107, 32767, 32767, 33919, 33521, 32767, 29409, 33693, 32767, 32767, 32355, 33507, 32767, 30083, 33611, 32767, 32331, 30379, 32767, 32791, 30649, 32767, 32767, 34225, 31373, 32767, 32865, 33333, 32767, 32767, 37783, 32859, 32767, 33175, 32497, 32767, 32767, 32767, 32767, 32767]
add3_viv_int16 = [32767, 32767, 32767, 32767, 32747, 32767, 33721, 31087, 33231, 32559, 33139, 31849, 32547, 31573, 31721, 32767, 32799, 32815, 33051, 35271, 32813, 32835, 32767, 32767]
add4_viv_int16 = [32767, 32767, 32749, 32407, 32899, 32487, 32063, 32249, 32809, 34159, 32825, 32767]
add5_viv_int16 = [32767, 32511, 32691, 32119, 33471, 32797]
add6_viv_int16 = [32653,32417,33157]
add7_viv_int16 = [32537, 32965]
macc_out_viv_int16 = 32745
bias_out_viv_int16 = 32711
neur_out_viv_int16 = 32711


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
bias_out_viv_float = prob_int16_to_bipolar(bias_out_viv_int16)
neur_out_viv_float = prob_int16_to_bipolar(neur_out_viv_int16)

# Convert outputs rev2 to floats
macc_out_viv_float = prob_int16_to_bipolar(macc_out_viv_int16)
bias_out_viv_float = prob_int16_to_bipolar(bias_out_viv_int16)
neur_out_viv_float = prob_int16_to_bipolar(neur_out_viv_int16)



# Python results
add1_pyt_float = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.027252197265625, 0.01849365234375, 0.00128173828125, -0.0, 0.0, 0.0, 0.0, -0.18603515625, 0.25634765625, 0.050323486328125, -0.0, 0.0, 0.0, 0.0, -0.20831298828125, 0.027099609375, 0.02978515625, -0.0, 0.0, -0.0, 0.0, -0.196258544921875, 0.17572021484375, 0.049163818359375, -0.0, 0.0, 0.0, 0.0, -0.158111572265625, 0.05670166015625, -0.0018310546875, 0.0, 0.0, 0.0, -0.0267333984375, -0.145599365234375, 0.0032958984375, 0.0, 0.0, -0.0, 0.00146484375, -0.00982666015625, -0.120025634765625, -0.0, 0.0, 0.0, 0.0, 0.0, 0.09222412109375, -0.087799072265625, 0.0, 0.0, 0.0, 0.0, 0.00634765625, 0.054473876953125, -0.01593017578125, 0.0, 0.0, 0.0, 0.0, 0.1383056640625, 0.170867919921875, 0.00555419921875, 0.0, 0.0, -0.0, 0.0, 0.028839111328125, -0.01483154296875, 0.001953125, 0.0, -0.0, -0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0]
add2_pyt_float = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0136260986328125, 0.0098876953125, 0.0, 0.0, 0.03515625, 0.0251617431640625, 0.0, -0.104156494140625, 0.0284423828125, 0.0, 0.0, -0.0102691650390625, 0.0245819091796875, 0.0, -0.0790557861328125, 0.027435302734375, 0.0, -0.01336669921875, -0.0711517333984375, 0.0, 0.000732421875, -0.0649261474609375, 0.0, 0.0, 0.046112060546875, -0.0438995361328125, 0.0, 0.003173828125, 0.0192718505859375, 0.0, 0.0, 0.1545867919921875, 0.002777099609375, 0.0, 0.0144195556640625, -0.006439208984375, 0.0, 0.0, 0.0, 0.0, 0.0]
add3_pyt_float = [0.0, 0.0, 0.0, 0.0, -0.00186920166015625, 0.0, 0.03015899658203125, -0.0520782470703125, 0.01422119140625, -0.00513458251953125, 0.01229095458984375, -0.02581024169921875, -0.006683349609375, -0.03557586669921875, -0.03209686279296875, 0.0, 0.00110626220703125, 0.0015869140625, 0.00963592529296875, 0.07729339599609375, 0.0013885498046875, 0.00399017333984375, 0.0, 0.0]
add4_pyt_float = [0.0, 0.0, -0.000934600830078125, -0.010959625244140625, 0.004543304443359375, -0.0067596435546875, -0.021129608154296875, -0.016048431396484375, 0.001346588134765625, 0.04346466064453125, 0.002689361572265625, 0.0]
add5_pyt_float = [0.0, -0.005947113037109375, -0.0011081695556640625, -0.018589019775390625, 0.022405624389648438, 0.0013446807861328125]
add6_pyt_float = [-0.0029735565185546875, -0.009848594665527344, 0.011875152587890625]
add7_pyt_float = [-0.006411075592041016, 0.0059375762939453125]

macc_out_pyt_float = -0.00023674964904785156
bias_out_pyt_float = 4.947185516357422e-05
neur_out_pyt_float = 4.947185516357422e-05


####### Plot and compare outputs ########

plt.figure(1)
## Add1
assert(len(add1_pyt_float) == len(add1_viv_float))
x_values = [i for i in range(len(add1_pyt_float))]
plt.subplot(3,3,1)
plt.title("adder stage 1 output")
plt.bar(x_values, add1_pyt_float, label="python values")
plt.scatter(x_values, add1_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add2
assert(len(add2_pyt_float) == len(add2_viv_float))
x_values = [i for i in range(len(add2_pyt_float))]
plt.subplot(3,3,2)
plt.title("adder stage 2 output")
plt.bar(x_values, add2_pyt_float, label="python values")
plt.scatter(x_values, add2_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add3
assert(len(add3_pyt_float) == len(add3_viv_float))
x_values = [i for i in range(len(add3_pyt_float))]
plt.subplot(3,3,3)
plt.title("adder stage 3 output")
plt.bar(x_values, add3_pyt_float, label="python values")
plt.scatter(x_values, add3_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add4
assert(len(add4_pyt_float) == len(add4_viv_float))
x_values = [i for i in range(len(add4_pyt_float))]
plt.subplot(3,3,4)
plt.title("adder stage 4 output")
plt.bar(x_values, add4_pyt_float, label="python values")
plt.scatter(x_values, add4_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add5
assert(len(add5_pyt_float) == len(add5_viv_float))
x_values = [i for i in range(len(add5_pyt_float))]
plt.subplot(3,3,5)
plt.title("adder stage 5 output")
plt.bar(x_values, add5_pyt_float, label="python values")
plt.scatter(x_values, add5_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add6
assert(len(add6_pyt_float) == len(add6_viv_float))
x_values = [i for i in range(len(add6_pyt_float))]
plt.subplot(3,3,6)
plt.title("adder stage 6 output")
plt.bar(x_values, add6_pyt_float, label="python values")
plt.scatter(x_values, add6_viv_float, label="vivado values")
plt.legend()
plt.grid()

## Add7
assert(len(add7_pyt_float) == len(add7_viv_float))
x_values = [i for i in range(len(add7_pyt_float))]
plt.subplot(3,3,7)
plt.title("adder stage 7 output")
plt.bar(x_values, add7_pyt_float, label="python values")
plt.scatter(x_values, add7_viv_float, label="vivado values")
plt.legend()
plt.grid()

#plt.show()

## Plot MAE for each stage
MAE_add1 = mean_absolute_error(add1_pyt_float, add1_viv_float)
MAE_add2 = mean_absolute_error(add2_pyt_float, add2_viv_float)
MAE_add3 = mean_absolute_error(add3_pyt_float, add3_viv_float)
MAE_add4 = mean_absolute_error(add4_pyt_float, add4_viv_float)
MAE_add5 = mean_absolute_error(add5_pyt_float, add5_viv_float)
MAE_add6 = mean_absolute_error(add6_pyt_float, add6_viv_float)
MAE_add7 = mean_absolute_error(add7_pyt_float, add7_viv_float)

MAE_macc_out = np.abs(macc_out_pyt_float - macc_out_viv_float)
MAE_bias_out = np.abs(bias_out_pyt_float - bias_out_viv_float)
MAE_neur_out = np.abs(neur_out_pyt_float - neur_out_viv_float)

MAE_series = [MAE_add1, MAE_add2, MAE_add3, MAE_add4, MAE_add5, MAE_add6, MAE_add7, MAE_macc_out, MAE_bias_out, MAE_neur_out]

plt.figure(2)
x_values = [i for i in range(10)]
plt.title("MAE after each stage in Neuron196_L2")
plt.bar(x_values, MAE_series)
plt.grid()
plt.show()

# Print final outputs comparison
print(f"Macc_out vivado float: {macc_out_viv_float}")
print(f"Macc_out python float: {macc_out_pyt_float}")

print(f"Bias_out vivado float: {bias_out_viv_float}")
print(f"Bias_out python float: {bias_out_pyt_float}")

print(f"Neur_out vivado float: {neur_out_viv_float}")
print(f"Neur_out python float: {neur_out_pyt_float}")