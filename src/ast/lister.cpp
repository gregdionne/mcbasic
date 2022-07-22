// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "lister.hpp"
#include "optimizer/constinspector.hpp"
#include "utils/strescape.hpp"

#include <stdarg.h>

template <typename T> static inline std::string list(T &t) {
  ExprLister that;
  t->soak(&that);
  return that.result;
}

template <typename T> static inline std::string plist(T &t) {

  if (nullptr == dynamic_cast<NaryNumericExpr *>(t.get()) &&
      nullptr == dynamic_cast<RelationalExpr *>(t.get()) &&
      nullptr == dynamic_cast<PowerExpr *>(t.get())) {
    return list(t);
  }

  auto addexpr = dynamic_cast<AdditiveExpr *>(t.get());
  if (addexpr && addexpr->operands.size() + addexpr->invoperands.size() == 1) {
    return list(t);
  }

  return '(' + list(t) + ')';
}

static std::string replace(std::string str, const std::string &pattern,
                           const std::string &replacement) {
  std::size_t pos = str.find(pattern);

  while (pos != std::string::npos) {
    str.replace(pos, pattern.size(), replacement);
    pos = str.find(str, pos + replacement.size());
  }

  return str;
}

static std::string removeTrailing(std::string str, const std::string &pattern) {
  std::size_t pos = str.rfind(pattern);
  if (pos == str.length() - pattern.length()) {
    return str.substr(0, pos);
  }
  return str;
}

void Lister::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Lister::operate(Line &l) {
  result += std::to_string(l.lineNumber);
  bool continuing = false;
  for (auto &statement : l.statements) {
    StatementLister that;
    statement->soak(&that);
    result += (continuing ? ':' : ' ') + that.result;
    continuing = true;
  }
  result += "\n";
}

void ExprLister::absorb(const NumericConstantExpr &e) {
  char buf[1024];
  sprintf(buf, "%g", e.value);
  result = buf;
}

void ExprLister::absorb(const StringConstantExpr &e) {
  result = '"' + strEscapeLIST(e.value) + '"';
}

void ExprLister::absorb(const NumericVariableExpr &e) { result = e.varname; }

void ExprLister::absorb(const StringVariableExpr &e) {
  result = e.varname + '$';
}

void ExprLister::absorb(const NaryNumericExpr &e) {
  bool continuing = false;

  if (!e.operands.empty()) {
    for (auto &operand : e.operands) {
      if (continuing) {
        result += e.funcName.length() > 1 ? " " : "";
        result += e.funcName;
        result += e.funcName.length() > 1 ? " " : "";
      }
      result += plist(operand);
      continuing = true;
    }
  } else if (e.funcName == "*") {
    result += "1";
  }

  if (!e.invoperands.empty()) {
    for (auto &invoperand : e.invoperands) {
      result += e.invName + plist(invoperand);
    }
  }
}

void ExprLister::absorb(const StringConcatenationExpr &e) {
  bool continuing = false;
  for (auto &operand : e.operands) {
    if (continuing) {
      result += '+';
    }

    result += plist(operand);
    continuing = true;
  }
}

void ExprLister::absorb(const ArrayIndicesExpr &e) {
  bool continuing = false;
  result = "(";
  for (auto &operand : e.operands) {
    if (continuing) {
      result += ',';
    }
    result += list(operand);
    continuing = true;
  }
  result += ")";
}

void ExprLister::absorb(const PrintTabExpr &e) {
  result = "TAB(" + list(e.tabstop) + ")";
}

void ExprLister::absorb(const PrintCommaExpr & /*expr*/) { result = ","; }

void ExprLister::absorb(const PrintSpaceExpr & /*expr*/) { result = " "; }

void ExprLister::absorb(const PrintCRExpr & /*expr*/) { result = ""; }

void ExprLister::absorb(const NumericArrayExpr &e) {
  result = list(e.varexp) + list(e.indices);
}

void ExprLister::absorb(const StringArrayExpr &e) {
  result = list(e.varexp) + list(e.indices);
}

void ExprLister::absorb(const PowerExpr &e) {
  result = plist(e.base) + e.funcName + plist(e.exponent);
}

void ExprLister::absorb(const IntegerDivisionExpr &e) {
  result = "IDIV(" + plist(e.dividend) + "," + plist(e.divisor) + ")";
}

void ExprLister::absorb(const ShiftExpr &e) {
  result = "SHIFT(" + list(e.expr) + ',' + list(e.count) + ')';
}

