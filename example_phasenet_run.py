import os, sys
import numpy as np
import matplotlib.pyplot as plt
import obspy
import requests



PHASENET_API_URL = "http://34.221.45.133"

import obspy
obspy_stream = obspy.read()

## plot the stream
fig, ax = plt.subplots(3, 1, figsize=(10, 6))
for itr, tr in enumerate(obspy_stream):
    ax[itr].plot(tr.times(), tr.data, label=tr.id)
plt.savefig('stream.png')
plt.close()

## Extract 3-component data
stream = obspy_stream.sort()
assert(len(stream) == 3)
data = []
for trace in stream:
    data.append(trace.data)
data = np.array(data).T
assert(data.shape[-1] == 3)
data_id = stream[0].get_id()[:-1]
timestamp = stream[0].stats.starttime.datetime.strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3]

req = {"id": [[data_id]],
    "timestamp": [timestamp],
    "vec": [data.tolist()]}



# Predict P/S-phase picks using PhaseNet
resp = requests.post(f'{PHASENET_API_URL}/predict', json=req)
print('Picks', resp.json())


# Get both picks and prediction

resp = requests.post(f'{PHASENET_API_URL}/predict_prob', json=req)
# print(resp)

picks, preds = resp.json() 
preds = np.array(preds)
# print('Picks', picks)


# fig, ax = plt.subplots(3, 1, figsize=(10, 6))
# for itr in range(3):
#     ax[itr].plot(data[:,itr], label='Data')
#     ax[itr].plot(preds[0, :, 0, itr+1], label='Picks')
#     ax[itr].legend()
# plt.savefig('picks.png')


plt.figure()
plt.subplot(211)
plt.plot(data[:,-1], 'k', label="Z")
plt.subplot(212)
plt.plot(preds[0, :, 0, 1], label="P")
plt.plot(preds[0, :, 0, 2], label="S")
plt.legend()
plt.show();