// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_IMPURITYREAPER_HPP
#define OPTIMIZER_IMPURITYREAPER_HPP

#include "ast/expression.hpp"
#include "ast/nullstatementtransmutator.hpp"
#include "ast/pessimisticexprchecker.hpp"

// These classes are intended to be used when removing statements whose
// expressions have side-effects (e.g., they additionally alter the state
// of a random number generator, or the state of memory of the key polling
// buffer.) A pure expression has no side-effects.
//
// Before removing a statement we destructively collate any impure expressions
// found within.  If any are found, we return it in an EVAL statement, otherwise
// we return null.

// An impure expression has side-effects
class IsImpure : public PessimisticExprChecker {
public:
  IsImpure() = default;
  IsImpure(const IsImpure &) = delete;
  IsImpure(IsImpure &&) = delete;
  IsImpure &operator=(const IsImpure &) = delete;
  IsImpure &operator=(IsImpure &&) = delete;
  ~IsImpure() override = default;

  bool inspect(const RndExpr & /*expr*/) const override { return true; }
  bool inspect(const InkeyExpr & /*expr*/) const override { return true; }
};

// Destructively aggregates (reaps) impure expressions
class ExprImpurityReaper : public ExprMutator<void, void> {
public:
  explicit ExprImpurityReaper(std::vector<up<Expr>> &r) : results(r) {}
  ExprImpurityReaper() = delete;
  ExprImpurityReaper(const ExprImpurityReaper &) = delete;
  ExprImpurityReaper(ExprImpurityReaper &&) = delete;
  ExprImpurityReaper &operator=(const ExprImpurityReaper &) = delete;
  ExprImpurityReaper &operator=(ExprImpurityReaper &&) = delete;
  ~ExprImpurityReaper() override = default;

  void mutate(ArrayIndicesExpr &expr) override;
  void mutate(NumericConstantExpr &expr) override;
  void mutate(StringConstantExpr &expr) override;
  void mutate(NumericArrayExpr &expr) override;
  void mutate(StringArrayExpr &expr) override;
  void mutate(NumericVariableExpr &expr) override;
  void mutate(StringVariableExpr &expr) override;
  void mutate(NaryNumericExpr &expr) override;
  void mutate(StringConcatenationExpr &expr) override;
  void mutate(PrintTabExpr &expr) override;
  void mutate(PrintSpaceExpr &expr) override;
  void mutate(PrintCRExpr &expr) override;
  void mutate(PrintCommaExpr &expr) override;
  void mutate(PowerExpr &expr) override;
  void mutate(IntegerDivisionExpr &expr) override;
  void mutate(MultiplicativeExpr &expr) override;
  void mutate(AdditiveExpr &expr) override;
  void mutate(ComplementedExpr &expr) override;
  void mutate(RelationalExpr &expr) override;
  void mutate(AndExpr &expr) override;
  void mutate(OrExpr &expr) override;
  void mutate(ShiftExpr &expr) override;
  void mutate(SgnExpr &expr) override;
  void mutate(IntExpr &expr) override;
  void mutate(AbsExpr &expr) override;
  void mutate(SqrExpr &expr) override;
  void mutate(ExpExpr &expr) override;
  void mutate(LogExpr &expr) override;
  void mutate(SinExpr &expr) override;
  void mutate(CosExpr &expr) override;
  void mutate(TanExpr &expr) override;
  void mutate(RndExpr &expr) override;
  void mutate(PeekExpr &expr) override;
  void mutate(LenExpr &expr) override;
  void mutate(StrExpr &expr) override;
  void mutate(ValExpr &expr) override;
  void mutate(AscExpr &expr) override;
  void mutate(ChrExpr &expr) override;
  void mutate(LeftExpr &expr) override;
  void mutate(RightExpr &expr) override;
  void mutate(MidExpr &expr) override;
  void mutate(PointExpr &expr) override;
  void mutate(InkeyExpr &expr) override;
  void mutate(MemExpr &expr) override;
  void mutate(SquareExpr &expr) override;
  void mutate(TimerExpr &expr) override;
  void mutate(PosExpr &expr) override;
  void mutate(PeekWordExpr &expr) override;

  void reap(up<Expr> &expr);
  void reap(up<NumericExpr> &numExpr);
  void reap(up<StringExpr> &strExpr);

  std::vector<up<Expr>> &results;

private:
  IsImpure isImpure;
};

// traverse through a statement destructively
// collating expressions with side-effects.
//
// if any are found, it wraps them into an
// Eval statement
class StatementImpurityReaper : public NullStatementTransmutator {
public:
  // for if statements with no consequent
  up<Statement> mutate(If &s) override;

  // for unused assignments
  up<Statement> mutate(Let &s) override;
  up<Statement> mutate(Accum &s) override;
  up<Statement> mutate(Decum &s) override;
  up<Statement> mutate(Necum &s) override;

private:
  using NullStatementTransmutator::mutate;
  std::vector<up<Expr>> results;
};

#endif
