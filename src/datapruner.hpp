// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef DATAPRUNER_HPP
#define DATAPRUNER_HPP

#include "program.hpp"

// Excise DATA from the program AST

class DataPruner : public ProgramOp {
public:
  void operate(Program &p) override;
  void operate(Line &l) override;
};

class StatementDataPruner : public StatementOp {
public:
  void operate(If &s) override;
  void operate(Data &s) override;
  bool result;

private:
  using StatementOp::operate;
};

template <typename T>
inline bool boperate(T *thing, StatementDataPruner *dataPruner) {
  dataPruner->result = false;
  thing->operate(dataPruner);
  return dataPruner->result;
}

#endif
