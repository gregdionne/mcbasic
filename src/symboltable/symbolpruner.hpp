// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_SYMBOLPRUNER_HPP
#define SYMBOLTABLE_SYMBOLPRUNER_HPP

#include "ast/program.hpp"
#include "symboltable.hpp"
#include "utils/announcer.hpp"

// Validate symbols exist in symbol table

class ExprSymbolPruner : public ExprMutator<void, void> {
public:
  ExprSymbolPruner(SymbolTable &st, int line, Announcer &a)
      : symbolTable(st), lineNumber(line), announcer(a) {}

  ExprSymbolPruner() = delete;
  ExprSymbolPruner(const ExprSymbolPruner &) = delete;
  ExprSymbolPruner(ExprSymbolPruner &&) = delete;
  ExprSymbolPruner &operator=(const ExprSymbolPruner &) = delete;
  ExprSymbolPruner &operator=(ExprSymbolPruner &&) = delete;
  ~ExprSymbolPruner() override = default;

  void mutate(ArrayIndicesExpr & /*expr*/) override;
  void mutate(NumericConstantExpr & /*expr*/) override;
  void mutate(StringConstantExpr & /*expr*/) override;
  void mutate(NumericArrayExpr & /*expr*/) override;
  void mutate(StringArrayExpr & /*expr*/) override;
  void mutate(NumericVariableExpr & /*expr*/) override;
  void mutate(StringVariableExpr & /*expr*/) override;
  void mutate(NaryNumericExpr & /*expr*/) override;
  void mutate(StringConcatenationExpr & /*expr*/) override;
  void mutate(PrintTabExpr & /*expr*/) override;
  void mutate(PrintSpaceExpr & /*expr*/) override;
  void mutate(PrintCRExpr & /*expr*/) override;
  void mutate(PrintCommaExpr & /*expr*/) override;
  void mutate(PowerExpr & /*expr*/) override;
  void mutate(IntegerDivisionExpr & /*expr*/) override;
  void mutate(MultiplicativeExpr & /*expr*/) override;
  void mutate(AdditiveExpr & /*expr*/) override;
  void mutate(ComplementedExpr & /*expr*/) override;
  void mutate(RelationalExpr & /*expr*/) override;
  void mutate(AndExpr & /*expr*/) override;
  void mutate(OrExpr & /*expr*/) override;
  void mutate(ShiftExpr & /*expr*/) override;
  void mutate(SgnExpr & /*expr*/) override;
  void mutate(IntExpr & /*expr*/) override;
  void mutate(AbsExpr & /*expr*/) override;
  void mutate(SqrExpr & /*expr*/) override;
  void mutate(ExpExpr & /*expr*/) override;
  void mutate(LogExpr & /*expr*/) override;
  void mutate(SinExpr & /*expr*/) override;
  void mutate(CosExpr & /*expr*/) override;
  void mutate(TanExpr & /*expr*/) override;
  void mutate(RndExpr & /*expr*/) override;
  void mutate(PeekExpr & /*expr*/) override;
  void mutate(LenExpr & /*expr*/) override;
  void mutate(StrExpr & /*expr*/) override;
  void mutate(ValExpr & /*expr*/) override;
  void mutate(AscExpr & /*expr*/) override;
  void mutate(ChrExpr & /*expr*/) override;
  void mutate(LeftExpr & /*expr*/) override;
  void mutate(RightExpr & /*expr*/) override;
  void mutate(MidExpr & /*expr*/) override;
  void mutate(PointExpr & /*expr*/) override;
  void mutate(InkeyExpr & /*expr*/) override;
  void mutate(MemExpr & /*expr*/) override;
  void mutate(SquareExpr & /*expr*/) override;
  void mutate(TimerExpr & /*expr*/) override;
  void mutate(PosExpr & /*expr*/) override;
  void mutate(PeekWordExpr & /*expr*/) override;

  void reset() { missing = false; }
  bool isMissing() const { return missing; }

private:
  bool missing{false};
  SymbolTable &symbolTable;
  int lineNumber;
  Announcer &announcer;
};

class StatementSymbolPruner : public StatementMutator<void> {
public:
  StatementSymbolPruner(SymbolTable &st, int line, Announcer &a)
      : se(st, line, a), that(&se) {}

  StatementSymbolPruner() = delete;
  StatementSymbolPruner(const StatementSymbolPruner &) = delete;
  StatementSymbolPruner(StatementSymbolPruner &&) = delete;
  StatementSymbolPruner &operator=(const StatementSymbolPruner &) = delete;
  StatementSymbolPruner &operator=(StatementSymbolPruner &&) = delete;
  ~StatementSymbolPruner() override = default;

  void mutate(Rem & /*s*/) override;
  void mutate(For & /*s*/) override;
  void mutate(Go & /*s*/) override;
  void mutate(When & /*s*/) override;
  void mutate(If & /*s*/) override;
  void mutate(Data & /*s*/) override;
  void mutate(Print & /*s*/) override;
  void mutate(Input & /*s*/) override;
  void mutate(End & /*s*/) override;
  void mutate(On & /*s*/) override;
  void mutate(Next & /*s*/) override;
  void mutate(Dim & /*s*/) override;
  void mutate(Read & /*s*/) override;
  void mutate(Let & /*s*/) override;
  void mutate(Accum & /*s*/) override;
  void mutate(Decum & /*s*/) override;
  void mutate(Necum & /*s*/) override;
  void mutate(Run & /*s*/) override;
  void mutate(Restore & /*s*/) override;
  void mutate(Return & /*s*/) override;
  void mutate(Stop & /*s*/) override;
  void mutate(Poke & /*s*/) override;
  void mutate(Clear & /*s*/) override;
  void mutate(Set & /*s*/) override;
  void mutate(Reset & /*s*/) override;
  void mutate(Cls & /*s*/) override;
  void mutate(Sound & /*s*/) override;
  void mutate(Exec & /*s*/) override;
  void mutate(Error & /*s*/) override;

private:
  ExprSymbolPruner se;
  ExprSymbolPruner *that;
};

class SymbolPruner : public ProgramOp {
public:
  SymbolPruner(SymbolTable &st, Announcer &&a)
      : symbolTable(st), announcer(a) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  SymbolTable &symbolTable;
  Announcer announcer;
};
#endif
