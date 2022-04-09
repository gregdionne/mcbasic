// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "constfolder.hpp"
#include "constinspector.hpp"
#include "consttable/fixedpoint.hpp"

#include <algorithm>
#include <cmath>
#include <string>

// fold expressions...
bool ExprConstFolder::fold(up<NumericExpr> &expr) {
  if (expr->isConst(dvalue)) {
    gotConst = true;
  } else {
    gotConst = false;
    expr->mutate(this);
    if (gotConst) {
      expr = makeup<NumericConstantExpr>(dvalue);
    }
  }

  return gotConst;
}

bool ExprConstFolder::fold(up<StringExpr> &expr) {
  if (expr->isConst(svalue)) {
    gotConst = true;
  } else {
    gotConst = false;
    expr->mutate(this);
    if (gotConst) {
      expr = makeup<StringConstantExpr>(svalue);
    }
  }

  return gotConst;
}

bool ExprConstFolder::fold(up<StringExpr> &expr, std::string &value) {
  bool result = fold(expr);
  value = svalue;
  return result;
}

bool ExprConstFolder::fold(up<NumericExpr> &expr, double &value) {
  bool result = fold(expr);
  value = dvalue;
  return result;
}

bool ExprConstFolder::fold(up<Expr> &expr) {
  if (expr->isConst(dvalue) || expr->isConst(svalue)) {
    gotConst = true;
  } else {
    gotConst = false;
    expr->mutate(this);
    if (gotConst) {
      expr = expr->isString() ? up<Expr>(new StringConstantExpr(svalue))
                              : up<Expr>(new NumericConstantExpr(dvalue));
    }
  }

  return gotConst;
}

void ConstFolder::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void ConstFolder::operate(Line &l) {
  for (auto &statement : l.statements) {
    statement->mutate(that);
  }
}

void StatementConstFolder::mutate(For &s) {
  cfe.fold(s.from);
  cfe.fold(s.to);
  if (s.step) {
    cfe.fold(s.step);
  }
}

void StatementConstFolder::mutate(When &s) { cfe.fold(s.predicate); }

void StatementConstFolder::mutate(If &s) {
  cfe.fold(s.predicate);
  for (auto &statement : s.consequent) {
    statement->mutate(this);
  }
}

void StatementConstFolder::mutate(Print &s) {
  if (s.at) {
    cfe.fold(s.at);
  }

  for (auto &expr : s.printExpr) {
    cfe.fold(expr);
  }

  for (std::size_t i = 0; i + 1 < s.printExpr.size(); ++i) {
    std::string lhs;
    std::string rhs;
    while (i + 1 < s.printExpr.size() && s.printExpr[i]->isConst(lhs) &&
           s.printExpr[i + 1]->isConst(rhs)) {
      s.printExpr[i] = makeup<StringConstantExpr>(lhs + rhs);
      s.printExpr.erase(s.printExpr.begin() + i + 1);
    }
  }
}

void StatementConstFolder::mutate(On &s) { cfe.fold(s.branchIndex); }

// useful for pruning array index arguments
void StatementConstFolder::mutate(Dim &s) {
  for (auto &variable : s.variables) {
    cfe.fold(variable);
  }
}

// useful for pruning array index arguments
void StatementConstFolder::mutate(Read &s) {
  for (auto &variable : s.variables) {
    cfe.fold(variable);
  }
}

// useful for pruning array index arguments
void StatementConstFolder::mutate(Input &s) {
  for (auto &variable : s.variables) {
    cfe.fold(variable);
  }
}

void StatementConstFolder::mutate(Let &s) {
  cfe.fold(s.lhs); // if lhs is already const?  verify rhs == const then purge?
  cfe.fold(s.rhs);
}

void StatementConstFolder::mutate(Accum &s) {
  cfe.fold(s.lhs); // if lhs is already const?  verify rhs == 0 then purge?
  cfe.fold(s.rhs);
}

void StatementConstFolder::mutate(Decum &s) {
  cfe.fold(s.lhs); // if lhs is already const?  verify rhs == 0 then purge?
  cfe.fold(s.rhs);
}

