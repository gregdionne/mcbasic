// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "constfolder.hpp"

#include <algorithm>
#include <string>

// fold expressions...
bool ExprConstFolder::fold(std::unique_ptr<NumericExpr> &expr) {
  if (expr->isConst(dvalue)) {
    gotConst = true;
  } else {
    gotConst = false;
    expr->operate(this);
    if (gotConst) {
      expr = std::make_unique<NumericConstantExpr>(dvalue);
    }
  }

  return gotConst;
}

bool ExprConstFolder::fold(std::unique_ptr<StringExpr> &expr) {
  if (expr->isConst(svalue)) {
    gotConst = true;
  } else {
    expr->operate(this);
    if (gotConst) {
      expr = std::make_unique<StringConstantExpr>(svalue);
    }
  }

  return gotConst;
}

bool ExprConstFolder::fold(std::unique_ptr<StringExpr> &expr,
                           std::string &value) {
  bool result = fold(expr);
  value = svalue;
  return result;
}

bool ExprConstFolder::fold(std::unique_ptr<NumericExpr> &expr, double &value) {
  bool result = fold(expr);
  value = dvalue;
  return result;
}

bool ExprConstFolder::fold(std::unique_ptr<Expr> &expr) {
  if (expr->isConst(dvalue) || expr->isConst(svalue)) {
    gotConst = true;
  } else {
    gotConst = false;
    expr->operate(this);
    if (gotConst) {
      expr = expr->isString()
                 ? std::unique_ptr<Expr>(new StringConstantExpr(svalue))
                 : std::unique_ptr<Expr>(new NumericConstantExpr(dvalue));
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
    statement->operate(that);
  }
}

void StatementConstFolder::operate(For &s) {
  cfe.fold(s.from);
  cfe.fold(s.to);
  if (s.step) {
    cfe.fold(s.step);
  }
}

void StatementConstFolder::operate(GoIf &s) { cfe.fold(s.predicate); }

void StatementConstFolder::operate(If &s) {
  cfe.fold(s.predicate);
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}

void StatementConstFolder::operate(Print &s) {
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
      s.printExpr[i] = std::make_unique<StringConstantExpr>(lhs + rhs);
      s.printExpr.erase(s.printExpr.begin() + i + 1);
    }
  }
}

void StatementConstFolder::operate(On &s) {
  cfe.fold(s.branchIndex);
  // todo if constant branch to constval only
}

void StatementConstFolder::operate(Dim &s) {
  for (auto &variable : s.variables) {
    cfe.fold(variable);
  }
}

void StatementConstFolder::operate(Let &s) {
  cfe.fold(s.lhs); // if lhs is already const?  verify rhs == const then purge?
  cfe.fold(s.rhs);
}

void StatementConstFolder::operate(Poke &s) {
  cfe.fold(s.dest);
  cfe.fold(s.val);
}

void StatementConstFolder::operate(Clear & /* s */) {
  // if (s.size)
  //   cfe.fold(s.size);
}

void StatementConstFolder::operate(Set &s) {
  cfe.fold(s.x);
  cfe.fold(s.y);
  if (s.c) {
    cfe.fold(s.c);
  }
}

void StatementConstFolder::operate(Reset &s) {
  cfe.fold(s.x);
  cfe.fold(s.y);
}

void StatementConstFolder::operate(Cls &s) {
  if (s.color) {
    cfe.fold(s.color);
  }
}

void StatementConstFolder::operate(Sound &s) {
  cfe.fold(s.pitch);
  cfe.fold(s.duration);
}

// fetchers...
std::string ExprConstFolder::fetchConst(StringExpr &e) {
  gotConst = false;
  e.operate(this);
  return svalue;
}

double ExprConstFolder::fetchConst(NumericExpr &e) {
  gotConst = false;
  e.operate(this);
  return dvalue;
}

// string expressions...
void ExprConstFolder::operate(StringConstantExpr &e) {
  gotConst = true;
  svalue = e.value;
}

void ExprConstFolder::operate(StringVariableExpr & /*expr*/) {
  //    lookup e.varname
  //    if const...
  //
  gotConst = false;
}

void ExprConstFolder::operate(StringArrayExpr &e) {
  gotConst = false;
  e.indices->operate(this);
  gotConst = false;
}

void ExprConstFolder::operate(PrintTabExpr & /*expr*/) { gotConst = false; }

void ExprConstFolder::operate(PrintSpaceExpr & /*expr*/) {
  svalue = " ";
  gotConst = true;
}

void ExprConstFolder::operate(PrintCRExpr & /*expr*/) {
  svalue = "\r";
  gotConst = true;
}

