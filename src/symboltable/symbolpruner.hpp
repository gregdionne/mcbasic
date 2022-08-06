// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_SYMBOLPRUNER_HPP
#define SYMBOLTABLE_SYMBOLPRUNER_HPP

#include "ast/nullexprmutator.hpp"
#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "symboltable.hpp"

// Validate symbols exist in symbol table

class ExprSymbolPruner : public NullExprMutator {
public:
  ExprSymbolPruner(SymbolTable &st, int line, bool w)
      : symbolTable(st), lineNumber(line), warn(w) {}
  void mutate(NumericConstantExpr & /*e*/) override {}
  void mutate(StringConstantExpr & /*e*/) override {}
  void mutate(NumericVariableExpr &e) override;
  void mutate(StringVariableExpr &e) override;
  void mutate(NaryNumericExpr &e) override;
  void mutate(StringConcatenationExpr &e) override;
  void mutate(ArrayIndicesExpr &e) override;
  void mutate(PrintTabExpr &e) override;
  void mutate(PrintCommaExpr & /*e*/) override {}
  void mutate(PrintSpaceExpr & /*e*/) override {}
  void mutate(PrintCRExpr & /*e*/) override {}
  void mutate(NumericArrayExpr &e) override;
  void mutate(StringArrayExpr &e) override;
  void mutate(PowerExpr &e) override;
  void mutate(IntegerDivisionExpr &e) override;
  void mutate(MultiplicativeExpr &e) override {
    e.NaryNumericExpr::mutate(this);
  }
  void mutate(AdditiveExpr &e) override { e.NaryNumericExpr::mutate(this); }
  void mutate(ComplementedExpr &e) override;
  void mutate(AndExpr &e) override { e.NaryNumericExpr::mutate(this); }
  void mutate(OrExpr &e) override { e.NaryNumericExpr::mutate(this); }
  void mutate(ShiftExpr &e) override;
  void mutate(SgnExpr &e) override;
  void mutate(IntExpr &e) override;
  void mutate(AbsExpr &e) override;
  void mutate(RndExpr &e) override;
  void mutate(PeekExpr &e) override;
  void mutate(LenExpr &e) override;
  void mutate(StrExpr &e) override;
  void mutate(ValExpr &e) override;
  void mutate(AscExpr &e) override;
  void mutate(ChrExpr &e) override;
  void mutate(RelationalExpr &e) override;
  void mutate(LeftExpr &e) override;
  void mutate(RightExpr &e) override;
  void mutate(MidExpr &e) override;
  void mutate(PointExpr &e) override;
  void mutate(InkeyExpr & /*e*/) override {}
  void mutate(SquareExpr &e) override;

  void reset() { missing = false; }
  bool isMissing() const { return missing; }

private:
  bool missing{false};
  SymbolTable &symbolTable;
  int lineNumber;
  bool warn;
};

class StatementSymbolPruner : public NullStatementMutator {
public:
  StatementSymbolPruner(SymbolTable &st, int line, bool warn)
      : se(st, line, warn), that(&se) {}
  void mutate(Rem & /*s*/) override {}
  void mutate(For &s) override;
  void mutate(Go & /*s*/) override {}
  void mutate(When &s) override;
  void mutate(If &s) override;
  void mutate(Data & /*s*/) override {}
  void mutate(Print &s) override;
  void mutate(Input &s) override;
  void mutate(End & /*s*/) override {}
  void mutate(On &s) override;
  void mutate(Next &s) override;
  void mutate(Dim &s) override;
  void mutate(Read &s) override;
  void mutate(Let &s) override;
  void mutate(Accum &s) override;
  void mutate(Decum &s) override;
  void mutate(Necum &s) override;
  void mutate(Run & /*s*/) override {}
  void mutate(Restore & /*s*/) override {}
  void mutate(Return & /*s*/) override {}
  void mutate(Stop & /*s*/) override {}
  void mutate(Poke &s) override;
  void mutate(Clear &s) override;
  void mutate(Set &s) override;
  void mutate(Reset &s) override;
  void mutate(Cls &s) override;
  void mutate(Sound &s) override;
  void mutate(Exec &s) override;

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
