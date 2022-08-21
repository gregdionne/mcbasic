// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "impurityreaper.hpp"

up<Statement> StatementImpurityReaper::mutate(If &s) {
  auto eval = makeup<Eval>();
  ExprImpurityReaper ir(eval->operands);
  ir.reap(s.predicate);
  return eval->operands.empty() ? up<Statement>()
                                : static_cast<up<Statement>>(mv(eval));
}

up<Statement> StatementImpurityReaper::mutate(Let &s) {
  auto eval = makeup<Eval>();
  ExprImpurityReaper ir(eval->operands);
  ir.reap(s.lhs);
  ir.reap(s.rhs);
  return eval->operands.empty() ? up<Statement>()
                                : static_cast<up<Statement>>(mv(eval));
}

up<Statement> StatementImpurityReaper::mutate(Accum &s) {
  auto eval = makeup<Eval>();
  ExprImpurityReaper ir(eval->operands);
  ir.reap(s.lhs);
  ir.reap(s.rhs);
  return eval->operands.empty() ? up<Statement>()
                                : static_cast<up<Statement>>(mv(eval));
}

up<Statement> StatementImpurityReaper::mutate(Decum &s) {
  auto eval = makeup<Eval>();
  ExprImpurityReaper ir(eval->operands);
  ir.reap(s.lhs);
  ir.reap(s.rhs);
  return eval->operands.empty() ? up<Statement>()
                                : static_cast<up<Statement>>(mv(eval));
}

up<Statement> StatementImpurityReaper::mutate(Necum &s) {
  auto eval = makeup<Eval>();
  ExprImpurityReaper ir(eval->operands);
  ir.reap(s.lhs);
  ir.reap(s.rhs);
  return eval->operands.empty() ? up<Statement>()
                                : static_cast<up<Statement>>(mv(eval));
}

void ExprImpurityReaper::reap(up<Expr> &expr) {
  if (expr->check(&isImpure)) {
    results.emplace_back(mv(expr));
  } else {
    expr->mutate(this);
  }
}

void ExprImpurityReaper::reap(up<NumericExpr> &numExpr) {
  if (numExpr->check(&isImpure)) {
    results.emplace_back(mv(numExpr));
  } else {
    numExpr->mutate(this);
  }
}

void ExprImpurityReaper::reap(up<StringExpr> &strExpr) {
  if (strExpr->check(&isImpure)) {
    results.emplace_back(mv(strExpr));
  } else {
    strExpr->mutate(this);
  }
}

void ExprImpurityReaper::mutate(ArrayIndicesExpr &expr) {
  for (auto &op : expr.operands) {
    reap(op);
  }
}

void ExprImpurityReaper::mutate(NumericConstantExpr & /*expr*/) {}

void ExprImpurityReaper::mutate(StringConstantExpr & /*expr*/) {}

void ExprImpurityReaper::mutate(NumericArrayExpr &expr) {
  return expr.indices->mutate(this);
}

void ExprImpurityReaper::mutate(StringArrayExpr &expr) {
  expr.indices->mutate(this);
}
void ExprImpurityReaper::mutate(NumericVariableExpr & /*expr*/) {}
void ExprImpurityReaper::mutate(StringVariableExpr & /*expr*/) {}
void ExprImpurityReaper::mutate(NaryNumericExpr &expr) {
  for (auto &op : expr.operands) {
    reap(op);
  }
  for (auto &invop : expr.invoperands) {
    reap(invop);
  }
}
void ExprImpurityReaper::mutate(StringConcatenationExpr &expr) {
  for (auto &op : expr.operands) {
    reap(op);
  }
}

void ExprImpurityReaper::mutate(PrintTabExpr & /*expr*/) {}

void ExprImpurityReaper::mutate(PrintSpaceExpr & /*expr*/) {}

void ExprImpurityReaper::mutate(PrintCRExpr & /*expr*/) {}

void ExprImpurityReaper::mutate(PrintCommaExpr & /*expr*/) {}

void ExprImpurityReaper::mutate(PowerExpr &expr) {
  reap(expr.base);
  reap(expr.exponent);
}

void ExprImpurityReaper::mutate(IntegerDivisionExpr &expr) {
  reap(expr.dividend);
  reap(expr.divisor);
}
void ExprImpurityReaper::mutate(MultiplicativeExpr &expr) {
  return expr.NaryNumericExpr::mutate(this);
}
void ExprImpurityReaper::mutate(AdditiveExpr &expr) {
  return expr.NaryNumericExpr::mutate(this);
}
void ExprImpurityReaper::mutate(ComplementedExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(RelationalExpr &expr) {
  reap(expr.lhs);
  reap(expr.rhs);
}
void ExprImpurityReaper::mutate(AndExpr &expr) {
  return expr.NaryNumericExpr::mutate(this);
}
void ExprImpurityReaper::mutate(OrExpr &expr) {
  return expr.NaryNumericExpr::mutate(this);
}
void ExprImpurityReaper::mutate(ShiftExpr &expr) {
  reap(expr.expr);
  reap(expr.count);
}
void ExprImpurityReaper::mutate(SgnExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(IntExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(AbsExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(SqrExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(ExpExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(LogExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(SinExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(CosExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(TanExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(RndExpr & /*expr*/) {
  // should not be able to be reached
}

void ExprImpurityReaper::mutate(PeekExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(LenExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(StrExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(ValExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(AscExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(ChrExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(LeftExpr &expr) {
  reap(expr.str);
  reap(expr.len);
}
void ExprImpurityReaper::mutate(RightExpr &expr) {
  reap(expr.str);
  reap(expr.len);
}
void ExprImpurityReaper::mutate(MidExpr &expr) {
  reap(expr.str);
  reap(expr.start);
  if (expr.len) {
    reap(expr.len);
  }
}
void ExprImpurityReaper::mutate(PointExpr &expr) {
  reap(expr.x);
  reap(expr.y);
}
void ExprImpurityReaper::mutate(InkeyExpr & /*expr*/) {
  // should not be reached
}

void ExprImpurityReaper::mutate(MemExpr & /*expr*/) {}
void ExprImpurityReaper::mutate(SquareExpr &expr) { reap(expr.expr); }
void ExprImpurityReaper::mutate(TimerExpr & /*expr*/) {}
void ExprImpurityReaper::mutate(PosExpr & /*expr*/) {}
void ExprImpurityReaper::mutate(PeekWordExpr &expr) { reap(expr.expr); }
