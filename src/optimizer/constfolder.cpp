// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "constfolder.hpp"
#include "constinspector.hpp"
#include "consttable/fixedpoint.hpp"

#include <algorithm>
#include <cmath>
#include <string>

#include "ast/lister.hpp"

utils::optional<double> ExprConstFolder::fold(up<NumericExpr> &expr) {
  ExprLister el;
  expr->soak(&el);

  if (auto num = expr->constify(&constInspector)) {
    return num;
  }

  if (auto num = expr->constify(this)) {
    auto oldResult = el.result;
    expr = makeup<NumericConstantExpr>(*num);
    expr->soak(&el);
    if (oldResult.length() && oldResult != el.result) {
      announcer.start(lineNumber);
      announcer.finish("replaced %s with %s", oldResult.c_str(),
                       el.result.c_str());
    }
    return num;
  }

  return {};
}

utils::optional<std::string> ExprConstFolder::fold(up<StringExpr> &expr) {
  ExprLister el;
  expr->soak(&el);

  if (auto str = expr->constify(&constInspector)) {
    return str;
  }

  if (auto str = expr->constify(this)) {
    auto oldResult = el.result;
    expr = makeup<StringConstantExpr>(*str);
    expr->soak(&el);
    if (oldResult.length() && oldResult != " " && oldResult != el.result) {
      announcer.start(lineNumber);
      announcer.finish("replaced %s with %s", oldResult.c_str(),
                       el.result.c_str());
    }
    return str;
  }

  return {};
}

void ExprConstFolder::fold(up<Expr> &expr) {
  if (auto *nexpr = expr->numExpr()) {
    static_cast<void>(expr.release());
    auto tmpExpr = up<NumericExpr>(nexpr);
    fold(tmpExpr);
    expr = mv(tmpExpr);
  } else if (auto *sexpr = expr->strExpr()) {
    static_cast<void>(expr.release());
    auto tmpExpr = up<StringExpr>(sexpr);
    fold(tmpExpr);
    expr = mv(tmpExpr);
  } else {
    fprintf(stderr, "internal error: const folder\n");
    fprintf(stderr, "expression neither numeric nor string\n");
    exit(1);
  }
}

