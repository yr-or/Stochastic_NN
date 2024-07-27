"""
For testing various parts of weights and biases in L3
"""

import matplotlib.pyplot as plt
import numpy as np

def bipolar_to_prob(y):
    return (y+1)/2

def prob_to_bipolar(x):
    return (2*x)-1

def bipolar_to_prob_int8(y):
    return int(bipolar_to_prob(y)*256)

def prob_int8_to_bipolar(x):
    return prob_to_bipolar(x/256)

def bipolar_to_prob_int16(y):
    return int(bipolar_to_prob(y)*65536)

def prob_int16_to_bipolar(x):
    return prob_to_bipolar(x/65536)

def prob_int16_to_unipolar(x):
    return x/65536


W_ARRAY_L3_int16_bipolar = (
        [ 39680, 29696, 24576, 31488, 23552, 30976, 33280, 29952, 29440, 23808, 40448, 33536, 22528, 25088, 34816, 24576, 28416, 43008, 38656, 34560, 16896, 23808, 37632, 39936, 29696, 38912, 37376, 32768, 24832, 34048, 39424, 38656 ],
        [ 51712, 53248, 42240, 31744, 23552, 23552, 41472, 27136, 29440, 48896, 24576, 22016, 44032, 24832, 32000, 36352, 23552, 34560, 35328, 39936, 39680, 39680, 35328, 37632, 21760, 17152, 33792, 34816, 28160, 37888, 19968, 20736 ],
        [ 26112, 29184, 33792, 54016, 35840, 27904, 27136, 36608, 37888, 38400, 38400, 30208, 30976, 21760, 3840, 35584, 41216, 33280, 28160, 23552, 40704, 40192, 40192, 33792, 48128, 26368, 43008, 33024, 32768, 38656, 27392, 37632 ],
        [ 25344, 32768, 30720, 32256, 37632, 30464, 38656, 28160, 33536, 33536, 34304, 35072, 38400, 40192, 25344, 28416, 39168, 28928, 40704, 25344, 37120, 39936, 28160, 14848, 28928, 26368, 40448, 46848, 33792, 25600, 38912, 24832 ],
        [ 40960, 5632, 11776, 28416, 26368, 24064, 24064, 43520, 34048, 29952, 18176, 37376, 43520, 42240, 25344, 38656, 38912, 22528, 23808, 37120, 38656, 22272, 31488, 38912, 24320, 34048, 7168, 18432, 41984, 15872, 19712, 42752 ],
        [ 21504, 48384, 44032, 29952, 13568, 36864, 29952, 23296, 25600, 20736, 24576, 36864, 28160, 33792, 48128, 34048, 34304, 40960, 16640, 29184, 33536, 27648, 35072, 13824, 40960, 37120, 20224, 38144, 42752, 27136, 28672, 21760 ],
        [ 37632, 27904, 39424, 34304, 45312, 25088, 33792, 26112, 37376, 37376, 15872, 40704, 18944, 24576, 34048, 35072, 6912, 24064, 41472, 35072, 35840, 8192, 30720, 36608, 25088, 40448, 16384, 29952, 5632, 40192, 27136, 31488 ],
        [ 41984, 23040, 24320, 34816, 41984, 31744, 15872, 27392, 28160, 54016, 41984, 26368, 28416, 32768, 37120, 25344, 35840, 40448, 33024, 40448, 36352, 36864, 26112, 38400, 40448, 24064, 29440, 22784, 40448, 34816, 38144, 30976 ],
        [ 17920, 13568, 27648, 14080, 20480, 41984, 36352, 36096, 36096, 21504, 26112, 36096, 31744, 34816, 31744, 37376, 39168, 15616, 19200, 39424, 28160, 29952, 39424, 33024, 32000, 34304, 33280, 20992, 17920, 39168, 37376, 20480 ],
        [ 26880, 32768, 25600, 10240, 36096, 33792, 33024, 39424, 19968, 11008, 38912, 35328, 19456, 36352, 37120, 38912, 28928, 34560, 32512, 34048, 7936, 40448, 34560, 39424, 256, 28928, 36352, 27648, 41216, 7680, 34816, 41984 ]
    )

B_ARRAY_L2_bipolar_int16 = [32773, 32768, 32768, 32772, 32774, 32774, 32767, 32768, 32769, 32777, 32764, 32774, 32770, 32776, 32782, 32786, 32765, 32778, 32765, 32775, 32776, 32773, 32774, 32778, 32771, 32781, 32758, 32764, 32790, 32766, 32760, 32770]


### FInd number of duplicated in weights ###
from collections import Counter
from itertools import chain

W_ARRAY_L3_flat = list(chain.from_iterable(W_ARRAY_L3_int16_bipolar))

counter = Counter(W_ARRAY_L3_flat)
occurs = sorted(counter.items(), key=lambda item: item[1], reverse=True)
for value, count in occurs:
    print(f"Value {value} has {count} occurrence(s)")

# Remove single occurances
duplicates = {key: value for key, value in counter.items() if value>1}

num_duplicates = sum(duplicates.values()) - len(duplicates)
print(f"Num duplicates = {num_duplicates}")
print(f"Num unique values = {len(W_ARRAY_L3_flat) - num_duplicates}")

## Generate unqiue weights vector in descending order
weights_uniq = [x[0] for x in occurs]
print(weights_uniq)

# Generate indexes in weights_uniq for each value in W_ARRAY_L2 2D array
ind_arr_L2 = []
for row in W_ARRAY_L3_int16_bipolar:
    ind_row = []
    for val in row:
        ind_row.append( weights_uniq.index(val) )
    ind_arr_L2.append(ind_row)
print(ind_arr_L2)

# Confirm that every value in W_ARRAY_L2_int16_bipoalar is in weights_uniq
for row in W_ARRAY_L3_int16_bipolar:
    for val in row:
        if val not in weights_uniq:
            print("ERROR")

# Print in verilog array form
"""
print("'{ ")
for row in ind_arr_L2:
    print("{", end="")
    for val in row:
        print(f"{val}, ", end="")
    print("},")
print("};")
"""
