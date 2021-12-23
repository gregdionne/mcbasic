// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_TARGET_HPP
#define BACKEND_TARGET_HPP

#include "coder.hpp"
#include "compiler/instqueue.hpp"
#include "consttable/consttable.hpp"
#include "datatable/datatable.hpp"
#include "mcbasic/options.hpp"
#include "symboltable/symboltable.hpp"

// Top level class to generate assembly for the target.

class Target {
public:
  virtual ~Target() = default;
  virtual std::string generateAssembly(DataTable &dataTable,
                                       ConstTable &constTable,
                                       SymbolTable &symbolTable,
                                       InstQueue &queue, Options &options) = 0;
};

#endif
