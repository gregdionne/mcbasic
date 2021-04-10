// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef CONSTTABULATOR_HPP
#define CONSTTABULATOR_HPP

#include "program.hpp"

// fills the specified table with all the constants in the program AST

class ExprConstTabulator : public ExprOp {
public:
  explicit ExprConstTabulator(ConstTable &ct) : constTable(ct) {}
  void operate(StringConstantExpr &e) override;
  void operate(StringConcatenationExpr &e) override;
  void operate(StringArrayExpr &e) override;
  void operate(LeftExpr &e) override;
  void operate(MidExpr &e) override;
  void operate(RightExpr &e) override;
  void operate(LenExpr &e) override;
  void operate(StrExpr &e) override;
  void operate(ValExpr &e) override;
  void operate(AscExpr &e) override;
  void operate(ChrExpr &e) override;
  void operate(NumericConstantExpr &e) override;
  void operate(NumericArrayExpr &e) override;
  void operate(ArrayIndicesExpr &e) override;
  void operate(NegatedExpr &e) override;
  void operate(PowerExpr &e) override;
  void operate(IntegerDivisionExpr &e) override;
  void operate(MultiplicativeExpr &e) override;
  void operate(AdditiveExpr &e) override;
  void operate(ComplementedExpr &e) override;
  void operate(AndExpr &e) override;
  void operate(OrExpr &e) override;
  void operate(ShiftExpr &e) override;
  void operate(SgnExpr &e) override;
  void operate(IntExpr &e) override;
  void operate(AbsExpr &e) override;
  void operate(SqrExpr &e) override;
  void operate(ExpExpr &e) override;
  void operate(LogExpr &e) override;
  void operate(SinExpr &e) override;
  void operate(CosExpr &e) override;
  void operate(TanExpr &e) override;
  void operate(RndExpr &e) override;
  void operate(PeekExpr &e) override;
  void operate(RelationalExpr &e) override;
  void operate(PointExpr &e) override;

private:
  ConstTable &constTable;
};

class StatementConstTabulator : public StatementOp {
public:
  explicit StatementConstTabulator(ConstTable &ct) : op(ct), that(&op) {}
  void operate(For &s) override;
  void operate(When &s) override;
  void operate(If &s) override;
  void operate(Print &s) override;
  void operate(Input &s) override;
  void operate(On &s) override;
  void operate(Dim &s) override;
  void operate(Let &s) override;
  void operate(Inc &s) override;
  void operate(Dec &s) override;
  void operate(Poke &s) override;
  void operate(Clear &s) override;
  void operate(Set &s) override;
  void operate(Reset &s) override;
  void operate(Cls &s) override;
  void operate(Sound &s) override;

private:
  using StatementOp::operate;
  ExprConstTabulator op;
  ExprOp *that;
};

class ConstTabulator : public ProgramOp {
public:
  explicit ConstTabulator(ConstTable &ct) : constTable(ct), op(ct), that(&op) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  using ProgramOp::operate;
  ConstTable &constTable;
  StatementConstTabulator op;
  StatementOp *that;
};
#endif
