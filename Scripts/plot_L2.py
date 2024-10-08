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

def prob_int16_to_unipolar(x):
    return x/65536


def relu(x):
    if x > 0:
        return x
    else:
        return 0


##########  Values from all stochastic L2 #############
L2_out_viv_int16 = [32650, 32200, 32655, 32508, 32577, 32658, 33205, 32884, 33336, 31836, 32743, 32870, 32342, 32749, 33421, 32874, 32785, 32374, 32386, 33162, 32845, 32635, 32704, 32463, 33121, 32739, 33237, 32304, 32544, 32600, 32695, 32708 ]
L2_macc_out_viv_int16 = [32721, 32539, 32653, 32771, 32881, 32879, 33111, 32915, 33133, 32307, 32917, 32795, 32719, 32843, 33187, 32951, 32849, 32527, 32643, 32979, 32809, 32861, 32779, 32501, 32871, 32811, 33155, 32719, 32701, 32769, 32917, 32747 ]
#######################################################

L2_out_pyt_float = [4.947185516357422e-05, 0, 0, 0, 0.0019184350967407227, 0.0025833845138549805, 0.004719853401184082, 0.0016952753067016602, 0.005514621734619141, 0, 0.0013564825057983398, 0.0011587142944335938, 0, 0.0020524263381958008, 0.0064629316329956055, 0.0034962892532348633, 0.0017713308334350586, 0, 0, 0.002988457679748535, 0.0005317926406860352, 0.0028287172317504883, 0.0019246339797973633, 0, 0.001986384391784668, 0.0010368824005126953, 0.0059413909912109375, 0, 0, 0, 0.002078413963317871, 0]
L2_macc_out_pyt_float = [-0.00023674964904785156, -0.005519866943359375, -0.003680706024169922, -0.0007140636444091797, 0.0034401416778564453, 0.004800558090209961, 0.009500741958618164, 0.0033600330352783203, 0.010937690734863281, -0.013616561889648438, 0.0029265880584716797, 0.0019512176513671875, -0.0009810924530029297, 0.0035860538482666016, 0.012040853500366211, 0.0058634281158447266, 0.003695249557495117, -0.007080078125, -0.0031311511993408203, 0.00551915168762207, 0.0005753040313720703, 0.0053217411041259766, 0.0034525394439697266, -0.008504152297973633, 0.003789663314819336, 0.0012803077697753906, 0.012462615966796875, -0.0013015270233154297, -0.0019092559814453125, -0.00014352798461914062, 0.004645109176635742, -0.0011851787567138672]


######### Plot Comparison #########
## Convert vivado values to float
## PREV: L2_out_viv_float = [prob_int16_to_bipolar(x) for x in L2_out_viv_int16]
L2_out_viv_float = [relu(prob_int16_to_bipolar(x)) for x in L2_macc_out_viv_int16]
L2_macc_out_viv_float = [prob_int16_to_bipolar(x) for x in L2_macc_out_viv_int16]

## Compare neur_out
plt.figure(1)
plt.title("L2 Neuron outputs comparison")
assert(len(L2_out_viv_float) == len(L2_out_pyt_float))
x_values = [i for i in range(len(L2_out_viv_float))]
plt.bar(x_values, L2_out_pyt_float, label="Python values")
plt.scatter(x_values, L2_out_viv_float, label="Vivado values")
plt.legend()
plt.grid()

plt.figure(2)
plt.title("L2 Mac outputs comparison")
assert(len(L2_macc_out_viv_float) == len(L2_macc_out_pyt_float))
x_values = [i for i in range(len(L2_macc_out_viv_float))]
plt.bar(x_values, L2_macc_out_pyt_float, label="Python values")
plt.scatter(x_values, L2_macc_out_viv_float, label="Vivado values")
plt.legend()
plt.grid()

plt.show()
