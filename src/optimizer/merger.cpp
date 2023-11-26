// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "merger.hpp"
#include "ast/lister.hpp"
#include "constfolder.hpp"
#include "constinspector.hpp"
#include "consttable/fixedpoint.hpp"
#include "factorizer.hpp"
#include "isequal.hpp"
#include "isrelational.hpp"
#include "shiftcombiner.hpp"
#include <string>

// TODO:
//   Replace class with separate ExprOp's for each operation and
//   one additional ExprOp to manage the others.  That should
//   remove reliance upon private methods using dynamic_cast<>.

static std::string list(const Expr *expr) {
  ExprLister el;
  expr->soak(&el);
  return el.result;
}

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
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(expr.get()).c_str());
      auto divisor = makeup<MultiplicativeExpr>();
      divisor->operands = mv(mexpr->invoperands);
      mexpr->invoperands.clear();
      expr = makeup<IntegerDivisionExpr>(mv(iexpr->expr), mv(divisor));
      announcer.finish(list(expr.get()).c_str());
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
        announcer.start(lineNumber);
        announcer.say("replaced %s with ", list(expr.get()).c_str());
        auto *aexp = new AndExpr(mv(*iOperand));
        mexpr->operands.erase(iOperand);
        auto addExpr = makeup<AdditiveExpr>();
        addExpr->invoperands.emplace_back(mv(expr));
        aexp->operands.emplace_back(mv(addExpr));
        expr = up<NumericExpr>(aexp);
        announcer.finish(list(expr.get()).c_str());
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
          announcer.start(lineNumber);
          announcer.say("replaced %s with ", list(expr.get()).c_str());
          auto *aexp = new AndExpr(mv(nexpr->invoperands[0]));
          mexpr->operands.erase(iOperand);
          aexp->operands.emplace_back(mv(expr));
          expr = up<NumericExpr>(aexp);
          announcer.finish(list(expr.get()).c_str());
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
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(expr.get()).c_str());
      expr = makeup<ShiftExpr>(makeup<NumericConstantExpr>(1),
                               mv(mexpr->exponent));
      announcer.finish(list(expr.get()).c_str());
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
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(expr.get()).c_str());
      iOperand = ops.erase(iOperand);
      if (n != 0) {
        auto count = makeup<NumericConstantExpr>(sign * n);
        expr = makeup<ShiftExpr>(mv(expr), mv(count));
        announcer.finish(list(expr.get()).c_str());
        merge(expr);
        return true;
      }
      announcer.finish(list(expr.get()).c_str());
    } else if (auto *sexpr = dynamic_cast<ShiftExpr *>(iOperand->get())) {
      // X * SHIFT(A,B) -> SHIFT(X*A,B)
      // X / SHIFT(A,B) -> SHIFT(X/A,-B)
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(expr.get()).c_str());
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
      announcer.finish(list(expr.get()).c_str());
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
          announcer.start(lineNumber);
          announcer.say("replaced %s with ", list(expr.get()).c_str());
          operand = mv(nmexpr->invoperands[0]);
          expr = mv(nexpr->invoperands[0]);
          announcer.finish(list(expr.get()).c_str());
          return;
        }
      }
      for (auto &invoperand : mexpr->invoperands) {
        auto *nmexpr = dynamic_cast<AdditiveExpr *>(invoperand.get());
        if (nmexpr && nmexpr->operands.empty() &&
            nmexpr->invoperands.size() == 1) {
          announcer.start(lineNumber);
          announcer.say("replaced %s with ", list(expr.get()).c_str());
          invoperand = mv(nmexpr->invoperands[0]);
          expr = mv(nexpr->invoperands[0]);
          announcer.finish(list(expr.get()).c_str());
          return;
        }
      }
      for (auto &operand : mexpr->operands) {
        if (auto *nmexpr = dynamic_cast<NumericConstantExpr *>(operand.get())) {
          announcer.start(lineNumber);
          announcer.say("replaced %s with ", list(expr.get()).c_str());
          nmexpr->value = -nmexpr->value;
          expr = mv(nexpr->invoperands[0]);
          announcer.finish(list(expr.get()).c_str());
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
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(expr.get()).c_str());
      mexpr->operands.pop_back();
      auto neg = makeup<AdditiveExpr>();
      neg->invoperands.emplace_back(mv(expr));
      expr = mv(neg);
      announcer.finish(list(expr.get()).c_str());
    } else if (!mexpr->invoperands.empty() &&
               constInspector.isEqual(mexpr->invoperands.back().get(), -1)) {
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(expr.get()).c_str());
      mexpr->invoperands.pop_back();
      auto neg = makeup<AdditiveExpr>();
      neg->invoperands.emplace_back(mv(expr));
      expr = mv(neg);
      announcer.finish(list(expr.get()).c_str());
    }
  }
}

