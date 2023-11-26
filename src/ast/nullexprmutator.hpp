// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLEXPRMUTATOR_HPP
#define AST_NULLEXPRMUTATOR_HPP

#include "ast/expression.hpp"

class NullExprMutator : public ExprMutator<void, void> {
public:
  NullExprMutator() = default;
  NullExprMutator(const NullExprMutator &) = delete;
  NullExprMutator(NullExprMutator &&) = delete;
  NullExprMutator &operator=(const NullExprMutator &) = delete;
  NullExprMutator &operator=(NullExprMutator &&) = delete;
  ~NullExprMutator() override = default;

  void mutate(ArrayIndicesExpr & /*expr*/) override {}
  void mutate(NumericConstantExpr & /*expr*/) override {}
  void mutate(StringConstantExpr & /*expr*/) override {}
  void mutate(NumericArrayExpr & /*expr*/) override {}
  void mutate(StringArrayExpr & /*expr*/) override {}
  void mutate(NumericVariableExpr & /*expr*/) override {}
  void mutate(StringVariableExpr & /*expr*/) override {}
  void mutate(NaryNumericExpr & /*expr*/) override {}
  void mutate(StringConcatenationExpr & /*expr*/) override {}
  void mutate(PrintTabExpr & /*expr*/) override {}
  void mutate(PrintSpaceExpr & /*expr*/) override {}
  void mutate(PrintCRExpr & /*expr*/) override {}
  void mutate(PrintCommaExpr & /*expr*/) override {}
  void mutate(PowerExpr & /*expr*/) override {}
  void mutate(IntegerDivisionExpr & /*expr*/) override {}
  void mutate(MultiplicativeExpr & /*expr*/) override {}
  void mutate(AdditiveExpr & /*expr*/) override {}
  void mutate(ComplementedExpr & /*expr*/) override {}
  void mutate(RelationalExpr & /*expr*/) override {}
  void mutate(AndExpr & /*expr*/) override {}
  void mutate(OrExpr & /*expr*/) override {}
  void mutate(ShiftExpr & /*expr*/) override {}
  void mutate(SgnExpr & /*expr*/) override {}
  void mutate(IntExpr & /*expr*/) override {}
  void mutate(AbsExpr & /*expr*/) override {}
  void mutate(SqrExpr & /*expr*/) override {}
  void mutate(ExpExpr & /*expr*/) override {}
  void mutate(LogExpr & /*expr*/) override {}
  void mutate(SinExpr & /*expr*/) override {}
  void mutate(CosExpr & /*expr*/) override {}
  void mutate(TanExpr & /*expr*/) override {}
  void mutate(RndExpr & /*expr*/) override {}
  void mutate(PeekExpr & /*expr*/) override {}
  void mutate(LenExpr & /*expr*/) override {}
  void mutate(StrExpr & /*expr*/) override {}
  void mutate(ValExpr & /*expr*/) override {}
  void mutate(AscExpr & /*expr*/) override {}
  void mutate(ChrExpr & /*expr*/) override {}
  void mutate(LeftExpr & /*expr*/) override {}
  void mutate(RightExpr & /*expr*/) override {}
  void mutate(MidExpr & /*expr*/) override {}
  void mutate(PointExpr & /*expr*/) override {}
  void mutate(InkeyExpr & /*expr*/) override {}
  void mutate(MemExpr & /*expr*/) override {}
  void mutate(SquareExpr & /*expr*/) override {}
  void mutate(FractExpr & /*expr*/) override {}
  void mutate(TimerExpr & /*expr*/) override {}
  void mutate(PosExpr & /*expr*/) override {}
  void mutate(PeekWordExpr & /*expr*/) override {}
};
#endif
