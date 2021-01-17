// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "datatabulator.hpp"

void DataTabulator::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }

  dataTable.testPurity();
}

void DataTabulator::operate(Line &l) {
  for (auto &statement : l.statements) {
    statement->operate(&dts);
  }
}

void StatementDataTabulator::operate(Data &s) {
  for (auto &record : s.records) {
    dataTable.add(record->value);
  }
}

void StatementDataTabulator::operate(If &s) {
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}
