# Introduction

The application will blink a LED and it will transmit bytes over the USB FTDI UART!
The Lattice IceStick has a FTDI chip that allows it to establish a UART connection over the
USB connection that is also used to programm the IceStick.
This example shows how to use this FTDI chip. (It is actually surprisingly very simple! 
There is a peripheral pin where you can send a signal to and it will be transmitted over the FTDI chip

# Credit

This code is taken from https://www.youtube.com/@msrivastava

I found the code via this forum post: https://github.com/YosysHQ/icestorm/issues/51

The original repository is here: https://github.com/nesl/ice40_examples/tree/master/uart_transmission

The change I made is that instead of sending data as fast as possible,
the modified code sends a character per sector.

# APIO Driver Installation

```
set PATH=%PATH%;C:\Users\wolfg\Downloads\oss-cad-suite\lib\
cd C:\Users\wolfg\dev\verilog\ice40_examples\uart_transmission
mkdir build
REM C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\yosys.exe -p "synth_ice40 -top top -blif build/uart.blif -json build/uart.json" top.v uart_trx.v
C:\Users\wolfg\Downloads\oss-cad-suite\bin\yosys.exe -p "synth_ice40 -top top -blif build/uart.blif -json build/uart.json" top.v uart_trx.v
```

APIO drivers:

Run a cmd as an administrator
```
apio drivers --ftdi-enable
```

In Zadig: 
* Options > List all Devices
* Find "Dual RS232-HS (Interface 0)"
* Select the libusbk (v3.0.7.0) driver from the drop-down and click "Replace Driver"
* "The driver was installed successfully!" > Close
```
apio system --lsftdi
```

# APIO Usage

It is possible to initialize a apio project inside the existing folder!
```
apio init --board icestick
```
The .pcf file icestick.pcf is downloaded from here: https://github.com/FPGAwars/apio-examples/blob/master/icestick/template/icestick.pcf and just copied into the folder! apio will use it automatically without any configuration!
```
apio verify
```
The design will not validate initially since on line 56 of top.v there is an ecxess comma which has to be removed.
```
apio build
apio upload
```
The application will blink a LED and it will transmit bytes over the USB FTDI UART!

Open a terminal emulator on the com port that has been assigned to the ice stick.
The type of the terminal is text.
The baudrate is 9600
In the YAT terminal, you can activate a linebreak after 80 characters.
The application will send numbers from 0 to 9 at a baudrate of 9600 as fast as it can.

# Further Tests with PIP

where does pip store packages
```
pip list -v

Package            Version  Location                                                                 Installer
------------------ -------- ------------------------------------------------------------------------ ---------
apio               0.8.4    C:\Users\wolfg\AppData\Local\Programs\Python\Python312\Lib\site-packages pip
```

apio, list installed packages
```
apio install --list
```

```
set PATH=%PATH%;C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\lib\

C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\yosys.exe
libreadline8.dll - C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\lib\libreadline8.dll
libgcc_s_seh-1.dll
tcl86.dll
```

```
yosys -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif -json $(BUILD)/$(PROJ).json" $(FILES)
```