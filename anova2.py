import json
import numpy as np
import os
import pandas as pd


with open('data.json', 'r') as f:
    data = json.load(f)

factors = ['movement_of_nodes', 'no_of_nodes', 'traffic']

# Create a dataframe with the data
array1 = np.array([data[factors[0]]['15_static_tcp.txt']['packet_loss'], data[factors[0]]['15_random_tcp.txt']['packet_loss'], data[factors[0]]['15_deterministic_tcp.txt']['packet_loss']])
array_1 = array1.transpose()

array2 = np.array([data[factors[0]]['15_static_tcp.txt']['delay'], data[factors[0]]['15_random_tcp.txt']['delay'], data[factors[0]]['15_deterministic_tcp.txt']['delay']])
array_2 = array2.transpose()

array3 = np.array([data[factors[0]]['15_static_tcp.txt']['throughput'], data[factors[0]]['15_random_tcp.txt']['throughput'], data[factors[0]]['15_deterministic_tcp.txt']['throughput']])
array_3 = array3.transpose()

df_movements_of_nodes = [array_1, array_2, array_3]


array1 = np.array([data[factors[1]]['5_random_tcp.txt']['packet_loss'], data[factors[1]]['10_random_tcp.txt']['packet_loss'], data[factors[1]]['15_random_tcp.txt']['packet_loss'], data[factors[1]]['20_random_tcp.txt']['packet_loss']])
array_1 = array1.transpose()

array2 = np.array([data[factors[1]]['5_random_tcp.txt']['delay'], data[factors[1]]['10_random_tcp.txt']['delay'], data[factors[1]]['15_random_tcp.txt']['delay'], data[factors[1]]['20_random_tcp.txt']['delay']])
array_2 = array2.transpose()

array3 = np.array([data[factors[1]]['5_random_tcp.txt']['throughput'], data[factors[1]]['10_random_tcp.txt']['throughput'], data[factors[1]]['15_random_tcp.txt']['throughput'], data[factors[1]]['20_random_tcp.txt']['throughput']])
array_3 = array3.transpose()

df_no_of_nodes = [array_1, array_2, array_3]

# print(data[factors[2]]['15_random_udp.txt'])
array1 = np.array([data[factors[2]]['15_random_udp.txt']['packet_loss'], data[factors[2]]['15_random_tcp.txt']['packet_loss']])
array_1 = array1.transpose()

array2 = np.array([data[factors[2]]['15_random_udp.txt']['delay'], data[factors[2]]['15_random_tcp.txt']['delay']])
array_2 = array2.transpose()

array3 = np.array([data[factors[2]]['15_random_udp.txt']['throughput'], data[factors[2]]['15_random_tcp.txt']['throughput']])
array_3 = array3.transpose()

df_traffic = [array_1, array_2, array_3]

# print(df_movements_of_nodes[2])
# print(df_no_of_nodes[2])
print(df_traffic[2])
# df_movement_of_nodes = []
# df = pd.DataFrame(data, columns=factors)