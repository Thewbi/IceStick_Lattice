# Links and Credit

* https://eecs.blog/lattice-ice40-fpga-icestorm-tutorial/?utm_content=cmp-true

# Compiling

Create the environment without none of the yosys .exe files will execute successfully.

```
C:\Users\wolfg\Downloads\oss-cad-suite\environment.bat
```

Create a build folder

```
mkdir build
```

Synthesise to a .blif file

```
yosys -p "synth_ice40 -top top -blif build/blinky.blif -json build/blinky.json" top.v -q
```

Place and route using arachne / nextpnr to a .asc file

```
#arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ).asc -p pinmap.pcf $(BUILD)/$(PROJ).blif
#arachne-pnr -d 1k -P tq144 -p pinmap.pcf build/blink.blif -o build/blink.asc

nextpnr-ice40 --package tq144 --hx1k --json build/blinky.json --pcf pinmap.pcf --asc build/blinky.asc --gui
nextpnr-ice40 --package tq144 --hx1k --json build/blinky.json --pcf pinmap.pcf --asc build/blinky.asc -q
nextpnr-ice40 --hx1k --json build/blinky.json --pcf pinmap.pcf --asc build/blinky.asc
```
	
Convert to bitstream using IcePack. The bitstream is stored into a .bin file

```
icepack build/blinky.asc build/blinky.bin
icepack build/blinky.asc hardware.bin
```

upload the bitstream

```
iceprog build/blinky.bin
iceprog -v -d i:0x0403:0x6010:0 build/blinky.bin 
iceprog -d i:0x0403:0x6010:0 build/blinky.bin
```

```
yosys -p "synth_ice40 -json hardware.json" -q top.v
nextpnr-ice40 --hx1k --package tq144 --json hardware.json --asc hardware.asc --pcf pinmap.pcf -q
icepack hardware.asc hardware.bin
iceprog -d i:0x0403:0x6010:0 hardware.bin
```

```
yosys -p "synth_ice40 -json build/hardware.json" -q top.v
nextpnr-ice40 --hx1k --package tq144 --json build/hardware.json --asc build/hardware.asc --pcf pinmap.pcf -q
icepack build/hardware.asc build/hardware.bin
iceprog -d i:0x0403:0x6010:0 build/hardware.bin
```



https://github.com/reactive-systems/icedude


## IceBurn

https://github.com/davidcarne/iceBurn.git

```
git clone https://github.com/davidcarne/iceBurn.git
```