// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_TEXT_HPP
#define AST_TEXT_HPP

#include "consttable/consttable.hpp"
#include "datatable/datatable.hpp"
#include "symboltable/symboltable.hpp"

struct Text {
  DataTable dataTable;
  ConstTable constTable;
  SymbolTable symbolTable;
};

#endif