void StatementConstFolder::mutate(Necum &s) {
  cfe.fold(s.lhs); // if lhs is already const?  verify rhs == 0 then purge?
  cfe.fold(s.rhs);
}

void StatementConstFolder::mutate(Poke &s) {
  cfe.fold(s.dest);
  cfe.fold(s.val);
}

void StatementConstFolder::mutate(Clear & /* s */) {
  // if (s.size)
  //   cfe.fold(s.size);
}

void StatementConstFolder::mutate(Set &s) {
  cfe.fold(s.x);
  cfe.fold(s.y);
  if (s.c) {
    cfe.fold(s.c);
  }
}

void StatementConstFolder::mutate(Reset &s) {
  cfe.fold(s.x);
  cfe.fold(s.y);
}

void StatementConstFolder::mutate(Cls &s) {
  if (s.color) {
    cfe.fold(s.color);
  }
}

void StatementConstFolder::mutate(Sound &s) {
  cfe.fold(s.pitch);
  cfe.fold(s.duration);
}

void StatementConstFolder::mutate(Exec &s) { cfe.fold(s.address); }

// fetchers...
std::string ExprConstFolder::fetchConst(StringExpr &e) {
  gotConst = false;
  e.mutate(this);
  return svalue;
}

double ExprConstFolder::fetchConst(NumericExpr &e) {
  gotConst = false;
  e.mutate(this);
  return dvalue;
}

// string expressions...
void ExprConstFolder::mutate(StringConstantExpr &e) {
  gotConst = true;
  svalue = e.value;
}

void ExprConstFolder::mutate(StringVariableExpr & /*expr*/) {
  //    lookup e.varname
  //    if const...
  //
  gotConst = false;
}

void ExprConstFolder::mutate(StringArrayExpr &e) {
  gotConst = false;
  e.indices->mutate(this);
  gotConst = false;
}

void ExprConstFolder::mutate(PrintTabExpr &e) {
  gotConst = false;
  e.tabstop->mutate(this);
  gotConst = false;
}

void ExprConstFolder::mutate(PrintSpaceExpr & /*expr*/) {
  svalue = " ";
  gotConst = true;
}

void ExprConstFolder::mutate(PrintCRExpr & /*expr*/) {
  svalue = "\r";
  gotConst = true;
}

void ExprConstFolder::mutate(StringConcatenationExpr &e) {

  for (auto &operand : e.operands) {
    fold(operand);
  }

  for (std::size_t i = 0; i + 1 < e.operands.size(); ++i) {
    std::string lhs;
    std::string rhs;
    while (i + 1 < e.operands.size() && e.operands[i]->isConst(lhs) &&
           e.operands[i + 1]->isConst(rhs)) {
      e.operands[i] = makeup<StringConstantExpr>(lhs + rhs);
      e.operands.erase(e.operands.begin() + i + 1);
    }
  }

  gotConst = e.operands.size() == 1 && e.operands[0]->isConst(svalue);
}

void ExprConstFolder::mutate(LeftExpr &e) {
  std::string cvalue;
  bool gotStr = fold(e.str, cvalue);

  double clen;
  bool gotLen = fold(e.len, clen);

  gotConst = gotStr && gotLen;
  if (gotConst) {
    try {
      svalue = cvalue.substr(0, static_cast<std::size_t>(clen));
    } catch (...) {
      fprintf(stderr, "couldn't get LEFT$(\"%s\",%f.0)\n", cvalue.c_str(),
              clen);
      exit(1);
    }
  }
}

void ExprConstFolder::mutate(RightExpr &e) {
  std::string cvalue;
  bool gotStr = fold(e.str, cvalue);

  double clen;
  bool gotLen = fold(e.len, clen);

  gotConst = gotStr && gotLen;
  if (gotConst) {
    try {
      svalue = cvalue.substr(static_cast<std::size_t>(cvalue.length() - clen));
    } catch (...) {
      fprintf(stderr, "couldn't get RIGHT$(\"%s\",%f.0)\n", cvalue.c_str(),
              clen);
      exit(1);
    }
  }
}

