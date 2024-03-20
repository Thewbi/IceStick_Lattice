# Links and Credits

* https://www.bastibl.net/open-source-fpga/
* https://blog.julian1.io/2017/01/29/icestick-ftdi-spi.html
* https://github.com/julian1/ice40-spi-usb-controller

# SPI Flash

The IceStick has a Micron 32 Mbit N25Q32 SPI flash.
32 Mbit about 3.8 MegaByte
32.000.000 / 8 = 4.000.000 Byte = 3.906,25 Kb = 3,814 Mb

# SPI Flash Sleep Mode after Programming

According to https://www.bastibl.net/open-source-fpga/, uploading
a bitstream to the IceStick will store this bitstream into the 
SPI Flash.

When the IceStick powers up, it reconfigures itself using the bitstream
stored in the SPI Flash. Once it is done configuring itself, the SPI Flash 
it put into sleep mode in which it cannot be read or written.

This sleep mode has to be prevented in order to be able to use the SPI
Flash. The approach is to produce a special bitstream, which contains
some information that makes the IceStick not put the SPI flash to sleep.

In order to tell APIO to produce this special type of bitstream, you 
need a special parameter for icepack.exe

```
-s
        disable final deep-sleep SPI flash command after bitstream is loaded
```

## Install Yosys on Windows

Go here:
https://yosyshq.net/yosys/download.html

Click on the link "OSS CAD Suite Download Links" to get to this site: 
https://github.com/YosysHQ/oss-cad-suite-build/releases

Download the windows .exe archive from the latest release.
Run the .exe file. The .exe file is basically an automatic archive extractor.
It will create a folder called: oss-cad-suite

You first have to set up the environment before you can run the tools.
As an example here is how to run icepack:

```
cd oss-cad-suite
cd bin
..\environment.bat
icepack.exe --help
```

## icepack.exe

Error: https://stackoverflow.com/questions/44573802/using-stdstring-causes-windows-entry-point-not-found

```
set PATH=%PATH%;C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\lib
C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\icepack.exe

C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\lib\libgcc_s_seh-1.dll
```

## iceprog.exe

iceprog -o 1M C:\Users\wolfg\dev\fpga\IceStick_Lattice\spi_flash\foo.txt

```
C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\iceprog.exe --help




Simple programming tool for FTDI-based Lattice iCE programmers.
Usage: C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\iceprog.exe [-b|-n|-c] <input file>
       C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\iceprog.exe -r|-R<bytes> <output file>
       C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\iceprog.exe -S <input file>
       C:\Users\wolfg\.apio\packages\tools-oss-cad-suite\bin\iceprog.exe -t

General options:
  -d <device string>    use the specified USB device [default: i:0x0403:0x6010 or i:0x0403:0x6014]
                          d:<devicenode>               (e.g. d:002/005)
                          i:<vendor>:<product>         (e.g. i:0x0403:0x6010)
                          i:<vendor>:<product>:<index> (e.g. i:0x0403:0x6010:0)
                          s:<vendor>:<product>:<serial-string>
  -I [ABCD]             connect to the specified interface on the FTDI chip
                          [default: A]
  -o <offset in bytes>  start address for read/write [default: 0]
                          (append 'k' to the argument for size in kilobytes,
                          or 'M' for size in megabytes)
  -s                    slow SPI (50 kHz instead of 6 MHz)
  -k                    keep flash in powered up state (i.e. skip power down command)
  -v                    verbose output
  -i [4,32,64]          select erase block size [default: 64k]

Mode of operation:
  [default]             write file contents to flash, then verify
  -X                    write file contents to flash only
  -r                    read first 256 kB from flash and write to file
  -R <size in bytes>    read the specified number of bytes from flash
                          (append 'k' to the argument for size in kilobytes,
                          or 'M' for size in megabytes)
  -c                    do not write flash, only verify (`check')
  -S                    perform SRAM programming
  -t                    just read the flash ID sequence

Erase mode (only meaningful in default mode):
  [default]             erase aligned chunks of 64kB in write mode
                          This means that some data after the written data (or
                          even before when -o is used) may be erased as well.
  -b                    bulk erase entire flash before writing
  -e <size in bytes>    erase flash as if we were writing that number of bytes
  -n                    do not erase flash before writing
  -p                    disable write protection before erasing or writing
                          This can be useful if flash memory appears to be
                          bricked and won't respond to erasing or programming.

Miscellaneous options:
      --help            display this help and exit
  --                    treat all remaining arguments as filenames

Exit status:
  0 on success,
  1 if a non-hardware error occurred (e.g., failure to read from or
    write to a file, or invoked with invalid options),
  2 if communication with the hardware failed (e.g., cannot find the
    iCE FTDI USB device),
  3 if verification of the data failed.

Notes for iCEstick (iCE40HX-1k devel board):
  An unmodified iCEstick can only be programmed via the serial flash.
  Direct programming of the SRAM is not supported. For direct SRAM
  programming the flash chip and one zero ohm resistor must be desoldered
  and the FT2232H SI pin must be connected to the iCE SPI_SI pin, as shown
  in this picture:
  http://www.clifford.at/gallery/2014-elektronik/IMG_20141115_183838

Notes for the iCE40-HX8K Breakout Board:
  Make sure that the jumper settings on the board match the selected
  mode (SRAM or FLASH). See the iCE40-HX8K user manual for details.

If you have a bug report, please file an issue on github:
  https://github.com/cliffordwolf/icestorm/issues
```




# Blinky example using the Yosys toolchain 

```
cd oss-cad-suite
cd bin
..\environment.bat
icepack.exe --help
```



# APIO

```
apio examples -l
apio boards --list

apio init --board icestick
apio sim
apio build
apio verify
apio upload
```