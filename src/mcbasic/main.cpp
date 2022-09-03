// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "arguments.hpp"
#include "backend/bytecodetarget.hpp"
#include "backend/nativetarget.hpp"
#include "backend/writer.hpp"
#include "compiler/compiler.hpp"
#include "optimizer/optimizer.hpp"
#include "options.hpp"
#include "parser/parser.hpp"

int main(int argc, char *argv[]) {
  const Arguments args(argc, argv);

  for (const auto &filename : args.filenames) {
    fprintf(stderr, "Compiling %s...\n", filename);

    Program program = Parser(args.progname, filename, args.options).parse();

    Text text = Optimizer(args.options).optimize(program);

    InstQueue queue = Compiler(text, args.options.g).compile(program);

    auto target = args.options.native.isEnabled()
                      ? up<Target>(makeup<NativeTarget>())
                      : up<Target>(makeup<ByteCodeTarget>());

    auto assembly = target->generateAssembly(text, queue, args.options);

    Writer(args.progname, filename, args.options).write(assembly);
  }
}
