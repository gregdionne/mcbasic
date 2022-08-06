// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRTRANSMUTATOR_HPP
#define AST_NULLEXPRTRANSMUTATOR_HPP

#include "expression.hpp"

class NullExprTransmutator
    : public ExprMutator<up<NumericExpr>, up<StringExpr>> {
public:
  NullExprTransmutator() = default;
  NullExprTransmutator(const NullExprTransmutator &) = delete;
  NullExprTransmutator(NullExprTransmutator &&) = delete;
  NullExprTransmutator &operator=(const NullExprTransmutator &) = delete;
  NullExprTransmutator &operator=(NullExprTransmutator &&) = delete;
  ~NullExprTransmutator() override = default;

  up<NumericExpr> mutate(ArrayIndicesExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(NumericConstantExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(StringConstantExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(NumericArrayExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(StringArrayExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(NumericVariableExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(StringVariableExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(NaryNumericExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(StringConcatenationExpr & /*expr*/) override {
    return {};
  }
  up<StringExpr> mutate(PrintTabExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(PrintSpaceExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(PrintCRExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(PrintCommaExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(PowerExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(IntegerDivisionExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(MultiplicativeExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(AdditiveExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(ComplementedExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(RelationalExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(AndExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(OrExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(ShiftExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(SgnExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(IntExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(AbsExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(SqrExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(ExpExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(LogExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(SinExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(CosExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(TanExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(RndExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(PeekExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(LenExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(StrExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(ValExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(AscExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(ChrExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(LeftExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(RightExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(MidExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(PointExpr & /*expr*/) override { return {}; }
  up<StringExpr> mutate(InkeyExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(MemExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(SquareExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(TimerExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(PosExpr & /*expr*/) override { return {}; }
  up<NumericExpr> mutate(PeekWordExpr & /*expr*/) override { return {}; }
};

#endif
