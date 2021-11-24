// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLPRUNER_HPP
#define SYMBOLPRUNER_HPP

#include "program.hpp"

// Validate symbols exist in symbol table

class ExprSymbolPruner : public ExprOp {
public:
  ExprSymbolPruner(SymbolTable &st, int line, bool w)
      : symbolTable(st), lineNumber(line), warn(w) {}
  void operate(NumericConstantExpr &) override {}
  void operate(StringConstantExpr &) override {}
  void operate(NumericVariableExpr &e) override;
  void operate(StringVariableExpr &e) override;
  void operate(NaryNumericExpr &e) override;
  void operate(StringConcatenationExpr &e) override;
  void operate(ArrayIndicesExpr &e) override;
  void operate(PrintTabExpr &e) override;
  void operate(PrintCommaExpr &) override {}
  void operate(PrintSpaceExpr &) override {}
  void operate(PrintCRExpr &) override {}
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
  void operate(InkeyExpr &) override {}

  bool isMissing{false};

private:
  SymbolTable &symbolTable;
  int lineNumber;
  bool warn;
};

class StatementSymbolPruner : public StatementOp {
public:
  StatementSymbolPruner(SymbolTable &st, int line, bool warn)
      : se(st, line, warn), that(&se) {}
  void operate(Rem &) override {}
  void operate(For &s) override;
  void operate(Go &) override {}
  void operate(When &s) override;
  void operate(If &s) override;
  void operate(Data &) override {}
  void operate(Print &s) override;
  void operate(Input &s) override;
  void operate(End &) override {}
  void operate(On &s) override;
  void operate(Next &s) override;
  void operate(Dim &s) override;
  void operate(Read &s) override;
  void operate(Let &s) override;
  void operate(Inc &s) override;
  void operate(Dec &s) override;
  void operate(Run &) override {}
  void operate(Restore &) override {}
  void operate(Return &) override {}
  void operate(Stop &) override {}
  void operate(Poke &s) override;
  void operate(Clear &s) override;
  void operate(Set &s) override;
  void operate(Reset &s) override;
  void operate(Cls &s) override;
  void operate(Sound &s) override;

private:
  ExprSymbolPruner se;
  ExprSymbolPruner *that;
};

class SymbolPruner : public ProgramOp {
public:
  SymbolPruner(SymbolTable &st, bool w) : symbolTable(st), warn(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  SymbolTable &symbolTable;
  bool warn;
};
#endif
