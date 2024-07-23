"""
For comparing outputs implemented neuron196 from ILA data to python data
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.metrics import mean_absolute_error
import re

############### Read ILA data from impl Layer2 ################
"""
iladata_neuron_all_digit8_trial3.csv"   # Working data for neuron non-regen
Neur_regen_iladata.csv                  # Digit 8 neur regen data
"""
file1 = "C:\\Users\\Rory\\Documents\\HDL\Stochastic_NN\\Outputs\\Neur_regen_digit0_iladata.csv"

df1 = pd.read_csv(file1)

# Delete row 2 and rewrite to file
if "UNSIGNED" in df1.iloc[0].values:
    df2 = df1.drop(index=0).reset_index(drop=True)
    df2.to_csv(file1, index=False)
######### 

df = pd.read_csv(file1)

# Set start and end range
row_index_done = (df[df['done'] == 1].index)
data = df.iloc[row_index_done, 5:]

## ILA results - Neuron196 input digit=8
macc_out_bin_ila_int16 = data["macc_out_bin[15:0]"]
bias_out_bin_ila_int16 = data["bias_out_bin[15:0]"]
relu_out_bin_ila_int16 = data["relu_out_bin[15:0]"]     # Change to bias_out if using data from non-regen neuron

add1_res_bin_ila_int16 = data.loc[:, "add1_res_bin[0][15:0]":"add1_res_bin[97][15:0]"]
add2_res_bin_ila_int16 = data.loc[:, "add2_res_bin[0][15:0]":"add2_res_bin[48][15:0]"]
add3_res_bin_ila_int16 = data.loc[:, "add3_res_bin[0][15:0]":"add3_res_bin[23][15:0]"]
add4_res_bin_ila_int16 = data.loc[:, "add4_res_bin[0][15:0]":"add4_res_bin[11][15:0]"]
add5_res_bin_ila_int16 = data.loc[:, "add5_res_bin[0][15:0]":"add5_res_bin[5][15:0]"]
add6_res_bin_ila_int16 = data.loc[:, "add6_res_bin[0][15:0]":"add6_res_bin[2][15:0]"]
add7_res_bin_ila_int16 = data.loc[:, "add7_res_bin[0][15:0]":"add7_res_bin[1][15:0]"]


############ Plot Results #################
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


### Simulation results 20 July ###
#regexp = re.compile(r"Input:\s+(?P<input>\d+), Output:\s+(?P<output>\d+)")
add1_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 31875, 33375, 32811, 32767, 32767, 32767, 32767, 26671, 41175, 34415, 32767, 32767, 32767, 32767, 25939, 33659, 33743, 32767, 32767, 32767, 32767, 26335, 38539, 34371, 32767, 32767, 32767, 32767, 27583, 34623, 32711, 32767, 32767, 32767, 31895, 27995, 32871, 32767, 32767, 32767, 32815, 32447, 28835, 32767, 32767, 32767, 32767, 32767, 35795, 29883, 32767, 32767, 32767, 32767, 32971, 34543, 32247, 32767, 32767, 32767, 32767, 37295, 38367, 32951, 32767, 32767, 32767, 32767, 33703, 32275, 32831, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767]
add2_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32319, 33087, 32767, 32767, 33923, 33591, 32767, 29355, 33699, 32767, 32767, 32439, 33567, 32767, 30175, 33667, 32767, 32331, 30431, 32767, 32791, 30643, 32767, 32767, 34279, 31323, 32767, 32871, 33395, 32767, 32767, 37831, 32859, 32767, 33235, 32551, 32767, 32767, 32767, 32767, 32767]
add3_viv_int16 = [32767, 32767, 32767, 32767, 32691, 32767, 33759, 31067, 33231, 32607, 33167, 31911, 32547, 31591, 31711, 32767, 32807, 32815, 33087, 35295, 32815, 32895, 32767, 32767]
add4_viv_int16 = [32767, 32767, 32729, 32413, 32919, 32539, 32069, 32239, 32811, 34191, 32855, 32767]
add5_viv_int16 = [32767, 32569, 32729, 32155, 33505, 32811]
add6_viv_int16 = [32667, 32417, 33531]
add7_viv_int16 = [32537, 33153]
macc_out_viv_int16 = 32836
bias_out_viv_int16 = 16393  #16411
neur_out_viv_int16 = 16411

### Simulation results 22 July ###
## Testing Neuron with regen - digit 8 ##
add1_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 31879, 33375, 32811, 32767, 32767, 32767, 32767, 26671, 41171, 34417, 32767, 32767, 32767, 32767, 25941, 33655, 33743, 32767, 32767, 32767, 32767, 26339, 38523, 34375, 32767, 32767, 32767, 32767, 27587, 34625, 32703, 32767, 32767, 32767, 31887, 27993, 32875, 32767, 32767, 32767, 32815, 32445, 28833, 32767, 32767, 32767, 32767, 32767, 35789, 29889, 32767, 32767, 32767, 32767, 32979, 34549, 32243, 32767, 32767, 32767, 32767, 37303, 38363, 32947, 32767, 32767, 32767, 32767, 33715, 32281, 32831, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767]
add2_viv_int16 = [32767, 32767, 32767, 32767, 32767, 32767, 32767, 32767, 32323, 33093, 32767, 32767, 33921, 33591, 32767, 29355, 33697, 32767, 32767, 32429, 33571, 32767, 30177, 33663, 32767, 32327, 30435, 32767, 32791, 30637, 32767, 32767, 34279, 31327, 32767, 32873, 33397, 32767, 32767, 37833, 32857, 32767, 33241, 32555, 32767, 32767, 32767, 32767, 32767]
add3_viv_int16 = [32767, 32767, 32767, 32767, 32707, 32767, 33757, 31061, 33233, 32597, 33167, 31917, 32547, 31597, 31713, 32767, 32805, 32819, 33081, 35301, 32813, 32895, 32767, 32767]
add4_viv_int16 = [32767, 32767, 32735, 32409, 32911, 32543, 32073, 32239, 32811, 34189, 32849, 32767]
add5_viv_int16 = [32767, 32571, 32729, 32153, 33495, 32807]
add6_viv_int16 = [32669, 32423, 33151]
add7_viv_int16 = [32543, 32955]
macc_out_viv_int16 = 32748
bias_out_viv_int16 = 16345
neur_out_viv_int16 = 32768



"""
# Vivado results - 8-bit
add1_viv_int = [127,127,125,125,128,126,127,127,127,126,127,126,128,127,126,125,127,128,125,128,129,127,126,128,102,160,133,126,127,126,125,94,128,126,129,128,127,126,104,158,134,127,126,126,127,109,126,130,126,126,127,124,110,130,128,126,127,124,125,109,128,126,129,126,124,137,113,126,127,129,126,132,126,123,127,126,128,126,145,150,127,126,126,126,128,131,126,132,128,127,126,128,126,127,128,126,128,126]
add2_viv_int = [126,127,129,126,127,128,129,125,128,126,130,126,134,129,130,109,127,131,126,132,127,126,115,131,128,128,121,125,128,115,128,128,134,120,129,127,125,127,125,147,125,124,130,133,125,129,129,127,127]
add3_viv_int = [126,128,128,128,126,129,132,118,129,130,126,121,127,122,120,129,129,128,128,135,126,132,126,127]
add4_viv_int = [126,129,126,126,127,128,126,128,129,130,130,127]
add5_viv_int = [128,126,124,129,133,130]
add6_viv_int = [130,123,127]
add7_viv_int = [126,136]

