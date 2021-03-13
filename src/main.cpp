// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "bytecodetarget.hpp"
#include "compiler.hpp"
#include "nativetarget.hpp"
#include "optimizer.hpp"
#include "options.hpp"
#include "parser.hpp"
#include "writer.hpp"

int main(int argc, char *argv[]) {
  Options opts;
  opts.init(argc, argv);

  Parser parser(argc, argv);
  Writer out(argc, argv);

  do {
    if (opts.Wfloat || opts.list) {
      fprintf(stderr, "Compiling %s...\n", argv[parser.in.argfile]);
    }

    Program p = parser.parse();
    p.sortlines();

    DataTable dataTable;
    SymbolTable symbolTable;
    ConstTable constTable;
    Optimizer o(dataTable, symbolTable, constTable, opts.Wfloat, opts.list);
    o.optimize(p);

    InstQueue q;
    Compiler c(dataTable, constTable, symbolTable, q, opts.g);
    c.operate(p);

    auto target =
        opts.native
            ? std::unique_ptr<Target>(std::make_unique<NativeTarget>())
            : std::unique_ptr<Target>(std::make_unique<ByteCodeTarget>());

    out.writeHeader();

    out.writeString(
        target->generateAssembly(dataTable, constTable, symbolTable, q, opts));

    out.close();
  } while (parser.in.openNext() && out.openNext());
}
