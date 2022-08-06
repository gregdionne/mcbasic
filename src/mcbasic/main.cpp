// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "backend/bytecodetarget.hpp"
#include "backend/nativetarget.hpp"
#include "backend/writer.hpp"
#include "compiler/compiler.hpp"
#include "optimizer/optimizer.hpp"
#include "options.hpp"
#include "parser/parser.hpp"

int main(int argc, char *argv[]) {
  Options opts;
  opts.init(argc, argv);

  Parser parser(argc, argv, opts);

  Writer out(argc, argv);

  do {
    fprintf(stderr, "Compiling %s...\n", argv[parser.currentArgNum()]);

    Program p = parser.parse();
    p.sortLines();
    p.removeDuplicateLines(opts.Wduplicate);

    DataTable dataTable;
    SymbolTable symbolTable;
    ConstTable constTable;
    Optimizer o(dataTable, symbolTable, constTable, opts);
    o.optimize(p);

    InstQueue q;
    Compiler c(dataTable, constTable, symbolTable, q, opts.g);
    c.operate(p);

    auto target = opts.native ? up<Target>(makeup<NativeTarget>())
                              : up<Target>(makeup<ByteCodeTarget>());

    out.openNext();
    out.writeHeader();

    out.writeString(
        target->generateAssembly(dataTable, constTable, symbolTable, q, opts));

    out.close();
  } while (parser.openNext());
}
