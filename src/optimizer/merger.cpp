// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "merger.hpp"
#include "constfolder.hpp"
#include "consttable/fixedpoint.hpp"
#include "isrelational.hpp"
#include <string>

// TODO:
//   Replace class with separate ExprOp's for each operation and
//   one additional ExprOp to manage the others.  That should
//   remove reliance upon private methods using dynamic_cast<>.

void ExprMerger::reduceNullOp(std::unique_ptr<NumericExpr> &expr) {
  auto *nexpr = dynamic_cast<NaryNumericExpr *>(expr.get());
  if (nexpr != nullptr && nexpr->operands.empty() &&
      nexpr->invoperands.empty()) {
    expr = std::make_unique<NumericConstantExpr>(nexpr->identity);
  }
}

void ExprMerger::mergeUnaryOp(std::unique_ptr<NumericExpr> &expr) {
  auto *andexpr = dynamic_cast<AndExpr *>(expr.get());
  if ((andexpr != nullptr) && andexpr->operands.size() == 1) {
    expr = std::move(andexpr->operands[0]);
  }

  auto *orexpr = dynamic_cast<OrExpr *>(expr.get());
  if ((orexpr != nullptr) && orexpr->operands.size() == 1) {
    expr = std::move(orexpr->operands[0]);
  }

  auto *mexpr = dynamic_cast<MultiplicativeExpr *>(expr.get());
  if ((mexpr != nullptr) && mexpr->operands.size() == 1 &&
      mexpr->invoperands.empty()) {
    expr = std::move(mexpr->operands[0]);
  }

  auto *aexpr = dynamic_cast<AdditiveExpr *>(expr.get());
  if ((aexpr != nullptr) && aexpr->operands.size() == 1 &&
      aexpr->invoperands.empty()) {
    expr = std::move(aexpr->operands[0]);
  } else if ((aexpr != nullptr) && aexpr->operands.empty() &&
             aexpr->invoperands.size() == 1) {
    expr = std::make_unique<NegatedExpr>(std::move(aexpr->invoperands[0]));
  }
}

void ExprMerger::mergeIntegerDivision(std::unique_ptr<NumericExpr> &expr,
                                      ExprMerger *that) {
  auto *iexpr = dynamic_cast<IntExpr *>(expr.get());
  if (iexpr != nullptr) {
    auto *mexpr = dynamic_cast<MultiplicativeExpr *>(iexpr->expr.get());
    if (mexpr != nullptr && !mexpr->invoperands.empty()) {
      auto divisor = std::make_unique<MultiplicativeExpr>(
          std::make_unique<NumericConstantExpr>(1));
      divisor->operands = std::move(mexpr->invoperands);
      mexpr->invoperands.clear();
      expr = std::make_unique<IntegerDivisionExpr>(std::move(iexpr->expr),
                                                   std::move(divisor));
      that->merge(expr);
    }
  }
}

void ExprMerger::reduceRelationalMultiplication(
    std::unique_ptr<NumericExpr> &expr, IsFloat &isFloat, ExprMerger *that) {
  auto *mexpr = dynamic_cast<MultiplicativeExpr *>(expr.get());
  if (mexpr != nullptr) {
    for (auto iOperand = mexpr->operands.begin();
         iOperand != mexpr->operands.end(); ++iOperand) {
      auto *rexpr = dynamic_cast<RelationalExpr *>(iOperand->get());
      if ((rexpr != nullptr) && !mexpr->inspect(&isFloat)) {
        auto *aexp = new AndExpr(std::move(*iOperand));
        mexpr->operands.erase(iOperand);
        aexp->operands.emplace_back(
            std::make_unique<NegatedExpr>(std::move(expr)));
        expr = std::unique_ptr<NumericExpr>(aexp);
        that->merge(expr);
        return;
      }
    }
    for (auto iOperand = mexpr->operands.begin();
         iOperand != mexpr->operands.end(); ++iOperand) {
      auto *nexpr = dynamic_cast<NegatedExpr *>(iOperand->get());
      if (nexpr != nullptr) {
        auto *rexpr = dynamic_cast<RelationalExpr *>(nexpr->expr.get());
        if ((rexpr != nullptr) && !mexpr->inspect(&isFloat)) {
          auto *aexp = new AndExpr(std::move(nexpr->expr));
          mexpr->operands.erase(iOperand);
          aexp->operands.emplace_back(std::move(expr));
          expr = std::unique_ptr<NumericExpr>(aexp);
          that->merge(expr);
          return;
        }
      }
    }
  }
}

