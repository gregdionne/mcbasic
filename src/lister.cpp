// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "lister.hpp"

#include <stdarg.h>

template <typename T> static inline std::string list(T &t) {
  ExprLister that;
  t->operate(&that);
  return that.result;
}

template <typename T> static inline std::string plist(T &t) {
  if (nullptr == dynamic_cast<NaryNumericExpr *>(t.get()) &&
      nullptr == dynamic_cast<RelationalExpr *>(t.get())) {
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
    statement->operate(&that);
    result += (continuing ? ':' : ' ') + that.result;
    continuing = true;
  }
  result += "\n";
}

void ExprLister::operate(NumericConstantExpr &e) {
  char buf[1024];
  sprintf(buf, "%g", e.value);
  result = buf;
}

void ExprLister::operate(StringConstantExpr &e) {
  result = '"' + e.value + '"';
}

void ExprLister::operate(NumericVariableExpr &e) { result = e.varname; }

void ExprLister::operate(StringVariableExpr &e) { result = e.varname + '$'; }

void ExprLister::operate(NaryNumericExpr &e) {
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

void ExprLister::operate(StringConcatenationExpr &e) {
  bool continuing = false;
  for (auto &operand : e.operands) {
    if (continuing) {
      result += '+';
    }

    result += plist(operand);
    continuing = true;
  }
}

void ExprLister::operate(ArrayIndicesExpr &e) {
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

void ExprLister::operate(PrintTabExpr &e) {
  result = "TAB(" + list(e.tabstop) + ")";
}

void ExprLister::operate(PrintCommaExpr & /*expr*/) { result = ","; }

void ExprLister::operate(PrintSpaceExpr & /*expr*/) { result = " "; }

void ExprLister::operate(PrintCRExpr & /*expr*/) { result = ""; }

void ExprLister::operate(NumericArrayExpr &e) {
  result = list(e.varexp) + list(e.indices);
}

void ExprLister::operate(StringArrayExpr &e) {
  result = list(e.varexp) + list(e.indices);
}

void ExprLister::operate(NegatedExpr &e) { result = "-" + plist(e.expr); }

void ExprLister::operate(ComplementedExpr &e) {
  result = e.funcName + " " + plist(e.expr);
}

void ExprLister::operate(SgnExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(IntExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(AbsExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(RndExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(PeekExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(LenExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(StrExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(ValExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(AscExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(ChrExpr &e) {
  result += e.funcName + '(' + list(e.expr) + ')';
}

void ExprLister::operate(RelationalExpr &e) {
  result = plist(e.lhs) + e.comparator + plist(e.rhs);
}

void ExprLister::operate(LeftExpr &e) {
  result = "LEFT$(" + list(e.str) + ',' + list(e.len) + ")";
}

void ExprLister::operate(RightExpr &e) {
  result = "RIGHT$(" + list(e.str) + ',' + list(e.len) + ")";
}

void ExprLister::operate(MidExpr &e) {
  if (e.len) {
    result =
        "MID$(" + list(e.str) + ',' + list(e.start) + ',' + list(e.len) + ")";
  } else {
    result = "MID$(" + list(e.str) + ',' + list(e.start) + ")";
  }
}

void ExprLister::operate(PointExpr &e) {
  result = "POINT(" + list(e.x) + "," + list(e.y) + ')';
}

void ExprLister::operate(InkeyExpr & /*expr*/) { result = "INKEY$"; }

void StatementLister::operate(Rem &s) {
  result = "REM " + removeTrailing(s.comment, "\n");
}

void StatementLister::operate(For &s) {
  result = "FOR " + list(s.iter) + "=" + list(s.from) + " TO " + list(s.to);
  if (s.step) {
    result += " STEP " + list(s.step);
  }
}

void StatementLister::operate(Go &s) {
  result = (s.isSub ? "GOSUB " : "GOTO ") + std::to_string(s.lineNumber);
}

void StatementLister::operate(When &s) {
  result = "WHEN " + list(s.predicate) + (s.isSub ? " GOSUB " : " GOTO ") +
           std::to_string(s.lineNumber);
}

void StatementLister::operate(If &s) {
  result += "IF " + list(s.predicate) + " THEN";

  if (generatePredicates) {
    bool continuing = false;
    for (auto &statement : s.consequent) {
      StatementLister that;
      statement->operate(&that);
      result += (continuing ? ":" : " ") + that.result;
      continuing = true;
    }
  }
}

void StatementLister::operate(Data &s) {
  result = "DATA";
  bool continuing = false;
  for (auto &record : s.records) {
    result += (continuing ? "," : " ") + list(record);
    continuing = true;
  }
}

void StatementLister::operate(Print &s) {
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

void StatementLister::operate(Input &s) {
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

void StatementLister::operate(End & /*statement*/) { result = "END"; }

void StatementLister::operate(On &s) {
  result = "ON " + list(s.branchIndex) + " GO" + (s.isSub ? "SUB" : "TO");

  bool continuing = false;
  for (auto &lineNumber : s.branchTable) {
    result += (continuing ? "," : " ") + std::to_string(lineNumber);
    continuing = true;
  }
}

void StatementLister::operate(Next &s) {
  result = "NEXT";
  bool continuing = false;
  for (auto &variable : s.variables) {
    result += (continuing ? "," : " ") + list(variable);
    continuing = true;
  }
}

void StatementLister::operate(Dim &s) {
  result = "DIM";
  bool continuing = false;
  for (auto &variable : s.variables) {
    result += (continuing ? "," : " ") + list(variable);
    continuing = true;
  }
}

void StatementLister::operate(Read &s) {
  result = "READ";
  bool continuing = false;
  for (auto &variable : s.variables) {
    result += (continuing ? "," : " ") + list(variable);
    continuing = true;
  }
}

void StatementLister::operate(Let &s) {
  result += list(s.lhs) + "=" + list(s.rhs);
}

void StatementLister::operate(Inc &s) {
  result += list(s.lhs) + "+=" + list(s.rhs);
}

void StatementLister::operate(Dec &s) {
  result += list(s.lhs) + "-=" + list(s.rhs);
}

void StatementLister::operate(Run &s) {
  result = "RUN";
  if (s.hasLineNumber) {
    result += " " + std::to_string(s.lineNumber);
  }
}

void StatementLister::operate(Restore & /*statement*/) { result = "RESTORE"; }

void StatementLister::operate(Return & /*statement*/) { result = "RETURN"; }

void StatementLister::operate(Stop & /*statement*/) { result = "STOP"; }

void StatementLister::operate(Poke &s) {
  result = "POKE " + list(s.dest) + "," + list(s.val);
}

void StatementLister::operate(Clear &s) {
  result = "CLEAR";
  if (s.size) {
    result += " " + list(s.size);
  }
}

void StatementLister::operate(Set &s) {
  result = "SET(" + list(s.x) + "," + list(s.y);

  if (s.c) {
    result += "," + list(s.c);
  }

  result += ")";
}

void StatementLister::operate(Reset &s) {
  result = "RESET(" + list(s.x) + "," + list(s.y) + ")";
}

void StatementLister::operate(Cls &s) {
  result = "CLS";
  if (s.color) {
    result += " " + list(s.color);
  }
}

void StatementLister::operate(Sound &s) {
  result = "SOUND " + list(s.pitch) + "," + list(s.duration);
}
