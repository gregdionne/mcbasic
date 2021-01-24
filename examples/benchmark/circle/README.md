# Circle Drawing Benchmark
The "circle.bas" MICROCOLOR BASIC program draws a circle on the MC-10 once each using three different methods.

If you use the Virtual MC-10 you can use the "quicktype" feature to load and RUN the programs.
The ["cassette" branch of Mike Tinnes' MC-10 emulator](https://github.com/gregdionne/mc-10) can be used in a similar fashion.

## Direct calls to SIN and COS
The first method draws the a circle using repeated calls to SIN() and COS().

## Angle Addition Formulae
The second method uses angle-addition formulae for SIN() and COS() to perform the plot.  If you compare the results visually against those when run without the compiler, you can observe that the results are slightly different due to differences in the numerical representation of the values.

## Brensenham's Circle Algorithm
The last method uses Brensenham's method. It should run fast since it uses only integers and requires no multiplicatin.

# Notes
The bytecode assembly source file (circle-bytecode.asm) was generated via "mcbasic circle.bas"

The native assembly source file (circle-native.asm) was generated via "mcbasic -native circle.bas"

The assembly source files can be compiled with the [tasm6801 compiler](https://github.com/gregdionne/tasm6801):

To get a sense of the speed differences between the various assembled versions you can
load the equivalent .c10 files into your favorite emulator.

CLOADM and EXEC as you would a normal machine language program.

