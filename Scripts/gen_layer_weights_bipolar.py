# Rev 1: Adding scaling factor into bias values

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

# Layer 2 Bias values from colab notebook
B_ARRAY_L2 = [ 11, 1, 0, 9, 13, 12, -2, 1, 3, 19, -7, 12, 4, 17, 29, 37, -5, 20, -5, 15, 16, 11, 13, 20, 6, 26, -19, -7, 45, -4, -16, 5 ]

# Layer 2 weights from colab notebook
W_ARRAY_L2 = (
	[ 9, -1, 4, 17, 23, 43, 30, 7, -37, 0, 33, 13, 9, -6, 2, 10, -31, 4, 1, 11, -1, 4, -23, -27, -3, 28, 25, -4, -12, -6, 27, 13, 21, -20, -19, -19, -6, 31, 21, 16, -41, -26, 11, -4, 11, 11, 4, 18, 0, -48, 28, 49, 17, 16, -29, -16, 41, -13, 8, -2, 26, 11, -18, -50, 65, 33, 8, 0, -37, -85, 35, 17, -25, -3, 11, 11, -58, -25, 47, 19, 9, 9, -36, -59, 32, -6, -16, 11, 20, -8, -52, -15, 22, -13, -15, 9, 33, -14, 17, -8, 1, 36, 13, -16, -24, -17, 4, -32, -7, 21, 11, -1, -2, -45, -1, 8, 18, -16, -26, -11, -10, -3, 7, 7, 15, 21, 28, -6, -32, 0, 26, 22, -12, -21, 7, 2, 31, 15, 3, -30, 7, 6, -3, 2, 21, 45, 1, -12, -3, 1, 16, 7, -4, 31, 4, -42, 22, 33, 26, 21, 2, -5, 1, -13, 4, -14, -43, -13, 2, -4, 35, 27, 1, -10, 8, -22, 2, -60, -42, -42, -31, -2, 9, -28, -32, 2, 8, -4, -6, -5, 7, 14, -24, 31, -20, -7 ],
	[ -1, -2, 7, 15, 12, 1, 30, 45, 35, 14, 2, 2, -8, -6, 2, -27, -29, -21, 22, -14, 19, 58, 30, 36, 45, 23, 27, 7, -7, -33, 8, -4, 10, 25, 24, 23, 3, 18, 21, 32, 52, 13, 13, -37, -18, 12, 18, 16, 30, 30, 27, 30, 26, 0, 22, 57, 3, -40, -17, 2, 14, 17, 19, -23, -61, -57, -32, -16, -21, 51, 2, -8, -1, 3, -2, -14, -10, -55, -27, -44, -62, -94, -83, 47, -19, 8, -9, -24, -14, -2, -7, -12, 10, 3, 16, -11, -48, -5, 9, -30, -45, -18, 6, 3, -12, -6, -8, -7, 0, -1, 13, -1, 3, 43, -56, -81, -53, -19, -25, -7, -5, 3, 14, -8, 16, -44, -19, 23, -14, -42, -63, -86, -83, 23, 18, 13, 16, 7, 43, -19, -11, 28, 40, 23, 13, 13, 18, 43, 33, 22, 15, 24, 11, 14, -5, 10, 36, 9, 31, 40, 24, 26, 29, 12, 9, -8, -28, 14, -12, 11, 34, 55, 44, 35, 15, 6, 18, -3, 16, 10, -30, -2, -6, 10, 26, 6, -25, 4, -54, -25, -16, 6, 13, 40, -4, -2 ],
	[ 4, -11, 5, 26, 17, 46, 63, 63, 68, 33, 15, 21, 8, 5, -1, 21, 27, 15, -3, -23, 0, 5, 22, 54, 36, 25, 9, 19, 6, 7, -19, -29, -35, -27, -20, -14, 17, 20, 12, 16, 13, 32, 37, -44, -44, -21, -9, 20, 0, 17, 14, 19, 20, 35, 54, 12, 16, -70, -42, -3, 3, 20, 32, 26, -1, -15, -2, 18, 22, 48, -51, -13, 0, 17, -8, 22, 10, -19, -60, -72, -100, -119, -67, 59, -15, -3, -17, 2, -6, -28, -3, -6, -13, 11, -18, -69, -90, 40, 3, -20, -53, -1, 1, -22, 5, 2, -2, -1, -4, -38, 2, -12, -29, 27, -17, -14, -4, 2, 27, 3, -14, -3, -17, -9, 20, 32, -4, -2, 8, 3, -8, -25, 13, -5, 1, 20, 21, -3, 33, -1, -26, 26, 20, 7, 18, 34, 35, 12, 26, 34, 45, 34, 59, 42, 11, -7, 42, -17, -12, 0, -10, 20, 13, 10, 20, 34, 47, 32, 12, 3, -5, 15, -8, -6, 33, 17, 35, 25, 15, 40, 49, 24, -7, 9, -12, -49, -19, 32, 34, 40, 70, 36, 24, 30, 22, 6 ],
	[ 8, -1, -3, 11, -2, -4, -22, -9, 53, 3, 2, 17, 3, -3, 10, 11, 7, 18, 50, 51, 38, 27, 15, -10, -2, -5, 17, -1, -2, -15, 22, 26, 21, 28, -1, -6, -9, -11, -10, -15, 5, 7, 38, -16, -14, 0, -12, 1, 7, 10, -19, -16, -13, -11, 1, 28, 28, -26, -43, -34, -30, -20, -24, 0, -7, -10, -9, -10, -7, 18, 17, -19, -56, -78, -62, -68, -30, 5, -9, -4, 7, -20, -5, -16, -6, -6, -34, -21, -8, 48, 80, 2, -22, 1, 8, -15, 22, 27, -8, 64, 50, 40, 47, 54, 37, 10, 18, 6, -1, 18, 37, 53, -4, 28, 41, 29, 9, 10, 0, 12, 35, 21, 22, 24, 11, 51, 2, 18, 19, -1, 9, 1, 8, 18, 31, 5, 11, 5, 7, 17, -30, 31, -4, -19, -11, -8, -15, -15, -3, 4, -4, -7, -7, 35, -8, 28, -9, -21, -8, 5, -7, -29, -33, -21, -6, -27, -22, -14, -2, -9, -53, -21, -9, 0, -4, -9, -19, -41, 12, 14, 14, 34, -3, -20, -49, -65, -46, -21, -50, -22, 1, -16, -1, 0, -20, -5 ],
	[ 8, 9, 17, 37, 40, 22, 7, -16, 26, 46, 40, 23, 9, 3, 12, -3, 35, 56, 16, 50, 38, 17, -4, 3, 4, 28, 9, -6, -10, -15, 21, -7, -9, -15, -18, -40, -29, -35, -55, -46, -46, -29, 30, 32, 9, 13, 13, 5, 7, 21, 18, 3, -9, -54, -78, -11, 23, 11, 31, 23, 31, 30, 6, 5, -7, -7, 7, 6, -50, -13, -4, 13, 36, 51, 20, -10, -34, -10, 14, 8, 22, 24, -38, -31, 16, -10, 7, -15, -34, -52, -34, 23, 38, 27, 19, 22, -27, -24, -20, -12, -20, -7, -18, -1, 9, 38, 11, 14, 39, 19, -10, -21, 27, 0, -5, 14, -17, 3, 13, 21, 5, 27, 14, -3, 17, 24, 29, 7, 15, -4, -38, -11, 2, 23, 16, 9, -19, -4, -1, 52, -23, 20, -18, -8, -14, -16, 12, 10, -15, -43, -49, -50, 1, -2, -9, -21, 4, -8, -13, -9, -18, -22, -29, -46, -52, -45, -4, -18, -11, -1, 50, 29, 5, 10, 1, -6, -6, -21, -9, -10, 20, 32, -4, 4, -5, 37, 72, 20, 36, 52, 50, 39, 65, 43, 25, 2 ],
	[ 4, -11, 4, 7, -15, 2, -8, -30, 13, -62, -36, -24, 7, 6, 0, 20, -1, -43, 3, -1, 2, -19, 10, 19, 5, -8, -11, -4, -6, 1, -49, -27, 14, 38, 24, -1, 6, 11, 15, -11, 26, 37, -8, 3, -28, 7, 25, 17, 21, 29, 21, 46, 8, -3, 28, 3, 28, 0, -13, 25, 35, 25, 12, 9, 13, 24, 6, 23, 64, 45, 13, 15, 42, 48, 47, 31, 8, 23, -11, 8, 4, 40, 94, 70, 5, 40, 53, 32, 16, 1, 8, 5, -10, -8, 7, 14, 23, 39, 12, -2, 1, 9, -7, -10, -7, -9, 0, -2, 12, 16, 3, -24, -15, -4, 11, 5, -14, 15, -9, -15, 22, -2, -6, 8, -9, -38, 38, -30, 29, 17, 8, 2, -30, -24, 5, 3, 8, 1, 6, -36, 15, -51, 1, 7, -4, -6, -4, 5, 12, 0, -7, 5, -17, -28, -1, -16, -16, -3, 1, 4, 12, 18, 28, 2, -1, 10, -2, -12, -11, 31, -16, -5, 7, 28, 37, 50, 24, 26, 31, 16, 0, -33, -6, -3, -17, -5, 56, 87, 90, 87, 86, 77, 78, 63, 7, 9 ],
	[ -9, 3, -11, 2, -10, 9, 2, 34, 0, 24, 21, 21, -9, 0, 5, 6, 13, 34, 0, -11, -12, 4, 14, -1, 17, -5, -11, -24, 15, 20, 46, 35, -4, -1, 2, 1, 10, 18, 25, 6, -7, 21, 3, -7, -1, -10, -9, -15, -6, 9, 2, 16, 23, 11, 6, -7, -45, -4, -11, -11, -5, 1, 20, 20, 24, 8, 17, 4, -3, -14, -20, 12, -1, -13, -17, -8, 20, 12, 0, 20, 21, 11, -8, -1, -43, -13, 5, -9, 5, -23, 50, 26, -2, -9, -29, -1, -12, -30, 14, -44, -25, -14, -1, -3, 51, 13, -17, -39, -28, -13, -32, -46, 15, -1, -18, -25, -12, -2, -5, -15, -24, -20, -10, 1, -2, -35, -29, 12, -8, -7, -11, -43, -50, -17, 14, 22, 5, 14, -33, -9, 14, 13, 1, 28, 7, -13, -7, 10, 20, 42, 34, -32, -14, -1, -3, 25, 8, 14, 18, 28, 31, 30, 16, 11, -5, -46, -32, 16, 3, 25, -1, 16, 47, 34, 39, 7, 4, -8, -9, -28, -18, -7, -11, 4, 40, 32, 15, 22, 11, 7, 23, 15, 32, -10, -6, 11 ],
	[ -7, -10, 5, -20, 3, -20, -12, -30, -23, -35, -50, -11, 10, -8, 1, -28, -29, -26, 4, 32, -19, -13, -36, -17, -40, 7, -16, -21, -9, -24, -36, 8, -6, 19, 25, 22, 1, -1, 7, 6, 15, -1, -42, -20, -15, -17, -10, -20, -17, 6, 13, -15, -19, -7, 21, 29, -67, -29, -4, -17, -13, -24, 18, 1, 2, -2, -11, 9, 4, 11, -30, -32, -18, -1, 0, 14, 30, -12, 3, -1, -23, -15, -37, -3, -10, -40, -53, 1, 20, 20, 11, 19, 41, 13, -2, -1, 1, -4, -16, -14, -42, -13, -14, 0, 6, 30, 51, -9, -30, -35, -7, 0, -22, -37, -17, 3, 1, -6, 9, 10, 15, -63, -30, -9, 5, 1, -30, -30, -8, 16, 5, 8, -15, -1, -18, -38, 13, 38, -17, -7, -11, -33, -34, 0, 10, 7, -11, 0, 3, -24, -5, -3, -14, -33, -15, -4, -59, -3, 19, 22, 11, -4, -12, 7, 7, -7, 17, -29, 10, -37, -27, 0, -13, -5, -2, 20, 13, 26, 6, 6, 0, -15, -11, 19, 20, 25, 18, -4, -9, 0, 7, -35, -46, -35, -10, -5 ],
	[ 12, 4, -5, 20, 38, 8, 1, -22, 41, 47, 57, 39, -12, -5, -1, -12, 8, 43, 27, 56, 17, 19, -3, 11, 7, 34, 23, 13, -4, -14, 18, 6, 19, -2, 1, 14, 28, 25, 14, 3, 5, 24, 43, 9, 9, 0, 5, -12, -2, -11, -36, -13, -14, 19, 13, -7, 25, 24, 44, 3, 7, -10, 0, -1, -3, -8, 15, 29, -33, 0, 19, 23, 1, -4, -21, -21, 3, -4, -16, 0, -1, 11, -34, -28, 2, -13, -28, -32, -28, 0, 25, -6, -5, -13, 8, 17, 71, -12, -11, 9, -29, -3, -1, 31, 37, 30, 5, 17, 11, 9, 32, 56, 3, 23, -5, 2, 25, 42, 32, 36, 17, 7, 17, 20, 55, 49, -36, 22, 12, 7, 4, -2, 10, 5, 15, -11, -5, 17, -2, -4, -17, 31, -9, 23, 32, 18, 15, 40, 2, -11, 6, 20, -23, 6, -7, 33, -2, 30, 25, 39, 35, 6, 5, 12, 15, 2, -26, -27, 8, -29, -38, 1, -4, 5, 3, 9, -5, -24, -23, -23, 10, 0, 6, -13, -23, -42, -61, -50, -79, -65, -48, -25, -69, -53, -15, -5 ],
	[ 9, -3, 2, 13, 22, -17, -18, 61, 43, 20, 29, 9, -6, -2, -5, -14, -5, 32, 1, -6, 34, 28, -3, 34, -19, 8, 8, 11, 11, 12, 39, 19, 28, 22, 25, 2, 14, 3, -7, -9, -2, -34, 39, 56, 9, 2, 5, -19, -16, -24, -18, -13, -17, -2, -10, -9, 70, 9, -18, -16, -20, -6, 9, 4, -20, 6, 6, 19, 10, -30, 37, 20, -2, -6, 7, 45, 63, -25, -15, 23, 9, 17, 3, -50, 29, 25, 26, 42, 67, 57, -28, -57, 11, -6, -7, -10, -3, -16, 13, 29, 9, 45, 27, -28, -127, 9, 9, -16, -11, -4, -14, -19, 23, 26, 2, 2, -26, -103, -69, 29, 8, 8, 7, -9, -40, 19, 35, -9, -8, -30, -52, -70, -16, 16, 20, 7, 19, -5, -25, 29, 12, -34, -25, -15, -7, 10, -6, 10, 25, 28, -2, 2, 15, 25, 8, -8, 14, -5, 15, 3, -5, 0, 2, 24, 6, -3, 30, 20, -1, -7, 7, -17, 5, -12, -2, 13, 8, 16, 2, -23, 9, -8, 5, 8, -33, -22, -11, -9, 1, -10, -2, 17, 15, 40, -3, -5 ],
	[ -11, 4, 6, 4, -21, 5, 5, -6, 22, -32, -27, 1, -10, 3, 0, 22, -19, -6, 15, 20, 26, -6, -39, -51, -32, -25, -9, 13, -1, 9, 27, 15, 20, 42, 34, 28, -11, -31, -39, -6, -27, -31, 14, 63, 2, 35, 31, 27, 26, 41, 43, 29, -3, 2, -32, -67, 48, 1, 0, 12, -6, -17, -3, 26, 50, 27, 2, -5, -35, -40, 27, 12, -18, -32, -28, -32, -25, 0, 4, 19, 29, 0, -33, -32, -10, -12, -45, -23, 2, -8, -27, -26, -17, 21, 1, -16, -62, -34, -27, -17, -16, 13, -5, -8, -4, -15, 10, 28, 1, -19, -13, 60, 8, -34, -22, 0, -8, -23, -30, -17, 28, -14, -10, -10, -14, 27, 35, -23, -32, -17, -11, 10, 9, 2, -2, -2, -1, -20, 6, 15, 13, 18, -10, -24, 5, 16, 21, -1, -3, -10, -8, -16, 17, 9, 1, 0, -21, 19, 17, 19, -2, 4, 5, -10, -14, 21, 14, -34, 0, 5, 56, 42, 6, -6, 2, -14, -16, -26, -1, -7, 18, 5, -7, 10, -4, 46, 72, 50, 33, 46, 34, 59, 51, 8, -9, -8 ],
	[ -11, -10, 16, 30, 38, 20, 27, -37, -5, 45, 55, 27, -11, -2, 4, -21, 51, 48, 40, 70, 39, 23, 19, 44, 56, 58, 30, 17, -1, 6, -5, 6, 42, 38, 26, 17, 27, 43, 40, 27, 34, 16, 0, -22, 9, 10, 29, -7, 15, 26, 14, -1, -3, -11, 48, 33, -54, 0, 11, -22, -4, -4, 6, -21, -22, -10, -9, -41, 10, -6, -41, -21, -13, 1, 6, 9, -10, -49, -29, 1, -5, -19, 26, -28, -23, -37, -3, 27, 45, 29, 19, -15, 18, 17, 9, 25, 0, -63, 18, -41, 12, 25, 10, 16, 14, 3, 27, 22, 4, 12, 14, -28, 14, 11, -6, -18, -20, 11, 9, -13, 25, 22, 4, 21, 9, -71, -29, 46, 19, 17, -13, -2, -21, 2, 34, 12, 12, -5, -20, -51, 4, 8, -14, -6, 0, 16, 25, 33, 37, 20, 8, -6, -21, -38, 6, 40, -12, -6, 4, 20, 25, 18, 15, 25, -1, 27, -12, 3, 2, 43, 34, 27, 19, 17, 19, 24, 34, 32, 22, 49, -11, -34, 8, 27, 37, 11, 6, 6, 23, 10, 7, -7, -15, -26, -15, -7 ],
	[ -2, 5, -2, -16, -32, -9, -16, 13, -27, -51, -35, -1, -7, -11, 8, -4, 13, 3, 10, 9, 34, 25, 18, -39, -29, -61, -46, -2, 17, 26, 26, -1, -3, 4, 16, 43, 27, -14, -13, -35, -32, -13, 34, 3, 23, 7, -14, -21, -2, 25, 12, -1, -25, -54, -50, -9, -9, 29, 14, 12, -25, -30, 6, 32, 38, 10, -23, -80, -70, 19, -5, 32, -17, -30, -25, -40, 18, 43, 6, -12, -52, -70, -12, 15, -6, 8, -14, 3, -5, -13, 21, 10, -21, 0, -27, -46, 26, 30, 19, 19, 15, 10, 12, -31, 0, 24, -11, -10, 10, 22, 14, 50, 41, 38, 7, 0, -12, -42, 5, 23, -12, 7, 11, 28, 7, 10, -6, 55, 12, -3, -12, -29, 15, 13, 18, 17, 11, 21, 2, 13, 5, 7, -22, 16, -18, -1, -4, 10, 21, 25, 22, -9, 4, 10, 14, 20, 16, 1, -14, 7, -14, 12, 24, 36, 15, -27, -21, 27, -11, 17, 18, 10, 39, 17, 14, -7, -30, -8, -7, -32, -25, 21, -8, -25, -14, -21, -34, -57, -105, -75, -56, -34, -66, -55, 8, 4 ],
	[ 3, 0, -17, -33, -32, -62, -45, -26, -37, -43, -55, -17, 7, 7, 10, -15, 11, -7, -18, -9, 6, 18, 13, 24, 32, -22, -37, -29, 9, 14, 13, 23, 16, 19, 6, 9, 0, 13, 21, 10, 21, -5, 32, 18, 28, 20, 32, 19, 14, 0, 9, 19, 9, 6, 13, 49, -41, 18, 3, 12, 19, -2, -20, -15, 6, 16, 36, 22, 31, 64, -51, 17, 9, 4, -7, -14, -16, -4, 15, 18, 6, -18, -17, 21, -8, -3, 2, 7, 18, 37, 31, 19, 39, 23, 4, -44, -65, -27, 36, 4, 27, 5, 11, 17, 15, 14, 26, 28, -1, -4, -46, -4, 31, 25, -1, 0, -36, -36, 4, 9, 35, 33, 0, 3, -44, -29, -44, 38, 27, -2, -32, -40, -13, 17, 25, 23, 13, -41, -77, -30, -19, -16, 8, -7, -19, -38, -26, 0, 26, 9, 3, -19, -81, -36, -7, 30, -1, -9, -25, 4, -8, 12, 18, 13, 15, -13, -32, -4, -7, 27, 63, 79, 49, 60, 31, 34, 38, 34, 22, 22, -54, -22, 4, 0, 32, 49, 39, 39, 35, 9, 8, 4, 2, 5, -3, 9 ],
	[ -4, -6, 9, -4, -14, -15, -13, 24, -41, 22, 48, 21, 2, 8, 3, 23, 27, -31, -10, -33, -49, -47, -5, 26, 18, 18, -15, -5, 7, 28, 31, 6, -12, -50, -27, -10, -19, -25, -17, -18, 10, 13, -28, -4, -6, -2, -33, -15, -10, 24, 15, 15, 8, 1, -4, -11, -12, -31, -16, -4, -27, -34, 13, 38, 27, 24, 33, 27, 51, 28, 28, -14, -24, -24, -51, -42, 33, 44, 11, 11, 30, 41, 92, 54, 6, 10, -30, -31, -24, -10, 25, 25, -6, -32, -57, -74, -25, 43, 26, -5, 3, -2, -23, -3, 16, 23, 0, -12, -8, -91, -16, -23, -3, -7, 15, -9, -34, -19, -8, 13, 27, -16, -27, -72, -18, 24, 31, -37, -1, 25, 9, 11, 21, 32, 8, -22, -68, -49, -1, 34, 18, -39, -22, 11, 2, 4, 22, 13, -6, -61, -87, -34, -11, -2, 13, -34, 2, 13, 12, 19, 21, -4, -48, -110, -43, -14, -10, 8, -11, 12, 12, -14, -6, 3, 17, -1, -49, -104, -42, -22, -5, 4, -4, 12, -26, -33, 12, 34, 49, 31, 38, 44, 28, 7, -8, 4 ],
	[ 8, 7, -2, -33, -27, -29, -27, 0, -37, -24, -22, -19, -9, 1, 8, -25, -18, -32, 3, -8, 6, 10, -8, -23, -19, 26, 7, -4, -9, -2, -18, -17, 8, 18, 19, 7, 16, -2, 15, -9, 27, 31, -47, -46, -23, -34, 0, 3, 0, 26, 6, 4, -2, -12, 31, 83, -54, -28, -16, -21, -15, 1, -1, 2, -18, -7, -7, -12, 18, 27, -33, -39, 16, 13, 26, 13, 3, -15, -16, -2, -8, -22, 4, 21, -31, -17, 30, 24, 40, -1, 11, 34, 15, 14, 30, 8, -20, -4, -19, 4, -2, 19, 14, -5, 24, 44, 27, -9, -9, -18, -28, 43, -36, 3, -24, 4, -13, 10, 20, 31, 17, -22, -23, -29, -3, 17, -38, -16, -19, 0, -11, 8, 20, 25, 10, 15, 18, -4, 15, 20, -11, 3, -9, 2, 15, 10, 0, 26, 21, 27, 16, 29, 23, -20, 8, -1, 4, -16, 18, 6, 0, -2, -12, 8, 32, 45, 45, -44, -1, -53, -57, -20, 1, -12, -15, -12, -2, 18, 26, 46, 23, -23, -3, 17, 28, 21, 15, -12, 4, 17, 7, -18, -1, -27, 12, 8 ],
	[ -9, 11, -7, -31, -31, -21, -29, -6, 2, -6, -13, -21, 1, 1, -8, -1, 8, 0, -36, -46, -55, -49, -20, 0, 40, 21, 9, 6, 8, 31, 13, 19, 2, 9, 4, -2, 13, 13, 8, 12, 34, 29, 53, 41, 43, 33, 47, 27, 19, -7, 3, 8, 10, 31, 23, 8, 43, 39, 60, 48, 39, 20, 13, -3, -4, 17, 19, 24, -12, 23, 18, 42, 31, 30, 21, 16, 25, -8, -16, 2, 24, 1, -23, -1, 33, 4, -18, -33, -12, 5, 21, -6, -15, 31, 15, -33, -16, 15, 7, 10, -55, -58, -48, -25, 3, 12, -8, 27, -8, -11, -2, 58, 6, 46, -25, -49, -42, -50, 5, -2, 19, 12, 7, 1, 25, 29, 9, 30, 48, -11, -15, -7, -20, -6, 6, 1, 14, 13, 14, 17, 14, -1, 18, 20, -9, -4, 6, 5, -8, -15, 7, 13, -8, -1, -7, 18, 11, 39, 26, 28, 13, 14, -16, -31, -23, 24, -7, -28, -5, 10, 10, 19, 12, 30, 33, 19, 21, 2, -6, 10, 17, -21, 2, -9, -9, -2, -7, -6, 12, -14, 0, 8, -22, -18, -5, 4 ],
	[ -11, -6, 10, -18, -20, 13, 2, -41, -29, -8, -4, -3, -9, -8, -2, -19, -42, -45, -13, -26, -15, -4, 3, -20, -1, -28, -3, 17, -8, -28, -21, -11, -17, -26, -7, -10, 1, -1, -6, 17, 42, 14, -11, 22, 14, 10, -9, -9, 2, -9, -15, -4, 8, 0, 30, 14, 36, 3, 20, 20, 9, 10, 26, 26, 24, 7, 1, 8, 30, -14, 50, 12, 16, 32, 22, 44, 33, -7, 10, 17, -4, -4, 3, 37, 43, 24, 21, 18, 5, 15, -22, -40, -32, 9, 4, 7, 6, 24, 13, -12, 19, -3, -21, -17, -18, -47, -45, -1, 16, 43, 43, 23, -22, 16, 15, -29, -38, -14, -43, -55, -5, 23, 23, 28, 20, 25, 27, -7, 2, -7, -30, -34, -58, -9, 22, 17, 6, 0, -11, -9, -8, 6, 24, 5, -1, -6, 13, 13, 5, -9, -23, -2, 9, 0, -10, -21, -9, 4, 5, 14, 24, 25, 22, 1, -23, -9, -5, 0, -1, 27, 9, -14, 21, 13, 19, 8, 20, -6, -5, 3, 24, 12, 6, 8, -26, -38, -5, 4, 31, 46, 57, 24, 30, 49, 18, 7 ],
	[ -11, 12, 21, 23, 28, 45, 39, 3, 31, 59, 45, 38, -6, 5, -5, 28, 41, 67, 29, 18, 14, 10, 11, 1, 30, 27, -5, -17, -6, 23, 18, 16, 3, 3, -6, -13, -36, -24, -33, -31, -42, -35, 35, 31, 5, -17, 6, 1, 3, 16, -3, -38, -47, -49, -53, -47, 19, 21, 6, -14, -15, -22, 20, 71, 5, -48, -53, -90, -93, -11, 8, 55, -5, -13, -18, 6, 44, 23, -32, -15, -12, -47, -96, -42, 9, 32, -9, -11, 9, 22, 12, -1, 10, 17, 0, -10, -49, -55, -10, 7, -6, -8, 20, 19, 2, 2, 6, 4, 26, 27, 4, -59, 6, -8, -7, -11, 29, 50, 15, -2, 4, 5, 2, 11, 9, -32, 45, -18, -35, -31, -7, 17, -1, -4, 4, -4, 3, 6, -34, 8, 23, -36, -51, -21, -24, -23, 1, 16, -1, 10, 3, -17, -25, 24, 8, -4, -48, -33, -20, 2, -1, 0, -14, -7, -24, -19, -26, -2, 2, -14, 8, -1, 13, 21, 16, 2, 21, 9, -4, -19, -2, 0, -10, 13, 10, 44, 73, 50, 32, 45, 64, 44, 47, 35, 20, 8 ],
	[ -2, 11, -5, -10, 14, 22, 6, 19, -37, 21, 18, -20, 10, -8, -12, -19, -28, -51, -14, -39, -10, -8, -51, -29, -29, 35, -4, -22, 7, -22, -16, -7, -6, -8, 13, 6, -10, -22, -10, -4, 21, 38, -22, 10, -12, -6, -19, 14, 3, -17, -11, 9, 18, 14, 14, 9, 4, 6, -10, -3, 12, 17, 3, 0, -16, 2, 10, -1, 27, 25, 19, -10, -13, -17, -4, 13, 30, 21, -5, -7, 11, 0, -20, -2, 35, 34, 0, 14, 13, 15, 19, 14, 21, 22, 53, 30, -29, -50, 22, 11, -8, 10, 43, 29, -5, 8, 5, 40, 17, -16, -68, -64, -20, -31, -45, -10, 44, 15, 13, 14, 0, 1, -11, -37, -76, -73, 45, -49, -45, -28, 10, -10, 2, 6, -15, -11, -25, -68, -54, 12, 4, -63, -29, -22, -20, -21, -14, -7, -3, -20, -32, -44, -30, -7, 11, -68, -3, 31, 13, 11, 0, 18, -3, -13, -25, -17, -19, -9, 6, -10, -11, 6, -1, 11, 13, 4, 9, -8, -31, -19, -47, -9, 1, -3, -45, -13, 21, -13, -20, -8, -2, -4, -2, 16, -9, -12 ],
	[ 6, -1, 4, -25, -19, -22, -25, 21, 1, -16, -31, -27, 2, 1, -10, 25, 20, 26, 11, -13, -5, 2, -17, 8, -6, -14, 18, 0, -14, 38, 47, 18, -7, -4, -20, -21, 15, 15, 8, 32, -5, -31, 52, 27, 49, 27, 6, -9, -37, -38, -5, 19, 23, 0, -19, 14, 38, 16, 30, 0, 9, 6, -25, -35, 18, 14, 7, -16, -101, -23, 12, 3, -19, -10, -2, -19, -58, 13, 20, -7, -28, -46, -18, -12, 16, -17, -34, -45, -46, -60, -14, 22, 3, -24, -18, -29, 27, 27, -7, 21, -5, -13, -18, -9, 38, 31, 15, 24, 29, 15, 32, 73, -13, 40, 18, 25, 4, -3, 35, 15, 10, 15, 20, 19, 51, 47, -28, 53, 26, 25, 16, -14, 4, 18, 21, 6, 3, 12, 19, 36, -13, 31, 1, 24, 3, -12, -3, 21, 19, -1, -2, -9, 0, 40, 11, 12, 24, -7, -12, 1, 0, 6, 5, 11, -9, -17, -30, 14, -8, 4, 0, -20, -24, -12, -4, -17, -12, -23, -26, -18, 12, 18, -2, 3, -25, -22, -44, -6, -47, -60, -23, -42, -54, -37, -12, -8 ],
	[ -4, -3, -19, -25, -34, -37, -49, 6, 22, -37, -17, -10, 2, -3, -11, 29, 15, 28, -4, 5, -10, -33, -21, -2, -23, -23, 8, -20, -5, 49, 29, 24, -4, -1, 1, -11, -19, -11, 2, -12, -20, -24, 52, 43, -6, -20, 3, 12, 33, 45, 12, -8, -8, -10, -35, -20, 7, 20, 23, 22, 10, 30, 22, 33, 14, 6, -12, -6, -57, 25, -2, 32, 19, 8, 10, -2, -10, 31, 33, 27, -14, -20, 7, 62, 6, -4, -33, -37, -27, -68, -37, 47, 28, 2, -22, -49, 15, 61, -9, 12, -56, -42, -43, -45, -15, 24, 24, -1, -28, -26, -22, 31, 34, 23, -3, -15, -5, -14, 11, 0, -13, -11, -14, -18, 0, 37, 16, 27, 10, 22, 16, 6, 16, 12, 3, 5, 10, 24, -4, 52, -28, 20, 18, 21, 26, -7, -15, -10, 0, 2, 19, 10, 31, -4, 17, 41, 30, 21, -13, -21, -6, 0, -9, 4, 15, 22, 17, -13, -3, -2, 21, 7, -20, -26, -15, 14, 6, 18, 22, 10, 18, 26, 8, 23, -3, 36, 69, 66, 51, 84, 67, 39, 65, 33, 23, -7 ],
	[ 9, 3, 0, -22, -23, -8, 7, 17, 32, -54, -52, -23, -3, -9, -9, 3, -24, -49, -2, -28, -22, -25, -14, -23, -59, -13, -4, 4, -2, -16, -52, -33, -30, -9, -3, -10, 6, 14, 6, -10, 16, 9, -49, -39, -58, -43, -32, -24, -8, -3, 7, 11, 10, 6, -5, -3, -30, -22, -50, -25, -21, 5, 13, 15, 25, 14, -9, 14, 60, 21, -19, -39, 5, 24, 9, 24, 14, -8, -14, 1, -8, 30, 64, 26, -37, -16, 18, 31, 18, -10, 10, -7, -29, -16, 6, 32, 51, 47, -15, 2, -11, 12, 18, 23, 28, -7, -4, -20, -21, -9, 23, 41, -28, -2, 5, 8, 12, 42, 5, 0, -2, -31, -14, -6, 14, 50, -27, -38, 16, 34, 24, 17, -3, -2, -14, -16, 0, 34, 18, -3, 22, -8, 14, 18, 17, 6, -9, -26, -12, 1, 26, 31, 21, 4, -9, -8, -6, -6, 11, 3, 11, -6, -3, 2, 21, 27, 25, -34, -9, -51, -60, -42, -23, -8, -3, -4, 3, 13, -10, 17, 44, -10, 2, 22, 14, 10, -25, -6, 8, -10, -6, -26, -8, -35, 14, 10 ],
	[ 7, 8, 9, -24, 27, 30, 25, -3, -26, 23, -4, -7, -12, -5, -5, -10, -8, -17, -58, -65, -45, -47, -32, -28, -32, -2, 12, -9, 2, -25, 15, 17, 2, -4, -4, -26, -19, -9, -39, -20, -5, -45, -31, -5, -3, 15, 18, -3, 3, 11, 18, -8, -10, 7, -35, -14, 12, -4, 14, 21, 9, -6, -6, 21, -2, -17, -25, -34, -20, -23, 41, -17, -3, 8, 3, 11, 5, 25, 24, -2, -35, -35, -61, -47, 35, 12, 0, 12, 18, 14, -9, 14, 37, 30, 22, -15, -72, -55, -13, 44, 9, -18, -15, -5, -17, 4, 42, 34, -9, -21, -47, -21, -10, -5, -28, -37, -40, -18, 2, 45, 28, -14, -28, -46, -38, 6, 31, -9, -34, -94, -76, -1, 46, 32, -18, -26, -41, -64, -19, 37, 25, -57, -55, -85, -54, 16, 22, 10, -7, -11, -23, -32, -2, 4, 14, -42, -53, -58, -25, -13, -9, 5, 13, 7, 6, -3, 14, 5, -6, -11, -21, -34, -37, -26, -37, -14, -4, 7, 10, 1, 1, 16, 2, 17, 29, 21, 27, -12, -24, 12, -2, 10, -4, 28, 12, -4 ],
	[ -4, 9, -4, 0, 26, 5, -11, 8, 51, -15, -2, 6, -4, 11, -12, 1, -24, 5, 12, 12, -2, -17, 1, 1, -12, 9, 2, 17, -7, -10, -1, -4, 20, 17, 14, -4, -12, -12, -19, -21, 4, -7, 26, 2, -3, 9, 30, 32, 30, 3, 0, 4, 5, 14, -2, 11, 50, 2, -1, 0, 14, 28, 44, 30, 41, 38, 40, 47, 20, 60, 17, -37, -4, -11, -23, -24, -15, -23, 11, -4, 1, 0, 2, 64, 46, -35, -16, -33, -37, -38, -53, -49, -25, -27, -33, -46, -27, 28, -10, -52, -64, -50, -20, 3, -17, -23, -22, -23, -27, -37, -7, 41, -8, -51, -29, -13, 13, 10, -2, -23, -7, -17, -11, -12, 12, 49, 2, -25, 0, 32, 10, 16, 22, 0, -6, -5, -14, -13, -15, 21, -7, -4, 5, 25, 13, 26, 26, 13, 3, 8, 16, 8, -3, 11, -8, -2, -9, 12, 12, 19, 14, 11, 2, 8, -2, 19, 9, -35, 8, -16, 10, 5, 5, 20, 30, 36, 38, 31, 9, 3, 42, -7, 5, -3, -40, -37, -14, -10, 8, 15, 15, 0, -30, -25, -9, -9 ],
	[ 7, -4, 5, 19, 35, 62, 49, -10, 16, 56, 54, 34, -1, -4, -5, 33, 7, 6, 27, 54, 23, 22, 21, 41, 30, 50, 33, 15, 6, -38, -36, 5, -1, 9, 0, 18, 34, 20, 14, 20, 28, 24, -50, -36, -13, -23, -10, -12, 2, 13, 5, -3, 1, 22, 36, 27, -19, -41, -41, -8, 1, 17, -11, -27, -6, -4, 10, -14, 50, -25, 0, -63, -42, -1, 31, 19, 5, -32, -23, -7, -4, -1, 40, -19, -5, -44, -20, 41, 35, 33, 4, -26, -27, 8, 1, 29, 14, -58, 5, -30, 8, 38, 31, 32, -3, -19, -8, 3, 13, 24, 39, -34, -33, -9, 7, 34, 33, 33, -27, -18, 33, 20, 19, 10, 9, -50, -28, -16, 25, 24, 23, 18, 7, 15, 30, 6, 0, -7, 1, -62, 9, -15, 5, -17, 15, 35, 32, 27, 15, -2, -10, -7, -28, -6, -19, 4, -25, -14, 7, 27, 26, 35, 28, -17, -18, -11, -21, 3, 8, 17, -12, -16, 2, -18, 5, 10, 8, -11, -27, -15, -18, -14, 0, 9, 4, -33, -59, -30, -12, -29, -15, -3, -49, -34, -14, -6 ],
	[ -11, -3, 1, 10, -3, 0, -8, -6, 56, -8, -30, -12, 1, -9, 2, -2, -9, 20, 54, 40, 49, 50, 29, 17, -19, -24, -10, -26, -10, -5, -13, 30, 9, 7, 35, 56, 50, 33, 2, -25, -45, 3, 35, -15, -11, -19, -15, -3, 1, 30, 52, 42, 24, -6, -50, -6, 41, -4, -23, -16, -14, -30, -44, -12, 45, 41, 34, 20, -48, -1, 14, -15, -43, -27, -32, -27, -66, -28, -6, 32, 52, 55, -67, -5, -23, -31, -25, -12, 0, -14, -29, -5, 1, 11, 27, -26, -49, -22, -1, -28, 12, 14, 7, -9, 8, 14, -3, -25, -18, -36, -58, 38, 31, 2, 12, 2, -2, 16, -4, -7, 4, -31, -51, -14, -8, 26, 29, -5, -2, 12, 15, -2, -16, -3, 10, -12, -18, 3, 31, 19, 28, 22, 21, 22, 7, 10, 13, 8, 3, 4, 6, -6, 14, 8, 6, 53, 10, 20, 29, 31, 16, 16, 5, 4, -21, 17, 22, -33, 10, 8, 8, 9, 12, 27, 31, -9, 16, 15, 36, 16, 43, 9, -1, 27, 9, 52, 60, 45, 35, 22, 9, 21, 72, -9, -11, 5 ],
	[ 6, 1, -2, 8, 23, 13, 27, 4, 40, 22, 26, 12, -9, 8, 8, 16, 24, 33, 37, 47, 37, 10, 13, 22, 9, -55, -1, 0, 15, 51, 30, 13, 19, 25, 13, -1, 17, 2, -16, -8, -48, -19, 19, 3, 12, -15, -20, -17, -15, -3, -14, 2, -18, 3, -18, 25, 5, 13, -2, -15, -20, -32, -20, 21, 17, -5, 0, 17, 7, -12, 2, 24, -18, -22, -17, -1, 18, 27, 28, 4, 3, 12, 6, 16, -16, 14, 4, 17, 30, 32, 24, 10, -14, -9, -25, -24, -29, 29, 25, 9, 22, -6, -8, -19, -18, -42, -17, 12, 17, 24, -13, -2, 25, 28, 15, -21, -70, -74, -39, -29, 10, 6, 11, -6, -22, 1, 14, 39, 21, 14, 14, 6, 31, 39, 14, -4, -23, -14, -11, -24, 25, 10, 11, 6, 31, 52, 49, 35, 10, -6, -25, 7, 8, 39, 10, 21, 1, -28, 19, 24, 11, 2, -3, 16, -2, -10, -36, 35, -8, 7, -1, -13, -9, -50, -50, -33, -7, -3, -1, -34, -5, 28, -11, 2, -25, -61, -80, -64, -65, -5, 1, 2, -13, -3, 5, -12 ],
	[ -6, 0, -3, -28, -35, -21, -34, -37, -23, -51, -45, -36, -6, 0, 2, -15, -40, -58, -70, -75, -112, -110, -30, 1, -14, -24, -24, -8, 0, -14, -22, -43, -50, -39, -47, -56, -38, -32, -40, -1, -18, -22, -2, 47, 9, -4, 7, -12, -13, -14, -14, -11, 10, 6, -8, 32, 6, 39, -8, -9, 5, 18, 32, 19, 21, 13, 9, 14, 13, 18, -2, 3, -21, 1, 19, 33, 29, 13, 3, 6, 1, -1, 9, 17, 8, -5, -14, 32, 30, 30, -4, 14, 6, -12, -22, -22, -12, 20, 33, 46, 16, 30, 37, 24, 19, 2, 42, 8, 14, 4, -2, 10, 16, 6, -2, 5, 32, 36, 19, 23, 27, 3, 15, 23, -27, -21, -16, 2, -42, -46, -59, -52, -42, -1, -14, -24, -5, -33, -55, -1, -3, -29, -45, -65, -58, -55, -32, -14, -6, -26, -35, -36, 33, -5, 4, 1, -24, -2, 8, 9, -13, -15, -16, -41, -29, -17, 48, -8, 1, 15, 66, 34, 37, 6, -2, -6, 10, -8, 25, 43, 37, 5, -9, 19, 44, 35, 11, 22, 27, 50, 61, 19, 51, 39, -26, -5 ],
	[ -3, 3, 24, 19, 43, 71, 72, 54, 69, 60, 40, 34, 4, -4, -8, 26, 5, 36, 36, 34, 55, 37, 12, 5, 8, 42, 7, 13, 2, -11, 18, 3, 23, -14, -4, -1, -16, -1, 6, -18, 12, 60, 8, 10, 22, 20, -2, -14, -18, -14, -13, -15, 3, 9, -3, 5, 22, 34, 48, 11, 10, 2, -1, -7, -22, -23, -18, -14, -19, 5, 50, -5, 29, 37, 38, 8, -9, 14, -21, 5, 3, 2, 25, 15, 31, 26, -2, 5, 1, -46, -41, 5, -9, 3, -14, -1, 65, -5, 17, 18, -8, -28, -70, -53, 35, 26, -23, -4, -21, 13, 41, 8, 12, 7, -15, -60, -54, 33, 63, 17, 2, -8, 1, 16, 19, 13, 5, -29, -82, -67, 3, 43, 36, 24, 23, 22, 6, -12, -20, 23, -14, -25, -71, -14, 16, 28, 27, 32, 17, 27, 6, -39, -23, 11, 16, -21, 10, -17, -13, -11, 20, 20, 17, -3, -7, -29, -18, 7, 3, -22, -23, -22, -3, -8, -10, -1, -11, -2, 4, -9, -5, 7, 1, -14, -9, 6, 9, -15, -34, -25, -31, -2, -40, -36, 4, -11 ],
	[ -1, -2, 8, 4, 17, 15, 17, -11, 11, -3, 7, 6, 5, 5, -7, 7, 17, 13, 16, 18, 12, -16, 7, -10, -2, -26, 3, -6, 11, 17, 27, 16, 11, 22, 6, -12, -11, -14, -7, -20, -23, 22, 33, 37, 12, 0, 5, 25, 30, 38, 25, 14, 6, -4, -9, -19, 21, 25, 8, 8, 21, 29, 23, 30, 35, 28, 12, 12, 7, -8, 31, 52, 13, 2, 5, -6, 19, 8, 19, 8, 5, 29, 16, 7, 0, 36, -12, -12, -15, -23, -9, 10, 2, -3, -18, 7, 10, -4, 5, -13, -15, 12, 4, 10, -12, -12, -15, 19, 30, 15, 4, -38, 27, -23, 29, 18, 18, -12, -7, -34, -10, 6, 9, 9, -17, -28, 42, 2, -4, 9, -6, -23, -27, -25, 3, 9, 11, 12, -32, -13, 18, -8, 5, 13, -11, -13, -17, -9, -11, -6, -7, -14, -31, -15, 11, 7, -8, 16, -1, 0, 7, 5, 2, -16, -28, -2, -24, -18, 9, 25, 70, 44, 34, 24, 25, 35, 28, -9, -1, -23, -17, -33, -3, -10, 2, 44, 90, 81, 73, 65, 52, 69, 56, 66, 10, 3 ],
	[ 1, -10, -13, -28, -21, -4, -15, -9, 13, -54, -56, -28, -6, 6, 4, -18, -36, -33, -31, -10, -20, -14, -20, -25, -42, -2, -4, -19, -16, -18, -4, -7, -18, -8, -7, -7, 19, 23, 8, -1, -38, -22, -50, 2, 9, -2, -23, -4, 10, 0, 5, 17, 19, 12, -27, -83, 4, 17, 19, -13, -7, -7, -12, 7, 6, 24, 19, 14, -36, -49, 7, 7, 8, 2, -6, -14, -12, -60, -16, 16, 23, 5, -43, -68, -4, 3, 8, 15, -5, -12, -27, -63, -55, -1, 1, 16, 8, -20, -13, 12, 14, 38, 24, -26, -22, -43, -34, 35, 43, 11, 16, 57, -17, -20, 24, 26, 27, 19, 2, -24, 40, 57, 32, -8, -6, 57, 14, -4, 12, 35, 22, 28, -2, 17, 47, 34, -4, -6, -30, 41, 23, 23, 10, 9, -9, 3, 8, 11, 17, 9, -7, 2, 16, 17, 12, 15, -27, 17, 6, 20, 8, 13, 2, 24, 29, 33, 13, -23, 11, -51, -39, -19, -17, -8, -1, -13, -37, -30, 8, 34, 30, 7, 8, -5, 36, 45, 26, -13, -14, -30, -68, -38, 14, 2, 13, -4 ]
)


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


