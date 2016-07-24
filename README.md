# vhdUart

"Low cost" UART for FPGA
------------------------

8N1. Baud rate fixed. (Baud rate must be computed from input master clock frequency).

Size is about 80 Logic Element in a Cyclone IV.

9600 8N1 and 115200 8N1 versions tested in a Cyclone IV FPGA.

Signals
========

Outputs:

TX: serial data out

DOUT: RX data

DOK: RX data is available on DOUT

READY: TX data could be loaded

Inputs:

LOAD: load TX data in DIN

DIN: TX data

RX: serial data in

nRST: asynchronious reset active low

MCLK: master clock (48 MHz here for current setting) 
