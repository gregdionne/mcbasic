// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_NULLEXPRINSPECTOR_HPP
#define AST_NULLEXPRINSPECTOR_HPP

#include "expression.hpp"

class NullExprInspector : public ExprInspector<void, void> {
public:
  void inspect(const ArrayIndicesExpr &) const override {}
  void inspect(const NumericConstantExpr &) const override {}
  void inspect(const StringConstantExpr &) const override {}
  void inspect(const NumericArrayExpr &) const override {}
  void inspect(const StringArrayExpr &) const override {}
  void inspect(const NumericVariableExpr &) const override {}
  void inspect(const StringVariableExpr &) const override {}
  void inspect(const NaryNumericExpr &) const override {}
  void inspect(const StringConcatenationExpr &) const override {}
  void inspect(const PrintTabExpr &) const override {}
  void inspect(const PrintSpaceExpr &) const override {}
  void inspect(const PrintCRExpr &) const override {}
  void inspect(const PrintCommaExpr &) const override {}
  void inspect(const PowerExpr &) const override {}
  void inspect(const IntegerDivisionExpr &) const override {}
  void inspect(const MultiplicativeExpr &) const override {}
  void inspect(const AdditiveExpr &) const override {}
  void inspect(const ComplementedExpr &) const override {}
  void inspect(const RelationalExpr &) const override {}
  void inspect(const AndExpr &) const override {}
  void inspect(const OrExpr &) const override {}
  void inspect(const ShiftExpr &) const override {}
  void inspect(const SgnExpr &) const override {}
  void inspect(const IntExpr &) const override {}
  void inspect(const AbsExpr &) const override {}
  void inspect(const SqrExpr &) const override {}
  void inspect(const ExpExpr &) const override {}
  void inspect(const LogExpr &) const override {}
  void inspect(const SinExpr &) const override {}
  void inspect(const CosExpr &) const override {}
  void inspect(const TanExpr &) const override {}
  void inspect(const RndExpr &) const override {}
  void inspect(const PeekExpr &) const override {}
  void inspect(const LenExpr &) const override {}
  void inspect(const StrExpr &) const override {}
  void inspect(const ValExpr &) const override {}
  void inspect(const AscExpr &) const override {}
  void inspect(const ChrExpr &) const override {}
  void inspect(const LeftExpr &) const override {}
  void inspect(const RightExpr &) const override {}
  void inspect(const MidExpr &) const override {}
  void inspect(const PointExpr &) const override {}
  void inspect(const InkeyExpr &) const override {}
  void inspect(const MemExpr &) const override {}
  void inspect(const SquareExpr &) const override {}
  void inspect(const TimerExpr &) const override {}
  void inspect(const PosExpr &) const override {}
  void inspect(const PeekWordExpr &) const override {}
};

#endif
