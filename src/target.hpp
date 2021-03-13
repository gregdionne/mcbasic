// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef TARGET_HPP
#define TARGET_HPP

#include "coder.hpp"
#include "consttable.hpp"
#include "datatable.hpp"
#include "instqueue.hpp"
#include "options.hpp"
#include "symboltable.hpp"

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