void ExprConstFolder::mutate(MidExpr &e) {
  std::string cvalue;
  bool gotStr = fold(e.str, cvalue);

  double cstart;
  fold(e.start, cstart);

  gotConst &= gotStr;
  if (gotConst && !e.len) {
    try {
      svalue = cvalue.substr(static_cast<std::size_t>(cstart));
    } catch (...) {
      fprintf(stderr, "couldn't get MID$(\"%s\",%f.0)\n", cvalue.c_str(),
              cstart);
      exit(1);
    }
  } else if (gotConst) {
    double clen;
    fold(e.len, clen);

    if (gotConst) {
      try {
        svalue = cvalue.substr(static_cast<std::size_t>(cstart),
                               static_cast<std::size_t>(clen));
      } catch (...) {
        fprintf(stderr, "couldn't get MID$(\"%s\",%f.0,%f.0)\n", cvalue.c_str(),
                cstart, clen);
        exit(1);
      }
    }
  }
}

void ExprConstFolder::mutate(LenExpr &e) {
  if (fold(e.expr)) {
    dvalue = static_cast<double>(svalue.length());
  }
}

void ExprConstFolder::mutate(StrExpr &e) {
  if (fold(e.expr)) {
    svalue = std::to_string(dvalue);
    std::size_t dot = svalue.find_first_of('.');
    std::size_t last = svalue.find_last_not_of(".0");
    if (dot != std::string::npos) {
      svalue = svalue.substr(0, std::max(dot, last + 1));
      svalue = dvalue < 0 && ((FixedPoint(dvalue).wholenum != 0) ||
                              (FixedPoint(dvalue).fraction != 0))
                   ? svalue
                   : " " + svalue;
    }
  }
}

void ExprConstFolder::mutate(ShiftExpr &e) {
  if (fold(e.expr)) {
    double tmpval = dvalue;
    if (fold(e.count)) {
      if (dvalue != std::round(dvalue)) {
        fprintf(stderr, "SHIFT count evaluated to non-integral value\n");
        exit(1);
      }
      dvalue = dvalue > 0   ? tmpval * (1 << static_cast<int>(dvalue))
               : dvalue < 0 ? tmpval / (1 << static_cast<int>(-dvalue))
                            : tmpval;
    }
  }
}

void ExprConstFolder::mutate(ValExpr &e) {
  fold(e.expr);
  gotConst = false;
}

void ExprConstFolder::mutate(AscExpr &e) {
  if (fold(e.expr)) {
    dvalue =
        svalue.length() > 0 ? static_cast<unsigned char>(*svalue.c_str()) : 0;
  }
}

void ExprConstFolder::mutate(ChrExpr &e) {
  if (fold(e.expr)) {
    svalue = static_cast<char>(dvalue);
  }
}

void ExprConstFolder::mutate(NumericConstantExpr &e) {
  dvalue = e.value;
  gotConst = true;
}

void ExprConstFolder::mutate(NumericVariableExpr & /*expr*/) {
  // lookup e.varname
  // if const
  gotConst = false;
}

void ExprConstFolder::mutate(NumericArrayExpr &e) {
  gotConst = false;
  e.indices->mutate(this);
  gotConst = false;
}

void ExprConstFolder::mutate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    fold(operand);
  }
  gotConst = false;
}

void ExprConstFolder::mutate(ComplementedExpr &e) {
  if (fold(e.expr)) {
    dvalue = static_cast<double>(~static_cast<int>(dvalue));
  }
}

void ExprConstFolder::mutate(SgnExpr &e) {
  if (fold(e.expr)) {
    dvalue = dvalue < 0 ? -1.0 : dvalue > 0 ? 1.0 : 0.0;
  }
}

void ExprConstFolder::mutate(IntExpr &e) {
  if (fold(e.expr)) {
    dvalue = static_cast<double>(static_cast<int>(dvalue));
  }
}

void ExprConstFolder::mutate(AbsExpr &e) {
  if (fold(e.expr)) {
    dvalue = dvalue < 0 ? -dvalue : dvalue;
  }
}

void ExprConstFolder::mutate(SqrExpr &e) {
  if (fold(e.expr)) {
    dvalue = std::sqrt(dvalue);
  }
}