void ExprLister::absorb(const ComplementedExpr &e) {
  result = "NOT " + plist(e.expr);
}

void ExprLister::absorb(const SgnExpr &e) {
  result += "SGN(" + list(e.expr) + ')';
}

void ExprLister::absorb(const IntExpr &e) {
  result += "INT(" + list(e.expr) + ')';
}

void ExprLister::absorb(const AbsExpr &e) {
  result += "ABS(" + list(e.expr) + ')';
}

void ExprLister::absorb(const SqrExpr &e) {
  result += "SQR(" + list(e.expr) + ')';
}

void ExprLister::absorb(const ExpExpr &e) {
  result += "EXP(" + list(e.expr) + ')';
}

void ExprLister::absorb(const LogExpr &e) {
  result += "LOG(" + list(e.expr) + ')';
}

void ExprLister::absorb(const SinExpr &e) {
  result += "SIN(" + list(e.expr) + ')';
}

void ExprLister::absorb(const CosExpr &e) {
  result += "COS(" + list(e.expr) + ')';
}

void ExprLister::absorb(const TanExpr &e) {
  result += "TAN(" + list(e.expr) + ')';
}

void ExprLister::absorb(const RndExpr &e) {
  result += "RND(" + list(e.expr) + ')';
}

void ExprLister::absorb(const PeekExpr &e) {
  result += "PEEK(" + list(e.expr) + ')';
}

void ExprLister::absorb(const LenExpr &e) {
  result += "LEN(" + list(e.expr) + ')';
}

void ExprLister::absorb(const StrExpr &e) {
  result += "STR$(" + list(e.expr) + ')';
}

void ExprLister::absorb(const ValExpr &e) {
  result += "VAL(" + list(e.expr) + ')';
}

void ExprLister::absorb(const AscExpr &e) {
  result += "ASC(" + list(e.expr) + ')';
}

void ExprLister::absorb(const ChrExpr &e) {
  result += "CHR$(" + list(e.expr) + ')';
}

void ExprLister::absorb(const RelationalExpr &e) {
  result = plist(e.lhs) + e.comparator + plist(e.rhs);
}

void ExprLister::absorb(const LeftExpr &e) {
  result = "LEFT$(" + list(e.str) + ',' + list(e.len) + ")";
}

void ExprLister::absorb(const RightExpr &e) {
  result = "RIGHT$(" + list(e.str) + ',' + list(e.len) + ")";
}

void ExprLister::absorb(const MidExpr &e) {
  if (e.len) {
    result =
        "MID$(" + list(e.str) + ',' + list(e.start) + ',' + list(e.len) + ")";
  } else {
    result = "MID$(" + list(e.str) + ',' + list(e.start) + ")";
  }
}

void ExprLister::absorb(const PointExpr &e) {
  result = "POINT(" + list(e.x) + "," + list(e.y) + ')';
}

void ExprLister::absorb(const InkeyExpr & /*expr*/) { result = "INKEY$"; }

void ExprLister::absorb(const MemExpr & /*expr*/) { result = "MEM"; }

void ExprLister::absorb(const SquareExpr &e) {
  result = "SQ(" + list(e.expr) + ')';
}

void ExprLister::absorb(const TimerExpr & /*expr*/) { result = "TIMER"; }

void ExprLister::absorb(const PosExpr & /*expr*/) { result = "POS"; }

void ExprLister::absorb(const PeekWordExpr &e) {
  result = "PEEKW(" + list(e.expr) + ')';
}

void StatementLister::absorb(const Rem &s) {
  result = "REM " + removeTrailing(s.comment, "\n");
}

void StatementLister::absorb(const For &s) {
  result = "FOR " + list(s.iter) + "=" + list(s.from) + " TO " + list(s.to);
  if (s.step) {
    result += " STEP " + list(s.step);
  }
}

void StatementLister::absorb(const Go &s) {
  result = (s.isSub ? "GOSUB " : "GOTO ") + std::to_string(s.lineNumber);
}

void StatementLister::absorb(const When &s) {
  result = "WHEN " + list(s.predicate) + (s.isSub ? " GOSUB " : " GOTO ") +
           std::to_string(s.lineNumber);
}

void StatementLister::absorb(const If &s) {
  result += "IF " + list(s.predicate) + " THEN";

  if (generatePredicates) {
    bool continuing = false;
    for (auto &statement : s.consequent) {
      StatementLister that;
      statement->soak(&that);
      result += (continuing ? ":" : " ") + that.result;
      continuing = true;
    }
  }
}