void ExprMerger::reducePowerOfTwo(std::unique_ptr<NumericExpr> &expr,
                                  IsFloat &isFloat, ExprMerger *that) {
  auto *mexpr = dynamic_cast<PowerExpr *>(expr.get());
  if (mexpr != nullptr) {
    double value;
    if (mexpr->base->isConst(value) && value == 2 &&
        !mexpr->exponent->inspect(&isFloat)) {
      expr = std::make_unique<ShiftExpr>(
          std::make_unique<NumericConstantExpr>(1), std::move(mexpr->exponent));
      that->merge(expr);
    }
  }
}

void ExprMerger::reducePowerOfTwoMultiplication(
    std::unique_ptr<NumericExpr> &expr, ExprMerger *that) {
  auto *mexpr = dynamic_cast<MultiplicativeExpr *>(expr.get());
  if (mexpr != nullptr) {
    for (auto iOperand = mexpr->operands.begin();
         iOperand != mexpr->operands.end(); ++iOperand) {
      double v;
      if ((*iOperand)->isConst(v) && FixedPoint(v).isPowerOfTwo()) {
        int n = FixedPoint(v).log2abs();
        mexpr->operands.erase(iOperand);
        that->merge(expr);
        if (n != 0) {
          auto count = std::make_unique<NumericConstantExpr>(n);
          expr = std::make_unique<ShiftExpr>(std::move(expr), std::move(count));
          that->merge(expr);
        }
        return;
      }
    }

    for (auto iOperand = mexpr->invoperands.begin();
         iOperand != mexpr->invoperands.end(); ++iOperand) {
      double v;
      if ((*iOperand)->isConst(v) && FixedPoint(v).isPowerOfTwo()) {
        int n = FixedPoint(v).log2abs();
        mexpr->invoperands.erase(iOperand);
        that->merge(expr);
        if (n != 0) {
          auto count = std::make_unique<NumericConstantExpr>(-n);
          expr = std::make_unique<ShiftExpr>(std::move(expr), std::move(count));
          that->merge(expr);
        }
        return;
      }
    }
  }
}

void ExprMerger::mergeNegatedMultiplication(
    std::unique_ptr<NumericExpr> &expr) {
  auto *nexpr = dynamic_cast<NegatedExpr *>(expr.get());
  if (nexpr != nullptr) {
    auto *mexpr = dynamic_cast<MultiplicativeExpr *>(nexpr->expr.get());
    if (mexpr != nullptr) {
      for (auto &operand : mexpr->operands) {
        auto *nmexpr = dynamic_cast<NegatedExpr *>(operand.get());
        if (nmexpr != nullptr) {
          operand = std::move(nmexpr->expr);
          expr = std::move(nexpr->expr);
          return;
        }
      }
      for (auto &invoperand : mexpr->invoperands) {
        auto *nmexpr = dynamic_cast<NegatedExpr *>(invoperand.get());
        if (nmexpr != nullptr) {
          invoperand = std::move(nmexpr->expr);
          expr = std::move(nexpr->expr);
          return;
        }
      }
      for (auto &operand : mexpr->operands) {
        auto *nmexpr = dynamic_cast<NumericConstantExpr *>(operand.get());
        if (nmexpr != nullptr) {
          nmexpr->value = -nmexpr->value;
          expr = std::move(nexpr->expr);
          return;
        }
      }
    }
  }
}