void ExprConstFolder::mutate(ExpExpr &e) {
  if (fold(e.expr)) {
    dvalue = std::exp(dvalue);
  }
}

void ExprConstFolder::mutate(LogExpr &e) {
  if (fold(e.expr)) {
    dvalue = std::log(dvalue);
  }
}

void ExprConstFolder::mutate(SinExpr &e) {
  if (fold(e.expr)) {
    dvalue = std::sin(dvalue);
  }
}

void ExprConstFolder::mutate(CosExpr &e) {
  if (fold(e.expr)) {
    dvalue = std::cos(dvalue);
  }
}

void ExprConstFolder::mutate(TanExpr &e) {
  if (fold(e.expr)) {
    dvalue = std::tan(dvalue);
  }
}

void ExprConstFolder::mutate(RndExpr &e) {
  fold(e.expr);
  gotConst = false;
}

void ExprConstFolder::mutate(PeekExpr &e) {
  fold(e.expr);
  gotConst = false;
}

void ExprConstFolder::mutate(PointExpr &e) {
  fold(e.x);
  fold(e.y);
  gotConst = false;
}

void ExprConstFolder::mutate(InkeyExpr & /*expr*/) { gotConst = false; }

void ExprConstFolder::mutate(MemExpr & /*expr*/) { gotConst = false; }

void ExprConstFolder::mutate(PosExpr & /*expr*/) { gotConst = false; }

void ExprConstFolder::mutate(TimerExpr & /*expr*/) { gotConst = false; }

void ExprConstFolder::mutate(PeekWordExpr & /*expr*/) { gotConst = false; }

void ExprConstFolder::fold(std::vector<up<NumericExpr>> &operands,
                           bool &enableFold, bool &folded, int &iOffset,
                           double &value, void (*op)(double &value, double v)) {
  for (std::size_t i = 0; i < operands.size(); ++i) {
    fold(operands[i]);
    if (gotConst) {
      op(value, dvalue);
      if (enableFold) {
        folded = true;
        operands.erase(operands.begin() + i);
        --i;
      } else {
        iOffset = i;
        enableFold = true;
      }
    }
  }
}

void ExprConstFolder::mutate(AdditiveExpr &e) {
  for (auto &operand : e.operands) {
    fold(operand);
  }

  for (auto &invoperand : e.invoperands) {
    fold(invoperand);
  }

  double value = 0.0;

  int iOffset = 0;
  bool gotFold = false;

  bool gotAdd = false;
  fold(e.operands, gotAdd, gotFold, iOffset, value,
       [](double &value, double v) -> void { value += v; });

  bool gotSub = gotAdd;
  fold(e.invoperands, gotSub, gotFold, iOffset, value,
       [](double &value, double v) -> void { value -= v; });

  if (gotFold) {
    if (gotAdd) {
      if (value != 0) {
        e.operands[iOffset] = makeup<NumericConstantExpr>(value);
      } else {
        e.operands.erase(e.operands.begin() + iOffset);
      }
    } else if (gotSub) {
      if (value != 0) {
        e.invoperands[iOffset] = makeup<NumericConstantExpr>(value);
      } else {
        e.invoperands.erase(e.invoperands.begin() + iOffset);
      }
    }
  }

  if (e.operands.size() == 1 && e.invoperands.empty() &&
      e.operands[0]->isConst(dvalue)) {
    gotConst = true;
  } else if (e.operands.empty() && e.invoperands.size() == 1 &&
             e.invoperands[0]->isConst(dvalue)) {
    dvalue = -dvalue;
    gotConst = true;
  } else if (e.operands.empty() && e.invoperands.empty()) {
    dvalue = 0.0;
    gotConst = true;
  } else {
    gotConst = false;
  }
}

void ExprConstFolder::mutate(PowerExpr &e) {
  fold(e.base);
  fold(e.exponent);

  double base;
  double exponent;
  gotConst = e.base->isConst(base) && e.exponent->isConst(exponent);
  if (gotConst) {
    dvalue = std::pow(base, exponent);
  }
}

