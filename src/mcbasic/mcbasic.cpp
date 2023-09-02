// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "mcbasic.hpp"

#include "backend/assembler/assembler.hpp"
#include "backend/target/bytecodetarget.hpp"
#include "backend/target/nativetarget.hpp"
#include "compiler/compiler.hpp"
#include "optimizer/optimizer.hpp"
#include "parser/parser.hpp"

std::string mcbasic(const char *progname, const char *filename,
                    const MCBASICCLIOptions &options) {
  Program program = Parser(progname, filename, options).parse();

  Text text = Optimizer(options).optimize(program);

  InstQueue queue = Compiler(text, options.g).compile(program);

  auto target = options.native.isEnabled()
                    ? up<Target>(makeup<NativeTarget>())
                    : up<Target>(makeup<ByteCodeTarget>());

  return target->generateAssembly(text, queue, progname, filename, options);
}
