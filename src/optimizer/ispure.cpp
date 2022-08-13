// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "ispure.hpp"

bool IsPure::inspect(const ArrayIndicesExpr &expr) const {
  for (const auto &op : expr.operands) {
    if (!op->check(this)) {
      return false;
    }
  }
  return true;
}

bool IsPure::inspect(const NumericConstantExpr & /*expr*/) const {
  return true;
}
bool IsPure::inspect(const StringConstantExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const NumericArrayExpr &expr) const {
  return expr.indices->check(this);
}

bool IsPure::inspect(const StringArrayExpr &expr) const {
  return expr.indices->check(this);
}
bool IsPure::inspect(const NumericVariableExpr & /*expr*/) const {
  return true;
}
bool IsPure::inspect(const StringVariableExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const NaryNumericExpr &expr) const {
  for (const auto &op : expr.operands) {
    if (!op->check(this)) {
      return false;
    }
  }
  for (const auto &invop : expr.invoperands) {
    if (!invop->check(this)) {
      return false;
    }
  }
  return true;
}
bool IsPure::inspect(const StringConcatenationExpr &expr) const {
  for (const auto &op : expr.operands) {
    if (!op->check(this)) {
      return false;
    }
  }
  return true;
}
bool IsPure::inspect(const PrintTabExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const PrintSpaceExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const PrintCRExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const PrintCommaExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const PowerExpr &expr) const {
  return expr.base->check(this) && expr.exponent->check(this);
}
bool IsPure::inspect(const IntegerDivisionExpr &expr) const {
  return expr.dividend->check(this) && expr.divisor->check(this);
}
bool IsPure::inspect(const MultiplicativeExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}
bool IsPure::inspect(const AdditiveExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}
bool IsPure::inspect(const ComplementedExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const RelationalExpr &expr) const {
  return expr.lhs->check(this) && expr.rhs->check(this);
}
bool IsPure::inspect(const AndExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}
bool IsPure::inspect(const OrExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}
bool IsPure::inspect(const ShiftExpr &expr) const {
  return expr.expr->check(this) && expr.count->check(this);
}
bool IsPure::inspect(const SgnExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const IntExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const AbsExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const SqrExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const ExpExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const LogExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const SinExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const CosExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const TanExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const RndExpr & /*expr*/) const { return false; }
bool IsPure::inspect(const PeekExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const LenExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const StrExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const ValExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const AscExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const ChrExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const LeftExpr &expr) const {
  return expr.str->check(this) && expr.len->check(this);
}
bool IsPure::inspect(const RightExpr &expr) const {
  return expr.str->check(this) && expr.len->check(this);
}
bool IsPure::inspect(const MidExpr &expr) const {
  return expr.str->check(this) && expr.start->check(this) &&
         (!expr.len || expr.len->check(this));
}
bool IsPure::inspect(const PointExpr &expr) const {
  return expr.x->check(this) && expr.y->check(this);
}
bool IsPure::inspect(const InkeyExpr & /*expr*/) const { return false; }
bool IsPure::inspect(const MemExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const SquareExpr &expr) const {
  return expr.expr->check(this);
}
bool IsPure::inspect(const TimerExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const PosExpr & /*expr*/) const { return true; }
bool IsPure::inspect(const PeekWordExpr &expr) const {
  return expr.expr->check(this);
}
