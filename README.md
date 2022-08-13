# mcbasic
A cross-compiler for MICROCOLOR BASIC 1.0 which runs on a stock TRS-80 MC-10 (preferably with the 16K adaptor or Darren Atkinson's MCX-32SD).

## Requirements
* A real "stock" TRS-80 MC-10 or an emulator like the "Virtual MC-10"
* A text file containing a MICROCOLOR BASIC program.
* A compatible Telemark cross-assembler
* The 16K Expansion is very helpful except for very small programs

Don't have James' Virtual MC-10?  You really should if you have Microsoft Windows.  Don't have Windows?
* You'll find a tasm6801 repository [here](https://github.com/gregdionne/tasm6801)
* You'll find a modified version of Mike Tinnes' JavaScript emulator [here](https://github.com/gregdionne/mc-10)
* You can also select the MC-10 from Ciaran Anscomb's XRoar emulator [here](https://www.6809.org.uk/xroar/online/)

Don't have a MICROCOLOR BASIC program?
* Have a look at Jim Gerrie's TRS-80 MC-10 amazing repository [here](https://github.com/jggames/trs80mc10)
* Have a look at the [examples](https://github.com/gregdionne/mcbasic/tree/main/examples), which contain a few precompiled programs from Jim's repository.

Want to write your own program?
* You may find it easier to first develop with an emulator that supports loading external text files rather than typing them in manually into the emulator.  The Virtual MC-10 has a "QuickType" feature for this purpose.  The modified JavaScript emulator allows you to enter keystrokes via a text file through the "Choose File" button. 
* You'll find a language reference manual [here](https://colorcomputerarchive.com/repo/MC-10/Documents/Manuals/Hardware/MC-10%20Operation%20and%20Language%20Reference%20Manual/MC-10%20Operation%20and%20Language%20Reference%20Manual%20(Tandy).pdf).

## Limitations
* Darren Atkinson's MCX-128 is not yet supported.
* BREAK interruption is not supported

## Unimplemented keywords
* CLOAD*, CSAVE*, LIST, CONT
* LLIST, LPRINT  
* USR(), VARPTR(), CLOADM


## Compilation

### MacOS (Darwin)

Requires C++14.  Tested on Apple clang version 12.0.0 (clang-1200.0.32.28).
The simple makefile should work on most systems.

If you'd rather compile without make, navigate to the "src" directory and enter:
`c++ -std=c++14 -I. */*.cpp -o ../mcbasic`

This should compile the program and put the executable in the parent directory.

### Windows 10

Some attempt has been made to make the source compatible with Windows Visual Studio 2017.  What works is to launch the Visual Studio "developer command prompt" by following the instructions [here](https://docs.microsoft.com/en-us/cpp/build/walkthrough-compile-a-c-program-on-the-command-line).  If the link fails, try searching the internet for "Walkthrough:  Compile a C program on the command line".

Once you have the developer command prompt open, navigate to the "src" directory of mcbasic, then run the `vscompile.bat` script by typing:

`vscompile`

You should see `mcbasic.exe` created in the src directory.

## Usage

You should be comfortable using either a shell program (in linux) or a command prompt (in Windows) and know how to place the executable on your path.  Once it is on your path, you may invoke it like any other command line utility.

Save your BASIC program as a text file.  You may use any extension (e.g. ".txt" ".bas")
Once you have your basic program, you may compile it via:

`mcbasic [options] <yourprogram.bas>`

Where [options] can be:

Option            | Description
----------------- | -----------
&#8209;native     | use native instructions instead of creating bytecode.  This improves execution speed at the cost of increased codesize.  Many programs are too big to use native.
&#8209;Wfloat     | warn when a variable is promoted floating-point&#185;.  (default)  [-Wno-float to disable].
&#8209;Wduplicate | warn when a duplicate line number is seen.  (default)  [-Wno-duplicate to disable].
&#8209;Wunreached | warn when statements cannot be reached.  (default)  [-Wno-unreached to disable].
&#8209;Wuninit    | warn when a variable is used but never initialized anywhere.  (default)  [-Wno-uninit to disable].
&#8209;Wunused    | warn when a variable is assigned to an expression with no side-effects but never used.  (default)  [-Wno-unused to disable].
&#8209;Wbranch    | warn when conditional branches are pruned.  (default)  [-Wno-branch to disable].
&#8209;g          | generate debug instructions to provide the most recent line number when an error is encountered.
&#8209;list       | output a BASIC&#179; program listing after optimizations.
&#8209;undoc      | enable compilation with undocumented opcodes.&#8308;
&#8209;el         | allow empty line number specifications in ON, GO, and GOSUB statements.&#8309;
&#8209;ul         | do not generate compilation errors on unlisted line numbers.&#8310;
&#8209;mcode      | enable use of machine code (i.e. EXEC).&#8311;
&#8209;v          | be verbose when optimizing.
&#8209;&#8209;    | treat subsequent arguments as file input (so you can compile a file that starts with "-", like "-filename.bas")

It will then generate an assembly file: <yourprogram.asm>.

You can then run your favorite assembler so long as it supports [Telemark](http://www.s100computers.com/Software%20Folder/6502%20Monitor/The%20Telemark%20Assembler%20Manual.pdf)-style syntax.

`tasm6801 <yourprogram.asm>`

If you use [this](https://github.com/gregdionne/tasm6801) version, it will generate a .C10 suitable for loading in an emulator via CLOADM.
I'll eventually&#8312; bundle the assembler into the compiler as well, so this step may be unnecessary in the future.

For playback into a real TRS-80 MC-10 you can try compiling Cirian Anscomb's [cas2wav](https://www.6809.org.uk/dragon/cas2wav-0.8.tar.gz) program to convert a .C10 to .WAV
I'll eventually&#8312; bundle .WAV creation into the assembler as well, so this step may be also unnecessary in the future.

### Notes

&#185; The current back-end implementation "emulates" floating-point with fixed-point.  While that makes it faster than floating-point; it's far less accurate, takes more memory&#178;, and is slower than using integers.  Avoid floating-point if you can.

&#178; The current back-end implementation uses three bytes when implementing an integer (24 bit two's complement) and five bytes when implementing fixed-point (24 bit two's complement integer; 16-bit fraction).

&#179; Some extensions are used during the compilation stage (e.g. += and -= assignment increment/decrement operators and a WHEN..GOTO/GOSUB as a replacement for IF..GOTO/GOSUB ELSE). These extensions are internal and are not available for use in the source BASIC files.

&#8308; Currently only the undocumented negate-with-carry instructions.  The MC6801 and MC6809 both implement `NGCA` (opcode $42), `NGCB` (opcode $52), `NGC <indexed>` (opcode $62), and `NGC <extended>` (opcode $72).  These permit negation of the "D" register in four cycles by issuing a `NEGB` (opcode $50) followed by `NGCA` (opcode $42).  They can also negate multi-byte numbers in-place.&#178;  Use caution when using the &#8209;undoc switch, as many 6801 emulators fail to implement these instructions correctly.

&#8309; A significant number of MC-10 programs exploited the fact that a missing line number after a GOTO, GOSUB, or ON..GOTO or ON..GOSUB statement implicitly resolved to line number zero (0) in MICROCOLOR BASIC.  This enabled compact ON..GOTO and ON..GOSUB statements where unused branch indices could be conveniently skipped (or sent to line 0).  For example, a programmer could write `ON X GOTO 100,200,,300,,,,400,:GOTO 500` to branch to lines 100, 200, 0, 300, 0, 0, 0, 400, and 0 for values of X from 1-9, respectively; and to line 500 for other values of X. 

&#8310; A runtime `?UL ERROR` will be generated instead.  This is intended to be used in conjunction with the `-el` compiler flag.  Use `-g` to diagnose where these errors occur.

&#8311; As a precaution against unexpected behavior, the `-mcode` compiler flag is required for use with EXEC.  EXEC will only work with the compiler if the machine code it invokes does not assume the MICROCOLOR BASIC interpreter is running or modify direct page variables needed by the compiler to function.  Sic hunt dracones!

&#8312; The code in this repository was written in brief spurts over the course of perhaps fifteen years.  It's been largely relegated to a minor side-project as time and interest have permitted.  Originally in K&R C, it was ported to ANSI C, then C++ (98).  I've given it just enough treatment to work in C++14, but alas, C++20 is out as of this writing!  It needs to be upgraded to comply with more modern programming guidelines.  But perhaps, like MICROCOLOR BASIC itself, some of this code may bring you back to a simpler era.  Enjoy!