void ExprMerger::mergeDoubleShift(up<NumericExpr> &expr) {

  if (auto *outerExpr = dynamic_cast<ShiftExpr *>(expr.get())) {
    if (auto *innerExpr = dynamic_cast<ShiftExpr *>(outerExpr->expr.get())) {
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(expr.get()).c_str());
      auto addExpr = makeup<AdditiveExpr>(mv(outerExpr->count));
      addExpr->operands.emplace_back(mv(innerExpr->count));
      outerExpr->count = mv(addExpr);
      outerExpr->expr = mv(innerExpr->expr);
      announcer.finish(list(expr.get()).c_str());
      merge(outerExpr->count);
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
          announcer.start(lineNumber);
          announcer.finish(
              "replaced PEEK(9)*256+PEEK(10) with TIMER expression");
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
        announcer.start(lineNumber);
        announcer.finish("replaced PEEK(%f)*256+PEEK(%f) with PEEKW expression",
                         *value1, *value2);
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
            announcer.start(lineNumber);
            announcer.finish(
                "replaced PEEK(<n>)*256+PEEK(<n+1>) with PEEKW expression");
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
          announcer.start(lineNumber);
          announcer.finish(
              "replaced PEEK(17024)*256+PEEK(17025) with POS expression");
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
        announcer.start(lineNumber);
        auto op2 = list(iOp2->get());
        announcer.finish("replaced %s * %s with SQ(%s)", op2.c_str(),
                         op2.c_str(), op2.c_str());
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
      announcer.start(lineNumber);
      announcer.say("replaced %s with ", list(pexpr).c_str());
      auto sq = makeup<SquareExpr>();
      sq->expr = mv(pexpr->base);
      expr = mv(sq);
      announcer.finish(list(expr.get()).c_str());
    }
  }
}

bool ExprMerger::reduceProperFraction(std::vector<up<NumericExpr>> &ops1,
                                      std::vector<up<NumericExpr>> &ops2) {
  for (auto iOp2 = ops2.begin(); iOp2 != ops2.end(); ++iOp2) {
    if (auto *iexpr = dynamic_cast<IntExpr *>(iOp2->get())) {
      IsEqual isEqual(iexpr->expr.get());
      for (auto &op1 : ops1) {
        if (op1->check(&isEqual)) {
          auto op1str = list(op1.get());
          auto op2str = list(iOp2->get());
          announcer.start(lineNumber);
          announcer.say("replaced (%s)-%s with ", op1str.c_str(),
                        op2str.c_str());
          auto fract = makeup<FractExpr>();
          fract->expr = mv(op1);
          op1 = mv(fract);
          iOp2 = ops2.erase(iOp2);
          announcer.finish(list(op1.get()).c_str());
          return true;
        }
      }
    }
  }
  return false;
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
  exprConstFolder.setLineNumber(lineNumber);
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
  exprConstFolder.setLineNumber(lineNumber);
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
  StatementMerger statementMerger(symbolTable, option);
  statementMerger.setLineNumber(l.lineNumber);
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
      announcer.start(lineNumber);
      announcer.finish("merged nested concatenation");
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
      announcer.start(lineNumber);
      announcer.finish(
          "identity element %f removed from n-ary numeric expression");
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
  // give (X/Y)-INT(X/Y) a shot before X/Y-IDIV(X,Y)
  while (reduceProperFraction(e.operands, e.invoperands) ||
         reduceProperFraction(e.invoperands, e.operands)) {
  }

  Factorizer factorizer(lineNumber, option);
  ShiftCombiner shiftCombiner(lineNumber, option);
  do {
    merge(e);
    knead(e.operands);
    knead(e.invoperands);
  } while (factorizer.factorize(&e) || shiftCombiner.combine(&e) ||
           reduceProperFraction(e.operands, e.invoperands) ||
           reduceProperFraction(e.invoperands, e.operands));
}

void ExprMerger::mutate(MultiplicativeExpr &e) {
  merge(e);
  reduceSquaredMultiplication(e.operands);
  reduceSquaredMultiplication(e.operands);
  knead(e.operands);
  knead(e.invoperands);
}

void ExprMerger::mutate(AndExpr &e) {
  Factorizer factorizer(lineNumber, option);
  ShiftCombiner shiftCombiner(lineNumber, option);
  do {
    merge(e);
    knead(e.operands);
  } while (factorizer.factorize(&e) || shiftCombiner.combine(&e));
}

void ExprMerger::mutate(OrExpr &e) {
  Factorizer factorizer(lineNumber, option);
  ShiftCombiner shiftCombiner(lineNumber, option);
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
      announcer.start(lineNumber);
      announcer.say("%s replaced with ", list(&e).c_str());

      auto rhs = makeup<AdditiveExpr>();
      rhs->operands.insert(rhs->operands.end(),
                           std::make_move_iterator(addExp->invoperands.begin()),
                           std::make_move_iterator(addExp->invoperands.end()));
      addExp->invoperands.clear();
      e.rhs = mv(rhs);
      announcer.finish(list(&e).c_str());
      merge(e.lhs);
      merge(e.rhs);
    }
  }
}

void ExprMerger::mutate(PrintTabExpr &e) { merge(e.tabstop); }

void ExprMerger::mutate(SquareExpr &e) { merge(e.expr); }

void ExprMerger::mutate(FractExpr &e) { merge(e.expr); }
