// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "mcbasicarguments.hpp"

static const char *const argUsage = "file1 [file2 [file3 ...]]\n\n";
static const char *const argDescription =
    "mcbasic can be used to compile BASIC "
    "programs written for the TRS-80 MC-10.\n\n"
    "To use it, save your BASIC program as a text file "
    "(e.g., program.bas).\n"
    "Once you have your basic program, compile it via:\n\n"
    "\b program.bas\n\n"
    "It will then generate a .c10 file: <yourprogram.c10>\n"
    "You can load the .c10 file in an emulator via CLOADM.\n\n"
    "For playback into a real TRS-80 MC-10 you can try "
    "compiling Cirian Anscomb's cas2wav program to convert "
    "a .c10 file to a .wav.\n\n"
    "See:  https://www.6809.org.uk/dragon/cas2wav-0.8.tar.gz\n\n";

static const char *const helpExample =
    "If you have a text file called hello.bas with the "
    "following contents:\n\n"
    "10 CLS\n"
    "20 PRINT\"HELLO WORLD!\"\n\n"
    "Compile the program by typing:\n\n"
    "\b hello.bas\n\n"
    "if all went well, you should see hello.c10 in the "
    "same directory as hello.bas\n\n";

MCBASICArguments::MCBASICArguments(int argc, const char *const argv[])
    : progname(argv[0]) {

  filenames = options.parse(argc, argv, argUsage, argDescription, helpExample);

  if (filenames.empty()) {
    options.usage(progname, argUsage);
    exit(1);
  }
}
