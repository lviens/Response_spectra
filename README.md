# Response spectra
Matlab response spectra function with an example.
- Main function: RS_code.m
Function to compute the spectral response of a time-series using the Duhamel integral technique.

- Example (Example_RS.m):
The code reads 3 KiK-net data files (located in the Data folder) using the read_KiK_net.m function and uses the function in RS_code.m to compute the response spectra. The KiK-net data are the waveforms of the 2011 Tohoku-Oki earthquake recorded at the surface by the TKYH12 station.
This code plots the acceleration waveforms as well as the response spectra specified by the User.
