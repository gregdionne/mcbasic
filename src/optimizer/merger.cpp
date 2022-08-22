// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "merger.hpp"
#include "constfolder.hpp"
#include "constinspector.hpp"
#include "consttable/fixedpoint.hpp"
#include "isequal.hpp"
#include "isrelational.hpp"
#include "factorizer.hpp"
#include "shiftcombiner.hpp"
#include <string>

// TODO:
//   Replace class with separate ExprOp's for each operation and
//   one additional ExprOp to manage the others.  That should
//   remove reliance upon private methods using dynamic_cast<>.

void ExprMerger::reduceNaryExpr(up<NumericExpr> &expr) {

  if (auto *nexpr = dynamic_cast<NaryNumericExpr *>(expr.get())) {
    // replace empty with identity
    if (nexpr->operands.empty() && nexpr->invoperands.empty()) {
      expr = makeup<NumericConstantExpr>(nexpr->identity);
      return;
    }

    // replace unary with argument
    if (nexpr->operands.size() == 1 && nexpr->invoperands.empty()) {
      expr = mv(nexpr->operands[0]);
      return;
    }
  }
}

void ExprMerger::reduceIntegerDivision(up<NumericExpr> &expr) {
  if (auto *iexpr = dynamic_cast<IntExpr *>(expr.get())) {
    auto *mexpr = dynamic_cast<MultiplicativeExpr *>(iexpr->expr.get());
    if (mexpr && !mexpr->invoperands.empty()) {
      auto divisor = makeup<MultiplicativeExpr>();
      divisor->operands = mv(mexpr->invoperands);
      mexpr->invoperands.clear();
      expr = makeup<IntegerDivisionExpr>(mv(iexpr->expr), mv(divisor));
      merge(expr);
    }
  }
}

void ExprMerger::reduceRelationalMultiplication(up<NumericExpr> &expr,
                                                IsFloat &isFloat) {
  if (auto *mexpr = dynamic_cast<MultiplicativeExpr *>(expr.get())) {
    for (auto iOperand = mexpr->operands.begin();
         iOperand != mexpr->operands.end(); ++iOperand) {
      auto *rexpr = dynamic_cast<RelationalExpr *>(iOperand->get());
      if (rexpr && !mexpr->check(&isFloat)) {
        auto *aexp = new AndExpr(mv(*iOperand));
        mexpr->operands.erase(iOperand);
        auto addExpr = makeup<AdditiveExpr>();
        addExpr->invoperands.emplace_back(mv(expr));
        aexp->operands.emplace_back(mv(addExpr));
        expr = up<NumericExpr>(aexp);
        merge(expr);
        return;
      }
    }
    for (auto iOperand = mexpr->operands.begin();
         iOperand != mexpr->operands.end(); ++iOperand) {
      auto *nexpr = dynamic_cast<AdditiveExpr *>(iOperand->get());
      if (nexpr && nexpr->operands.empty() && nexpr->invoperands.size() == 1) {
        auto *rexpr =
            dynamic_cast<RelationalExpr *>(nexpr->invoperands[0].get());
        if (rexpr && !mexpr->check(&isFloat)) {
          auto *aexp = new AndExpr(mv(nexpr->invoperands[0]));
          mexpr->operands.erase(iOperand);
          aexp->operands.emplace_back(mv(expr));
          expr = up<NumericExpr>(aexp);
          merge(expr);
          return;
        }
      }
    }
  }
}

void ExprMerger::reducePowerOfTwo(up<NumericExpr> &expr, IsFloat &isFloat) {
  if (auto *mexpr = dynamic_cast<PowerExpr *>(expr.get())) {
    ConstInspector constInspector;
    if (constInspector.isEqual(mexpr->base.get(), 2) &&
        !mexpr->exponent->check(&isFloat)) {
      expr = makeup<ShiftExpr>(makeup<NumericConstantExpr>(1),
                               mv(mexpr->exponent));
      merge(expr);
    }
  }
}

