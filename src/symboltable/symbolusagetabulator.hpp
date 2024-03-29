// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_SYMBOLUSAGETABULATOR_HPP
#define SYMBOLTABLE_SYMBOLUSAGETABULATOR_HPP

#include "ast/nullexprinspector.hpp"
#include "ast/program.hpp"
#include "symboltable.hpp"

// Mark usage of
//  - for-loop iteration variables
//  - symbols inside an expression
//  - symbols within indices an array assignment.

class ExprSymbolUsageTabulator : public ExprInspector<void, void> {
public:
  ExprSymbolUsageTabulator(SymbolTable &st, int ln)
      : symbolTable(st), lineNumber(ln) {}
  ExprSymbolUsageTabulator() = delete;
  ExprSymbolUsageTabulator(const ExprSymbolUsageTabulator &) = delete;
  ExprSymbolUsageTabulator(ExprSymbolUsageTabulator &&) = delete;
  ExprSymbolUsageTabulator &
  operator=(const ExprSymbolUsageTabulator &) = delete;
  ExprSymbolUsageTabulator &operator=(ExprSymbolUsageTabulator &&) = delete;
  ~ExprSymbolUsageTabulator() override = default;

  void inspect(const ArrayIndicesExpr &e) const override;
  void inspect(const NumericConstantExpr &e) const override;
  void inspect(const StringConstantExpr &e) const override;
  void inspect(const NumericArrayExpr &e) const override;
  void inspect(const StringArrayExpr &e) const override;
  void inspect(const NumericVariableExpr &e) const override;
  void inspect(const StringVariableExpr &e) const override;
  void inspect(const NaryNumericExpr &e) const override;
  void inspect(const StringConcatenationExpr &e) const override;
  void inspect(const PrintTabExpr &e) const override;
  void inspect(const PrintSpaceExpr &e) const override;
  void inspect(const PrintCRExpr &e) const override;
  void inspect(const PrintCommaExpr &e) const override;
  void inspect(const PowerExpr &e) const override;
  void inspect(const IntegerDivisionExpr &e) const override;
  void inspect(const MultiplicativeExpr &e) const override;
  void inspect(const AdditiveExpr &e) const override;
  void inspect(const ComplementedExpr &e) const override;
  void inspect(const RelationalExpr &e) const override;
  void inspect(const AndExpr &e) const override;
  void inspect(const OrExpr &e) const override;
  void inspect(const ShiftExpr &e) const override;
  void inspect(const SgnExpr &e) const override;
  void inspect(const IntExpr &e) const override;
  void inspect(const AbsExpr &e) const override;
  void inspect(const SqrExpr &e) const override;
  void inspect(const ExpExpr &e) const override;
  void inspect(const LogExpr &e) const override;
  void inspect(const SinExpr &e) const override;
  void inspect(const CosExpr &e) const override;
  void inspect(const TanExpr &e) const override;
  void inspect(const RndExpr &e) const override;
  void inspect(const PeekExpr &e) const override;
  void inspect(const LenExpr &e) const override;
  void inspect(const StrExpr &e) const override;
  void inspect(const ValExpr &e) const override;
  void inspect(const AscExpr &e) const override;
  void inspect(const ChrExpr &e) const override;
  void inspect(const LeftExpr &e) const override;
  void inspect(const RightExpr &e) const override;
  void inspect(const MidExpr &e) const override;
  void inspect(const PointExpr &e) const override;
  void inspect(const InkeyExpr &e) const override;
  void inspect(const MemExpr &e) const override;
  void inspect(const SquareExpr &e) const override;
  void inspect(const FractExpr &e) const override;
  void inspect(const TimerExpr &e) const override;
  void inspect(const PosExpr &e) const override;
  void inspect(const PeekWordExpr &e) const override;

private:
  SymbolTable &symbolTable;
  const int lineNumber;
};

class AssignSymbolUsageInspector : public NullExprInspector {
public:
  AssignSymbolUsageInspector(ExprSymbolUsageTabulator &suei, SymbolTable &st,
                             int ln)
      : exprSymbolUsageTabulator(suei), symbolTable(st), lineNumber(ln) {}
  void inspect(const NumericArrayExpr &e) const override;
  void inspect(const StringArrayExpr &e) const override;

private:
  using NullExprInspector::inspect;
  ExprSymbolUsageTabulator &exprSymbolUsageTabulator;
  SymbolTable &symbolTable;
  int lineNumber;
};

class StatementSymbolUsageInspector : public StatementInspector<void> {
public:
  StatementSymbolUsageInspector(SymbolTable &st, int ln)
      : exprSymbolUsageTabulator(st, ln),
        assignSymbolUsageInspector(exprSymbolUsageTabulator, st, ln),
        symbolTable(st) {}
  StatementSymbolUsageInspector() = delete;
  StatementSymbolUsageInspector(const StatementSymbolUsageInspector &) = delete;
  StatementSymbolUsageInspector(StatementSymbolUsageInspector &&) = delete;
  StatementSymbolUsageInspector &
  operator=(const StatementSymbolUsageInspector &) = delete;
  StatementSymbolUsageInspector &
  operator=(StatementSymbolUsageInspector &&) = delete;
  ~StatementSymbolUsageInspector() override = default;

  void inspect(const Rem &s) const override;
  void inspect(const For &s) const override;
  void inspect(const Go &s) const override;
  void inspect(const When &s) const override;
  void inspect(const If &s) const override;
  void inspect(const Data &s) const override;
  void inspect(const Print &s) const override;
  void inspect(const Input &s) const override;
  void inspect(const End &s) const override;
  void inspect(const On &s) const override;
  void inspect(const Next &s) const override;
  void inspect(const Dim &s) const override;
  void inspect(const Read &s) const override;
  void inspect(const Let &s) const override;
  void inspect(const Accum &s) const override;
  void inspect(const Decum &s) const override;
  void inspect(const Necum &s) const override;
  void inspect(const Eval &s) const override;
  void inspect(const Run &s) const override;
  void inspect(const Restore &s) const override;
  void inspect(const Return &s) const override;
  void inspect(const Stop &s) const override;
  void inspect(const Poke &s) const override;
  void inspect(const Clear &s) const override;
  void inspect(const CLoadM &s) const override;
  void inspect(const CLoadStar &s) const override;
  void inspect(const CSaveStar &s) const override;
  void inspect(const Set &s) const override;
  void inspect(const Reset &s) const override;
  void inspect(const Cls &s) const override;
  void inspect(const Sound &s) const override;
  void inspect(const Exec &s) const override;
  void inspect(const Error &s) const override;

private:
  ExprSymbolUsageTabulator exprSymbolUsageTabulator;
  AssignSymbolUsageInspector assignSymbolUsageInspector;
  SymbolTable &symbolTable;
};

class SymbolUsageInspector : public ProgramOp {
public:
  explicit SymbolUsageInspector(SymbolTable &st) : symbolTable(st) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  SymbolTable &symbolTable;
};

#endif
