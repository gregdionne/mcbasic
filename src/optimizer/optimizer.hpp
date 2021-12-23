// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_OPTIMIZER_HPP
#define OPTIMIZER_OPTIMIZER_HPP

#include "ast/program.hpp"
#include "consttable/consttable.hpp"
#include "datatable/datatable.hpp"
#include "mcbasic/options.hpp"
#include "symboltable/symboltable.hpp"

// given the program AST, calls all optimizations
// builds final data table, constant table, and symbol table (variables/arrays)

class Optimizer {
public:
  Optimizer(DataTable &dt, SymbolTable &st, ConstTable &ct, Options &opts)
      : dataTable(dt), symbolTable(st), constTable(ct), options(opts) {}

  void optimize(Program &p);

private:
  DataTable &dataTable;
  SymbolTable &symbolTable;
  ConstTable &constTable;
  Options &options;
};

#endif
