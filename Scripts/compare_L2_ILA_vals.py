import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

############### Read ILA data from impl Layer2 ################
file1 = "C:\\Users\\Rory\Documents\\HDL\Stochastic_NN\\Outputs\\iladata_Test_L2_regen_synth.csv"

df = pd.read_csv(file1, skiprows=1)

#df.info()

# Set start and end range
row_index_done = df[df['HEX.1'] == 1].index
data = df.iloc[row_index_done, 5:].values.tolist()[0]

L2_relu_out_ila_int16 = data[0:32]
L2_macc_out_ila_int16 = data[32:65]