# Test input data
test_data_digits = {
	"test_data_zero" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42, 115, 88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 42, 123, 118, 103, 55, 0, 0, 0, 0, 0, 0, 0, 0, 57, 127, 101, 123, 52, 106, 0, 0, 0, 0, 0, 0, 0, 31, 122, 91, 11, 18, 0, 125, 27, 0, 0, 0, 0, 0, 8, 117, 47, 6, 0, 0, 0, 127, 49, 0, 0, 0, 0, 0, 65, 101, 0, 0, 0, 0, 0, 127, 43, 0, 0, 0, 0, 0, 84, 60, 0, 0, 0, 1, 66, 92, 2, 0, 0, 0, 0, 0, 85, 46, 0, 0, 14, 88, 74, 0, 0, 0, 0, 0, 0, 0, 84, 113, 65, 96, 116, 65, 7, 0, 0, 0, 0, 0, 0, 0, 32, 111, 127, 83, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_one" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70, 71, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70, 79, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68, 97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 127, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 124, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 48, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_two" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 56, 64, 64, 35, 10, 2, 0, 0, 0, 0, 0, 0, 0, 85, 127, 127, 127, 127, 119, 114, 93, 7, 0, 0, 0, 0, 0, 105, 110, 79, 105, 122, 127, 127, 127, 117, 8, 0, 0, 0, 0, 0, 0, 0, 0, 13, 29, 66, 115, 127, 41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 107, 120, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 82, 126, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43, 107, 125, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 71, 122, 111, 37, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 121, 127, 89, 43, 41, 9, 1, 0, 0, 0, 0, 0, 0, 10, 100, 124, 127, 127, 127, 120, 88, 0, 0, 0, 0, 0, 0, 0, 0, 19, 34, 64, 47, 12, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_three" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 19, 64, 63, 63, 23, 0, 0, 0, 0, 0, 0, 0, 28, 109, 123, 127, 126, 126, 115, 9, 0, 0, 0, 0, 0, 0, 14, 70, 48, 33, 42, 123, 116, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 125, 83, 0, 0, 0, 0, 0, 0, 0, 4, 40, 48, 101, 126, 106, 30, 0, 0, 0, 0, 0, 0, 0, 67, 127, 127, 127, 127, 63, 0, 0, 0, 0, 0, 0, 0, 0, 4, 22, 11, 11, 83, 82, 0, 0, 0, 0, 0, 0, 0, 10, 1, 0, 0, 12, 104, 82, 0, 0, 0, 0, 0, 0, 34, 118, 39, 34, 45, 105, 118, 49, 0, 0, 0, 0, 0, 0, 32, 114, 126, 126, 116, 84, 20, 0, 0, 0, 0, 0, 0, 0, 0, 14, 61, 34, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_four" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 39, 5, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 86, 10, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 27, 103, 0, 0, 0, 0, 22, 107, 0, 0, 0, 0, 0, 0, 59, 77, 0, 0, 0, 0, 41, 90, 0, 0, 0, 0, 2, 34, 120, 42, 0, 0, 0, 0, 40, 108, 54, 66, 87, 95, 93, 58, 127, 5, 0, 0, 0, 0, 0, 39, 46, 46, 20, 0, 0, 35, 113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 91, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_five" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 48, 95, 127, 127, 103, 0, 0, 0, 0, 0, 0, 0, 0, 40, 119, 95, 71, 56, 32, 0, 0, 0, 0, 0, 0, 64, 48, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 119, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 48, 127, 103, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 56, 119, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 103, 48, 0, 0, 0, 0, 0, 0, 0, 0, 64, 95, 64, 103, 119, 16, 0, 0, 0, 0, 0, 0, 0, 0, 111, 111, 103, 64, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_six" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35, 123, 94, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 126, 83, 109, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 119, 97, 7, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 84, 120, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 121, 86, 37, 49, 29, 0, 0, 0, 0, 0, 0, 0, 0, 53, 127, 110, 118, 102, 124, 27, 0, 0, 0, 0, 0, 0, 0, 57, 127, 116, 24, 14, 127, 46, 0, 0, 0, 0, 0, 0, 0, 57, 116, 40, 1, 82, 121, 11, 0, 0, 0, 0, 0, 0, 0, 24, 124, 90, 92, 127, 42, 0, 0, 0, 0, 0, 0, 0, 0, 0, 34, 96, 98, 61, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_seven" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 12, 46, 61, 73, 16, 0, 0, 0, 1, 0, 0, 0, 29, 91, 119, 82, 53, 127, 50, 0, 0, 0, 0, 0, 0, 0, 36, 60, 13, 10, 108, 91, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 108, 96, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 103, 91, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 98, 103, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70, 98, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_eight" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 42, 54, 30, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 127, 111, 108, 97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 57, 116, 3, 21, 122, 68, 0, 0, 0, 0, 0, 0, 0, 0, 57, 125, 74, 120, 123, 56, 0, 0, 0, 0, 0, 0, 0, 0, 63, 127, 127, 72, 4, 0, 0, 0, 0, 0, 0, 0, 4, 58, 123, 107, 27, 0, 0, 0, 0, 0, 0, 0, 0, 6, 95, 127, 117, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70, 90, 31, 98, 81, 0, 0, 0, 0, 0, 0, 0, 0, 12, 122, 40, 21, 126, 54, 0, 0, 0, 0, 0, 0, 0, 0, 20, 124, 116, 123, 96, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35, 64, 55, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
	"test_data_nine" : [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 63, 38, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 81, 110, 77, 127, 27, 0, 0, 0, 0, 0, 0, 0, 23, 113, 34, 1, 68, 101, 1, 0, 0, 0, 0, 0, 0, 0, 58, 52, 0, 17, 117, 65, 0, 0, 0, 0, 0, 0, 0, 0, 59, 118, 92, 104, 127, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 31, 75, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 110, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 104, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 69, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 118, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 30, 0, 0, 0, 0, 0, 0, 0, 0 ]
}


