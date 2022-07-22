// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRTRANSMUTATOR_HPP
#define AST_NULLEXPRTRANSMUTATOR_HPP

#include "expression.hpp"

class NullExprTransmutator
    : public ExprMutator<up<NumericExpr>, up<StringExpr>> {
public:
  virtual up<NumericExpr> mutate(ArrayIndicesExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(NumericConstantExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<StringExpr> mutate(StringConstantExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<NumericExpr> mutate(NumericArrayExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<StringExpr> mutate(StringArrayExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<NumericExpr> mutate(NumericVariableExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<StringExpr> mutate(StringVariableExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<NumericExpr> mutate(NaryNumericExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<StringExpr> mutate(StringConcatenationExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<StringExpr> mutate(PrintTabExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<StringExpr> mutate(PrintSpaceExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<StringExpr> mutate(PrintCRExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<StringExpr> mutate(PrintCommaExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<NumericExpr> mutate(PowerExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(IntegerDivisionExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(MultiplicativeExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(AdditiveExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(ComplementedExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(RelationalExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(AndExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(OrExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(ShiftExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(SgnExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(IntExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(AbsExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(SqrExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(ExpExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(LogExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(SinExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(CosExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(TanExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(RndExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(PeekExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(LenExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<StringExpr> mutate(StrExpr & /*expr*/) { return up<StringExpr>(); }
  virtual up<NumericExpr> mutate(ValExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(AscExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<StringExpr> mutate(ChrExpr & /*expr*/) { return up<StringExpr>(); }
  virtual up<StringExpr> mutate(LeftExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<StringExpr> mutate(RightExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<StringExpr> mutate(MidExpr & /*expr*/) { return up<StringExpr>(); }
  virtual up<NumericExpr> mutate(PointExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<StringExpr> mutate(InkeyExpr & /*expr*/) {
    return up<StringExpr>();
  }
  virtual up<NumericExpr> mutate(MemExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(SquareExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(TimerExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(PosExpr & /*expr*/) {
    return up<NumericExpr>();
  }
  virtual up<NumericExpr> mutate(PeekWordExpr & /*expr*/) {
    return up<NumericExpr>();
  }
};

#endif