void ConstFolder::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void ConstFolder::operate(Line &l) {
  cfs.setLineNumber(l.lineNumber);
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

  auto it1 = s.printExpr.begin();
  if (it1 != s.printExpr.end()) {
    auto it2 = std::next(it1);
    while (it2 != s.printExpr.end()) {
      auto str1 = cfe.fold(*it1);
      auto str2 = cfe.fold(*it2);
      if (str1 && str2) {
        *it1 = makeup<StringConstantExpr>(*str1 + *str2);
        it2 = s.printExpr.erase(it2);
      } else {
        ++it1;
        ++it2;
      }
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

void StatementConstFolder::mutate(Eval &s) {
  for (auto &operand : s.operands) {
    cfe.fold(operand);
  }
}

void StatementConstFolder::mutate(Poke &s) {
  cfe.fold(s.dest);
  cfe.fold(s.val);
}

void StatementConstFolder::mutate(Clear & /* s */) {
  // if (s.size)
  //   cfe.fold(s.size);
}

void StatementConstFolder::mutate(CLoadM &s) {
  if (s.filename) {
    cfe.fold(s.filename);
  }
  if (s.offset) {
    cfe.fold(s.offset);
  }
}

void StatementConstFolder::mutate(CLoadStar &s) {
  if (s.filename) {
    cfe.fold(s.filename);
  }
}

void StatementConstFolder::mutate(CSaveStar &s) {
  if (s.filename) {
    cfe.fold(s.filename);
  }
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

// string expressions...
utils::optional<std::string> ExprConstFolder::mutate(StringConstantExpr &e) {
  return utils::optional<std::string>(e.value);
}

utils::optional<std::string>
ExprConstFolder::mutate(StringVariableExpr & /*expr*/) {
  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(StringArrayExpr &e) {
  e.indices->constify(this);
  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(PrintTabExpr &e) {
  fold(e.tabstop);
  return {};
}

utils::optional<std::string>
ExprConstFolder::mutate(PrintSpaceExpr & /*expr*/) {
  return utils::optional<std::string>(" ");
}

utils::optional<std::string>
ExprConstFolder::mutate(PrintCommaExpr & /*expr*/) {
  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(PrintCRExpr & /*expr*/) {
  return utils::optional<std::string>("\r");
}

utils::optional<std::string>
ExprConstFolder::mutate(StringConcatenationExpr &e) {

  for (auto &operand : e.operands) {
    fold(operand);
  }

  auto it1 = e.operands.begin();
  if (it1 != e.operands.end()) {
    auto it2 = std::next(it1);
    while (it2 != e.operands.end()) {
      auto str1 = (*it1)->constify(&constInspector);
      auto str2 = (*it2)->constify(&constInspector);
      if (str1 && str2) {
        *it1 = makeup<StringConstantExpr>(*str1 + *str2);
        it2 = e.operands.erase(it2);
      } else {
        ++it1;
        ++it2;
      }
    }
  }

  if (e.operands.size() == 1) {
    return e.operands[0]->constify(&constInspector);
  }

  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(LeftExpr &e) {
  auto str = fold(e.str);
  auto len = fold(e.len);

  if (str && len) {
    if (*len < 0) {
      fprintf(stderr,
              "line %i: negative length specified in LEFT$(\"%s\",%.0f)\n",
              lineNumber, str->c_str(), *len);
      exit(1);
    }

    auto slen = static_cast<std::size_t>(*len);
    if (str->length() <= slen) {
      return str;
    }

    auto svalue = str->substr(0, slen);
    return utils::optional<std::string>(svalue);
  }

  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(RightExpr &e) {
  auto str = fold(e.str);
  auto len = fold(e.len);

  if (str && len) {
    if (*len < 0) {
      fprintf(stderr,
              "line %i: negative length specified in RIGHT$(\"%s\",%.0f)\n",
              lineNumber, str->c_str(), *len);
      exit(1);
    }

    auto slen = static_cast<std::size_t>(*len);
    if (str->length() <= slen) {
      return str;
    }

    auto svalue = str->substr(str->length() - slen);
    return utils::optional<std::string>(svalue);
  }

  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(MidExpr &e) {
  auto str = fold(e.str);
  auto start = fold(e.start);

  if (str && start) {
    if (!e.len) {
      try {
        auto svalue = str->substr(static_cast<std::size_t>(*start));
        return utils::optional<std::string>(svalue);
      } catch (...) {
        fprintf(stderr, "couldn't get MID$(\"%s\",%f.0)\n", str->c_str(),
                *start);
        exit(1);
      }
    } else if (auto len = fold(e.len)) {
      try {
        auto svalue = str->substr(static_cast<std::size_t>(*start),
                                  static_cast<std::size_t>(*len));
        return utils::optional<std::string>(svalue);
      } catch (...) {
        fprintf(stderr, "couldn't get MID$(\"%s\",%f.0,%f.0)\n", str->c_str(),
                *start, *len);
        exit(1);
      }
    }
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(LenExpr &e) {
  if (auto svalue = fold(e.expr)) {
    return utils::optional<double>(static_cast<double>(svalue->length()));
  }
  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(StrExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    auto svalue = std::to_string(*dvalue);
    std::size_t dot = svalue.find_first_of('.');
    std::size_t last = svalue.find_last_not_of(".0");
    if (dot != std::string::npos) {
      svalue = svalue.substr(0, std::max(dot, last + 1));
      svalue = *dvalue < 0 && ((FixedPoint(*dvalue).wholenum != 0) ||
                               (FixedPoint(*dvalue).fraction != 0))
                   ? svalue
                   : " " + svalue;
    }
    return utils::optional<std::string>(svalue);
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(ShiftExpr &e) {
  if (auto tmpval = fold(e.expr)) {
    if (auto value = fold(e.count)) {
      auto dvalue = *value;
      if (dvalue != std::round(dvalue)) {
        fprintf(stderr, "SHIFT count evaluated to non-integral value\n");
        exit(1);
      }
      dvalue = dvalue > 0   ? *tmpval * (1 << static_cast<int>(dvalue))
               : dvalue < 0 ? *tmpval / (1 << static_cast<int>(-dvalue))
                            : *tmpval;
      return utils::optional<double>(dvalue);
    }
  }
  return {};
}

// TODO: replicate how BASIC encodes values
utils::optional<double> ExprConstFolder::mutate(ValExpr &e) {
  fold(e.expr);
  return {};
}

utils::optional<double> ExprConstFolder::mutate(AscExpr &e) {
  if (auto svalue = fold(e.expr)) {
    return utils::optional<double>(
        svalue->length() > 0 ? static_cast<unsigned char>(*svalue->c_str())
                             : 0);
  }
  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(ChrExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    std::string svalue(1, static_cast<char>(*dvalue));
    return utils::optional<std::string>(svalue);
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(NumericConstantExpr &e) {
  return utils::optional<double>(e.value);
}

utils::optional<double>
ExprConstFolder::mutate(NumericVariableExpr & /*expr*/) {
  // lookup e.varname
  // if const
  return {};
}

utils::optional<double> ExprConstFolder::mutate(NumericArrayExpr &e) {
  e.indices->constify(this);
  return {};
}

utils::optional<double> ExprConstFolder::mutate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    fold(operand);
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(ComplementedExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(
        static_cast<double>(~static_cast<int>(*dvalue)));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(SgnExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(*dvalue < 0   ? -1.0
                                   : *dvalue > 0 ? 1.0
                                                 : 0.0);
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(IntExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(
        static_cast<double>(static_cast<int>(*dvalue)));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(AbsExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(*dvalue < 0 ? -*dvalue : *dvalue);
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(SqrExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(std::sqrt(*dvalue));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(ExpExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(std::exp(*dvalue));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(LogExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(std::log(*dvalue));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(SinExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(std::sin(*dvalue));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(CosExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(std::cos(*dvalue));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(TanExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(std::tan(*dvalue));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(RndExpr &e) {
  fold(e.expr);
  return {};
}

utils::optional<double> ExprConstFolder::mutate(PeekExpr &e) {
  fold(e.expr);
  return {};
}

utils::optional<double> ExprConstFolder::mutate(PointExpr &e) {
  fold(e.x);
  fold(e.y);
  return {};
}

utils::optional<std::string> ExprConstFolder::mutate(InkeyExpr & /*expr*/) {
  return {};
}

utils::optional<double> ExprConstFolder::mutate(MemExpr & /*expr*/) {
  return {};
}

utils::optional<double> ExprConstFolder::mutate(PosExpr & /*expr*/) {
  return {};
}

utils::optional<double> ExprConstFolder::mutate(TimerExpr & /*expr*/) {
  return {};
}

utils::optional<double> ExprConstFolder::mutate(PeekWordExpr & /*expr*/) {
  return {};
}

utils::optional<double> ExprConstFolder::mutate(NaryNumericExpr &e) {

  double lhs = e.identity;
  bool haveLHS = false;
  auto iOp = e.operands.begin();
  while (iOp != e.operands.end()) {
    if (auto operand = fold(*iOp)) {
      haveLHS = true;
      lhs = e.function(lhs, *operand);
      iOp = e.operands.erase(iOp);
    } else {
      ++iOp;
    }
  }

  double rhs = e.identity;
  bool haveRHS = false;
  iOp = e.invoperands.begin();
  while (iOp != e.invoperands.end()) {
    if (auto operand = fold(*iOp)) {
      haveRHS = true;
      rhs = e.function(rhs, *operand);
      iOp = e.invoperands.erase(iOp);
    } else {
      ++iOp;
    }
  }

  double value = e.inverse(lhs, rhs);

  if (value == e.annihilator || (e.operands.empty() && e.invoperands.empty())) {
    return utils::optional<double>(value);
  }

  if (value != e.identity) {
    if (haveLHS) {
      e.operands.emplace_back(makeup<NumericConstantExpr>(value));
    } else if (haveRHS) {
      e.invoperands.emplace_back(makeup<NumericConstantExpr>(rhs));
    } else {
      fprintf(stderr, "internal error: constant folder of n-ary expressions\n");
      fprintf(stderr,
              "inverse(identity, identity) does not preserve identity\n");
      fprintf(stderr, "op = %s identity = %f value = %f, lhs = %f, rhs = %f\n",
              e.funcName.c_str(), e.identity, value, lhs, rhs);
      exit(1);
    }
  }

  return {};
}

utils::optional<double> ExprConstFolder::mutate(AdditiveExpr &e) {
  return e.NaryNumericExpr::constify(this);
}

utils::optional<double> ExprConstFolder::mutate(MultiplicativeExpr &e) {
  return e.NaryNumericExpr::constify(this);
}

utils::optional<double> ExprConstFolder::mutate(AndExpr &e) {
  return e.NaryNumericExpr::constify(this);
}

utils::optional<double> ExprConstFolder::mutate(OrExpr &e) {
  return e.NaryNumericExpr::constify(this);
}

utils::optional<double> ExprConstFolder::mutate(PowerExpr &e) {
  auto base = fold(e.base);
  auto exponent = fold(e.exponent);

  if (base && exponent) {
    return utils::optional<double>(std::pow(*base, *exponent));
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(IntegerDivisionExpr &e) {
  auto dividend = fold(e.dividend);
  auto divisor = fold(e.divisor);

  if (dividend && divisor) {
    return utils::optional<double>(std::floor(*dividend / *divisor));
  }
  return {};
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

utils::optional<double> ExprConstFolder::mutate(RelationalExpr &e) {
  fold(e.lhs);
  fold(e.rhs);

  auto *nlhs = e.lhs->numExpr();
  auto *nrhs = e.rhs->numExpr();
  auto *slhs = e.lhs->strExpr();
  auto *srhs = e.rhs->strExpr();

  if (nlhs && nrhs) {
    auto lhs = nlhs->constify(&constInspector);
    auto rhs = nrhs->constify(&constInspector);
    if (lhs && rhs) {
      return utils::optional<double>(compare(e.comparator, *lhs, *rhs));
    }
  } else if (slhs && srhs) {
    auto lhs = slhs->constify(&constInspector);
    auto rhs = srhs->constify(&constInspector);
    if (lhs && rhs) {
      return utils::optional<double>(compare(e.comparator, *lhs, *rhs));
    }
  } else {
    fprintf(stderr, "mismatch in comparison oparator\n");
    exit(1);
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(SquareExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(*dvalue * *dvalue);
  }
  return {};
}

utils::optional<double> ExprConstFolder::mutate(FractExpr &e) {
  if (auto dvalue = fold(e.expr)) {
    return utils::optional<double>(*dvalue - std::floor(*dvalue));
  }
  return {};
}
