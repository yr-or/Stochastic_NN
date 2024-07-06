import matplotlib.pyplot as plt
import numpy as np
import re
from sklearn.metrics import mean_squared_error

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

def sigmoid(x):
	return 1 / (1 + np.exp(-4*x))

inps = []
outs = []

regexp = re.compile(r"Input:\s+(?P<input>\d+), Output:\s+(?P<output>\d+)")
with open("C:\\Users\\Rory\\Documents\\HDL\\Stochastic_NN\\Stochastic_NN.sim\\sim_1\\behav\\xsim\\sigmoid_data.txt", "r+") as f:
	for line in f:
		m = regexp.search(line)
		inps.append(int(m.group('input')))
		outs.append(int(m.group('output')))

x_bi = [prob_int_to_bipolar(x) for x in inps]
y_bi = [prob_int_to_bipolar(y) for y in outs]
y_uni = [int_to_unipolar(y) for y in outs]

plt.figure(1)
plt.scatter(inps, outs)
plt.grid(True)

plt.figure(2)
plt.scatter(x_bi, y_uni, label="Sigmoid FSM")
plt.grid(True)
plt.xlabel("Input value")
plt.ylabel("Output value")
plt.title("Sigmoid data")
# Plot actual sigmoid function
sgm_x_pts = np.linspace(-1,1,100)
sgm_y_pts = sigmoid(sgm_x_pts)
plt.plot(sgm_x_pts, sgm_y_pts, 'r', label="Sigmoid exact")
plt.legend()

# Get MSE
sgm_x_pts = np.array(x_bi)
sgm_y_pts = sigmoid(sgm_x_pts)
mse = mean_squared_error(sgm_y_pts, y_uni)
print("MSE =", mse)

plt.show()