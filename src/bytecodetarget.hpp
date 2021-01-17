// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BYTECODETARGET_HPP
#define BYTECODETARGET_HPP

#include "coretarget.hpp"

// top level target code generator for bytecode

class ByteCodeTarget : public CoreTarget {

protected:
  std::string generateCode(InstQueue &queue) override;
  std::string generateLibraryCatalog(Library &library) override;
  std::string generateSymbolCatalog(ConstTable &constTable,
                                    SymbolTable &symbolTable) override;
  void extendDirectPage(Assembler &tasm) override;
  std::unique_ptr<Dispatcher> makeDispatcher() override;
};

#endif