bool ExprMerger::reducePowerOfTwoMultiplication(
    up<NumericExpr> &expr, std::vector<up<NumericExpr>> &ops, int sign) {

  for (auto iOperand = ops.begin(); iOperand != ops.end(); ++iOperand) {
    ConstInspector constInspector;
    auto v = (*iOperand)->constify(&constInspector);
    if (v && FixedPoint(*v).isPowerOfTwo()) {
      int n = FixedPoint(*v).log2abs();
      iOperand = ops.erase(iOperand);
      if (n != 0) {
        auto count = makeup<NumericConstantExpr>(sign * n);
        expr = makeup<ShiftExpr>(mv(expr), mv(count));
        merge(expr);
        return true;
      }
    } else if (auto *sexpr = dynamic_cast<ShiftExpr *>(iOperand->get())) {
      // X * SHIFT(A,B) -> SHIFT(X*A,B)
      // X / SHIFT(A,B) -> SHIFT(X/A,-B)
      auto shiftExpr = mv(*iOperand);
      sexpr = dynamic_cast<ShiftExpr *>(shiftExpr.get());
      *iOperand = mv(sexpr->expr);
      sexpr->expr = mv(expr);
      if (sign < 0) {
        auto addExpr = makeup<AdditiveExpr>();
        addExpr->invoperands.emplace_back(mv(sexpr->count));
        sexpr->count = mv(addExpr);
      }
      expr = mv(shiftExpr);
      merge(expr);
      return true;
    }
  }
  return false;
}

void ExprMerger::reducePowerOfTwoMultiplication(up<NumericExpr> &expr) {
  if (auto *mexpr = dynamic_cast<MultiplicativeExpr *>(expr.get())) {

    if (reducePowerOfTwoMultiplication(expr, mexpr->operands, +1)) {
      return;
    }

    reducePowerOfTwoMultiplication(expr, mexpr->invoperands, -1);
  }
}

void ExprMerger::mergeNegatedMultiplication(up<NumericExpr> &expr) {
  auto *nexpr = dynamic_cast<AdditiveExpr *>(expr.get());
  if (nexpr && nexpr->operands.empty() && nexpr->invoperands.size() == 1) {
    if (auto *mexpr =
            dynamic_cast<MultiplicativeExpr *>(nexpr->invoperands[0].get())) {
      for (auto &operand : mexpr->operands) {
        auto *nmexpr = dynamic_cast<AdditiveExpr *>(operand.get());
        if (nmexpr && nmexpr->operands.empty() &&
            nmexpr->invoperands.size() == 1) {
          operand = mv(nmexpr->invoperands[0]);
          expr = mv(nexpr->invoperands[0]);
          return;
        }
      }
      for (auto &invoperand : mexpr->invoperands) {
        auto *nmexpr = dynamic_cast<AdditiveExpr *>(invoperand.get());
        if (nmexpr && nmexpr->operands.empty() &&
            nmexpr->invoperands.size() == 1) {
          invoperand = mv(nmexpr->invoperands[0]);
          expr = mv(nexpr->invoperands[0]);
          return;
        }
      }
      for (auto &operand : mexpr->operands) {
        if (auto *nmexpr = dynamic_cast<NumericConstantExpr *>(operand.get())) {
          nmexpr->value = -nmexpr->value;
          expr = mv(nexpr->invoperands[0]);
          return;
        }
      }
    }
  }
}

void ExprMerger::reduceMultiplyByNegativeOne(up<NumericExpr> &expr) {
  if (auto *mexpr = dynamic_cast<MultiplicativeExpr *>(expr.get())) {
    ConstInspector constInspector;
    if (!mexpr->operands.empty() &&
        constInspector.isEqual(mexpr->operands.back().get(), -1)) {
      mexpr->operands.pop_back();
      auto neg = makeup<AdditiveExpr>();
      neg->invoperands.emplace_back(mv(expr));
      expr = mv(neg);
    } else if (!mexpr->invoperands.empty() &&
               constInspector.isEqual(mexpr->invoperands.back().get(), -1)) {
      mexpr->invoperands.pop_back();
      auto neg = makeup<AdditiveExpr>();
      neg->invoperands.emplace_back(mv(expr));
      expr = mv(neg);
    }
  }
}

void ExprMerger::mergeDoubleShift(up<NumericExpr> &expr) {

  if (auto *outerExpr = dynamic_cast<ShiftExpr *>(expr.get())) {
    if (auto *innerExpr = dynamic_cast<ShiftExpr *>(outerExpr->expr.get())) {
      auto addExpr = makeup<AdditiveExpr>(mv(outerExpr->count));
      addExpr->operands.emplace_back(mv(innerExpr->count));
      up<NumericExpr> aExpr = mv(addExpr);
      merge(aExpr);
      outerExpr->count = mv(aExpr);
      outerExpr->expr = mv(innerExpr->expr);
    }
  }
}

