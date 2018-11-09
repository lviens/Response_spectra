# Response spectra
Matlab response spectra function with an example.
- Main function: RS_function.m
Function to compute the spectral response of a time-series using the Duhamel integral technique.

- Example (Example_RS.m):
The code reads 3 KiK-net data files (located in the Data folder) using the read_KiK_net.m function and computes the response spectra of the time series using RS_function.m. The KiK-net data are the waveforms of the 2011 Tohoku-Oki earthquake recorded at the surface by the TKYH12 station.
The code finally plots the acceleration waveforms as well as the response spectra specified by the User.

- Read KiK-net data: read_KiK_net.m
This code reads the KiK-net data using the importfile_KiK_header.m and importfile_KiK_net.m functions.
