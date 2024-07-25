import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

############### Read ILA data from impl Layer2 ################
#file1 = "C:\\Users\\Rory\Documents\\HDL\Stochastic_NN\\Outputs\\iladata_Test_L2_regen_synth.csv"
file1 = "C:\\Users\\Rory\\Documents\\HDL\\Stochastic_NN2\\Outputs\\L2_regen_digit8_iladata.csv"

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
L2_neur_out_ila_int16 = data.loc[:, "L2_neur_out_bin[0][15:0]":"L2_neur_out_bin[31][15:0]"]
L2_macc_out_ila_int16 = data.loc[:, "L2_macc_out_bin[0][15:0]":"L2_macc_out_bin[31][15:0]"]

L2_neur_out_ila_int16 = L2_neur_out_ila_int16.values.tolist()[0]
L2_macc_out_ila_int16 = L2_macc_out_ila_int16.values.tolist()[0]


## Python outputs
L2_macc_out_pyt_float = [-0.00023674964904785156, -0.005519866943359375, -0.003680706024169922, -0.0007140636444091797, 0.0034401416778564453, 0.004800558090209961, 0.009500741958618164, 0.0033600330352783203, 0.010937690734863281, -0.013616561889648438, 0.0029265880584716797, 0.0019512176513671875, -0.0009810924530029297, 0.0035860538482666016, 0.012040853500366211, 0.0058634281158447266, 0.003695249557495117, -0.007080078125, -0.0031311511993408203, 0.00551915168762207, 0.0005753040313720703, 0.0053217411041259766, 0.0034525394439697266, -0.008504152297973633, 0.003789663314819336, 0.0012803077697753906, 0.012462615966796875, -0.0013015270233154297, -0.0019092559814453125, -0.00014352798461914062, 0.004645109176635742, -0.0011851787567138672]
L2_neur_out_pyt_float = [0, 0.0005669593811035156, 0.0010323524475097656, 0.0005563497543334961, 0.0011459589004516602, 0.001115560531616211, 0.0017745494842529297, 0.001165628433227539, 0.0020128488540649414, 0, 0, 0.0006077289581298828, 0.0028543472290039062, 0.0014847517013549805, 0.003276824951171875, 0.0030471086502075195, 0.0006672143936157227, 0, 0.001738429069519043, 0.0014890432357788086, 0.00040078163146972656, 0.002362966537475586, 0, 0.002204298973083496, 0, 0.00020575523376464844, 0, 0.00015819072723388672, 0.0012420415878295898, 0.0016390085220336914, 0.00010418891906738281, 0]


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



# Convert ILA values to floats
L2_neur_out_ila_float = [prob_int16_to_bipolar(x) for x in L2_neur_out_ila_int16]
L2_macc_out_ila_float = [prob_int16_to_bipolar(x) for x in L2_macc_out_ila_int16]


####### Plot and compare outputs ########
plt.figure(1)
## Macc out
assert(len(L2_macc_out_pyt_float) == len(L2_macc_out_ila_float))
x_values = [i for i in range(len(L2_macc_out_pyt_float))]

plt.title("MAC L2 output")
plt.bar(x_values, L2_macc_out_pyt_float, label="python values")
plt.scatter(x_values, L2_macc_out_ila_float, label="vivado values")
plt.legend()
plt.grid()


plt.show()