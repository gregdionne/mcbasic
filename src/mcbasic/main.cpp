// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "backend/assembler/assembler.hpp"
#include "mcbasic.hpp"
#include "mcbasicarguments.hpp"
#include "utils/cstring.hpp"
#include "utils/fileread.hpp"
#include "utils/srcwriter.hpp"

int main(int argc, char *argv[]) {
  const MCBASICArguments args(argc, argv);

  for (const auto &filename : args.filenames) {
    Assembler tasm;
    tasm.setObjEnable(args.options.c.isEnabled());
    tasm.setC10Enable(!args.options.S.isEnabled() &&
                      !args.options.c.isEnabled());

    if (utils::ends_with(filename, ".asm")) {
      fprintf(stderr, "Assembling %s...\n", filename);
      tasm.load(fileread(args.progname, filename));
      tasm.assemble(args.progname, filename);
    } else {
      fprintf(stderr, "Compiling %s...\n", filename);
      tasm.load(mcbasic(args.progname, filename, args.options));
      SrcWriter srcWriter(args.progname, filename, args.options);
      srcWriter.write(tasm.source());
      if (!args.options.S.isEnabled()) {
        tasm.assemble(args.progname, srcWriter.getOutname());
      }
    }
  }
}
