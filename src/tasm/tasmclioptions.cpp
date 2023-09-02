// Copyright (C) 2019 Greg Dionne
// Distributed under MIT License
#include "tasmclioptions.hpp"

TasmCLIOptions::TasmCLIOptions()
    : compact{false, "compact", nullptr,
              "Suppress line numbers in the output listing.",
              "Use a compact format in the .lst file"},
      obj{true, "obj", "no-obj", "Generate an object file.",
          "Write the raw binary to the .obj file."},
      c10{true, "c10", "no-c10", "Generate an MC-10 cassette file.",
          "Write an MC-10 cassette file (.c10) suitable for "
          "loading in an emulator."},
      lst{true, "lst", "no-lst", "Generate an assembly listing.",
          "Generate an annotated copy of the source file with "
          "line numbers, compiled addresses and generated bytes "
          "prepended to each line.  Line numbers may be suppressed "
          "by specifying the -compact option."},
      sym{false, "sym", "no-sym", "Generate a symbol table.",
          "Report the value and name of each symbol.  Modules "
          "and symbols appear in the order they appear in the "
          "source file(s)."},
      gbl{false, "gbl", "no-gbl", "Generate a table of global symbols.",
          "Report the value, name, and a list of all modules "
          "for each global symbol."},
      wBranch{false, "Wbranch", "Wno-branch",
              "Warn when JMP or JSR can be replaced with BRA or BSR.",
              "If the destination of a JMP or JSR is within 128 bytes of "
              "the subsequent instruction, it can be replaced with BRA or "
              "BSR, respectively.  This saves a byte for each instruction."},
      wGlobal{false, "Wglobal", "Wno-global",
              "Warn when a global symbol is not called from another module.",
              "The warning can be used to catch unused public subroutines."},
      wUnused{false, "Wunused", "Wno-unused",
              "Warn when a symbol is never referenced.",
              "The warning can be used to catch typos or neglecting to call "
              "subroutines."},
      dash{false, "-", nullptr, "Stop processing flag options.",
           "The '--' option allows compilation of filenames beginning with a "
           "dash ('-')."} {

  addOption(&compact);
  addOption(&obj);
  addOption(&c10);
  addOption(&lst);
  addOption(&sym);
  addOption(&gbl);
  addOption(&wBranch);
  addOption(&wGlobal);
  addOption(&wUnused);
  addOption(&dash);
}
