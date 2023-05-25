import numpy as np
import pandas as pd
import os
import json

paths = ['movement_of_nodes','no_of_nodes','traffic']

data_dict = {}

res = []
for path in paths:
    ins = []
    print(path)
    data_dict[path] = {}
    for file in os.listdir(path):
        data_dict[path][file] = {}
        data_dict[path][file]["packet_loss"] = []
        data_dict[path][file]["delay"] = []
        data_dict[path][file]["throughput"] = []
        if file[-1]=='t':
            print(file)
            # Read the file line by line
            with open(os.path.join(path,file)) as f:
                content = f.readlines()
            # Remove whitespace characters like `\n` at the end of each line
                content = [x.strip() for x in content]
                # Remove empty strings
                content = list(filter(None, content))
                # Remove the first line
                # content = content[1:]
                for iter in range(len(content)):
                    if (iter%3==0):
                        data_dict[path][file]["packet_loss"].append(float(content[iter]))
                    elif (iter%3==1):
                        data_dict[path][file]["delay"].append(float(content[iter]))
                    else:
                        data_dict[path][file]["throughput"].append(float(content[iter]))

# send data_dict to json
with open('data.json', 'w') as fp:
    json.dump(data_dict, fp)