void StatementLister::absorb(const Data &s) {
  result = "DATA";
  bool continuing = false;
  for (auto &record : s.records) {
    result += (continuing ? "," : " ") + list(record);
    continuing = true;
  }
}

void StatementLister::absorb(const Print &s) {
  result = "PRINT";
  if (s.at) {
    result += " @" + list(s.at) + ",";
  }

  bool continuing = false;
  for (auto &expr : s.printExpr) {
    result += (continuing ? "" : " ") +
              replace(list(expr), "\r", "\"CHR$(13)\"") + ";";
    continuing = true;
  }

  result = removeTrailing(result, "CHR$(13)\"\";");
  result = removeTrailing(result, " \"\"");
  result = removeTrailing(result, ";\"\"");
}

void StatementLister::absorb(const Input &s) {
  result = "INPUT";
  if (s.prompt) {
    result += " " + list(s.prompt) + ";";
  }

  bool continuing = false;
  for (auto &variable : s.variables) {
    result += (continuing ? "," : " ") + list(variable);
    continuing = true;
  }
}

void StatementLister::absorb(const End & /*statement*/) { result = "END"; }

void StatementLister::absorb(const On &s) {
  result = "ON " + list(s.branchIndex) + " GO" + (s.isSub ? "SUB" : "TO");

  bool continuing = false;
  for (auto &lineNumber : s.branchTable) {
    result += (continuing ? "," : " ") + std::to_string(lineNumber);
    continuing = true;
  }
}

void StatementLister::absorb(const Next &s) {
  result = "NEXT";
  bool continuing = false;
  for (auto &variable : s.variables) {
    result += (continuing ? "," : " ") + list(variable);
    continuing = true;
  }
}

void StatementLister::absorb(const Dim &s) {
  result = "DIM";
  bool continuing = false;
  for (auto &variable : s.variables) {
    result += (continuing ? "," : " ") + list(variable);
    continuing = true;
  }
}

void StatementLister::absorb(const Read &s) {
  result = "READ";
  bool continuing = false;
  for (auto &variable : s.variables) {
    result += (continuing ? "," : " ") + list(variable);
    continuing = true;
  }
}

void StatementLister::absorb(const Let &s) {
  result = list(s.lhs) + "=" + list(s.rhs);
}

void StatementLister::absorb(const Accum &s) {
  result = list(s.lhs) + "+=" + list(s.rhs);
}

void StatementLister::absorb(const Decum &s) {
  result = list(s.lhs) + "-=" + list(s.rhs);
}

void StatementLister::absorb(const Necum &s) {
  ConstInspector constInspector;
  result = list(s.lhs) + "=-" + list(s.lhs);
  auto rhs = dynamic_cast<NumericExpr *>(s.rhs.get());
  if (rhs && !constInspector.isEqual(rhs, 0)) {
    result += "+(" + list(s.rhs) + ")";
  }
}

void StatementLister::absorb(const Run &s) {
  result = "RUN";
  if (s.hasLineNumber) {
    result += " " + std::to_string(s.lineNumber);
  }
}

void StatementLister::absorb(const Restore & /*statement*/) {
  result = "RESTORE";
}

void StatementLister::absorb(const Return & /*statement*/) {
  result = "RETURN";
}

void StatementLister::absorb(const Stop & /*statement*/) { result = "STOP"; }

void StatementLister::absorb(const Poke &s) {
  result = "POKE " + list(s.dest) + "," + list(s.val);
}

void StatementLister::absorb(const Clear &s) {
  result = "CLEAR";
  if (s.size) {
    result += " " + list(s.size);
  }
}

void StatementLister::absorb(const Set &s) {
  result = "SET(" + list(s.x) + "," + list(s.y);

  if (s.c) {
    result += "," + list(s.c);
  }

  result += ")";
}

void StatementLister::absorb(const Reset &s) {
  result = "RESET(" + list(s.x) + "," + list(s.y) + ")";
}

void StatementLister::absorb(const Cls &s) {
  result = "CLS";
  if (s.color) {
    result += " " + list(s.color);
  }
}

void StatementLister::absorb(const Sound &s) {
  result = "SOUND " + list(s.pitch) + "," + list(s.duration);
}

void StatementLister::absorb(const Exec &s) {
  result = "EXEC";
  result += " " + list(s.address);
}

void StatementLister::absorb(const Error &s) {
  result = "ERROR " + list(s.errorCode);
}
