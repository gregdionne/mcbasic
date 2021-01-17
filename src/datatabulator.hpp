// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef DATATABULATOR_HPP
#define DATATABULATOR_HPP

#include "program.hpp"

// Populate the dataTable with data from DATA statements
// in the program AST

class StatementDataTabulator : public StatementOp {
public:
  DataTable &dataTable;
  explicit StatementDataTabulator(DataTable &dt) : dataTable(dt) {}
  void operate(If &s) override;
  void operate(Data &s) override;

  using StatementOp::operate;
};

class DataTabulator : public ProgramOp {
public:
  DataTable &dataTable;
  explicit DataTabulator(DataTable &dt) : dataTable(dt), dts(dt) {}
  void operate(Program &p) override;
  void operate(Line &l) override;
  StatementDataTabulator dts;
};

#endif