# Convert to bipolar ints and display in SV format
# Conversion is just +128 for for signed int8 to bipolar probability

def get_L2_biases():
	# L2 Bias array
	print("reg [7:0] B_ARRAY_L2 [0:NUM_NEURS-1] = '{ ", end='')
	for val in B_ARRAY_L2:
		val_bi_int_scaled = int((val/256)+128)
		print(f"{val_bi_int_scaled}, ", end='')
	print(" };")

def get_L2_weights():
	# L2 Weights array
	print("reg [7:0] W_ARRAY_L2 [0:NUM_NEURS-1][0:NUM_INPS-1] = '{ ", end='')
	for val_arr in W_ARRAY_L2:
		print("{ ", end='')
		for val in val_arr:
			print(f"{val+128}, ", end='')
		print(" }")
	print(" };")


def get_L3_biases():
	# L3 Bias array
	print("reg [7:0] B_ARRAY_L3 [0:NUM_NEURS-1] = '{ ", end='')
	for val in B_ARRAY_L3:
		val_bi_int_scaled = int((val/8192)+128)
		print(f"{val_bi_int_scaled}, ", end='')
	print(" };")

def get_L3_weights():
	# L3 Weights array
	print("reg [7:0] W_ARRAY_L3 [0:NUM_NEURS-1][0:NUM_INPS-1] = '{ ", end='')
	for val_arr in W_ARRAY_L3:
		print("{ ", end='')
		for val in val_arr:
			print(f"{val+128}, ", end='')
		print(" }")
	print(" };")


