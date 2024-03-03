# Introduction

The application will implement a simple echo application using the Lattice IceStick
and the Digilent Bluetooth PMOD (https://digilent.com/shop/pmod-bt2-bluetooth-interface/).

You can plug in the PMOD_BT2 directly into the IceStick. The PMOD interface of both devices
is pin and voltage level compatible so there is no need for any jumper wires.

The PMOD_BT2 is running a 
bluetooth stack internally and it has a standard configuration applied by the Digilent.
This standard configuration makes the PMOD_BT2 start a SPP server which is the 
Bluetooth Classic way of having a serial connection open, that means a connection
that allows you to send characters to the communication partner over a Bluetooth Classic
connection. 

You can connect to the SPP server of the PMOD_BT2 using the Android app "Serial Bluetooth Terminal"
for testing purposes. You can also use windows or linux to connect to the SPP server by first
coupling/bonding the PMOD_BT2 to windows/linux. The device the has to show up as a regular
COM port into which you can send serial data.

Once the connection is established between your cellphone/computer and the SPP
server on the PMOD_BT2, you can send characters over the SPP connection using the 
"Serial Bluetooth Terminal" app or any application that can connect to a COM port.
Windows applications for that are terminal emulators such as YAT, putty, terraterm and many others.

The characters you send are receive by the PMOD_BT2 and they are then put into it's UART interface.
Every device that connects to the UART interface gets the characters forwarded.

Once the PMOD_BT2 is plugged into the IceStick, the IceStick can talk to the PMOD_BT2 via a 
UART connection which has to support hardware flow control (CTS/RTS). This UART connection grants
direct access to the characters that are sent to the PMOD_BT2 module via the SPP connection.

In this application, a module to talk to the PMOD_BT2 over UART by Ed Nutting is used to implement 
the UART connection with hardware flow control. The PMOD_BT2 verilog module outputs received characters 
and provides a signal that goes high when a valid character has been received.

Ed Nutting's module also allows you to send characters back to the PMOD_BT2 over the UART connection.
Once the PMOD_BT2 receives a character it will send that character out to the communication partner
over Bluetooth using the SPP connection. 

The device is configured in the official example as an echo device which means it does send every
single character back to the communication partner that is received over the incoming direction.
In this example, the echo functionality is kept so if you send any data to the PMOD_BT2 you
should get that data back over the bluetooth connection.

In a sense there is no difference between a UART that is running over a wire-based physical interface
and the UART that is running over Bluetooth Classic. The UART allows you to send and receive characters
in a asynchronous fashion, this means you can send and receive at the same time.

In addition to the PMOD_BT2 UART, this application features a second UART that sends out characters
over the FTDI USB-based UART that the IceStick supports. This second connection was introduced
to debug the PMOD_BT2 connection. Every character that is received over Bluetooth also is output
over the FTDI USB based UART. You can connect to the USB-COM port and check if any data is 
received over the bluetooth connection. Sadly the USB UART has some issues and it does not correctly
transmit at the moment! But it works in some cases, enough to check the basic functioning of the system.

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


## icepll

A Tool that allows you to find configuration parameters for your PLL.

Source code is here: https://raw.githubusercontent.com/YosysHQ/icestorm/master/icepll/icepll.cc

Just copy icepll.cc and name it icepll.cpp and compile it using gcc (even on windows using cygwin)

```
gcc icepll.cpp -o icepll.exe
```

This will produce icepll.exe

Call icepll.exe

```
icepll.exe -i 12 -o 100
```

This means using an input reference clock of 12 Mhz (like the one present on the icestick)
produce a 100 Mhz clock through the PLL.

The output is:

```
F_PLLIN:    12.000 MHz (given)
F_PLLOUT:  100.000 MHz (requested)
F_PLLOUT:  100.500 MHz (achieved)

FEEDBACK: SIMPLE
F_PFD:   12.000 MHz
F_VCO:  804.000 MHz

DIVR:  0 (4'b0000)
DIVF: 66 (7'b1000010)
DIVQ:  3 (3'b011)

FILTER_RANGE: 1 (3'b001)
```

Then use these constant bit patterns in the PLL instance declaration:

```
SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.PLLOUT_SELECT("GENCLK"),
		.DIVR(4'b0000),
		.DIVF(7'b1000010),
		.DIVQ(3'b011),
		.FILTER_RANGE(3'b001)
	) uut (
		.LOCK(lock),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(SYS_CLK),
		.PLLOUTCORE(clkout)
	);
```