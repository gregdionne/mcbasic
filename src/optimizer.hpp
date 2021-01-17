// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_HPP
#define OPTIMIZER_HPP

#include "consttable.hpp"
#include "datatable.hpp"
#include "program.hpp"
#include "symboltable.hpp"

// given the program AST, calls all optimizations
// builds final data table, constant table, and symbol table (variables/arrays)

class Optimizer {
public:
  Optimizer(DataTable &dt, SymbolTable &st, ConstTable &ct, bool &wf, bool &l)
      : dataTable(dt), symbolTable(st), constTable(ct), Wfloat(wf), list(l) {}

  void optimize(Program &p);

private:
  DataTable &dataTable;
  SymbolTable &symbolTable;
  ConstTable &constTable;
  bool Wfloat;
  bool list;
};

#endif
