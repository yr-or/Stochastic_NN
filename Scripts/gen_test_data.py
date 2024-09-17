import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt

(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

# Get first 100 digits

####### Helper functions #########
def quantize_nbit(data, n_bit, use_scale=0, verbose=0):
    max_bit_val = (2**(n_bit-1))-1
    max_val     = np.max(np.abs(data))
    if use_scale > 0:
        scale = use_scale
    else :
        scale   = max_bit_val / max_val
    if verbose:
        print('Quantizing to +/- {}, scaling by {}'.format(max_bit_val, scale))

    out_int = np.around(data * scale)
    out = out_int /  scale

    return out, out_int, scale
#####################################

################## Get data from dataset ####################
# Write data out in the form
# logic signed [7:0] data [0:N-1] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 4, 0, 0, 0, 0, 53, 0, 0, 0, 0, 0, 0, 0, 82, 9, 0, 0, 0, 0, 95, 0, 0, 0, 0, 0, 0, 26, 98, 0, 0, 0, 0, 20, 102, 0, 0, 0, 0, 0, 0, 56, 73, 0, 0, 0, 0, 39, 86, 0, 0, 0, 0, 1, 32, 114, 40, 0, 0, 0, 0, 38, 103, 51, 63, 83, 91, 89, 55, 121, 4, 0, 0, 0, 0, 0, 36, 44, 44, 19, 0, 0, 33, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42, 77, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42, 87, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
def get_test_data(n_bit, data, show_img=0):
    # Get the data from the model layer

    # Input data - Flatten into 1-d vector
    m_output = data.reshape(1, np.prod(data.shape))
    m_output = m_output[0]

    # check the output shape is 1D
    if m_output.shape[0] != m_output.size:
        print('Error: Model output is not 1D. Check the model and layer requested')

    # Show the image if requested
    if show_img:
        plt.subplot(111)
        dim=int(np.sqrt(m_output.size))
        plt.imshow(m_output.reshape(dim,dim), cmap='Greys')
        plt.show()

    # Quantize
    data_q, data_qi, scale = quantize_nbit(m_output, n_bit)

    # Print this array
    arr = [int(x) for x in data_qi]
    #print(arr)

    return arr
############################################################

################ Run code ################
DISPLAY = 0

## Create list of 100 digits and labels
data_list = []
data_list_int8 = []
label_list = []

for i in range(100):
    data_arr_int8 = get_test_data(8, x_train[i], 0)
    label = y_train[i]

    # AveragePool
    data_arr_avg = np.zeros((14,14))
    for col in range(0, 28, 2):
        for row in range(0, 28, 2):
            ind = row*28 + col
            avg = np.round((data_arr_int8[ind] + data_arr_int8[ind+1] + data_arr_int8[ind+28] + data_arr_int8[ind+29])/4)
            data_arr_avg[int(row/2)][int(col/2)] = avg

    ### DEBUG ###
    if DISPLAY:
        plt.subplot(111)
        plt.imshow(data_arr_avg, cmap='Greys')
        plt.show()

    # Flatten into 1D array
    data_avg_int8 = data_arr_avg.reshape(1, 196).flatten().tolist()
    data_avg_int8 = [int(x) for x in data_avg_int8]

    # Add 8-bit value to list
    data_list_int8.append(data_avg_int8)

    # Convert to bipolar int16 array
    data_arr_bi_int16 = [(x+128)*256 for x in data_avg_int8]

    # Add to list
    data_list.append(data_arr_bi_int16)
    label_list.append(label)

def write_bi16():
    ## Print data to file in verilog format
    with open("test_data_2.txt", 'w+') as f:
        for digit in data_list:
            digit_str = str(digit)[1:-1]
            f.write("{ " + digit_str + " },\n")

        # Write labels to end of file
        labels_str = str(label_list)[1:-1]
        f.write( "labels = [ " +  labels_str + " ]\n")


def write_int8():
    ## Print data to file in verilog format
    with open("test_data_2_int8.txt", 'w+') as f:
        for digit in data_list_int8:
            digit_str = str(digit)[1:-1]
            f.write("{ " + digit_str + " },\n")

        # Write labels to end of file
        labels_str = str(label_list)[1:-1]
        f.write( "labels = [ " +  labels_str + " ]\n")

write_int8()