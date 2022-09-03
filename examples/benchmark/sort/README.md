# Sort Benchmark
The "sort" folder contains identical versions of the classic bubblesort, quicksort and countsort algorithms that may be run on a TRS80 MC-10.

These BASIC programs will sort the contents of the current screen in MICROCOLOR BASIC:

bsort.bas
qsort.bas
csort.bas

If you use the Virtual MC-10 you can use the "quicktype" feature to load and RUN the programs.
The ["cassette" branch of Mike Tinnes' MC-10 emulator](https://github.com/gregdionne/mc-10) can be used in a similar fashion.

The following assembly source files can be compiled with the [tasm6801 compiler](https://github.com/gregdionne/tasm6801):

bubblesort         | quicksort          | countsort          | Description
------------------ | ------------------ | ------------------ | ------------------------------------------
bsort-bytecode.asm | qsort-bytecode.asm | csort-bytecode.asm | result of "mcbasic bsort.bas qsort.bas"
bsort-native.asm   | qsort-native.asm   | csort-native.asm   | result of "mcbasic -native bsort.bas qsort.bas"
bsort-hand.asm     | qsort-hand.asm     | csort-hand.asm     | transliterated version (by hand).

To get a sense of the speed differences between the various assembled versions you can
load the equivalent .c10 files into your favorite emulator.

CLOADM and EXEC as you would a normal machine language program.

Timing for quicksort may vary depending on what is on screen.

               bubblesort   quicksort    countsort
interpreted:  1435 seconds  18 seconds   12 seconds
bytecode:      135 seconds   2 seconds    1 second
native:         76 seconds   1 seconds    ?
hand-coded:      4 seconds   ?           ??
