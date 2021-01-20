// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "merger.hpp"

#include <string>

// TODO:
//   Replace class with separate ExprOp's for each operation and
//   one additional ExprOp to manage the others.  That should
//   remove reliance upon private methods using dynamic_cast<>.

void ExprMerger::mergeUnaryOp(std::unique_ptr<NumericExpr> &expr) {
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

void ExprMerger::reduceRelationalMultiplication(
    std::unique_ptr<NumericExpr> &expr, IsFloat &isFloat, ExprMerger *that) {
  auto *mexpr = dynamic_cast<MultiplicativeExpr *>(expr.get());
  if (mexpr != nullptr) {
    for (auto iOperand = mexpr->operands.begin();
         iOperand != mexpr->operands.end(); ++iOperand) {
      auto *rexpr = dynamic_cast<RelationalExpr *>(iOperand->get());
      if ((rexpr != nullptr) && !boperate(mexpr, isFloat)) {
        auto *aexp = new AndExpr(std::move(*iOperand));
        mexpr->operands.erase(iOperand);
        aexp->append(
            std::unique_ptr<NumericExpr>(new NegatedExpr(std::move(expr))));
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
        if ((rexpr != nullptr) && !boperate(mexpr, isFloat)) {
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
          expr = std::make_unique<ShiftExpr>(std::move(expr), n);
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
          expr = std::make_unique<ShiftExpr>(std::move(expr), -n);
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

void ExprMerger::mergeDoubleShift(std::unique_ptr<NumericExpr> &expr) {
  ShiftExpr *outerExpr = nullptr;
  ShiftExpr *innerExpr = nullptr;

  if (((outerExpr = dynamic_cast<ShiftExpr *>(expr.get())) != nullptr) &&
      ((innerExpr = dynamic_cast<ShiftExpr *>(outerExpr->expr.get())) != nullptr)) {
    outerExpr->rhs += innerExpr->rhs;
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

    left = operands.begin();
    while (left != right) {
      if ((*left)->isRelational()) {
        ++left;
      } else if (!(*right)->isRelational()) {
        --right;
      } else {
        std::iter_swap(left, right);
      }
    }
  }
}

// merge expressions...
void ExprMerger::merge(std::unique_ptr<NumericExpr> &expr) {
  expr->operate(this);
  mergeUnaryOp(expr);
  mergeDoubleNegation(expr);
  mergeDoubleShift(expr);
  mergeNegatedSum(expr);
  mergeNegatedMultiplication(expr);
  reduceRelationalMultiplication(expr, isFloat, this);
  reducePowerOfTwoMultiplication(expr, this);
}

void ExprMerger::merge(std::unique_ptr<StringExpr> &expr) {
  expr->operate(this);
}

void ExprMerger::merge(std::unique_ptr<Expr> &expr) {
  auto *tmpExpr = dynamic_cast<NumericExpr *>(expr.get());
  if (tmpExpr != nullptr) {
    std::unique_ptr<NumericExpr> tmp(tmpExpr);
    static_cast<void>(expr.release());
    merge(tmp);
    expr = std::move(tmp);
  } else {
    expr->operate(this);
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
    statement->operate(&that);
  }
}

void StatementMerger::operate(For &s) {
  merger.merge(s.from);
  merger.merge(s.to);
  if (s.step) {
    merger.merge(s.step);
  }
}

void StatementMerger::operate(When &s) { merger.merge(s.predicate); }

void StatementMerger::operate(If &s) {
  merger.merge(s.predicate);
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}

void StatementMerger::operate(Print &s) {
  if (s.at) {
    merger.merge(s.at);
  }

  for (auto &expr : s.printExpr) {
    merger.merge(expr);
  }
}

void StatementMerger::operate(On &s) { merger.merge(s.branchIndex); }

void StatementMerger::operate(Dim &s) {
  for (auto &variable : s.variables) {
    merger.merge(variable);
  }
}

void StatementMerger::operate(Let &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::operate(Inc &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::operate(Dec &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::operate(Poke &s) {
  merger.merge(s.dest);
  merger.merge(s.val);
}

void StatementMerger::operate(Clear &s) {
  if (s.size) {
    merger.merge(s.size);
  }
}

void StatementMerger::operate(Set &s) {
  merger.merge(s.x);
  merger.merge(s.y);
  if (s.c) {
    merger.merge(s.c);
  }
}

void StatementMerger::operate(Reset &s) {
  merger.merge(s.x);
  merger.merge(s.y);
}

void StatementMerger::operate(Cls &s) {
  if (s.color) {
    merger.merge(s.color);
  }
}

void StatementMerger::operate(Sound &s) {
  merger.merge(s.pitch);
  merger.merge(s.duration);
}

// string expressions...
void ExprMerger::operate(StringArrayExpr &e) { e.indices->operate(this); }

void ExprMerger::operate(StringConcatenationExpr &e) {
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

void ExprMerger::operate(LeftExpr &e) {
  merge(e.str);
  merge(e.len);
}

void ExprMerger::operate(RightExpr &e) {
  merge(e.str);
  merge(e.len);
}

void ExprMerger::operate(MidExpr &e) {
  merge(e.str);
  merge(e.start);

  if (e.len) {
    merge(e.len);
  }
}

void ExprMerger::operate(LenExpr &e) { merge(e.expr); }

void ExprMerger::operate(StrExpr &e) { merge(e.expr); }

void ExprMerger::operate(ValExpr &e) { merge(e.expr); }

void ExprMerger::operate(AscExpr &e) { merge(e.expr); }

void ExprMerger::operate(ChrExpr &e) { merge(e.expr); }

void ExprMerger::operate(NumericArrayExpr &e) { e.indices->operate(this); }

void ExprMerger::operate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    merge(operand);
  }
}

void ExprMerger::operate(NegatedExpr &e) { merge(e.expr); }

void ExprMerger::operate(ComplementedExpr &e) { merge(e.expr); }

void ExprMerger::operate(SgnExpr &e) { merge(e.expr); }

void ExprMerger::operate(IntExpr &e) { merge(e.expr); }

void ExprMerger::operate(AbsExpr &e) { merge(e.expr); }

void ExprMerger::operate(RndExpr &e) { merge(e.expr); }

void ExprMerger::operate(PeekExpr &e) { merge(e.expr); }

void ExprMerger::operate(PointExpr &e) {
  merge(e.x);
  merge(e.y);
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
      e.operands.insert(e.invoperands.end(),
                        std::make_move_iterator(subExp->invoperands.begin()),
                        std::make_move_iterator(subExp->invoperands.end()));
      e.invoperands.erase(e.invoperands.begin() + i);
      --i;
    }
  }
}

void ExprMerger::operate(AdditiveExpr &e) {
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

void ExprMerger::operate(MultiplicativeExpr &e) {
  merge(e);
  knead(e.operands);
  knead(e.invoperands);
}

void ExprMerger::operate(AndExpr &e) {
  merge(e);
  knead(e.operands);
}

void ExprMerger::operate(OrExpr &e) {
  merge(e);
  knead(e.operands);
}

void ExprMerger::operate(RelationalExpr &e) {
  merge(e.lhs);
  merge(e.rhs);
}
