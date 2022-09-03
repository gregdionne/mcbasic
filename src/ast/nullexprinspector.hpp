// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRINSPECTOR_HPP
#define AST_NULLEXPRINSPECTOR_HPP

#include "expression.hpp"

class NullExprInspector : public ExprInspector<void, void> {
public:
  NullExprInspector() = default;
  NullExprInspector(const NullExprInspector &) = delete;
  NullExprInspector(NullExprInspector &&) = delete;
  NullExprInspector &operator=(const NullExprInspector &) = delete;
  NullExprInspector &operator=(NullExprInspector &&) = delete;
  ~NullExprInspector() override = default;

  void inspect(const ArrayIndicesExpr & /*expr*/) const override {}
  void inspect(const NumericConstantExpr & /*expr*/) const override {}
  void inspect(const StringConstantExpr & /*expr*/) const override {}
  void inspect(const NumericArrayExpr & /*expr*/) const override {}
  void inspect(const StringArrayExpr & /*expr*/) const override {}
  void inspect(const NumericVariableExpr & /*expr*/) const override {}
  void inspect(const StringVariableExpr & /*expr*/) const override {}
  void inspect(const NaryNumericExpr & /*expr*/) const override {}
  void inspect(const StringConcatenationExpr & /*expr*/) const override {}
  void inspect(const PrintTabExpr & /*expr*/) const override {}
  void inspect(const PrintSpaceExpr & /*expr*/) const override {}
  void inspect(const PrintCRExpr & /*expr*/) const override {}
  void inspect(const PrintCommaExpr & /*expr*/) const override {}
  void inspect(const PowerExpr & /*expr*/) const override {}
  void inspect(const IntegerDivisionExpr & /*expr*/) const override {}
  void inspect(const MultiplicativeExpr & /*expr*/) const override {}
  void inspect(const AdditiveExpr & /*expr*/) const override {}
  void inspect(const ComplementedExpr & /*expr*/) const override {}
  void inspect(const RelationalExpr & /*expr*/) const override {}
  void inspect(const AndExpr & /*expr*/) const override {}
  void inspect(const OrExpr & /*expr*/) const override {}
  void inspect(const ShiftExpr & /*expr*/) const override {}
  void inspect(const SgnExpr & /*expr*/) const override {}
  void inspect(const IntExpr & /*expr*/) const override {}
  void inspect(const AbsExpr & /*expr*/) const override {}
  void inspect(const SqrExpr & /*expr*/) const override {}
  void inspect(const ExpExpr & /*expr*/) const override {}
  void inspect(const LogExpr & /*expr*/) const override {}
  void inspect(const SinExpr & /*expr*/) const override {}
  void inspect(const CosExpr & /*expr*/) const override {}
  void inspect(const TanExpr & /*expr*/) const override {}
  void inspect(const RndExpr & /*expr*/) const override {}
  void inspect(const PeekExpr & /*expr*/) const override {}
  void inspect(const LenExpr & /*expr*/) const override {}
  void inspect(const StrExpr & /*expr*/) const override {}
  void inspect(const ValExpr & /*expr*/) const override {}
  void inspect(const AscExpr & /*expr*/) const override {}
  void inspect(const ChrExpr & /*expr*/) const override {}
  void inspect(const LeftExpr & /*expr*/) const override {}
  void inspect(const RightExpr & /*expr*/) const override {}
  void inspect(const MidExpr & /*expr*/) const override {}
  void inspect(const PointExpr & /*expr*/) const override {}
  void inspect(const InkeyExpr & /*expr*/) const override {}
  void inspect(const MemExpr & /*expr*/) const override {}
  void inspect(const SquareExpr & /*expr*/) const override {}
  void inspect(const FractExpr & /*expr*/) const override {}
  void inspect(const TimerExpr & /*expr*/) const override {}
  void inspect(const PosExpr & /*expr*/) const override {}
  void inspect(const PeekWordExpr & /*expr*/) const override {}
};

#endif
