# Links and Credit

* https://eecs.blog/lattice-ice40-fpga-icestorm-tutorial/?utm_content=cmp-true

# Quickstart

```
cd <your_project_folder>
mkdir build

set PATH=%PATH%;C:\Users\wolfg\Downloads\oss-cad-suite\lib\
C:\Users\wolfg\Downloads\oss-cad-suite\environment.bat

yosys.exe -p "synth_ice40 -top top -blif build/aout.blif -json build/aout.json" top.v
nextpnr-ice40 --hx1k --package tq144 --json build/aout.json --asc build/aout.asc --pcf icestick.pcf -q
icepack build/aout.asc build/aout.bin
iceprog -d i:0x0403:0x6010:0 build/aout.bin
```

# Compiling

Create the environment without none of the yosys .exe files will execute successfully.

```
C:\Users\wolfg\Downloads\oss-cad-suite\environment.bat
```

Create a build folder

```
mkdir build
```

Enable the yosys environment

```
set PATH=%PATH%;C:\Users\wolfg\Downloads\oss-cad-suite\lib\
C:\Users\wolfg\Downloads\oss-cad-suite\environment.bat
```

Synthesise to a .blif file

```
yosys -p "synth_ice40 -top top -blif build/aout.blif -json build/aout.json" top.v -q
```

Place and route using arachne / nextpnr to a .asc file

```
#arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ).asc -p icestick.pcf $(BUILD)/$(PROJ).blif
#arachne-pnr -d 1k -P tq144 -p icestick.pcf build/blink.blif -o build/blink.asc

nextpnr-ice40 --package tq144 --hx1k --json build/aout.json --pcf icestick.pcf --asc build/aout.asc --gui
nextpnr-ice40 --package tq144 --hx1k --json build/aout.json --pcf icestick.pcf --asc build/aout.asc -q
nextpnr-ice40 --hx1k --json build/aout.json --pcf icestick.pcf --asc build/aout.asc
```

Convert to bitstream using IcePack. The bitstream is stored into a .bin file

```
icepack build/aout.asc build/aout.bin
```

upload the bitstream

```
iceprog build/aout.bin
iceprog -v -d i:0x0403:0x6010:0 build/aout.bin
iceprog -d i:0x0403:0x6010:0 build/aout.bin
```

```
yosys -p "synth_ice40 -json aout.json" -q top.v
nextpnr-ice40 --hx1k --package tq144 --json aout.json --asc aout.asc --pcf pinmap.pcf -q
icepack aout.asc aout.bin
iceprog -d i:0x0403:0x6010:0 aout.bin
```

```
yosys -p "synth_ice40 -json build/aout.json" -q top.v
nextpnr-ice40 --hx1k --package tq144 --json build/aout.json --asc build/aout.asc --pcf pinmap.pcf -q
icepack build/aout.asc build/aout.bin
iceprog -d i:0x0403:0x6010:0 build/aout.bin
```

https://github.com/reactive-systems/icedude


## IceBurn

https://github.com/davidcarne/iceBurn.git

```
git clone https://github.com/davidcarne/iceBurn.git
```