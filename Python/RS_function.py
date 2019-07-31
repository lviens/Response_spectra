"""
Created on Wed Jul 31 12:23:55 2019

@author: Loic

- Function to compute the response spectra of time series using the Duhamel integral technique.

Inputs:
   - data: acceleration data in the time domain
   - delta: Sampling rate of the time-series (in Hz)
   - T: Output period range in second, Example (if delta>=20 Hz): T = np.concatenate((np.arange(.1, 1, .01), np.arange(1, 20, .1)))
   - xi: Damping factor (Standard: 5% -> 0.05)
   - Resp_type: Response type, choose between:
                - 'SA'  : Acceleration Spectra
                - 'PSA' : Pseudo-acceleration Spectra
                - 'SV'  : Velocity Spectra
                - 'PSV' : Pseudo-velocity Spectra
                - 'SD'  : Displacement Spectra

 Output:
     - Response spectra in the unit specified by 'Resp_type'
"""

import numpy as np

def RS_function(data, delta, T, xi, Resp_type):

    dt = 1/delta 
    w = 2*np.pi/T 
    
    mass = 1 #  constant mass (=1)
    c = 2*xi*w*mass
    wd = w*np.sqrt(1-xi**2)
    p1 = -mass*data
    
    # predefine output matrices
    S = np.zeros(len(T))
    D1 = S
    for j in np.arange(len(T)):
        # Duhamel time domain matrix form
        I0 = 1/w[j]**2*(1-np.exp(-xi*w[j]*dt)*(xi*w[j]/wd[j]*np.sin(wd[j]*dt)+np.cos(wd[j]*dt)))
        J0 = 1/w[j]**2*(xi*w[j]+np.exp(-xi*w[j]*dt)*(-xi*w[j]*np.cos(wd[j]*dt)+wd[j]*np.sin(wd[j]*dt)))
        
        AA = [[np.exp(-xi*w[j]*dt)*(np.cos(wd[j]*dt)+xi*w[j]/wd[j]*np.sin(wd[j]*dt)) , np.exp(-xi*w[j]*dt)*np.sin(wd[j]*dt)/wd[j] ] , 
               [-w[j]**2*np.exp(-xi*w[j]*dt)*np.sin(wd[j]*dt)/wd[j] ,np.exp(-xi*w[j]*dt)*(np.cos(wd[j]*dt)-xi*w[j]/wd[j]*np.sin(wd[j]*dt)) ]]
        BB = [[I0*(1+xi/w[j]/dt)+J0/w[j]**2/dt-1/w[j]**2 , -xi/w[j]/dt*I0-J0/w[j]**2/dt+1/w[j]**2 ] ,
            [J0-(xi*w[j]+1/dt)*I0, I0/dt] ]
        
        u1 = np.zeros(len(data))
        udre1 = np.zeros(len(data));
        for xx in range(1,len(data),1) :
    
            u1[xx] = AA[0][0]*u1[xx-1] + AA[0][1]*udre1[xx-1] + BB[0][0]*p1[xx-1] + BB[0][1]*p1[xx]
            udre1[xx] = AA[1][0]*u1[xx-1]+AA[1][1]*udre1[xx-1] + BB[1][0]*p1[xx-1]+BB[1][1]*p1[xx]
       
        if Resp_type == 'SA':
            udd1 = -(w[j]**2*u1+c[j]*udre1)-data  # calculate acceleration
            S[j] = np.max(np.abs(udd1+data))
        elif Resp_type == 'PSA':
            D1[j] = np.max(np.abs(u1))
            S[j] = D1[j]*w[j]**2
        elif Resp_type == 'SV':
            S[j] = np.max(np.abs(udre1))
        elif Resp_type == 'PSV':
            D1[j] = np.max(np.abs(u1))
            S[j] = D1[j]*w[j]
        elif Resp_type == 'SD':
            S[j] = np.max(np.abs(u1)) 
    return S
