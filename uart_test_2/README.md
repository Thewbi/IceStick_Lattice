# Notes

For the icestick it is not possible to program to SRAM directly! So the -S flag of iceprog wont work.
The flash has to be written which takes longer that programming SRAM.

Baudrate 9600
In general since there is no hardware flow control a terminal emulator can send data faster than the UART
can process the data. This will inevitably cause data loss. Without hardaware flow control there is nothing
to be done about this problem!

# Quickstart

```
cd <your_project_folder>
mkdir build

set PATH=%PATH%;C:\Users\wolfg\Downloads\oss-cad-suite\lib\
C:\Users\wolfg\Downloads\oss-cad-suite\environment.bat

yosys.exe -p "synth_ice40 -top top -blif build/aout.blif -json build/aout.json" uart_demo.v uart.v
nextpnr-ice40 --hx1k --package tq144 --json build/aout.json --asc build/aout.asc --pcf icestick.pcf -q
icepack build/aout.asc build/aout.bin
iceprog -d i:0x0403:0x6010:0 build/aout.bin
```

# Simulation using iVerilog on Windows

```
C:\iverilog\bin\iverilog.exe -s top_testbench -o build/aout.vvp uart_demo_testbench.v uart_demo.v uart.v
clear && C:\iverilog\bin\vvp.exe build/aout.vvp
gtkwave build/aout.vcd

C:\iverilog\bin\vvp.exe riscv.vvp -lxt2
```