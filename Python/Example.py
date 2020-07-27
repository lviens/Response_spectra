#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 27 09:55:02 2020

@author: Loic Viens
Example to compute the response spectra from acceleration waveforms. The data are from the 2011 Mw 9.0 Tohoku-Oki earthquake recorded at the TKYH12 KiK-net station.

- Resp_type: Response type, choose between:
             - 'SA'  : Acceleration Spectra
             - 'PSA' : Pseudo-acceleration Spectra
             - 'SV'  : Velocity Spectra
             - 'PSV' : Pseudo-velocity Spectra
             - 'SD'  : Displacement Spectra
"""

from obspy import read
import numpy as np
import matplotlib.pyplot as plt
from RS_function import RS_function

#%% Parameters of the response spectra
Resp_type = 'SA' # See above for the different options
T = np.concatenate( (np.arange(0.05, 0.1, 0.005) , np.arange (0.1, 0.5, 0.01) , np.arange (0.5, 1, 0.02) , np.arange (1, 5, 0.1), np.arange (5, 15.5, .5) ) ) # Time vector for the spectral response
freq = 1/T # Frequenxy vector
xi = .05 # Damping factor

#%%
# Components of the ground motion
components = ['NS2', 'EW2', 'UD2']

# Define size of the output response spectra matrix
Sfin = np.zeros((3, len(T)))

# Loop over the NS, EW, and UD components, read the KiK-net data and compute the response spectra.
data_s = []
for i in np.arange(  len(components)):
    data = read('../Data/TKYH121103111446.' + components[i] )
    data.detrend(type = 'constant') # Remove mean
    data.detrend(type = 'linear') # Remove trend
    dt = round(data[0].stats.delta,3) # Get dt sampling rate in seconds
    data_s.append(data[0].data*3920/6170801) # Scale the data 
    delta = 1/dt
    Sfin[i] = RS_function(data[0].data*3920/6170801, delta, T, xi, Resp_type = Resp_type)

#%% Plot the data
t = np.linspace(0, len(data_s[0])*dt, len(data_s[0])) # Time vector 

# Plot time series
fig = plt.figure(figsize = (6,10))
plt.subplot(3,1,1)
for i in np.arange(len(components)):
    plt.plot(t,data_s[i] + (i-1) * 200, label = components[i]) 
plt.grid()
plt.title('2011/03/11 - 14:46, Mw 9.0 Tohoku-Oki Earthquake\n' 'TKYH12 KiK-net station' )
plt.legend(loc = 1)
plt.ylabel('Acceleration (cm/s/s)')
plt.xlabel('Time (s)')
plt.xlim(t[0], t[-1])


# Plot response spectra with period axis
plt.subplot(3,1,2)
for i in np.arange(len(components)):
    plt.semilogy(T, Sfin[i], linewidth = 2, label = components[i])
plt.grid()
plt.title('Damping: ' + str(xi*100) + ' %' )
plt.legend(loc = 1)
if Resp_type == 'SA':
    plt.ylabel('Acceleration response (cm/s/s)')
elif  Resp_type == 'SV':
    plt.ylabel('Velocity response (cm/s)')
else:
    plt.ylabel(Resp_type)
plt.xlabel('Period (s)')
plt.xlim(T[0],T[-1])

# Plot response spectra with frequency axis
plt.subplot(3,1,3)
for i in np.arange(len(components)):
    plt.semilogy(freq, Sfin[i], linewidth = 2, label = components[i])
plt.grid()
plt.xlim( freq[-1],freq[0])
plt.legend(loc = 4)
if Resp_type == 'SA':
    plt.ylabel('Acceleration response (cm/s/s)')
elif  Resp_type == 'SV':
    plt.ylabel('Velocity response (cm/s)')
else:
    plt.ylabel(Resp_type)
plt.xlabel('Frequency (Hz)')
plt.tight_layout()
plt.show()

fig.savefig('../Figures/Response_spectra.png', dpi=100)