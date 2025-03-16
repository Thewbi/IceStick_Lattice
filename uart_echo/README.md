# Notes

For the icestick it is not possible to program to SRAM directly! So the -S flag of iceprog wont work.
The flash has to be written which takes longer that programming SRAM.

# Quickstart

```
cd <your_project_folder>
mkdir build
set PATH=%PATH%;C:\Users\wolfg\Downloads\oss-cad-suite\lib\
C:\Users\wolfg\Downloads\oss-cad-suite\environment.bat
yosys.exe -p "synth_ice40 -top top -blif build/aout.blif -json build/aout.json" top.v uart_rx.v uart_tx.v
nextpnr-ice40 --hx1k --package tq144 --json build/aout.json --asc build/aout.asc --pcf icestick.pcf -q
icepack build/aout.asc build/aout.bin
iceprog -d i:0x0403:0x6010:0 build/aout.bin
```

# Simulation using iVerilog on Windows

```
C:\iverilog\bin\iverilog.exe -s top_testbench -o build/aout.vvp top_testbench.v top.v uart_tx.v
clear && C:\iverilog\bin\vvp.exe build/aout.vvp
gtkwave build/aout.vcd

C:\iverilog\bin\vvp.exe riscv.vvp -lxt2
```