void ExprConstFolder::mutate(IntegerDivisionExpr &e) {
  fold(e.dividend);
  fold(e.divisor);

  double dividend;
  double divisor;
  gotConst = e.dividend->isConst(dividend) && e.divisor->isConst(divisor);
  if (gotConst) {
    dvalue = std::floor(dividend / divisor);
  }
}

void ExprConstFolder::mutate(MultiplicativeExpr &e) {
  for (auto &operand : e.operands) {
    fold(operand);
  }

  for (auto &invoperand : e.invoperands) {
    fold(invoperand);
  }

  double value = 1.0;

  int iOffset = 0;
  bool gotFold = false;

  bool gotMul = false;
  fold(e.operands, gotMul, gotFold, iOffset, value,
       [](double &value, double v) { value *= v; });
  if (gotMul && value == 0) {
    gotMul = false;
    e.operands.clear();
    e.invoperands.clear();
    e.operands.emplace_back(makeup<NumericConstantExpr>(value));
  }

  bool gotDiv = gotMul;
  fold(e.invoperands, gotDiv, gotFold, iOffset, value,
       [](double &value, double v) { value /= v; });

  if (gotFold) {
    if (gotMul) {
      e.operands[iOffset] = makeup<NumericConstantExpr>(value);
    } else if (gotDiv) {
      e.invoperands[iOffset] = makeup<NumericConstantExpr>(value);
    }
  }

  if (e.operands.size() == 1 && e.invoperands.empty() &&
      e.operands[0]->isConst(dvalue)) {
    gotConst = true;
  } else if (e.operands.empty() && e.invoperands.size() == 1 &&
             e.invoperands[0]->isConst(dvalue)) {
    dvalue = 1 / dvalue;
    gotConst = true;
  } else {
    gotConst = false;
  }
}

void ExprConstFolder::mutate(AndExpr &e) {
  for (auto &operand : e.operands) {
    fold(operand);
  }

  double value = -1.0;
  int iOffset = 0;
  bool gotFold = false;
  bool gotAnd = false;

  fold(e.operands, gotAnd, gotFold, iOffset, value,
       [](double &value, double v) {
         value =
             static_cast<double>(static_cast<int>(value) & static_cast<int>(v));
       });

  if (gotFold) {
    e.operands[iOffset] =
        makeup<NumericConstantExpr>(static_cast<double>(value));
  }

  gotConst = e.operands.size() == 1 && e.operands[0]->isConst(dvalue);
}

void ExprConstFolder::mutate(OrExpr &e) {
  for (auto &operand : e.operands) {
    fold(operand);
  }

  double value = 0.0;
  int iOffset = 0;
  bool gotFold = false;
  bool gotOr = false;

  fold(e.operands, gotOr, gotFold, iOffset, value, [](double &value, double v) {
    value = static_cast<double>(static_cast<int>(value) | static_cast<int>(v));
  });

  if (gotFold) {
    dvalue = value;
    e.operands[iOffset] =
        makeup<NumericConstantExpr>(static_cast<double>(value));
  }

  gotConst = e.operands.size() == 1 && e.operands[0]->isConst(dvalue);
}

template <typename T>
static inline double compare(std::string &comparator, const T &a, const T &b) {
  return comparator == "<>"   ? -static_cast<double>(a != b)
         : comparator == "<"  ? -static_cast<double>(a < b)
         : comparator == "<=" ? -static_cast<double>(a <= b)
         : comparator == "="  ? -static_cast<double>(a == b)
         : comparator == "=>" ? -static_cast<double>(a >= b)
         : comparator == ">"  ? -static_cast<double>(a > b)
                              : 0;
}

void ExprConstFolder::mutate(RelationalExpr &e) {
  fold(e.lhs);
  fold(e.rhs);

  std::string lhsStr;
  std::string rhsStr;
  double lhsNum;
  double rhsNum;
  if (e.lhs->isConst(lhsStr) && e.rhs->isConst(rhsStr)) {
    dvalue = compare(e.comparator, lhsStr, rhsStr);
    gotConst = true;
  } else if (e.lhs->isConst(lhsNum) && e.rhs->isConst(rhsNum)) {
    dvalue = compare(e.comparator, lhsNum, rhsNum);
    gotConst = true;
  } else {
    gotConst = false;
  }
}
