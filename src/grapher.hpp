// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef GRAPHER_HPP
#define GRAPHER_HPP

#include "program.hpp"

// Debugging aid
// Print the program's abstract syntax tree

class ExprGrapher : public ExprOp {
public:
  explicit ExprGrapher(int &n_in) : n(n_in) {}
  void operate(NumericConstantExpr &e) override;
  void operate(StringConstantExpr &e) override;
  void operate(NumericVariableExpr &e) override;
  void operate(StringVariableExpr &e) override;
  void operate(NaryNumericExpr &e) override;
  void operate(StringConcatenationExpr &e) override;
  void operate(ArrayIndicesExpr &e) override;
  void operate(PrintTabExpr &e) override;
  void operate(PrintCommaExpr &e) override;
  void operate(PrintSpaceExpr &e) override;
  void operate(PrintCRExpr &e) override;
  void operate(NumericArrayExpr &e) override;
  void operate(StringArrayExpr &e) override;
  void operate(NegatedExpr &e) override;
  void operate(PowerExpr &e) override;
  void operate(IntegerDivisionExpr &e) override;
  void operate(MultiplicativeExpr &e) override {
    e.NaryNumericExpr::operate(this);
  }
  void operate(AdditiveExpr &e) override { e.NaryNumericExpr::operate(this); }
  void operate(ComplementedExpr &e) override;
  void operate(AndExpr &e) override { e.NaryNumericExpr::operate(this); }
  void operate(OrExpr &e) override { e.NaryNumericExpr::operate(this); }
  void operate(ShiftExpr &e) override;
  void operate(SgnExpr &e) override;
  void operate(IntExpr &e) override;
  void operate(AbsExpr &e) override;
  void operate(RndExpr &e) override;
  void operate(PeekExpr &e) override;
  void operate(LenExpr &e) override;
  void operate(StrExpr &e) override;
  void operate(ValExpr &e) override;
  void operate(AscExpr &e) override;
  void operate(ChrExpr &e) override;
  void operate(RelationalExpr &e) override;
  void operate(LeftExpr &e) override;
  void operate(RightExpr &e) override;
  void operate(MidExpr &e) override;
  void operate(PointExpr &e) override;
  void operate(InkeyExpr &e) override;
  int &n;
};

class StatementGrapher : public StatementOp {
public:
  explicit StatementGrapher(int &n_in) : n(n_in), ge(n), that(&ge) {}
  void operate(Rem &s) override;
  void operate(For &s) override;
  void operate(Go &s) override;
  void operate(When &s) override;
  void operate(If &s) override;
  void operate(Data &s) override;
  void operate(Print &s) override;
  void operate(Input &s) override;
  void operate(End &s) override;
  void operate(On &s) override;
  void operate(Next &s) override;
  void operate(Dim &s) override;
  void operate(Read &s) override;
  void operate(Let &s) override;
  void operate(Inc &s) override;
  void operate(Dec &s) override;
  void operate(Run &s) override;
  void operate(Restore &s) override;
  void operate(Return &s) override;
  void operate(Stop &s) override;
  void operate(Poke &s) override;
  void operate(Clear &s) override;
  void operate(Set &s) override;
  void operate(Reset &s) override;
  void operate(Cls &s) override;
  void operate(Sound &s) override;
  int &n;
  ExprGrapher ge;
  ExprGrapher *that;
};

class Grapher : public ProgramOp {
public:
  Grapher() : gs(n), that(&gs) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  int n{0};
  StatementGrapher gs;
  StatementGrapher *that;
};
#endif
