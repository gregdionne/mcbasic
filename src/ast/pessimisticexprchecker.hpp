// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_PESSIMISTICEXPRCHECKER_HPP
#define AST_PESSIMISTICEXPRCHECKER_HPP

#include "expression.hpp"

class PessimisticExprChecker : public ExprInspector<bool, bool> {
public:
  PessimisticExprChecker() = default;
  PessimisticExprChecker(const PessimisticExprChecker &) = delete;
  PessimisticExprChecker(PessimisticExprChecker &&) = delete;
  PessimisticExprChecker &operator=(const PessimisticExprChecker &) = delete;
  PessimisticExprChecker &operator=(PessimisticExprChecker &&) = delete;
  ~PessimisticExprChecker() override = default;

  bool inspect(const ArrayIndicesExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const NumericConstantExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const StringConstantExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const NumericArrayExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const StringArrayExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const NumericVariableExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const StringVariableExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const NaryNumericExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const StringConcatenationExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const PrintTabExpr & /*expr*/) const override { return false; }
  bool inspect(const PrintSpaceExpr & /*expr*/) const override { return false; }
  bool inspect(const PrintCRExpr & /*expr*/) const override { return false; }
  bool inspect(const PrintCommaExpr & /*expr*/) const override { return false; }
  bool inspect(const PowerExpr & /*expr*/) const override { return false; }
  bool inspect(const IntegerDivisionExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const MultiplicativeExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const AdditiveExpr & /*expr*/) const override { return false; }
  bool inspect(const ComplementedExpr & /*expr*/) const override {
    return false;
  }
  bool inspect(const RelationalExpr & /*expr*/) const override { return false; }
  bool inspect(const AndExpr & /*expr*/) const override { return false; }
  bool inspect(const OrExpr & /*expr*/) const override { return false; }
  bool inspect(const ShiftExpr & /*expr*/) const override { return false; }
  bool inspect(const SgnExpr & /*expr*/) const override { return false; }
  bool inspect(const IntExpr & /*expr*/) const override { return false; }
  bool inspect(const AbsExpr & /*expr*/) const override { return false; }
  bool inspect(const SqrExpr & /*expr*/) const override { return false; }
  bool inspect(const ExpExpr & /*expr*/) const override { return false; }
  bool inspect(const LogExpr & /*expr*/) const override { return false; }
  bool inspect(const SinExpr & /*expr*/) const override { return false; }
  bool inspect(const CosExpr & /*expr*/) const override { return false; }
  bool inspect(const TanExpr & /*expr*/) const override { return false; }
  bool inspect(const RndExpr & /*expr*/) const override { return false; }
  bool inspect(const PeekExpr & /*expr*/) const override { return false; }
  bool inspect(const LenExpr & /*expr*/) const override { return false; }
  bool inspect(const StrExpr & /*expr*/) const override { return false; }
  bool inspect(const ValExpr & /*expr*/) const override { return false; }
  bool inspect(const AscExpr & /*expr*/) const override { return false; }
  bool inspect(const ChrExpr & /*expr*/) const override { return false; }
  bool inspect(const LeftExpr & /*expr*/) const override { return false; }
  bool inspect(const RightExpr & /*expr*/) const override { return false; }
  bool inspect(const MidExpr & /*expr*/) const override { return false; }
  bool inspect(const PointExpr & /*expr*/) const override { return false; }
  bool inspect(const InkeyExpr & /*expr*/) const override { return false; }
  bool inspect(const MemExpr & /*expr*/) const override { return false; }
  bool inspect(const SquareExpr & /*expr*/) const override { return false; }
  bool inspect(const FractExpr & /*expr*/) const override { return false; }
  bool inspect(const TimerExpr & /*expr*/) const override { return false; }
  bool inspect(const PosExpr & /*expr*/) const override { return false; }
  bool inspect(const PeekWordExpr & /*expr*/) const override { return false; }
};

#endif
