# mcbasic
A cross-compiler for MICROCOLOR BASIC 1.0 which runs on a stock TRS-80 MC-10 or on James Tamer's "Virtual MC-10" which runs on Windows and bundles a shareware Telemark cross-assembler.

## Requirements
* A real "stock" TRS-80 MC-10 or an emulator like the "Virtual MC-10"
* A text file containing a MICROCOLOR BASIC program.
* A compatible Telemark cross-assembler
* The 16K Expansion is very helpful except for very small programs

Don't have James' Virtual MC-10?  You really should if you have Microsoft Windows.  Don't have Windows?
* You'll find a tasm6801 repository [here](https://github.com/gregdionne/tasm6801)
* You'll find a modified version of Mike Tinnes' JavaScript emulator [here](https://github.com/gregdionne/mc-10)

Don't have a MICROCOLOR BASIC program?
* Have a look at Jim Gerrie's TRS-80 MC-10 amazing repository [here](https://github.com/jggames/trs80mc10)
* Have a look at the [examples](https://github.com/gregdionne/mcbasic/tree/main/examples), which contain a few precompiled programs from Jim's repository.

Want to write your own program?
* You may find it easier to first develop with an emulator that supports loading external text files rather than typing them in manually into the emulator.  The Virtual MC-10 has a "QuickType" feature for this purpose.  The modified JavaScript emulator allows you to enter keystrokes via a text file through the "Choose File" button. 
* You'll find a language reference manual [here](https://colorcomputerarchive.com/repo/MC-10/Documents/Manuals/Hardware/MC-10%20Operation%20and%20Language%20Reference%20Manual/MC-10%20Operation%20and%20Language%20Reference%20Manual%20(Tandy).pdf).

## Limitations
* Darren Atkinson's MCX-BASIC ROM is not yet supported.
* Scientific E notation is not yet supported
* BREAK interruption is not supported

## Unimplemented keywords
* CLOAD*, CSAVE*, LIST, CONT
* LLIST, LPRINT  
* USR(), VARPTR(), EXEC, CLOADM


## Compilation

### MacOS (Darwin)

Requires C++14.  Tested on Apple clang version 12.0.0 (clang-1200.0.32.28).

`c++ -std=c++14 *.cpp -o mcbasic`

or if you're comfortable with `make`, a sample Makefile is in the source directory.

### Windows 10

Some attempt has been made to make the source compatible with Windows Visual Studio 2017.  What works is to follow the instructions [here](https://docs.microsoft.com/en-us/cpp/build/walkthrough-compile-a-c-program-on-the-command-line?view=vs-2019).  If the link fails, try searching the internet for "Walkthrough:  Compile a C program on the command line".

`cl /EHsc *.cpp /link /out:mcbasic.exe`


## Usage

Save your BASIC program as a text file.  You may use any extension (e.g. ".txt" ".bas")
Once you have your basic program, you may compile it via:

`mcbasic [options] <yourprogram.bas>`

Where [options] can be:

Option         | Description
------         | -----------
&#8209;native  | use native instructions instead of creating bytecode.  This improves execution speed at the cost of increased codesize.  Many programs are too big to use native.
&#8209;Wfloat  | warn when the compiler promotes variables to floating-point&#185;.   (default)  [-Wno-float to disable].
&#8209;g       | generate debug instructions to provide the most recent line number when an error is encountered.
&#8209;list    | output a BASIC&#179; program listing after optimizations.
&#8209;undoc   | enable compilation with undocumented opcodes.&#8308;
&#8209;&#8209; | treat subsequent arguments as file input (so you can compile a file that starts with "-", like "-filename.bas")

It will then generate an assembly file: <yourprogram.asm>.

You can then run your favorite assembler so long as it supports [Telemark](http://www.s100computers.com/Software%20Folder/6502%20Monitor/The%20Telemark%20Assembler%20Manual.pdf)-style syntax.

`tasm6801 <yourprogram.asm>`

If you use [this](https://github.com/gregdionne/tasm6801) version, it will generate a .C10 suitable for loading in an emulator.
I'll eventually&#8309; bundle the assembler into the compiler as well, so this step may be unnecessary in the future.

### Notes

&#185; The current back-end implementation "emulates" floating-point with fixed-point.  While that makes it faster than floating-point; it's far less accurate, takes more memory&#178;, and is slower than using integers.  Avoid floating-point if you can.

&#178; The current back-end implementation uses three bytes when implementing an integer (24 bit two's complement) and five bytes when implementing fixed-point (24 bit two's complement integer; 16-bit fraction).

&#179; Some extensions are used during the compilation stage (e.g. += and -= assignment increment/decrement operators and a WHEN..GOTO/GOSUB as a replacement for IF..GOTO/GOSUB ELSE). These extensions are internal and are not available for use in the source BASIC files.

&#8308; Currently only the undocumented negate-with-carry instructions are used.  These instructions are similar to that of the MC6809's undocumented NGC instruction with direct addressing mode (opcode $02).  The MC6801 implements `NGCA` (opcode $42), `NGCB` (opcode $52), `NGC <offset>,X` (opcode $62), and `NGC <address>` (opcode $72).

&#8309; The code in this repository was written in brief spurts over the course of perhaps fifteen years.  It's been largely relegated to a minor side-project as time and interest have permitted.  Originally in K&R C, it was ported to ANSI C, then C++ (98).  I've given it just enough treatment to work in C++14, but alas, C++20 is out as of this writing!  It needs to be upgraded to comply with more modern programming guidelines.  But perhaps, like MICROCOLOR BASIC itself, some of this code may bring you back to a simpler era.  Enjoy!

