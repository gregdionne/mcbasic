// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISPURE_HPP
#define OPTIMIZER_ISPURE_HPP

#include "ast/expression.hpp"

// Return true if expression has no side effects

class IsPure : public ExprInspector<bool, bool> {
public:
  IsPure() = default;
  IsPure(const IsPure &) = delete;
  IsPure(IsPure &&) = delete;
  IsPure &operator=(const IsPure &) = delete;
  IsPure &operator=(IsPure &&) = delete;
  ~IsPure() override = default;

  bool inspect(const ArrayIndicesExpr &expr) const override;
  bool inspect(const NumericConstantExpr &expr) const override;
  bool inspect(const StringConstantExpr &expr) const override;
  bool inspect(const NumericArrayExpr &expr) const override;
  bool inspect(const StringArrayExpr &expr) const override;
  bool inspect(const NumericVariableExpr &expr) const override;
  bool inspect(const StringVariableExpr &expr) const override;
  bool inspect(const NaryNumericExpr &expr) const override;
  bool inspect(const StringConcatenationExpr &expr) const override;
  bool inspect(const PrintTabExpr &expr) const override;
  bool inspect(const PrintSpaceExpr &expr) const override;
  bool inspect(const PrintCRExpr &expr) const override;
  bool inspect(const PrintCommaExpr &expr) const override;
  bool inspect(const PowerExpr &expr) const override;
  bool inspect(const IntegerDivisionExpr &expr) const override;
  bool inspect(const MultiplicativeExpr &expr) const override;
  bool inspect(const AdditiveExpr &expr) const override;
  bool inspect(const ComplementedExpr &expr) const override;
  bool inspect(const RelationalExpr &expr) const override;
  bool inspect(const AndExpr &expr) const override;
  bool inspect(const OrExpr &expr) const override;
  bool inspect(const ShiftExpr &expr) const override;
  bool inspect(const SgnExpr &expr) const override;
  bool inspect(const IntExpr &expr) const override;
  bool inspect(const AbsExpr &expr) const override;
  bool inspect(const SqrExpr &expr) const override;
  bool inspect(const ExpExpr &expr) const override;
  bool inspect(const LogExpr &expr) const override;
  bool inspect(const SinExpr &expr) const override;
  bool inspect(const CosExpr &expr) const override;
  bool inspect(const TanExpr &expr) const override;
  bool inspect(const RndExpr &expr) const override;
  bool inspect(const PeekExpr &expr) const override;
  bool inspect(const LenExpr &expr) const override;
  bool inspect(const StrExpr &expr) const override;
  bool inspect(const ValExpr &expr) const override;
  bool inspect(const AscExpr &expr) const override;
  bool inspect(const ChrExpr &expr) const override;
  bool inspect(const LeftExpr &expr) const override;
  bool inspect(const RightExpr &expr) const override;
  bool inspect(const MidExpr &expr) const override;
  bool inspect(const PointExpr &expr) const override;
  bool inspect(const InkeyExpr &expr) const override;
  bool inspect(const MemExpr &expr) const override;
  bool inspect(const SquareExpr &expr) const override;
  bool inspect(const TimerExpr &expr) const override;
  bool inspect(const PosExpr &expr) const override;
  bool inspect(const PeekWordExpr &expr) const override;
};

#endif