void ExprMerger::mergeNegatedSum(std::unique_ptr<NumericExpr> &expr) {
  auto *nexpr = dynamic_cast<NegatedExpr *>(expr.get());
  if (nexpr != nullptr) {
    auto *aexpr = dynamic_cast<AdditiveExpr *>(nexpr->expr.get());
    if (aexpr != nullptr) {
      std::swap(aexpr->operands, aexpr->invoperands);
      expr = std::move(nexpr->expr);
    }
  }
}

void ExprMerger::mergeDoubleNegation(std::unique_ptr<NumericExpr> &expr) {
  NegatedExpr *nexpr = nullptr;

  if (((nexpr = dynamic_cast<NegatedExpr *>(expr.get())) != nullptr) &&
      ((nexpr = dynamic_cast<NegatedExpr *>(nexpr->expr.get())) != nullptr)) {
    expr = std::move(nexpr->expr);
  }
}

void ExprMerger::mergeDoubleShift(std::unique_ptr<NumericExpr> &expr,
                                  ExprMerger *that) {
  ShiftExpr *outerExpr = nullptr;
  ShiftExpr *innerExpr = nullptr;

  if (((outerExpr = dynamic_cast<ShiftExpr *>(expr.get())) != nullptr) &&
      ((innerExpr = dynamic_cast<ShiftExpr *>(outerExpr->expr.get())) !=
       nullptr)) {
    auto addExpr = std::make_unique<AdditiveExpr>(std::move(outerExpr->count));
    addExpr->operands.emplace_back(std::move(innerExpr->count));
    ExprConstFolder cfe;
    addExpr->mutate(&cfe);
    std::unique_ptr<NumericExpr> aExpr = std::move(addExpr);
    that->merge(aExpr);
    outerExpr->count = std::move(aExpr);
    outerExpr->expr = std::move(innerExpr->expr);
  }
}

void ExprMerger::knead(std::vector<std::unique_ptr<NumericExpr>> &operands) {
  double dummy;
  auto left = operands.begin();
  auto right = operands.end();
  if (left != right) {
    --right;
    while (left != right) {
      if ((*right)->isVar() || (*right)->isConst(dummy)) {
        --right;
      } else if (!(*left)->isVar() && !(*left)->isConst(dummy)) {
        ++left;
      } else {
        std::iter_swap(left, right);
      }
    }

    IsRelational isRelational;
    left = operands.begin();
    while (left != right) {
      if ((*left)->inspect(&isRelational)) {
        ++left;
      } else if (!(*right)->inspect(&isRelational)) {
        --right;
      } else {
        std::iter_swap(left, right);
      }
    }
  }
}

// merge expressions...
void ExprMerger::merge(std::unique_ptr<NumericExpr> &expr) {
  expr->mutate(this);
  reduceNullOp(expr);
  mergeUnaryOp(expr);
  mergeDoubleNegation(expr);
  mergeDoubleShift(expr, this);
  mergeNegatedSum(expr);
  mergeNegatedMultiplication(expr);
  reducePowerOfTwo(expr, isFloat, this);
  reduceRelationalMultiplication(expr, isFloat, this);
  reducePowerOfTwoMultiplication(expr, this);
  mergeIntegerDivision(expr, this);
}

void ExprMerger::merge(std::unique_ptr<StringExpr> &expr) {
  expr->mutate(this);
}

void ExprMerger::merge(std::unique_ptr<Expr> &expr) {
  auto *tmpExpr = dynamic_cast<NumericExpr *>(expr.get());
  if (tmpExpr != nullptr) {
    std::unique_ptr<NumericExpr> tmp(tmpExpr);
    static_cast<void>(expr.release());
    merge(tmp);
    expr = std::move(tmp);
  } else {
    expr->mutate(this);
  }
}

void Merger::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Merger::operate(Line &l) {
  StatementMerger that(symbolTable);
  for (auto &statement : l.statements) {
    statement->mutate(&that);
  }
}