bool ExprMerger::mergeWithTimer(PeekExpr *peek1,
                                std::vector<up<NumericExpr>> &ops) {
  ConstInspector constInspector;

  if (constInspector.isEqual(peek1->expr.get(), 9)) {
    for (auto &op : ops) {
      if (auto *peek2 = dynamic_cast<PeekExpr *>(op.get())) {
        if (constInspector.isEqual(peek2->expr.get(), 10)) {
          op = makeup<TimerExpr>();
          return true;
        }
      }
    }
  }
  return false;
}

bool ExprMerger::mergeWithPeekWord(PeekExpr *peek1,
                                   std::vector<up<NumericExpr>> &ops) {
  ConstInspector constInspector;

  for (auto &op : ops) {
    if (auto *peek2 = dynamic_cast<PeekExpr *>(op.get())) {
      auto value1 = peek1->expr->constify(&constInspector);
      auto value2 = peek2->expr->constify(&constInspector);
      if (value1 && value2 && *value1 + 1 == *value2) {
        auto peekw = makeup<PeekWordExpr>();
        peekw->expr = mv(peek1->expr);
        op = mv(peekw);
        return true;
      }

      if (auto *arg2add = dynamic_cast<AdditiveExpr *>(peek2->expr.get())) {
        if (arg2add->invoperands.empty() && arg2add->operands.size() == 2 &&
            constInspector.isEqual(arg2add->operands[1].get(), 1)) {
          IsEqual isEqual(peek1->expr.get());
          if (arg2add->operands[0]->check(&isEqual)) {
            auto peekw = makeup<PeekWordExpr>();
            peekw->expr = mv(peek1->expr);
            op = mv(peekw);
            return true;
          }
        }
      }
    }
  }
  return false;
}

bool ExprMerger::mergeWithPos(PeekExpr *peek1,
                              std::vector<up<NumericExpr>> &ops) {
  ConstInspector constInspector;

  if (constInspector.isEqual(peek1->expr.get(), 17024)) {
    for (auto &op : ops) {
      if (auto *peek2 = dynamic_cast<PeekExpr *>(op.get())) {
        if (constInspector.isEqual(peek2->expr.get(), 17025)) {
          op = makeup<PosExpr>();
          return true;
        }
      }
    }
  }
  return false;
}

void ExprMerger::reduceSquaredMultiplication(
    std::vector<up<NumericExpr>> &ops) {
  for (auto iOp1 = ops.begin(); iOp1 != ops.end(); ++iOp1) {
    IsEqual isEqual(iOp1->get());
    auto iOp2 = std::next(iOp1);
    while (iOp2 != ops.end()) {
      if ((*iOp2)->check(&isEqual)) {
        iOp2 = ops.erase(iOp2);
        auto sq = makeup<SquareExpr>();
        sq->expr = mv(*iOp1);
        *iOp1 = std::move(sq);
        break;
      }
      ++iOp2;
    }
  }
}

void ExprMerger::reduceSquarePower(up<NumericExpr> &expr) {
  if (auto *pexpr = dynamic_cast<PowerExpr *>(expr.get())) {
    ConstInspector constInspector;
    if (constInspector.isEqual(pexpr->exponent.get(), 2)) {
      auto sq = makeup<SquareExpr>();
      sq->expr = mv(pexpr->base);
      expr = mv(sq);
    }
  }
}

bool ExprMerger::mergeDoublePeek(std::vector<up<NumericExpr>> &ops) {

  for (auto iOp1 = ops.begin(); iOp1 != ops.end(); ++iOp1) {
    if (auto *shift = dynamic_cast<ShiftExpr *>(iOp1->get())) {
      ConstInspector constInspector;
      if (constInspector.isEqual(shift->count.get(), 8)) {

        // merge exprs of type PEEK(<expr>)*256 + PEEK(<expr>)
        if (auto *peek1 = dynamic_cast<PeekExpr *>(shift->expr.get())) {
          if (mergeWithTimer(peek1, ops) || mergeWithPeekWord(peek1, ops)) {
            ops.erase(iOp1);
            return true;
          }
        }

        // merge exprs of type PEEK(<expr>AND1)*256 + PEEK(<expr>)
        if (auto *and1 = dynamic_cast<AndExpr *>(shift->expr.get())) {
          if (and1->operands.size() == 2 &&
              constInspector.isEqual(and1->operands[1].get(), 1)) {
            if (auto *peek1 =
                    dynamic_cast<PeekExpr *>(and1->operands[0].get())) {
              if (mergeWithPos(peek1, ops)) {
                ops.erase(iOp1);
                return true;
              }
            }
          }
        }
      }
    }
  }
  return false;
}

