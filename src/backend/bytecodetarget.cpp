// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "bytecodetarget.hpp"
#include "bytecodeimplementation.hpp"
#include "bytecoder.hpp"

void ByteCodeTarget::extendDirectPage(Assembler &tasm) {
  tasm.block("curinst", "2");
  tasm.block("nxtinst", "2");
}

std::string ByteCodeTarget::generateCode(InstQueue &queue) {
  Assembler tasm;

  tasm.org("M_CODE");
  tasm.blank();
  tasm.module("mdmain");
  tasm.ldx("#program");
  tasm.stx("nxtinst");
  tasm.label("mainloop");
  tasm.ldx("nxtinst");
  tasm.stx("curinst");
  tasm.ldab(",x");
  tasm.ldx("#catalog");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.jsr("0,x");
  tasm.bra("mainloop");
  tasm.blank();
  tasm.label("program");
  tasm.blank();
  std::string ops = tasm.source();

  ByteCoder coder;
  for (auto &instruction : queue.queue) {
    ops += instruction->operate(&coder);
    ops += '\n';
  }

  return ops;
}

up<Dispatcher> ByteCodeTarget::makeDispatcher() {
  return makeup<Dispatcher>(makeup<ByteCodeImplementation>());
}

std::string ByteCodeTarget::generateLibraryCatalog(Library &library) {
  Assembler tasm;
  tasm.comment("Library Catalog");

  auto entries = library.getCalls();

  if (entries.size() > 256) {
    fprintf(stderr, "error:  Too many bytecodes!\n");
    fprintf(stderr,
            "Sadly, mcbasic has generated "
            "%lu unique virtual instructions.\n",
            entries.size());
    fprintf(stderr,
            "This is %lu more instruction%s than can be "
            "indexed using a single byte.\n",
            entries.size() - 256, entries.size() > 257 ? "s" : "");
    fprintf(stderr, "Try reducing the size of the BASIC program; or, if "
                    "you have lots of memroy, use the -native compilation "
                    "switch.\n");
    exit(1);
  }

  int i = 0;
  for (const auto &entry : entries) {
    tasm.equ("bytecode_" + entry.first, std::to_string(i++));
  }

  tasm.blank();

  tasm.label("catalog");
  for (const auto &entry : entries) {
    tasm.word(entry.first);
  }

  tasm.blank();

  return tasm.source();
}

std::string ByteCodeTarget::generateSymbolCatalog(ConstTable &constTable,
                                                  SymbolTable &symbolTable) {
  Assembler tasm;

  tasm.comment("Bytecode symbol lookup table");
  tasm.blank();

  int count = 0;
  for (auto &entry : constTable.ints) {
    if (((entry & 0xff0000) != 0) && ((entry & 0xff0000) != 0xff0000)) {
      std::string name = FixedPoint(entry).label();
      tasm.equ("bytecode_" + name, std::to_string(count++));
    }
  }

  for (auto &entry : constTable.flts) {
    std::string name = entry.label();
    tasm.equ("bytecode_" + name, std::to_string(count++));
  }

  tasm.blank();

  for (const auto &symbol : symbolTable.numVarTable) {
    std::string name = (symbol.isFloat ? "FLTVAR_" : "INTVAR_") + symbol.name;
    tasm.equ("bytecode_" + name, std::to_string(count++));
  }

  for (const auto &symbol : symbolTable.strVarTable) {
    std::string name = "STRVAR_" + symbol.name;
    tasm.equ("bytecode_" + name, std::to_string(count++));
  }

  for (const auto &symbol : symbolTable.numArrTable) {
    std::string name = (symbol.isFloat ? "FLTARR_" : "INTARR_") + symbol.name;
    tasm.equ("bytecode_" + name, std::to_string(count++));
  }

  for (const auto &symbol : symbolTable.strArrTable) {
    std::string name = "STRARR_" + symbol.name;
    tasm.equ("bytecode_" + name, std::to_string(count++));
  }

  tasm.blank();
  tasm.label("symtbl");

  for (auto &entry : constTable.ints) {
    if (((entry & 0xff0000) != 0) && ((entry & 0xff0000) != 0xff0000)) {
      std::string name = FixedPoint(entry).label();
      tasm.word(name);
    }
  }

  for (auto &entry : constTable.flts) {
    std::string name = entry.label();
    tasm.word(name);
  }

  tasm.blank();

  for (const auto &symbol : symbolTable.numVarTable) {
    std::string name = (symbol.isFloat ? "FLTVAR_" : "INTVAR_") + symbol.name;
    tasm.word(name);
  }

  for (const auto &symbol : symbolTable.strVarTable) {
    std::string name = "STRVAR_" + symbol.name;
    tasm.word(name);
  }

  for (const auto &symbol : symbolTable.numArrTable) {
    std::string name = (symbol.isFloat ? "FLTARR_" : "INTARR_") + symbol.name;
    tasm.word(name);
  }

  for (const auto &symbol : symbolTable.strArrTable) {
    std::string name = "STRARR_" + symbol.name;
    tasm.word(name);
  }

  tasm.blank();
  return tasm.source();
}
