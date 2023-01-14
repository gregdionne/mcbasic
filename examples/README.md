# Examples
These are some example programs (with generated code) that can be used evaluate the performance and operation of the compiler.

## Benchmark
The files in the benchmark directory are small examples that can be run to compare the speed or performance against the MICROCOLOR BASIC interpreter.  See the README.md file in that directory to learn more about them.

## Jim Gerrie's Programs
Most of the files in the native and bytecode directories are taken from talented and dedicated programmer Jim Gerrie.

Files in the native directory were small enough to be compiled with the "-native" option.  Files in the bytecode directory were compiled without any options.

### External repositories
Jim has two repositories of BASIC programs for the MC-10.

#### Jim's main TRS-80 MC-10 repository.
Jim's main TRS-80 MC-10 repository (at https://github.com/jggames/trs80mc10) has perhaps a hundred or so programs for the MC-10 and is a mix of original and ported programs accumulated over the years.  Unless otherwise indicated, most of these programs will run quite well using the MICROCOLOR BASIC interpreter on the MC-10 with the 16K RAM Expansion.

Many of these programs will run considerably faster when using the compiler.  Most programs don't need much work to convert.  Other programs need a little more work to be usable at the increased speed.

Here are some that are either identical or very close to Jim's current source from his main repository:

Finished Ports       | Jim's source
-------------------- | -----------------------------
bytecode/rubik.bas   | Puzzle/Rubik/RUBIK5.TXT
native/four.bas      | Puzzle/Four/FOUR2.TXT
native/hurkle.bas    | Puzzle/Hurkle/HURKLE.TXT
native/pentomin.bas  | Puzzle/Pentomin/PENTOMIN2.TXT
native/klondike.bas  | Casino/Card Games/Klondike/KLONDIKE14.TXT
native/bingo.bas     | Casino/Bingo/BINGO3.TXT

#### Jim Gerrie's Compiled Programs
Jim also has made a dedicated repository of original and ported programs modified to for use with this compiler (at https://github.com/jggames/MCBasic).  While the files are replicated here, his latest official versions can be found there.  Some of these are ports of his earlier work that are tweaked to make the original program playable at the increased speed.

Finished Ports       | Jim's source
-------------------- | ---------------------
native/3dlaby.bas    | 3DLABYcompiler1.TXT
native/alphafor.bas  | ALPHAFORcompiler17.TXT
native/chess.bas     | CHESScompiler2.TXT
native/closeout.bas  | CLOSEOUTcompiler9.TXT
native/coloroid.bas  | COLOROIDcompiler9.TXT
native/defcon1.bas   | DEFCON1compiler17.TXT
native/jailbrk.bas   | JAILBRK9.TXT
native/qbert.bas     | QBERTcompiler21.TXT
native/scramble.bas  | SCRAMBLEcompiler39.TXT
native/swelfoop.bas  | SWELFOOPcompiler8.TXT
bytecode/berzerk.bas | BERZERKcompiler30.TXT
bytecode/mahjong.bas | NEWMAHJcompiler18.TXT
bytecode/loderun.bas | LODERUNcompiler38.TXT

### Ports that still need logic modification to be playable due to speed differences:

Incomplete Ports       |  Jim's source
---------------------- | --------------------------------
native/decoy.bas       |  Arcade/Decoy/DECOY4.TXT
native/dots.bas        |  Puzzle/Dots/DOTS3.TXT
native/elevator.bas    |  Arcade/Elevator/ELEVATOR19.TXT
native/mcmine.bas      |  Puzzle/MCMine/MCMINE2.TXT

The results of the compiled code are saved as .C10 files.  You may CLOADM them into your favorite MC-10 emulator.
