// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef CORETARGET_HPP
#define CORETARGET_HPP

#include "assembler.hpp"
#include "dispatcher.hpp"
#include "library.hpp"
#include "target.hpp"

// core routines for generating a target
//  code generation for virtual instructions is delegated to the coder
//  virtual instruction implementation is delegated to the dispatcher

class CoreTarget : public Target {
public:
  std::string generateAssembly(DataTable &dataTable, ConstTable &constTable,
                               SymbolTable &symbolTable,
                               InstQueue &queue) override;

protected:
  // generates the core BASIC registers
  // calls the extendDirectPage hook for bytecode direct page registers
  virtual std::string generateDirectPage(InstQueue &queue);

  // coder is responsible for calling the virtual instruction implementation:
  //  natively (via native MC6801 LDD, LDX, LDAB, and JSR instructions)
  //  bytecode (via the bytecode interpreter)
  virtual std::string generateCode(InstQueue & /*queue*/) = 0;

  // invokes the dispatcher to create the library
  virtual std::string generateLibrary(InstQueue &queue);

  // writes the DATA text
  virtual std::string generateDataTable(DataTable &dataTable);

  // writes any non-native constants (fixed-point or three-byte integers)
  // reserves space for variables and arrays in the block started by symbol
  // (bss) segment.
  virtual std::string generateSymbols(ConstTable &constTable,
                                      SymbolTable &symbolTable);

  // extensions for bytecode targets
  // provide hooks for the curinst and nxtinst DP registers
  virtual void extendDirectPage(Assembler & /*tasm*/) {}

  // provide hooks for bytecode lookup tables
  virtual std::string generateLibraryCatalog(Library &library);
  virtual std::string generateSymbolCatalog(ConstTable &constTable,
                                            SymbolTable &symbolTable);

  // dispatcher is responsible for writing the virtual instruction
  // implementation
  //  natively (direct calls via native MC6801 JSR instruction)
  //  bytecode (via the bytecode interpreter)
  virtual std::unique_ptr<Dispatcher> makeDispatcher() = 0;

private:
  // The MICROCOLOR BASIC 1.0 ROM has public routines declared in $FFDC-$FFEE
  // These lack the CONSOLE IN read (used for INPUT and when the MC-10 BASIC is
  // in "immediate mode") used in this implementation's version of INPUT.
  //
  // So we resort to generating equate directives for the "non-public" ROM
  // routines we are calling in the virtual instruction implementation.
  //
  // Some of these do not port to Darren Atkinson's MCX BASIC.  Alas, this
  // author does not have a dissassembly of Darren's MCX BASIC, so support for
  // it will be deferred until we know their equivalent addresses and when we
  // know which direct page locations are important to preserve on exit.
  //
  // MICROCOLOR BASIC 1.0 programs by Jim Gerrie make liberal use of PEEK and
  // POKE of implementation-specific ROM addresses.  For the most part, these
  // addresses are compatible between both MICROCOLOR BASIC 1.0 and MCX BASIC
  // implementations.
  //
  // ...or more generally we could eschew calling ROM routines altogether and
  // avoid the need to update this code should Darren release another ROM.
  static std::string generateMicroColorConstants();
};

#endif
