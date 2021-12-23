// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_DATATABULATOR_HPP
#define OPTIMIZER_DATATABULATOR_HPP

#include "ast/nullstatementinspector.hpp"
#include "ast/program.hpp"
#include "datatable/datatable.hpp"

// Populate the dataTable with data from DATA statements
// in the program AST

class StatementDataTabulator : public NullStatementInspector {
public:
  explicit StatementDataTabulator(DataTable &dt) : dataTable(dt) {}
  void inspect(const If &s) const override;
  void inspect(const Data &s) const override;

private:
  using NullStatementInspector::inspect;

  DataTable &dataTable;
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
