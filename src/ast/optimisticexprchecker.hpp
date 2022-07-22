// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_OPTIMISTICEXPRCHECKER_HPP
#define AST_OPTIMISTICEXPRCHECKER_HPP

#include "expression.hpp"

class OptimisticExprChecker : public ExprInspector<bool, bool> {
public:
  virtual bool inspect(const ArrayIndicesExpr & /*expr*/) const { return true; }
  virtual bool inspect(const NumericConstantExpr & /*expr*/) const {
    return true;
  }
  virtual bool inspect(const StringConstantExpr & /*expr*/) const {
    return true;
  }
  virtual bool inspect(const NumericArrayExpr & /*expr*/) const { return true; }
  virtual bool inspect(const StringArrayExpr & /*expr*/) const { return true; }
  virtual bool inspect(const NumericVariableExpr & /*expr*/) const {
    return true;
  }
  virtual bool inspect(const StringVariableExpr & /*expr*/) const {
    return true;
  }
  virtual bool inspect(const NaryNumericExpr & /*expr*/) const { return true; }
  virtual bool inspect(const StringConcatenationExpr & /*expr*/) const {
    return true;
  }
  virtual bool inspect(const PrintTabExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PrintSpaceExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PrintCRExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PrintCommaExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PowerExpr & /*expr*/) const { return true; }
  virtual bool inspect(const IntegerDivisionExpr & /*expr*/) const {
    return true;
  }
  virtual bool inspect(const MultiplicativeExpr & /*expr*/) const {
    return true;
  }
  virtual bool inspect(const AdditiveExpr & /*expr*/) const { return true; }
  virtual bool inspect(const ComplementedExpr & /*expr*/) const { return true; }
  virtual bool inspect(const RelationalExpr & /*expr*/) const { return true; }
  virtual bool inspect(const AndExpr & /*expr*/) const { return true; }
  virtual bool inspect(const OrExpr & /*expr*/) const { return true; }
  virtual bool inspect(const ShiftExpr & /*expr*/) const { return true; }
  virtual bool inspect(const SgnExpr & /*expr*/) const { return true; }
  virtual bool inspect(const IntExpr & /*expr*/) const { return true; }
  virtual bool inspect(const AbsExpr & /*expr*/) const { return true; }
  virtual bool inspect(const SqrExpr & /*expr*/) const { return true; }
  virtual bool inspect(const ExpExpr & /*expr*/) const { return true; }
  virtual bool inspect(const LogExpr & /*expr*/) const { return true; }
  virtual bool inspect(const SinExpr & /*expr*/) const { return true; }
  virtual bool inspect(const CosExpr & /*expr*/) const { return true; }
  virtual bool inspect(const TanExpr & /*expr*/) const { return true; }
  virtual bool inspect(const RndExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PeekExpr & /*expr*/) const { return true; }
  virtual bool inspect(const LenExpr & /*expr*/) const { return true; }
  virtual bool inspect(const StrExpr & /*expr*/) const { return true; }
  virtual bool inspect(const ValExpr & /*expr*/) const { return true; }
  virtual bool inspect(const AscExpr & /*expr*/) const { return true; }
  virtual bool inspect(const ChrExpr & /*expr*/) const { return true; }
  virtual bool inspect(const LeftExpr & /*expr*/) const { return true; }
  virtual bool inspect(const RightExpr & /*expr*/) const { return true; }
  virtual bool inspect(const MidExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PointExpr & /*expr*/) const { return true; }
  virtual bool inspect(const InkeyExpr & /*expr*/) const { return true; }
  virtual bool inspect(const MemExpr & /*expr*/) const { return true; }
  virtual bool inspect(const SquareExpr & /*expr*/) const { return true; }
  virtual bool inspect(const TimerExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PosExpr & /*expr*/) const { return true; }
  virtual bool inspect(const PeekWordExpr & /*expr*/) const { return true; }
};

#endif