void ExprMerger::mergeDoublePeek(up<NumericExpr> &expr) {
  if (auto *aexpr = dynamic_cast<AdditiveExpr *>(expr.get())) {
    // try additions
    if (mergeDoublePeek(aexpr->operands)) {
      merge(expr);
      return;
    }

    // try subtractions
    if (mergeDoublePeek(aexpr->invoperands)) {
      merge(expr);
      return;
    }
  }
}

void ExprMerger::knead(std::vector<up<NumericExpr>> &operands) {
  ConstInspector constInspector;

  auto left = operands.begin();
  auto right = operands.end();
  if (left != right) {
    --right;
    while (left != right) {
      if ((*right)->constify(&constInspector)) {
        --right;
      } else if (!(*left)->constify(&constInspector)) {
        ++left;
      } else {
        std::iter_swap(left, right);
      }
    }

    left = operands.begin();
    right = operands.end();

    --right;
    while (left != right) {
      if ((*right)->isVar() || (*right)->constify(&constInspector)) {
        --right;
      } else if (!(*left)->isVar() && !(*left)->constify(&constInspector)) {
        ++left;
      } else {
        std::iter_swap(left, right);
      }
    }

    IsRelational isRelational;
    left = operands.begin();
    while (left != right) {
      if ((*left)->check(&isRelational)) {
        ++left;
      } else if (!(*right)->check(&isRelational)) {
        --right;
      } else {
        std::iter_swap(left, right);
      }
    }
  }
}

// merge expressions...
void ExprMerger::merge(up<NumericExpr> &expr) {
  expr->mutate(this);
  exprConstFolder.fold(expr);
  reduceNaryExpr(expr);
  mergeDoubleShift(expr);
  mergeDoublePeek(expr);
  reduceMultiplyByNegativeOne(expr);
  mergeNegatedMultiplication(expr);
  reducePowerOfTwo(expr, isFloat);
  reduceRelationalMultiplication(expr, isFloat);
  reducePowerOfTwoMultiplication(expr);
  reduceSquarePower(expr);
  reduceIntegerDivision(expr);
}

void ExprMerger::merge(up<StringExpr> &expr) {
  expr->mutate(this);
  exprConstFolder.fold(expr);
}

