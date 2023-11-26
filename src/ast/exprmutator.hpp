// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_EXPRMUTATOR_HPP
#define AST_EXPRMUTATOR_HPP

#include "fwddeclexpression.hpp"

// ExprMutator
//   Changes an expression in-place.
//   Return values templetized according to string/numeric type
template <typename Number, typename String> class ExprMutator {
public:
  ExprMutator() = default;
  ExprMutator(const ExprMutator &) = delete;
  ExprMutator(ExprMutator &&) = delete;
  ExprMutator &operator=(const ExprMutator &) = delete;
  ExprMutator &operator=(ExprMutator &&) = delete;
  virtual ~ExprMutator() = default;

  virtual Number mutate(ArrayIndicesExpr & /*expr*/) = 0;
  virtual Number mutate(NumericConstantExpr & /*expr*/) = 0;
  virtual String mutate(StringConstantExpr & /*expr*/) = 0;
  virtual Number mutate(NumericArrayExpr & /*expr*/) = 0;
  virtual String mutate(StringArrayExpr & /*expr*/) = 0;
  virtual Number mutate(NumericVariableExpr & /*expr*/) = 0;
  virtual String mutate(StringVariableExpr & /*expr*/) = 0;
  virtual Number mutate(NaryNumericExpr & /*expr*/) = 0;
  virtual String mutate(StringConcatenationExpr & /*expr*/) = 0;
  virtual String mutate(PrintTabExpr & /*expr*/) = 0;
  virtual String mutate(PrintSpaceExpr & /*expr*/) = 0;
  virtual String mutate(PrintCRExpr & /*expr*/) = 0;
  virtual String mutate(PrintCommaExpr & /*expr*/) = 0;
  virtual Number mutate(PowerExpr & /*expr*/) = 0;
  virtual Number mutate(IntegerDivisionExpr & /*expr*/) = 0;
  virtual Number mutate(MultiplicativeExpr & /*expr*/) = 0;
  virtual Number mutate(AdditiveExpr & /*expr*/) = 0;
  virtual Number mutate(ComplementedExpr & /*expr*/) = 0;
  virtual Number mutate(RelationalExpr & /*expr*/) = 0;
  virtual Number mutate(AndExpr & /*expr*/) = 0;
  virtual Number mutate(OrExpr & /*expr*/) = 0;
  virtual Number mutate(ShiftExpr & /*expr*/) = 0;
  virtual Number mutate(SgnExpr & /*expr*/) = 0;
  virtual Number mutate(IntExpr & /*expr*/) = 0;
  virtual Number mutate(AbsExpr & /*expr*/) = 0;
  virtual Number mutate(SqrExpr & /*expr*/) = 0;
  virtual Number mutate(ExpExpr & /*expr*/) = 0;
  virtual Number mutate(LogExpr & /*expr*/) = 0;
  virtual Number mutate(SinExpr & /*expr*/) = 0;
  virtual Number mutate(CosExpr & /*expr*/) = 0;
  virtual Number mutate(TanExpr & /*expr*/) = 0;
  virtual Number mutate(RndExpr & /*expr*/) = 0;
  virtual Number mutate(PeekExpr & /*expr*/) = 0;
  virtual Number mutate(LenExpr & /*expr*/) = 0;
  virtual String mutate(StrExpr & /*expr*/) = 0;
  virtual Number mutate(ValExpr & /*expr*/) = 0;
  virtual Number mutate(AscExpr & /*expr*/) = 0;
  virtual String mutate(ChrExpr & /*expr*/) = 0;
  virtual String mutate(LeftExpr & /*expr*/) = 0;
  virtual String mutate(RightExpr & /*expr*/) = 0;
  virtual String mutate(MidExpr & /*expr*/) = 0;
  virtual Number mutate(PointExpr & /*expr*/) = 0;
  virtual String mutate(InkeyExpr & /*expr*/) = 0;
  virtual Number mutate(MemExpr & /*expr*/) = 0;
  virtual Number mutate(SquareExpr & /*expr*/) = 0;
  virtual Number mutate(FractExpr & /*expr*/) = 0;
  virtual Number mutate(TimerExpr & /*expr*/) = 0;
  virtual Number mutate(PosExpr & /*expr*/) = 0;
  virtual Number mutate(PeekWordExpr & /*expr*/) = 0;
};

#endif