void StatementMerger::mutate(For &s) {
  merger.merge(s.from);
  merger.merge(s.to);
  if (s.step) {
    merger.merge(s.step);
  }
}

void StatementMerger::mutate(When &s) { merger.merge(s.predicate); }

void StatementMerger::mutate(If &s) {
  merger.merge(s.predicate);
  for (auto &statement : s.consequent) {
    statement->mutate(this);
  }
}

void StatementMerger::mutate(Print &s) {
  if (s.at) {
    merger.merge(s.at);
  }

  for (auto &expr : s.printExpr) {
    merger.merge(expr);
  }
}

void StatementMerger::mutate(On &s) { merger.merge(s.branchIndex); }

void StatementMerger::mutate(Dim &s) {
  for (auto &variable : s.variables) {
    merger.merge(variable);
  }
}

void StatementMerger::mutate(Let &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::mutate(Inc &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::mutate(Dec &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::mutate(Poke &s) {
  merger.merge(s.dest);
  merger.merge(s.val);
}

void StatementMerger::mutate(Clear &s) {
  if (s.size) {
    merger.merge(s.size);
  }
}

void StatementMerger::mutate(Set &s) {
  merger.merge(s.x);
  merger.merge(s.y);
  if (s.c) {
    merger.merge(s.c);
  }
}

void StatementMerger::mutate(Reset &s) {
  merger.merge(s.x);
  merger.merge(s.y);
}

void StatementMerger::mutate(Cls &s) {
  if (s.color) {
    merger.merge(s.color);
  }
}

void StatementMerger::mutate(Sound &s) {
  merger.merge(s.pitch);
  merger.merge(s.duration);
}

// string expressions...
void ExprMerger::mutate(StringArrayExpr &e) { e.indices->mutate(this); }

void ExprMerger::mutate(StringConcatenationExpr &e) {
  for (auto &op : e.operands) {
    merge(op);
  }

  auto iOperand = e.operands.begin();
  while (iOperand != e.operands.end()) {
    auto *subExp = dynamic_cast<StringConcatenationExpr *>(iOperand->get());
    if (subExp != nullptr) {
      iOperand =
          e.operands.insert(std::next(iOperand),
                            std::make_move_iterator(subExp->operands.begin()),
                            std::make_move_iterator(subExp->operands.end()));
      iOperand = e.operands.erase(std::prev(iOperand));
    } else {
      ++iOperand;
    }
  }
}

void ExprMerger::mutate(LeftExpr &e) {
  merge(e.str);
  merge(e.len);
}

void ExprMerger::mutate(RightExpr &e) {
  merge(e.str);
  merge(e.len);
}

void ExprMerger::mutate(MidExpr &e) {
  merge(e.str);
  merge(e.start);

  if (e.len) {
    merge(e.len);
  }
}

void ExprMerger::mutate(LenExpr &e) { merge(e.expr); }

void ExprMerger::mutate(StrExpr &e) { merge(e.expr); }

void ExprMerger::mutate(ValExpr &e) { merge(e.expr); }

void ExprMerger::mutate(AscExpr &e) { merge(e.expr); }

void ExprMerger::mutate(ChrExpr &e) { merge(e.expr); }

void ExprMerger::mutate(NumericArrayExpr &e) { e.indices->mutate(this); }

void ExprMerger::mutate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    merge(operand);
  }
}

void ExprMerger::mutate(NegatedExpr &e) { merge(e.expr); }

void ExprMerger::mutate(ComplementedExpr &e) { merge(e.expr); }

void ExprMerger::mutate(SgnExpr &e) { merge(e.expr); }

void ExprMerger::mutate(IntExpr &e) { merge(e.expr); }

void ExprMerger::mutate(AbsExpr &e) { merge(e.expr); }

void ExprMerger::mutate(RndExpr &e) { merge(e.expr); }

void ExprMerger::mutate(PeekExpr &e) { merge(e.expr); }

void ExprMerger::mutate(PointExpr &e) {
  merge(e.x);
  merge(e.y);
}

void ExprMerger::mutate(PowerExpr &e) {
  merge(e.base);
  merge(e.exponent);
}

void ExprMerger::mutate(IntegerDivisionExpr &e) {
  merge(e.dividend);
  merge(e.divisor);
}

void ExprMerger::pruneIdentity(
    std::vector<std::unique_ptr<NumericExpr>> &operands, double identity) {
  auto iop = operands.begin();
  while (iop != operands.end()) {
    double value;
    if ((*iop)->isConst(value) && value == identity)
      iop = operands.erase(iop);
    else
      ++iop;
  }
}

void ExprMerger::merge(NaryNumericExpr &e) {
  for (auto &operand : e.operands) {
    merge(operand);
  }

  for (auto &invoperand : e.invoperands) {
    merge(invoperand);
  }

  for (std::size_t i = 0; i < e.operands.size(); ++i) {
    auto *subExp = dynamic_cast<NaryNumericExpr *>(e.operands[i].get());
    if ((subExp != nullptr) && e.funcName == subExp->funcName) {
      e.operands.insert(e.operands.end(),
                        std::make_move_iterator(subExp->operands.begin()),
                        std::make_move_iterator(subExp->operands.end()));
      e.invoperands.insert(e.invoperands.end(),
                           std::make_move_iterator(subExp->invoperands.begin()),
                           std::make_move_iterator(subExp->invoperands.end()));
      e.operands.erase(e.operands.begin() + i);
      --i;
    }
  }

  for (std::size_t i = 0; i < e.invoperands.size(); ++i) {
    auto *subExp = dynamic_cast<NaryNumericExpr *>(e.invoperands[i].get());
    if ((subExp != nullptr) && e.funcName == subExp->funcName) {
      e.invoperands.insert(e.invoperands.end(),
                           std::make_move_iterator(subExp->operands.begin()),
                           std::make_move_iterator(subExp->operands.end()));
      e.operands.insert(e.operands.end(),
                        std::make_move_iterator(subExp->invoperands.begin()),
                        std::make_move_iterator(subExp->invoperands.end()));
      e.invoperands.erase(e.invoperands.begin() + i);
      --i;
    }
  }

  pruneIdentity(e.operands, e.identity);
  pruneIdentity(e.invoperands, e.identity);
}

void ExprMerger::mutate(AdditiveExpr &e) {
  auto iOperand = e.operands.begin();
  while (iOperand != e.operands.end()) {
    auto *nexpr = dynamic_cast<NegatedExpr *>(iOperand->get());
    if (nexpr != nullptr) {
      e.invoperands.push_back(std::move(nexpr->expr));
      iOperand = e.operands.erase(iOperand);
    } else {
      ++iOperand;
    }
  }

  iOperand = e.invoperands.begin();
  while (iOperand != e.invoperands.end()) {
    auto *nexpr = dynamic_cast<NegatedExpr *>(iOperand->get());
    if (nexpr != nullptr) {
      e.operands.push_back(std::move(nexpr->expr));
      iOperand = e.invoperands.erase(iOperand);
    } else {
      ++iOperand;
    }
  }

  merge(e);
  knead(e.operands);
  knead(e.invoperands);
}

void ExprMerger::mutate(MultiplicativeExpr &e) {
  merge(e);
  knead(e.operands);
  knead(e.invoperands);
}

void ExprMerger::mutate(AndExpr &e) {
  merge(e);
  knead(e.operands);
}

void ExprMerger::mutate(OrExpr &e) {
  merge(e);
  knead(e.operands);
}

void ExprMerger::mutate(RelationalExpr &e) {
  merge(e.lhs);
  merge(e.rhs);
}

void ExprMerger::mutate(PrintTabExpr &e) { merge(e.tabstop); }
