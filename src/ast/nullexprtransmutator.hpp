// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRTRANSMUTATOR_HPP
#define AST_NULLEXPRTRANSMUTATOR_HPP

#include "expression.hpp"

class NullExprTransmutator : public ExprMutator<std::unique_ptr<NumericExpr>,
                                                std::unique_ptr<StringExpr>> {
public:
  virtual std::unique_ptr<NumericExpr> mutate(ArrayIndicesExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(NumericConstantExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(StringConstantExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(NumericArrayExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(StringArrayExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(NumericVariableExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(StringVariableExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(NaryNumericExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<StringExpr>
  mutate(StringConcatenationExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(PrintTabExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(PrintSpaceExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(PrintCRExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(PrintCommaExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(NegatedExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(PowerExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(IntegerDivisionExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(MultiplicativeExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(AdditiveExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(ComplementedExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(RelationalExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(AndExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(OrExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(ShiftExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(SgnExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(IntExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(AbsExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(SqrExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(ExpExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(LogExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(SinExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(CosExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(TanExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(RndExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(PeekExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(LenExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(StrExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(ValExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(AscExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(ChrExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(LeftExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(RightExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(MidExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(PointExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
  virtual std::unique_ptr<StringExpr> mutate(InkeyExpr & /*expr*/) {
    return std::unique_ptr<StringExpr>();
  }
  virtual std::unique_ptr<NumericExpr> mutate(MemExpr & /*expr*/) {
    return std::unique_ptr<NumericExpr>();
  }
};

#endif