def get_test_data():
	# Input data array

	for var_name, vals in test_data_digits.items():
		print(f"logic [7:0] {var_name} [0:NUM_INPS-1] = '{{ ", end='')
		for val in vals:
			print(f"{val+128}, ", end='')
		print(" };")


############## 16-bit #####################
###########################################
def get_test_data_16bit():
	# Input data array

	for var_name, vals in test_data_digits.items():
		print(f"logic [15:0] {var_name} [0:NUM_INPS-1] = '{{ ", end='')
		for val in vals:
			print(f"{(val+128)*256}, ", end='')
		print(" };")

def get_L2_biases_16bit():
	# L2 Bias array
	print("reg [15:0] B_ARRAY_L2 [0:NUM_NEURS-1] = '{ ", end='')
	for val in B_ARRAY_L2:
		val_bi_int_scaled = int(val+32768)		# Because ((val/256) + 128)*256 = val + 128*256 = val+32768
		print(f"{val_bi_int_scaled}, ", end='')
	print(" };")

def get_L2_weights_16bit():
	# L2 Weights array
	print("reg [15:0] W_ARRAY_L2 [0:NUM_NEURS-1][0:NUM_INPS-1] = '{ ", end='')
	for val_arr in W_ARRAY_L2:
		print("{ ", end='')
		for val in val_arr:
			print(f"{(val+128)*256}, ", end='')
		print(" }")
	print(" };")
#############################################################################
#############################################################################



#get_L2_biases()
#get_L3_biases()
#get_L2_weights()

#get_test_data()

#get_test_data_16bit()
get_L2_biases_16bit()
#get_L2_weights_16bit()

L2_weights_list = []
for li in W_ARRAY_L2:
	for val in li:
		L2_weights_list.append(val)
#plt.hist(L2_weights_list)
#plt.show()