// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef GRAPH_HPP
#define GRAPH_HPP

#include "program.hpp"

// Debugging aid
// Print the program's abstract syntax tree

class ExprLister : public ExprOp {
public:
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
  void operate(MultiplicativeExpr &e) override {
    operate(static_cast<NaryNumericExpr &>(e));
  }
  void operate(AdditiveExpr &e) override {
    operate(static_cast<NaryNumericExpr &>(e));
  }
  void operate(ComplementedExpr &e) override;
  void operate(AndExpr &e) override {
    operate(static_cast<NaryNumericExpr &>(e));
  }
  void operate(OrExpr &e) override {
    operate(static_cast<NaryNumericExpr &>(e));
  }
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
  std::string result;
};

class StatementLister : public StatementOp {
public:
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
  std::string result;
  bool generatePredicates{true};
};

class Lister : public ProgramOp {
public:
  void operate(Program &p) override;
  void operate(Line &l) override;
  std::string result;
};
#endif
