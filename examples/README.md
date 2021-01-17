# Examples

These are some example programs to evaluate the performance of the compiler.

## Benchmark
The files in the benchmark directory show how well the compiler fares against
hand-written assembly routines.  See the README.md file in that directory to
learn more about them. 

## Jim Gerrie's Programs
The files in the native and bytecode directories were taken from talented and dedicated
programmer Jim Gerrie's GitHub repository at https://github.com/jggames/trs80mc10.

Jim Gerrie has perhaps a hundred or so programs for the MC-10 and is a mix of original
and ported programs accumulated over the years.

Files in the native directory are small enough to be compiled with the "-native" option.
Files in the bytecode directory were compiled without any options.  

Most programs don't need much work to convert.  Some speed gains can be had by
casting the results of INPUT, VAL, and RND to INT before assignment.

### Here are some that are either identical or very close to Jim's current source.

Finished Ports       | Jim's source                                 |  Changes
-------------------- | -------------------------------------------- | ---------------
bytecode/rubik.bas   | Puzzle/Rubik/RUBIK5.TXT                      |  identical
native/3dlaby.bas    | Puzzle/3dLaby/3DLABY.TXT                     |  identical
native/chess.bas     | Board Games/Chess/CHESS2.TXT                 |  ON..GOTO define labels
native/coloroid.bas  | Puzzle/Coloroid/COLOROID9.TXT                |  RND() -> INT(RND())
native/defcon1.bas   | Strategy & Simulation/DefCon1/DEFCON1_14.TXT |  tweak missle path algorithm
native/hurkle.bas    | Puzzle/Hurkle/HURKLE.TXT                     |  RND() -> INT(RND())
native/life.bas JG   | Ideas & Others/LIFE10.TXT                    |  identical
native/pentomin.bas  | Puzzle/Pentomin/PENTOMIN2.TXT                |  fix typo

### Ports that still need logic modification to be playable due to speed differences:

Incomplete Ports      |  Jim's source                     | Changes
--------------------- | --------------------------------- | --------------------------------
bytecode/loderun.bas  |  Arcade/Loderunner/LODERUN33.TXT  | remove machine code
bytecode/nmahjong.bas |  Puzzle/Mahjong/NMAHJ15.TXT       | replace VAL with INT(VAL())) use MC-10 WASZ no CSAVE/CLOAD
native/decoy.bas      |  Arcade/Decoy/DECOY4.TXT          | identical
native/dots.bas       |  Puzzle/Dots/DOTS3.TXT            | identical
native/elevator.bas   |  Arcade/Elevator/ELEVATOR19.TXT   | identical
native/mcmine.bas     |  Puzzle/MCMine/MCMINE2.TXT        | identical

The results of the compiled code are saved as .C10 files.  You may CLOADM them into your favorite MC-10 emulator.
