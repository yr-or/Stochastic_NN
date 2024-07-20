import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.metrics import mean_absolute_error
import re

############### Read ILA data from impl Layer2 ################
file1 = "C:\\Users\\Rory\\Documents\\HDL\Stochastic_NN\\Outputs\\mul_res_iladata_trial2.csv"

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
mul_res_bin_ila_int16 = data.loc[:, "mul_res_bin[0][15:0]":"mul_res_bin[193][15:0]"]


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


#### Change viv values to point to ILA values #####
mul_res_viv_int16 = mul_res_bin_ila_int16.values.tolist()[0]

# Convert vivado values to floats
mul_res_viv_float = [prob_int16_to_bipolar(x) for x in mul_res_viv_int16]



# Python results
mul_res_pyt_float = [0.0, -0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, 0.0, 0.0, -0.0, 0.0, -0.0, -0.0, -0.0, 0.0, 0.0, -0.0, -0.0, -0.0, 0.0, 0.0, 0.0, -0.0, -0.00579833984375, -0.0487060546875, -0.019775390625, 0.0567626953125, 0.0025634765625, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.3720703125, 0.189697265625, 0.322998046875, 0.10064697265625, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, 0.0, -0.0626220703125, -0.35400390625, 0.01190185546875, 0.04229736328125, 0.0595703125, 0.0, -0.0, -0.0, 0.0, 0.0, -0.0, -0.0, 0.0, 0.0, -0.2017822265625, -0.19073486328125, 0.2122802734375, 0.13916015625, 0.06756591796875, 0.03076171875, -0.0, -0.0, 0.0, -0.0, -0.0, 0.0, 0.0, -0.0, -0.199951171875, -0.11627197265625, 0.1705322265625, -0.05712890625, -0.003662109375, 0.0, 0.0, -0.0, 0.0, -0.0, 0.0, 0.0, 0.003173828125, -0.056640625, -0.18017578125, -0.11102294921875, 0.006591796875, -0.0, -0.0, 0.0, 0.0, -0.0, -0.0, -0.0, -0.0, 0.0029296875, 0.1043701171875, -0.1240234375, -0.1856689453125, -0.05438232421875, -0.0, -0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, -0.0, 0.0, 0.142822265625, 0.0416259765625, -0.07177734375, -0.10382080078125, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.002197265625, 0.014892578125, 0.05126953125, 0.05767822265625, 0.0076904296875, -0.03955078125, -0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.02685546875, 0.249755859375, 0.18408203125, 0.15765380859375, 0.01171875, -0.0006103515625, 0.0, -0.0, 0.0, -0.0, -0.0, -0.0, 0.0, -0.0, 0.0, 0.05767822265625, 0.00390625, -0.0335693359375, 0.00390625, -0.0, 0.0, -0.0, -0.0, -0.0, -0.0, -0.0, 0.0, -0.0, -0.0, 0.0, 0.0, -0.0, -0.0, -0.0, 0.0, 0.0, -0.0, 0.0, -0.0, -0.0]
mul_res_pyt_float = mul_res_pyt_float[0:194]    # Because num of ila probes

####### Plot and compare ila outputs to python model ########
plt.figure(1)
assert(len(mul_res_pyt_float) == len(mul_res_viv_float))
x_values = [i for i in range(len(mul_res_pyt_float))]
plt.title("adder stage 1 output")
plt.bar(x_values, mul_res_pyt_float, label="python values")
plt.scatter(x_values, mul_res_viv_float, label="vivado values")
plt.legend()
plt.grid()


plt.show()