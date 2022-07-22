// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRMUTATOR_HPP
#define AST_NULLEXPRMUTATOR_HPP

#include "ast/expression.hpp"

class NullExprMutator : public ExprMutator<void, void> {
public:
  virtual void mutate(ArrayIndicesExpr & /*expr*/) override {}
  virtual void mutate(NumericConstantExpr & /*expr*/) override {}
  virtual void mutate(StringConstantExpr & /*expr*/) override {}
  virtual void mutate(NumericArrayExpr & /*expr*/) override {}
  virtual void mutate(StringArrayExpr & /*expr*/) override {}
  virtual void mutate(NumericVariableExpr & /*expr*/) override {}
  virtual void mutate(StringVariableExpr & /*expr*/) override {}
  virtual void mutate(NaryNumericExpr & /*expr*/) override {}
  virtual void mutate(StringConcatenationExpr & /*expr*/) override {}
  virtual void mutate(PrintTabExpr & /*expr*/) override {}
  virtual void mutate(PrintSpaceExpr & /*expr*/) override {}
  virtual void mutate(PrintCRExpr & /*expr*/) override {}
  virtual void mutate(PrintCommaExpr & /*expr*/) override {}
  virtual void mutate(PowerExpr & /*expr*/) override {}
  virtual void mutate(IntegerDivisionExpr & /*expr*/) override {}
  virtual void mutate(MultiplicativeExpr & /*expr*/) override {}
  virtual void mutate(AdditiveExpr & /*expr*/) override {}
  virtual void mutate(ComplementedExpr & /*expr*/) override {}
  virtual void mutate(RelationalExpr & /*expr*/) override {}
  virtual void mutate(AndExpr & /*expr*/) override {}
  virtual void mutate(OrExpr & /*expr*/) override {}
  virtual void mutate(ShiftExpr & /*expr*/) override {}
  virtual void mutate(SgnExpr & /*expr*/) override {}
  virtual void mutate(IntExpr & /*expr*/) override {}
  virtual void mutate(AbsExpr & /*expr*/) override {}
  virtual void mutate(SqrExpr & /*expr*/) override {}
  virtual void mutate(ExpExpr & /*expr*/) override {}
  virtual void mutate(LogExpr & /*expr*/) override {}
  virtual void mutate(SinExpr & /*expr*/) override {}
  virtual void mutate(CosExpr & /*expr*/) override {}
  virtual void mutate(TanExpr & /*expr*/) override {}
  virtual void mutate(RndExpr & /*expr*/) override {}
  virtual void mutate(PeekExpr & /*expr*/) override {}
  virtual void mutate(LenExpr & /*expr*/) override {}
  virtual void mutate(StrExpr & /*expr*/) override {}
  virtual void mutate(ValExpr & /*expr*/) override {}
  virtual void mutate(AscExpr & /*expr*/) override {}
  virtual void mutate(ChrExpr & /*expr*/) override {}
  virtual void mutate(LeftExpr & /*expr*/) override {}
  virtual void mutate(RightExpr & /*expr*/) override {}
  virtual void mutate(MidExpr & /*expr*/) override {}
  virtual void mutate(PointExpr & /*expr*/) override {}
  virtual void mutate(InkeyExpr & /*expr*/) override {}
  virtual void mutate(MemExpr & /*expr*/) override {}
  virtual void mutate(SquareExpr & /*expr*/) override {}
  virtual void mutate(TimerExpr & /*expr*/) override {}
  virtual void mutate(PosExpr & /*expr*/) override {}
  virtual void mutate(PeekWordExpr & /*expr*/) override {}
};
#endif
