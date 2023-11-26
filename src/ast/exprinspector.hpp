// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_EXPRINSPECTOR_HPP
#define AST_EXPRINSPECTOR_HPP

#include "fwddeclexpression.hpp"

// ExprInspector
//   Examines an expression (but cannot change it)
//   Return values templetized according to string/numeric type
template <typename Number, typename String> class ExprInspector {
public:
  ExprInspector() = default;
  ExprInspector(const ExprInspector &) = delete;
  ExprInspector(ExprInspector &&) = delete;
  ExprInspector &operator=(const ExprInspector &) = delete;
  ExprInspector &operator=(ExprInspector &&) = delete;
  virtual ~ExprInspector() = default;

  virtual Number inspect(const ArrayIndicesExpr & /*expr*/) const = 0;
  virtual Number inspect(const NumericConstantExpr & /*expr*/) const = 0;
  virtual String inspect(const StringConstantExpr & /*expr*/) const = 0;
  virtual Number inspect(const NumericArrayExpr & /*expr*/) const = 0;
  virtual String inspect(const StringArrayExpr & /*expr*/) const = 0;
  virtual Number inspect(const NumericVariableExpr & /*expr*/) const = 0;
  virtual String inspect(const StringVariableExpr & /*expr*/) const = 0;
  virtual Number inspect(const NaryNumericExpr & /*expr*/) const = 0;
  virtual String inspect(const StringConcatenationExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintTabExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintSpaceExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintCRExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintCommaExpr & /*expr*/) const = 0;
  virtual Number inspect(const PowerExpr & /*expr*/) const = 0;
  virtual Number inspect(const IntegerDivisionExpr & /*expr*/) const = 0;
  virtual Number inspect(const MultiplicativeExpr & /*expr*/) const = 0;
  virtual Number inspect(const AdditiveExpr & /*expr*/) const = 0;
  virtual Number inspect(const ComplementedExpr & /*expr*/) const = 0;
  virtual Number inspect(const RelationalExpr & /*expr*/) const = 0;
  virtual Number inspect(const AndExpr & /*expr*/) const = 0;
  virtual Number inspect(const OrExpr & /*expr*/) const = 0;
  virtual Number inspect(const ShiftExpr & /*expr*/) const = 0;
  virtual Number inspect(const SgnExpr & /*expr*/) const = 0;
  virtual Number inspect(const IntExpr & /*expr*/) const = 0;
  virtual Number inspect(const AbsExpr & /*expr*/) const = 0;
  virtual Number inspect(const SqrExpr & /*expr*/) const = 0;
  virtual Number inspect(const ExpExpr & /*expr*/) const = 0;
  virtual Number inspect(const LogExpr & /*expr*/) const = 0;
  virtual Number inspect(const SinExpr & /*expr*/) const = 0;
  virtual Number inspect(const CosExpr & /*expr*/) const = 0;
  virtual Number inspect(const TanExpr & /*expr*/) const = 0;
  virtual Number inspect(const RndExpr & /*expr*/) const = 0;
  virtual Number inspect(const PeekExpr & /*expr*/) const = 0;
  virtual Number inspect(const LenExpr & /*expr*/) const = 0;
  virtual String inspect(const StrExpr & /*expr*/) const = 0;
  virtual Number inspect(const ValExpr & /*expr*/) const = 0;
  virtual Number inspect(const AscExpr & /*expr*/) const = 0;
  virtual String inspect(const ChrExpr & /*expr*/) const = 0;
  virtual String inspect(const LeftExpr & /*expr*/) const = 0;
  virtual String inspect(const RightExpr & /*expr*/) const = 0;
  virtual String inspect(const MidExpr & /*expr*/) const = 0;
  virtual Number inspect(const PointExpr & /*expr*/) const = 0;
  virtual String inspect(const InkeyExpr & /*expr*/) const = 0;
  virtual Number inspect(const MemExpr & /*expr*/) const = 0;
  virtual Number inspect(const SquareExpr & /*expr*/) const = 0;
  virtual Number inspect(const FractExpr & /*expr*/) const = 0;
  virtual Number inspect(const TimerExpr & /*expr*/) const = 0;
  virtual Number inspect(const PosExpr & /*expr*/) const = 0;
  virtual Number inspect(const PeekWordExpr & /*expr*/) const = 0;
};

#endif
