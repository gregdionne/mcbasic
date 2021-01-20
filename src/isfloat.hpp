// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef ISFLOAT_HPP
#define ISFLOAT_HPP

#include "datatable.hpp"
#include "expression.hpp"
#include "symboltable.hpp"

class IsFloat : public ExprOp {
public:
  bool result;
  SymbolTable &symbolTable;
  explicit IsFloat(SymbolTable &st) : result(false), symbolTable(st) {}
  void operate(ValExpr &e) override;
  void operate(AbsExpr &e) override;
  void operate(ShiftExpr &e) override;
  void operate(NegatedExpr &e) override;
  void operate(MultiplicativeExpr &e) override;
  void operate(AdditiveExpr &e) override;
  void operate(RndExpr &e) override;
  void operate(NumericConstantExpr &e) override;
  void operate(NumericVariableExpr &e) override;
  void operate(NumericArrayExpr &e) override;
};

template <typename T> inline bool boperate(T &thing, IsFloat &isFloat) {
  isFloat.result = false;
  thing->operate(&isFloat);
  return isFloat.result;
}

#endif
