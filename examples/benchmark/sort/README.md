# Sort Benchmark
The "sort" folder contains identical versions of the classic bubblesort and quicksort algorithms that may be run on a TRS80 MC-10.

These BASIC programs will sort the contents of the current screen in MICROCOLOR BASIC:

bsort.bas
qsort.bas

If you use the Virtual MC-10 you can use the "quicktype" feature to load and RUN the programs.
The ["cassette" branch of Mike Tinnes' MC-10 emulator](https://github.com/gregdionne/mc-10) can be used in a similar fashion.

The following assembly source files can be compiled with the [tasm6801 compiler](https://github.com/gregdionne/tasm6801):

bubblesort         | quicksort          | Description
------------------ | ------------------ | ------------------------------------------
bsort-bytecode.asm | qsort-bytecode.asm | result of "mcbasic bsort.bas qsort.bas"
bsort-native.asm   | qsort-native.asm   | result of "mcbasic -native bsort.bas qsort.bas"
bsort-hand.asm     | qsort-hand.asm     | transliterated version (by hand).

To get a sense of the speed differences between the various assembled versions you can
load the equivalent .c10 files into your favorite emulator.

CLOADM and EXEC as you would a normal machine language program.


