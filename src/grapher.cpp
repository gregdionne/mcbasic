// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "grapher.hpp"

#include <stdarg.h>

template <typename T> static inline void indentOp(T &t, ExprGrapher *g) {
  ++g->n;
  t->operate(static_cast<ExprOp *>(g));
  --g->n;
}

template <typename T> static inline void indentOp(T &t, StatementGrapher *g) {
  ++g->n;
  t->operate(static_cast<StatementOp *>(g));
  --g->n;
}

static void printtab(int n, const char *formatstr, ...) {
  va_list vl;
  va_start(vl, formatstr);
  fprintf(stderr, "%s", std::string(n, ' ').c_str());
  vfprintf(stderr, formatstr, vl);
  fprintf(stderr, "\n");
}

void Grapher::operate(Program &p) {
  n = 0;
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Grapher::operate(Line &l) {
  fprintf(stderr, "%i\n", l.lineNumber);
  for (auto &statement : l.statements) {
    indentOp(statement, that);
  }
}

void ExprGrapher::operate(NumericConstantExpr &e) {
  printtab(n, "%f", e.value);
}

void ExprGrapher::operate(StringConstantExpr &e) {
  printtab(n, "\"%s\"", e.value.c_str());
}

void ExprGrapher::operate(NumericVariableExpr &e) {
  printtab(n, "%s", e.varname.c_str());
}

void ExprGrapher::operate(StringVariableExpr &e) {
  printtab(n, "%s$", e.varname.c_str());
}

void ExprGrapher::operate(PowerExpr &e) {
  printtab(n, "^");
  indentOp(e.base, this);
  indentOp(e.exponent, this);
}

void ExprGrapher::operate(IntegerDivisionExpr &e) {
  printtab(n, "IDIV");
  indentOp(e.dividend, this);
  indentOp(e.divisor, this);
}

void ExprGrapher::operate(NaryNumericExpr &e) {
  printtab(n, (e.funcName + "op").c_str());
  ++n;
  if (!e.operands.empty()) {
    printtab(n, e.funcName.c_str());
    for (auto &operand : e.operands) {
      indentOp(operand, this);
    }
  }

  if (!e.invoperands.empty()) {
    printtab(n, e.invName.c_str());
    for (auto &invoperand : e.invoperands) {
      indentOp(invoperand, this);
    }
  }
  --n;
}

void ExprGrapher::operate(StringConcatenationExpr &e) {
  printtab(n, "+ (string)");
  for (auto &operand : e.operands) {
    indentOp(operand, this);
  }
}

void ExprGrapher::operate(ArrayIndicesExpr &e) {
  printtab(n, "(");
  for (auto &operand : e.operands) {
    indentOp(operand, this);
  }
  printtab(n, ")");
}

void ExprGrapher::operate(PrintTabExpr &e) {
  printtab(n, "TAB(");
  indentOp(e.tabstop, this);
}

void ExprGrapher::operate(PrintCommaExpr & /*expr*/) { printtab(n, "<comma>"); }

void ExprGrapher::operate(PrintSpaceExpr & /*expr*/) { printtab(n, "<space>"); }

void ExprGrapher::operate(PrintCRExpr & /*expr*/) { printtab(n, "<cr>"); }

void ExprGrapher::operate(NumericArrayExpr &e) {
  printtab(n, "array");
  indentOp(e.varexp, this);
  indentOp(e.indices, this);
}

void ExprGrapher::operate(StringArrayExpr &e) {
  printtab(n, "array");
  indentOp(e.varexp, this);
  indentOp(e.indices, this);
}

void ExprGrapher::operate(ShiftExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
  indentOp(e.count, this);
}

void ExprGrapher::operate(NegatedExpr &e) {
  printtab(n, (e.funcName + "(neg)").c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(ComplementedExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(SgnExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(IntExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(AbsExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(RndExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(PeekExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(LenExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(StrExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(ValExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(AscExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(ChrExpr &e) {
  printtab(n, e.funcName.c_str());
  indentOp(e.expr, this);
}

void ExprGrapher::operate(RelationalExpr &e) {
  printtab(n, e.comparator.c_str());
  indentOp(e.lhs, this);
  indentOp(e.rhs, this);
}

void ExprGrapher::operate(LeftExpr &e) {
  printtab(n, "LEFT$");
  indentOp(e.str, this);
  indentOp(e.len, this);
}

void ExprGrapher::operate(RightExpr &e) {
  printtab(n, "RIGHT$");
  indentOp(e.str, this);
  indentOp(e.len, this);
}

void ExprGrapher::operate(MidExpr &e) {
  printtab(n, "MID$");
  indentOp(e.str, this);
  indentOp(e.start, this);
  if (e.len) {
    indentOp(e.len, this);
  }
}

void ExprGrapher::operate(PointExpr &e) {
  printtab(n, "POINT");
  indentOp(e.x, this);
  indentOp(e.y, this);
}

void ExprGrapher::operate(InkeyExpr & /*expr*/) { printtab(n, "INKEY$"); }

void ExprGrapher::operate(MemExpr & /*expr*/) { printtab(n, "MEM"); }

void StatementGrapher::operate(Rem &s) {
  printtab(n, "REM");
  printtab(n + 1, s.comment.c_str());
}

void StatementGrapher::operate(For &s) {
  printtab(n, "FOR");
  indentOp(s.iter, that);
  indentOp(s.from, that);
  indentOp(s.to, that);
  if (s.step) {
    indentOp(s.step, that);
  }
}

void StatementGrapher::operate(Go &s) {
  printtab(n, "GO%s %i", s.isSub ? "SUB" : "TO", s.lineNumber);
}

void StatementGrapher::operate(When &s) {
  printtab(n, "GO%sIF %i", s.isSub ? "SUB" : "TO", s.lineNumber);
  indentOp(s.predicate, that);
}

void StatementGrapher::operate(If &s) {
  printtab(n, "IF");
  indentOp(s.predicate, that);
  for (auto &statement : s.consequent) {
    indentOp(statement, this);
  }
}

void StatementGrapher::operate(Data &s) {
  printtab(n, "DATA");
  for (auto &record : s.records) {
    indentOp(record, that);
  }
}

void StatementGrapher::operate(Print &s) {
  printtab(n, "PRINT");
  if (s.at) {
    ++n;
    printtab(n, "@");
    indentOp(s.at, that);
    --n;
  }
  for (auto &expr : s.printExpr) {
    indentOp(expr, that);
  }
}

void StatementGrapher::operate(Input &s) {
  printtab(n, "INPUT");
  if (s.prompt) {
    indentOp(s.prompt, that);
  }
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementGrapher::operate(End & /*statement*/) { printtab(n, "END"); }

void StatementGrapher::operate(On &s) {
  printtab(n, "ON..GO%s", s.isSub ? "SUB" : "TO");
  indentOp(s.branchIndex, that);
  for (auto &lineNumber : s.branchTable) {
    printtab(n + 1, "%i", lineNumber);
  }
}

void StatementGrapher::operate(Next &s) {
  printtab(n, "NEXT");
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementGrapher::operate(Dim &s) {
  printtab(n, "DIM");
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementGrapher::operate(Read &s) {
  printtab(n, "READ");
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementGrapher::operate(Let &s) {
  printtab(n, "LET");
  indentOp(s.lhs, that);
  indentOp(s.rhs, that);
}

void StatementGrapher::operate(Inc &s) {
  printtab(n, "INC");
  indentOp(s.lhs, that);
  indentOp(s.rhs, that);
}

void StatementGrapher::operate(Dec &s) {
  printtab(n, "DEC");
  indentOp(s.lhs, that);
  indentOp(s.rhs, that);
}

void StatementGrapher::operate(Run &s) {
  printtab(n, "RUN");
  if (s.hasLineNumber)
    printtab(n + 1, "%i", s.lineNumber);
}

void StatementGrapher::operate(Restore & /*statement*/) {
  printtab(n, "RESTORE");
}

void StatementGrapher::operate(Return & /*statement*/) {
  printtab(n, "RETURN");
}

void StatementGrapher::operate(Stop & /*statement*/) { printtab(n, "STOP"); }

void StatementGrapher::operate(Poke &s) {
  printtab(n, "POKE");
  indentOp(s.dest, that);
  indentOp(s.val, that);
}

void StatementGrapher::operate(Clear &s) {
  printtab(n, "CLEAR");
  if (s.size) {
    indentOp(s.size, that);
  }
}

void StatementGrapher::operate(Set &s) {
  printtab(n, "SET");
  indentOp(s.x, that);
  indentOp(s.y, that);
  if (s.c) {
    indentOp(s.c, that);
  }
}

void StatementGrapher::operate(Reset &s) {
  printtab(n, "RESET");
  indentOp(s.x, that);
  indentOp(s.y, that);
}

void StatementGrapher::operate(Cls &s) {
  printtab(n, "CLS");
  if (s.color) {
    indentOp(s.color, that);
  }
}

void StatementGrapher::operate(Sound &s) {
  printtab(n, "SOUND");
  indentOp(s.pitch, that);
  indentOp(s.duration, that);
}

void StatementGrapher::operate(Error &s) {
  printtab(n, "ERROR");
  indentOp(s.errorCode, that);
}
