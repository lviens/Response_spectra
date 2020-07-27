# Response spectra function (Matlab and Python)
Matlab and Python response spectra functions with an example (Matlab only). 

Please cite the following paper if you use this code:  <br/>
- [Viens, Loïc and Marine A. Denolle (2019) Long‐Period Ground Motions from Past and Virtual Megathrust Earthquakes along the Nankai Trough, Japan. Bulletin of the Seismological Society of America, 109(4), 1312–1330](https://pubs.geoscienceworld.org/ssa/bssa/article-abstract/109/4/1312/571631/Long-Period-Ground-Motions-from-Past-and-Virtual?redirectedFrom=PDF) <br/>

## Description:

* The Matlab repository contains:  <br/>
  - Main function: RS_function.m <br/>
Function to compute the spectral response of a time-series using the Duhamel integral technique.

  - Example (Example_RS.m):<br/>
The code reads 3 KiK-net data files (located in the Data folder) using the read_KiK_net.m function and computes the response spectra of the time series using RS_function.m. The KiK-net data are the waveforms of the 2011 Tohoku-Oki earthquake recorded at the surface by the TKYH12 station.<br/>
The code finally plots the acceleration waveforms as well as the response spectra specified by the User.

  - Read KiK-net data: read_KiK_net.m<br/>
This code reads the KiK-net data using the importfile_KiK_header.m and importfile_KiK_net.m functions.

* The Python repository contains: 

## Example:
This example is obtained by running the **Example.py** Python code. 

<img src="https://github.com/lviens/Response_spectra/blob/master/Figures/Response_spectra.png" width=75%>