void ExprConstFolder::operate(StringConcatenationExpr &e) {
  bool pure = true;

  for (auto &operand : e.operands) {
    pure &= fold(operand);
  }

  for (std::size_t i = 0; i + 1 < e.operands.size(); ++i) {
    std::string lhs;
    std::string rhs;
    while (i + 1 < e.operands.size() && e.operands[i]->isConst(lhs) &&
           e.operands[i + 1]->isConst(rhs)) {
      e.operands[i] = std::make_unique<StringConstantExpr>(lhs + rhs);
      e.operands.erase(e.operands.begin() + i + 1);
    }
  }

  gotConst = e.operands.size() == 1 && e.operands[0]->isConst(svalue);
}

void ExprConstFolder::operate(LeftExpr &e) {
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

void ExprConstFolder::operate(RightExpr &e) {
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

void ExprConstFolder::operate(MidExpr &e) {
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

void ExprConstFolder::operate(LenExpr &e) {
  if (fold(e.expr)) {
    dvalue = static_cast<double>(svalue.length());
  }
}

void ExprConstFolder::operate(StrExpr &e) {
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

void ExprConstFolder::operate(ValExpr &e) {
  fold(e.expr);
  gotConst = false;
}

void ExprConstFolder::operate(AscExpr &e) {
  if (fold(e.expr)) {
    dvalue = svalue.length() > 0 ? static_cast<double>(*svalue.c_str()) : 0;
  }
}

void ExprConstFolder::operate(ChrExpr &e) {
  if (fold(e.expr)) {
    svalue = static_cast<char>(dvalue);
  }
}

void ExprConstFolder::operate(NumericConstantExpr &e) {
  dvalue = e.value;
  gotConst = true;
}

void ExprConstFolder::operate(NumericVariableExpr & /*expr*/) {
  // lookup e.varname
  // if const
  gotConst = false;
}

void ExprConstFolder::operate(NumericArrayExpr &e) {
  gotConst = false;
  e.indices->operate(this);
  gotConst = false;
}

void ExprConstFolder::operate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    fold(operand);
  }
  gotConst = false;
}

void ExprConstFolder::operate(NegatedExpr &e) {
  if (fold(e.expr)) {
    dvalue = -dvalue;
  }
}

void ExprConstFolder::operate(ComplementedExpr &e) {
  if (fold(e.expr)) {
    dvalue = static_cast<double>(~static_cast<int>(dvalue));
  }
}

void ExprConstFolder::operate(SgnExpr &e) {
  if (fold(e.expr)) {
    dvalue = dvalue < 0 ? -1.0 : dvalue > 0 ? 1.0 : 0.0;
  }
}

void ExprConstFolder::operate(IntExpr &e) {
  if (fold(e.expr)) {
    dvalue = static_cast<double>(static_cast<int>(dvalue));
  }
}

void ExprConstFolder::operate(AbsExpr &e) {
  if (fold(e.expr)) {
    dvalue = dvalue < 0 ? -dvalue : dvalue;
  }
}

void ExprConstFolder::operate(RndExpr &e) {
  fold(e.expr);
  gotConst = false;
}

void ExprConstFolder::operate(PeekExpr &e) {
  fold(e.expr);
  gotConst = false;
}

void ExprConstFolder::operate(PointExpr &e) {
  fold(e.x);
  fold(e.y);
  gotConst = false;
}

void ExprConstFolder::operate(InkeyExpr & /*expr*/) { gotConst = false; }

void ExprConstFolder::fold(std::vector<std::unique_ptr<NumericExpr>> &operands,
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

void ExprConstFolder::operate(AdditiveExpr &e) {
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
        e.operands[iOffset] = std::make_unique<NumericConstantExpr>(value);
      } else {
        e.operands.erase(e.operands.begin() + iOffset);
      }
    } else if (gotSub) {
      if (value != 0) {
        e.invoperands[iOffset] = std::make_unique<NumericConstantExpr>(value);
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

void ExprConstFolder::operate(MultiplicativeExpr &e) {
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
    e.append(true, std::make_unique<NumericConstantExpr>(value));
  }

  bool gotDiv = gotMul;
  fold(e.invoperands, gotDiv, gotFold, iOffset, value,
       [](double &value, double v) { value /= v; });

  if (gotFold) {
    if (gotMul) {
      e.operands[iOffset] = std::make_unique<NumericConstantExpr>(value);
    } else if (gotDiv) {
      e.invoperands[iOffset] = std::make_unique<NumericConstantExpr>(value);
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

void ExprConstFolder::operate(AndExpr &e) {
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
        std::make_unique<NumericConstantExpr>(static_cast<double>(value));
  }

  gotConst = e.operands.size() == 1 && e.operands[0]->isConst(dvalue);
}

void ExprConstFolder::operate(OrExpr &e) {
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
        std::make_unique<NumericConstantExpr>(static_cast<double>(value));
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

void ExprConstFolder::operate(RelationalExpr &e) {
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
