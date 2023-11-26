// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_EXPRABSORBER_HPP
#define AST_EXPRABSORBER_HPP

#include "fwddeclexpression.hpp"

// ExprAbsorber
//   Changes internal state via examining an expression.
//   Return values templetized according to string/numeric type
template <typename Number, typename String> class ExprAbsorber {
public:
  ExprAbsorber() = default;
  ExprAbsorber(const ExprAbsorber &) = delete;
  ExprAbsorber(ExprAbsorber &&) = delete;
  ExprAbsorber &operator=(const ExprAbsorber &) = delete;
  ExprAbsorber &operator=(ExprAbsorber &&) = delete;
  virtual ~ExprAbsorber() = default;

  virtual Number absorb(const ArrayIndicesExpr & /*expr*/) = 0;
  virtual Number absorb(const NumericConstantExpr & /*expr*/) = 0;
  virtual String absorb(const StringConstantExpr & /*expr*/) = 0;
  virtual Number absorb(const NumericArrayExpr & /*expr*/) = 0;
  virtual String absorb(const StringArrayExpr & /*expr*/) = 0;
  virtual Number absorb(const NumericVariableExpr & /*expr*/) = 0;
  virtual String absorb(const StringVariableExpr & /*expr*/) = 0;
  virtual Number absorb(const NaryNumericExpr & /*expr*/) = 0;
  virtual String absorb(const StringConcatenationExpr & /*expr*/) = 0;
  virtual String absorb(const PrintTabExpr & /*expr*/) = 0;
  virtual String absorb(const PrintSpaceExpr & /*expr*/) = 0;
  virtual String absorb(const PrintCRExpr & /*expr*/) = 0;
  virtual String absorb(const PrintCommaExpr & /*expr*/) = 0;
  virtual Number absorb(const PowerExpr & /*expr*/) = 0;
  virtual Number absorb(const IntegerDivisionExpr & /*expr*/) = 0;
  virtual Number absorb(const MultiplicativeExpr & /*expr*/) = 0;
  virtual Number absorb(const AdditiveExpr & /*expr*/) = 0;
  virtual Number absorb(const ComplementedExpr & /*expr*/) = 0;
  virtual Number absorb(const RelationalExpr & /*expr*/) = 0;
  virtual Number absorb(const AndExpr & /*expr*/) = 0;
  virtual Number absorb(const OrExpr & /*expr*/) = 0;
  virtual Number absorb(const ShiftExpr & /*expr*/) = 0;
  virtual Number absorb(const SgnExpr & /*expr*/) = 0;
  virtual Number absorb(const IntExpr & /*expr*/) = 0;
  virtual Number absorb(const AbsExpr & /*expr*/) = 0;
  virtual Number absorb(const SqrExpr & /*expr*/) = 0;
  virtual Number absorb(const ExpExpr & /*expr*/) = 0;
  virtual Number absorb(const LogExpr & /*expr*/) = 0;
  virtual Number absorb(const SinExpr & /*expr*/) = 0;
  virtual Number absorb(const CosExpr & /*expr*/) = 0;
  virtual Number absorb(const TanExpr & /*expr*/) = 0;
  virtual Number absorb(const RndExpr & /*expr*/) = 0;
  virtual Number absorb(const PeekExpr & /*expr*/) = 0;
  virtual Number absorb(const LenExpr & /*expr*/) = 0;
  virtual String absorb(const StrExpr & /*expr*/) = 0;
  virtual Number absorb(const ValExpr & /*expr*/) = 0;
  virtual Number absorb(const AscExpr & /*expr*/) = 0;
  virtual String absorb(const ChrExpr & /*expr*/) = 0;
  virtual String absorb(const LeftExpr & /*expr*/) = 0;
  virtual String absorb(const RightExpr & /*expr*/) = 0;
  virtual String absorb(const MidExpr & /*expr*/) = 0;
  virtual Number absorb(const PointExpr & /*expr*/) = 0;
  virtual String absorb(const InkeyExpr & /*expr*/) = 0;
  virtual Number absorb(const PosExpr & /*expr*/) = 0;
  virtual Number absorb(const MemExpr & /*expr*/) = 0;
  virtual Number absorb(const SquareExpr & /*expr*/) = 0;
  virtual Number absorb(const FractExpr & /*expr*/) = 0;
  virtual Number absorb(const TimerExpr & /*expr*/) = 0;
  virtual Number absorb(const PeekWordExpr & /*expr*/) = 0;
};

#endif
