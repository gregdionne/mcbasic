// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRSELECTOR_HPP
#define AST_NULLEXPRSELECTOR_HPP

#include "expression.hpp"

class NullExprSelector
    : public ExprInspector<const NumericExpr *, const StringExpr *> {
public:
  const NumericExpr *inspect(const ArrayIndicesExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const NumericConstantExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const StringConstantExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const NumericArrayExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const StringArrayExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const NumericVariableExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const StringVariableExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const NaryNumericExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const StringConcatenationExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintTabExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintSpaceExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintCRExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const PrintCommaExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const PowerExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const IntegerDivisionExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const MultiplicativeExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const AdditiveExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const ComplementedExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const RelationalExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const AndExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const OrExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const ShiftExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const SgnExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const IntExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const AbsExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const SqrExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const ExpExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const LogExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const SinExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const CosExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const TanExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const RndExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const PeekExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const LenExpr &) const override { return nullptr; }
  const StringExpr *inspect(const StrExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const ValExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const AscExpr &) const override { return nullptr; }
  const StringExpr *inspect(const ChrExpr &) const override { return nullptr; }
  const StringExpr *inspect(const LeftExpr &) const override { return nullptr; }
  const StringExpr *inspect(const RightExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const MidExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const PointExpr &) const override {
    return nullptr;
  }
  const StringExpr *inspect(const InkeyExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const MemExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const TimerExpr &) const override {
    return nullptr;
  }
  const NumericExpr *inspect(const PosExpr &) const override { return nullptr; }
  const NumericExpr *inspect(const PeekWordExpr &) const override {
    return nullptr;
  }
};

#endif