void ExprMerger::merge(up<Expr> &expr) {
  if (auto *tmpExpr = expr->numExpr()) {
    up<NumericExpr> tmp(tmpExpr);
    static_cast<void>(expr.release());
    merge(tmp);
    expr = mv(tmp);
  } else if (auto *tmpExpr = expr->strExpr()) {
    up<StringExpr> tmp(tmpExpr);
    static_cast<void>(expr.release());
    merge(tmp);
    expr = mv(tmp);
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
  StatementMerger statementMerger(symbolTable);
  for (auto &statement : l.statements) {
    statement->mutate(&statementMerger);
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

void StatementMerger::mutate(Accum &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::mutate(Decum &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::mutate(Necum &s) {
  merger.merge(s.lhs);
  merger.merge(s.rhs);
}

void StatementMerger::mutate(Eval &s) {
  for (auto &operand : s.operands) {
    merger.merge(operand);
  }
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

void StatementMerger::mutate(Exec &s) { merger.merge(s.address); }

// string expressions...
void ExprMerger::mutate(StringArrayExpr &e) { e.indices->mutate(this); }

void ExprMerger::mutate(StringConcatenationExpr &e) {
  for (auto &op : e.operands) {
    merge(op);
  }

  auto iOperand = e.operands.begin();
  while (iOperand != e.operands.end()) {
    if (auto *subExp =
            dynamic_cast<StringConcatenationExpr *>(iOperand->get())) {
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

void ExprMerger::mutate(ComplementedExpr &e) { merge(e.expr); }

void ExprMerger::mutate(SgnExpr &e) { merge(e.expr); }

void ExprMerger::mutate(IntExpr &e) { merge(e.expr); }

void ExprMerger::mutate(AbsExpr &e) { merge(e.expr); }

void ExprMerger::mutate(SqrExpr &e) { merge(e.expr); }

void ExprMerger::mutate(ExpExpr &e) { merge(e.expr); }

void ExprMerger::mutate(LogExpr &e) { merge(e.expr); }

void ExprMerger::mutate(SinExpr &e) { merge(e.expr); }

void ExprMerger::mutate(CosExpr &e) { merge(e.expr); }

void ExprMerger::mutate(TanExpr &e) { merge(e.expr); }

void ExprMerger::mutate(RndExpr &e) { merge(e.expr); }

void ExprMerger::mutate(PeekExpr &e) { merge(e.expr); }

void ExprMerger::mutate(PeekWordExpr &e) { merge(e.expr); }

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

void ExprMerger::pruneIdentity(std::vector<up<NumericExpr>> &operands,
                               double identity) {
  auto iop = operands.begin();
  while (iop != operands.end()) {
    ConstInspector constInspector;
    if (constInspector.isEqual(iop->get(), identity)) {
      iop = operands.erase(iop);
    } else {
      ++iop;
    }
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
    if (subExp && e.funcName == subExp->funcName) {
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
    if (subExp && e.funcName == subExp->funcName) {
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
  Factorizer factorizer;
  ShiftCombiner shiftCombiner;
  do {
    merge(e);
    knead(e.operands);
    knead(e.invoperands);
  } while (factorizer.factorize(&e) || shiftCombiner.combine(&e));
}

void ExprMerger::mutate(MultiplicativeExpr &e) {
  merge(e);
  reduceSquaredMultiplication(e.operands);
  reduceSquaredMultiplication(e.operands);
  knead(e.operands);
  knead(e.invoperands);
}

void ExprMerger::mutate(AndExpr &e) {
  Factorizer factorizer;
  ShiftCombiner shiftCombiner;
  do {
    merge(e);
    knead(e.operands);
  } while (factorizer.factorize(&e) || shiftCombiner.combine(&e));
}

void ExprMerger::mutate(OrExpr &e) {
  Factorizer factorizer;
  ShiftCombiner shiftCombiner;
  do {
    merge(e);
    knead(e.operands);
  } while (factorizer.factorize(&e) || shiftCombiner.combine(&e));
}

void ExprMerger::mutate(ShiftExpr &e) {
  merge(e.expr);
  merge(e.count);
}

void ExprMerger::mutate(RelationalExpr &e) {
  merge(e.lhs);
  merge(e.rhs);

  // knead expression
  auto *nlexp = e.lhs->numExpr();
  auto *slexp = e.lhs->strExpr();
  auto *nrexp = e.rhs->numExpr();
  auto *srexp = e.rhs->strExpr();

  ConstInspector constInspector;
  auto nlhs =
      nlexp ? nlexp->constify(&constInspector) : utils::optional<double>();
  auto slhs =
      slexp ? slexp->constify(&constInspector) : utils::optional<std::string>();
  auto nrhs =
      nlexp ? nrexp->constify(&constInspector) : utils::optional<double>();
  auto srhs =
      slexp ? srexp->constify(&constInspector) : utils::optional<std::string>();

  if (!nrhs && !srhs && (nlhs || (e.lhs->isVar() && !e.rhs->isVar()))) {
    std::swap(e.lhs, e.rhs);
    e.comparator = e.comparator == "<"                            ? ">"
                   : e.comparator == "<=" || e.comparator == "=<" ? ">="
                   : e.comparator == "="                          ? "="
                   : e.comparator == ">=" || e.comparator == "=>" ? "<="
                   : e.comparator == ">"                          ? "<"
                                                                  : "<>";
  }

  // convert A-B op 0 to A op B
  if (nrhs && *nrhs == 0) {
    auto *addExp = dynamic_cast<AdditiveExpr *>(e.lhs.get());
    if (addExp && !addExp->invoperands.empty()) {
      auto rhs = makeup<AdditiveExpr>();
      rhs->operands.insert(rhs->operands.end(),
                           std::make_move_iterator(addExp->invoperands.begin()),
                           std::make_move_iterator(addExp->invoperands.end()));
      addExp->invoperands.clear();
      e.rhs = mv(rhs);
      merge(e.lhs);
      merge(e.rhs);
    }
  }
}

void ExprMerger::mutate(PrintTabExpr &e) { merge(e.tabstop); }

void ExprMerger::mutate(SquareExpr &e) { merge(e.expr); }
