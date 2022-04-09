
# For-Loop Benchmark

The "forloop.bas" program flashes a cursor one hundred times (fifty times 'on' and fifty times 'off') using an empty for-loop as a delay routine.

If you use the Virtual MC-10 you can use the "quicktype" feature to load and RUN the programs.
The ["cassette" branch of Mike Tinnes' MC-10 emulator](https://github.com/gregdionne/mc-10) can be used in a similar fashion.


# Notes
The bytecode assembly source file (circle-bytecode.asm) was generated via "mcbasic circle.bas"

The native assembly source file (circle-native.asm) was generated via "mcbasic -native circle.bas"

The assembly source files can be compiled with the [tasm6801 compiler](https://github.com/gregdionne/tasm6801):

To get a sense of the speed differences between the various assembled versions you can load the equivalent .c10 files into your favorite emulator.

CLOADM and EXEC as you would a normal machine language program.

# Timing

interpreted:  98 seconds
bytecode:     19 seconds
native:       13 seconds
