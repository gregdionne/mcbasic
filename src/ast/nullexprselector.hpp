// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRSELECTOR_HPP
#define AST_NULLEXPRSELECTOR_HPP

#include "expression.hpp"

class NullExprSelector
    : public ExprInspector<const NumericExpr *, const StringExpr *> {
public:
  NullExprSelector() = default;
  NullExprSelector(const NullExprSelector &) = delete;
  NullExprSelector(NullExprSelector &&) = delete;
  NullExprSelector &operator=(const NullExprSelector &) = delete;
  NullExprSelector &operator=(NullExprSelector &&) = delete;
  ~NullExprSelector() override = default;

  const NumericExpr *inspect(const ArrayIndicesExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *
  inspect(const NumericConstantExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *
  inspect(const StringConstantExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const NumericArrayExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const StringArrayExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *
  inspect(const NumericVariableExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *
  inspect(const StringVariableExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const NaryNumericExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *
  inspect(const StringConcatenationExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintTabExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintSpaceExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintCRExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintCommaExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const PowerExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *
  inspect(const IntegerDivisionExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *
  inspect(const MultiplicativeExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const AdditiveExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const ComplementedExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const RelationalExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const AndExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const OrExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const ShiftExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const SgnExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const IntExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const AbsExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const SqrExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const ExpExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const LogExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const SinExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const CosExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const TanExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const RndExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const PeekExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const LenExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const StrExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const ValExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const AscExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const ChrExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const LeftExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const RightExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const MidExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const PointExpr & /*expr*/) const override {
    return nullptr;
  }
  const StringExpr *inspect(const InkeyExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const MemExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const SquareExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const FractExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const TimerExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const PosExpr & /*expr*/) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const PeekWordExpr & /*expr*/) const override {
    return nullptr;
  }
};

#endif