# Vivado results - 16-bit - BEFORE LFSR FIX

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
"""

"""
#### Change viv values to point to ILA values #####
#### Comment out to use simulated values ####
add1_viv_int16 = add1_res_bin_ila_int16.values.tolist()[0]
add2_viv_int16 = add2_res_bin_ila_int16.values.tolist()[0]
add3_viv_int16 = add3_res_bin_ila_int16.values.tolist()[0]
add4_viv_int16 = add4_res_bin_ila_int16.values.tolist()[0]
add5_viv_int16 = add5_res_bin_ila_int16.values.tolist()[0]
add6_viv_int16 = add6_res_bin_ila_int16.values.tolist()[0]
add7_viv_int16 = add7_res_bin_ila_int16.values.tolist()[0]
macc_out_viv_int16 = macc_out_bin_ila_int16.values.tolist()[0]
bias_out_viv_int16 = bias_out_bin_ila_int16.values.tolist()[0]
neur_out_viv_int16 = relu_out_bin_ila_int16.values.tolist()[0]
###################################################
"""

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



##### Python results - digit 8 ####
add1_pyt_float_digit8 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.027252197265625, 0.01849365234375, 0.00128173828125, -0.0, 0.0, 0.0, 0.0, -0.18603515625, 0.25634765625, 0.050323486328125, -0.0, 0.0, 0.0, 0.0, -0.20831298828125, 0.027099609375, 0.02978515625, -0.0, 0.0, -0.0, 0.0, -0.196258544921875, 0.17572021484375, 0.049163818359375, -0.0, 0.0, 0.0, 0.0, -0.158111572265625, 0.05670166015625, -0.0018310546875, 0.0, 0.0, 0.0, -0.0267333984375, -0.145599365234375, 0.0032958984375, 0.0, 0.0, -0.0, 0.00146484375, -0.00982666015625, -0.120025634765625, -0.0, 0.0, 0.0, 0.0, 0.0, 0.09222412109375, -0.087799072265625, 0.0, 0.0, 0.0, 0.0, 0.00634765625, 0.054473876953125, -0.01593017578125, 0.0, 0.0, 0.0, 0.0, 0.1383056640625, 0.170867919921875, 0.00555419921875, 0.0, 0.0, -0.0, 0.0, 0.028839111328125, -0.01483154296875, 0.001953125, 0.0, -0.0, -0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0]
add2_pyt_float_digit8 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0136260986328125, 0.0098876953125, 0.0, 0.0, 0.03515625, 0.0251617431640625, 0.0, -0.104156494140625, 0.0284423828125, 0.0, 0.0, -0.0102691650390625, 0.0245819091796875, 0.0, -0.0790557861328125, 0.027435302734375, 0.0, -0.01336669921875, -0.0711517333984375, 0.0, 0.000732421875, -0.0649261474609375, 0.0, 0.0, 0.046112060546875, -0.0438995361328125, 0.0, 0.003173828125, 0.0192718505859375, 0.0, 0.0, 0.1545867919921875, 0.002777099609375, 0.0, 0.0144195556640625, -0.006439208984375, 0.0, 0.0, 0.0, 0.0, 0.0]
add3_pyt_float_digit8 = [0.0, 0.0, 0.0, 0.0, -0.00186920166015625, 0.0, 0.03015899658203125, -0.0520782470703125, 0.01422119140625, -0.00513458251953125, 0.01229095458984375, -0.02581024169921875, -0.006683349609375, -0.03557586669921875, -0.03209686279296875, 0.0, 0.00110626220703125, 0.0015869140625, 0.00963592529296875, 0.07729339599609375, 0.0013885498046875, 0.00399017333984375, 0.0, 0.0]
add4_pyt_float_digit8 = [0.0, 0.0, -0.000934600830078125, -0.010959625244140625, 0.004543304443359375, -0.0067596435546875, -0.021129608154296875, -0.016048431396484375, 0.001346588134765625, 0.04346466064453125, 0.002689361572265625, 0.0]
add5_pyt_float_digit8 = [0.0, -0.005947113037109375, -0.0011081695556640625, -0.018589019775390625, 0.022405624389648438, 0.0013446807861328125]
add6_pyt_float_digit8 = [-0.0029735565185546875, -0.009848594665527344, 0.011875152587890625]
add7_pyt_float_digit8 = [-0.006411075592041016, 0.0059375762939453125]
macc_out_pyt_float_digit8 = -0.00023674964904785156
bias_out_pyt_float_digit8 = 4.947185516357422e-05
neur_out_pyt_float_digit8 = 4.947185516357422e-05

##### Python results - digit 0 ####
add1_pyt_float_digit0 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.02435302734375, 0.06219482421875, 0.0, -0.0, 0.0, 0.0, 0.00054931640625, -0.18017578125, 0.254852294921875, 0.028533935546875, -0.0, 0.0, 0.0, 0.019134521484375, -0.223876953125, 0.296356201171875, 0.02587890625, -0.0, 0.0, -0.0, 0.051361083984375, -0.169464111328125, 0.02581787109375, 0.041748046875, -0.0, 0.0, 0.002685546875, 0.0599365234375, -0.009521484375, 0.0, -0.044677734375, 0.0, 0.0, 0.0714111328125, 0.040069580078125, -0.0, 0.0, 0.00042724609375, 0.0, -0.0, 0.0205078125, 0.032958984375, -0.0, -0.00634765625, 0.02008056640625, 0.0, 0.0, 0.0, 0.0364990234375, -0.00897216796875, 0.0233154296875, 0.0, 0.0, 0.0, 0.005126953125, 0.16168212890625, -0.03955078125, -0.0057373046875, 0.0, 0.0, 0.0, 0.0322265625, 0.169464111328125, 0.0023193359375, 0.0, 0.0, -0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, -0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0]
add2_pyt_float_digit0 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.012176513671875, 0.031097412109375, 0.0, 0.000274658203125, 0.0373382568359375, 0.0142669677734375, 0.0, -0.1023712158203125, 0.1611175537109375, 0.0, 0.0256805419921875, -0.0718231201171875, 0.0208740234375, 0.0013427734375, 0.02520751953125, -0.0223388671875, 0.0, 0.0557403564453125, 0.0, 0.000213623046875, 0.01025390625, 0.0164794921875, 0.006866455078125, 0.0, 0.01824951171875, 0.007171630859375, 0.0, 0.0025634765625, 0.061065673828125, -0.00286865234375, 0.0, 0.1008453369140625, 0.00115966796875, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
add3_pyt_float_digit0 = [0.0, 0.0, 0.0, 0.0, 0.00946044921875, 0.0001373291015625, 0.0258026123046875, -0.05118560791015625, 0.08055877685546875, -0.0230712890625, 0.0111083984375, 0.001434326171875, 0.02787017822265625, 0.0001068115234375, 0.01336669921875, 0.0034332275390625, 0.0127105712890625, 0.00128173828125, 0.0290985107421875, 0.05042266845703125, 0.000579833984375, 0.0, 0.0, 0.0]
add4_pyt_float_digit0 = [0.0, 0.0, 0.00479888916015625, -0.012691497802734375, 0.028743743896484375, 0.0062713623046875, 0.013988494873046875, 0.00839996337890625, 0.00699615478515625, 0.039760589599609375, 0.0002899169921875, 0.0]
add5_pyt_float_digit0 = [0.0, -0.0039463043212890625, 0.017507553100585938, 0.011194229125976562, 0.023378372192382812, 0.00014495849609375]
add6_pyt_float_digit0 = [-0.0019731521606445312, 0.01435089111328125, 0.011761665344238281]
add7_pyt_float_digit0 = [0.006188869476318359, 0.005880832672119141]
macc_out_pyt_float_digit0 = 0.00603485107421875
bias_out_pyt_float_digit0 = 0.003185272216796875
neur_out_pyt_float_digit0 = 0.003185272216796875

## Select python digit
add1_pyt_float = add1_pyt_float_digit8
add2_pyt_float = add2_pyt_float_digit8
add3_pyt_float = add3_pyt_float_digit8
add4_pyt_float = add4_pyt_float_digit8
add5_pyt_float = add5_pyt_float_digit8
add6_pyt_float = add6_pyt_float_digit8
add7_pyt_float = add7_pyt_float_digit8
macc_out_pyt_float = macc_out_pyt_float_digit8
bias_out_pyt_float = bias_out_pyt_float_digit8
neur_out_pyt_float = neur_out_pyt_float_digit8


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

# Macc out
x_values = [0]
plt.subplot(3,3,8)
plt.title("MAC output")
plt.bar(x_values, macc_out_pyt_float, label="python values")
plt.scatter(x_values, macc_out_viv_float, label="vivado values")
plt.legend()
plt.grid()

# Bias out
x_values = [0]
plt.subplot(3,3,9)
plt.title("Bias output")
plt.bar(x_values, bias_out_pyt_float, label="python values")
plt.scatter(x_values, bias_out_viv_float, label="vivado values")
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
#plt.show()

# Print final outputs comparison
print(f"Macc_out vivado float: {macc_out_viv_float}")
print(f"Macc_out python float: {macc_out_pyt_float}")

print(f"Bias_out vivado float: {bias_out_viv_float}")
print(f"Bias_out python float: {bias_out_pyt_float}")

print(f"Neur_out vivado float: {neur_out_viv_float}")
print(f"Neur_out python float: {neur_out_pyt_float}")


######## Test accuracy of adders and multipliers from vivado results #########
# Adder 2 stage
"""
add2_true = [(add1_viv_float[i*2]+add1_viv_float[(i*2)+1])/2 for i in range(49)]
plt.figure(3)
plt.title("Add2 Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(add2_viv_float))]
plt.bar(x_vals, add2_true, label="expected")
plt.scatter(x_vals, add2_viv_float, label="actual")
plt.grid()
plt.legend()

# Adder 3 stage
add3_true = [(add2_viv_float[i*2]+add2_viv_float[(i*2)+1])/2 for i in range(24)]
plt.figure(4)
plt.title("Add3 Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(add3_viv_float))]
plt.bar(x_vals, add3_true, label="expected")
plt.scatter(x_vals, add3_viv_float, label="actual")
plt.grid()
plt.legend()

# Adder 4 stage
add4_true = [(add3_viv_float[i*2]+add3_viv_float[(i*2)+1])/2 for i in range(12)]
plt.figure(5)
plt.title("Add4 Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(add4_viv_float))]
plt.bar(x_vals, add4_true, label="expected")
plt.scatter(x_vals, add4_viv_float, label="actual")
plt.grid()
plt.legend()

# Adder 5 stage
add5_true = [(add4_viv_float[i*2]+add4_viv_float[(i*2)+1])/2 for i in range(6)]
plt.figure(6)
plt.title("Add5 Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(add5_viv_float))]
plt.bar(x_vals, add5_true, label="expected")
plt.scatter(x_vals, add5_viv_float, label="actual")
plt.grid()
plt.legend()
"""

# Adder 6 stage
add6_true = [(add5_viv_float[i*2]+add5_viv_float[(i*2)+1])/2 for i in range(3)]
plt.figure(3)
plt.title("Add6 Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(add6_viv_float))]
plt.bar(x_vals, add6_true, label="expected")
plt.scatter(x_vals, add6_viv_float, label="actual")
plt.grid()
plt.legend()

# Adder 7 stage
add7_true = [(add6_viv_float[0]+add6_viv_float[1])/2, (add6_viv_float[2]+add2_viv_float[48]/16)/2 ]
plt.figure(4)
plt.title("Add7 Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(add7_viv_float))]
plt.bar(x_vals, add7_true, label="expected")
plt.scatter(x_vals, add7_viv_float, label="actual")
plt.grid()
plt.legend()

# Macc out stage
macc_out_true = [(add7_viv_float[0]+add7_viv_float[1])/2]
plt.figure(5)
plt.title("MAC out Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(macc_out_true))]
plt.bar(x_vals, macc_out_true, label="expected")
plt.scatter(x_vals, macc_out_viv_float, label="actual")
plt.grid()
plt.legend()

# Bias out stage
bias_neur0_int16 = 32773
bias_neur0_float = prob_int16_to_bipolar(bias_neur0_int16)

bias_out_true = [(macc_out_viv_float + bias_neur0_float)/2]
print(bias_out_true)
plt.figure(6)
plt.title("Bias out Expected vs. actual based on actual inputs")
x_vals = [i for i in range(len(bias_out_true))]
plt.bar(x_vals, bias_out_true, label="expected")
plt.scatter(x_vals, bias_out_viv_float, label="actual")
plt.grid()
plt.legend()


plt.show()