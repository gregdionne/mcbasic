// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_OPTIMISTICEXPRCHECKER_HPP
#define AST_OPTIMISTICEXPRCHECKER_HPP

#include "expression.hpp"

class OptimisticExprChecker : public ExprInspector<bool, bool> {
public:
  OptimisticExprChecker() = default;
  OptimisticExprChecker(const OptimisticExprChecker &) = delete;
  OptimisticExprChecker(OptimisticExprChecker &&) = delete;
  OptimisticExprChecker &operator=(const OptimisticExprChecker &) = delete;
  OptimisticExprChecker &operator=(OptimisticExprChecker &&) = delete;
  ~OptimisticExprChecker() override = default;
  bool inspect(const ArrayIndicesExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const NumericConstantExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const StringConstantExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const NumericArrayExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const StringArrayExpr & /*expr*/) const override { return true; }
  bool inspect(const NumericVariableExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const StringVariableExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const NaryNumericExpr & /*expr*/) const override { return true; }
  bool inspect(const StringConcatenationExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const PrintTabExpr & /*expr*/) const override { return true; }
  bool inspect(const PrintSpaceExpr & /*expr*/) const override { return true; }
  bool inspect(const PrintCRExpr & /*expr*/) const override { return true; }
  bool inspect(const PrintCommaExpr & /*expr*/) const override { return true; }
  bool inspect(const PowerExpr & /*expr*/) const override { return true; }
  bool inspect(const IntegerDivisionExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const MultiplicativeExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const AdditiveExpr & /*expr*/) const override { return true; }
  bool inspect(const ComplementedExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const RelationalExpr & /*expr*/) const override { return true; }
  bool inspect(const AndExpr & /*expr*/) const override { return true; }
  bool inspect(const OrExpr & /*expr*/) const override { return true; }
  bool inspect(const ShiftExpr & /*expr*/) const override { return true; }
  bool inspect(const SgnExpr & /*expr*/) const override { return true; }
  bool inspect(const IntExpr & /*expr*/) const override { return true; }
  bool inspect(const AbsExpr & /*expr*/) const override { return true; }
  bool inspect(const SqrExpr & /*expr*/) const override { return true; }
  bool inspect(const ExpExpr & /*expr*/) const override { return true; }
  bool inspect(const LogExpr & /*expr*/) const override { return true; }
  bool inspect(const SinExpr & /*expr*/) const override { return true; }
  bool inspect(const CosExpr & /*expr*/) const override { return true; }
  bool inspect(const TanExpr & /*expr*/) const override { return true; }
  bool inspect(const RndExpr & /*expr*/) const override { return true; }
  bool inspect(const PeekExpr & /*expr*/) const override { return true; }
  bool inspect(const LenExpr & /*expr*/) const override { return true; }
  bool inspect(const StrExpr & /*expr*/) const override { return true; }
  bool inspect(const ValExpr & /*expr*/) const override { return true; }
  bool inspect(const AscExpr & /*expr*/) const override { return true; }
  bool inspect(const ChrExpr & /*expr*/) const override { return true; }
  bool inspect(const LeftExpr & /*expr*/) const override { return true; }
  bool inspect(const RightExpr & /*expr*/) const override { return true; }
  bool inspect(const MidExpr & /*expr*/) const override { return true; }
  bool inspect(const PointExpr & /*expr*/) const override { return true; }
  bool inspect(const InkeyExpr & /*expr*/) const override { return true; }
  bool inspect(const MemExpr & /*expr*/) const override { return true; }
  bool inspect(const SquareExpr & /*expr*/) const override { return true; }
  bool inspect(const FractExpr & /*expr*/) const override { return true; }
  bool inspect(const TimerExpr & /*expr*/) const override { return true; }
  bool inspect(const PosExpr & /*expr*/) const override { return true; }
  bool inspect(const PeekWordExpr & /*expr*/) const override { return true; }
};

#endif
