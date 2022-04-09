// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "viewer.hpp"

#include <stdarg.h>

template <typename T> static inline void indentOp(T &t, ExprViewer *g) {
  ++g->n;
  t->soak(static_cast<ExprAbsorber<void, void> *>(g));
  --g->n;
}

template <typename T> static inline void indentOp(T &t, StatementViewer *g) {
  ++g->n;
  t->soak(static_cast<StatementAbsorber<void> *>(g));
  --g->n;
}

static void printtab(int n, const char *formatstr, ...) {
  va_list vl;
  va_start(vl, formatstr);
  fprintf(stderr, "%s", std::string(n, ' ').c_str());
  vfprintf(stderr, formatstr, vl);
  fprintf(stderr, "\n");
}

void Viewer::operate(Program &p) {
  n = 0;
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Viewer::operate(Line &l) {
  fprintf(stderr, "%i\n", l.lineNumber);
  for (auto &statement : l.statements) {
    indentOp(statement, that);
  }
}

void ExprViewer::absorb(const NumericConstantExpr &e) {
  printtab(n, "%f", e.value);
}

void ExprViewer::absorb(const StringConstantExpr &e) {
  printtab(n, "\"%s\"", e.value.c_str());
}

void ExprViewer::absorb(const NumericVariableExpr &e) {
  printtab(n, "%s", e.varname.c_str());
}

void ExprViewer::absorb(const StringVariableExpr &e) {
  printtab(n, "%s$", e.varname.c_str());
}

void ExprViewer::absorb(const PowerExpr &e) {
  printtab(n, "^");
  indentOp(e.base, this);
  indentOp(e.exponent, this);
}

void ExprViewer::absorb(const IntegerDivisionExpr &e) {
  printtab(n, "IDIV");
  indentOp(e.dividend, this);
  indentOp(e.divisor, this);
}

void ExprViewer::absorb(const NaryNumericExpr &e) {
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

void ExprViewer::absorb(const StringConcatenationExpr &e) {
  printtab(n, "+ (string)");
  for (auto &operand : e.operands) {
    indentOp(operand, this);
  }
}

void ExprViewer::absorb(const ArrayIndicesExpr &e) {
  printtab(n, "(");
  for (auto &operand : e.operands) {
    indentOp(operand, this);
  }
  printtab(n, ")");
}

void ExprViewer::absorb(const PrintTabExpr &e) {
  printtab(n, "TAB(");
  indentOp(e.tabstop, this);
}

void ExprViewer::absorb(const PrintCommaExpr & /*expr*/) {
  printtab(n, "<comma>");
}

void ExprViewer::absorb(const PrintSpaceExpr & /*expr*/) {
  printtab(n, "<space>");
}

void ExprViewer::absorb(const PrintCRExpr & /*expr*/) { printtab(n, "<cr>"); }

void ExprViewer::absorb(const NumericArrayExpr &e) {
  printtab(n, "array");
  indentOp(e.varexp, this);
  indentOp(e.indices, this);
}

void ExprViewer::absorb(const StringArrayExpr &e) {
  printtab(n, "array");
  indentOp(e.varexp, this);
  indentOp(e.indices, this);
}

void ExprViewer::absorb(const ShiftExpr &e) {
  printtab(n, "SHIFT");
  indentOp(e.expr, this);
  indentOp(e.count, this);
}

void ExprViewer::absorb(const ComplementedExpr &e) {
  printtab(n, "NOT");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const SgnExpr &e) {
  printtab(n, "SGN");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const IntExpr &e) {
  printtab(n, "INT");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const AbsExpr &e) {
  printtab(n, "ABS");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const RndExpr &e) {
  printtab(n, "RND");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const SqrExpr &e) {
  printtab(n, "SQR");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const ExpExpr &e) {
  printtab(n, "EXP");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const LogExpr &e) {
  printtab(n, "LOG");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const SinExpr &e) {
  printtab(n, "SIN");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const CosExpr &e) {
  printtab(n, "COS");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const TanExpr &e) {
  printtab(n, "TAN");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const PeekExpr &e) {
  printtab(n, "PEEK");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const LenExpr &e) {
  printtab(n, "LEN");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const StrExpr &e) {
  printtab(n, "STR$");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const ValExpr &e) {
  printtab(n, "VAL");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const AscExpr &e) {
  printtab(n, "ASC");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const ChrExpr &e) {
  printtab(n, "CHR$");
  indentOp(e.expr, this);
}

void ExprViewer::absorb(const RelationalExpr &e) {
  printtab(n, e.comparator.c_str());
  indentOp(e.lhs, this);
  indentOp(e.rhs, this);
}

void ExprViewer::absorb(const LeftExpr &e) {
  printtab(n, "LEFT$");
  indentOp(e.str, this);
  indentOp(e.len, this);
}

void ExprViewer::absorb(const RightExpr &e) {
  printtab(n, "RIGHT$");
  indentOp(e.str, this);
  indentOp(e.len, this);
}

void ExprViewer::absorb(const MidExpr &e) {
  printtab(n, "MID$");
  indentOp(e.str, this);
  indentOp(e.start, this);
  if (e.len) {
    indentOp(e.len, this);
  }
}

void ExprViewer::absorb(const PointExpr &e) {
  printtab(n, "POINT");
  indentOp(e.x, this);
  indentOp(e.y, this);
}

void ExprViewer::absorb(const InkeyExpr & /*expr*/) { printtab(n, "INKEY$"); }

void ExprViewer::absorb(const MemExpr & /*expr*/) { printtab(n, "MEM"); }

void ExprViewer::absorb(const TimerExpr & /*expr*/) { printtab(n, "TIMER"); }

void ExprViewer::absorb(const PosExpr & /*expr*/) { printtab(n, "POS"); }

void ExprViewer::absorb(const PeekWordExpr &e) {
  printtab(n, "PEEKW");
  indentOp(e.expr, this);
}

void StatementViewer::absorb(const Rem &s) {
  printtab(n, "REM");
  printtab(n + 1, s.comment.c_str());
}

void StatementViewer::absorb(const For &s) {
  printtab(n, "FOR");
  indentOp(s.iter, that);
  indentOp(s.from, that);
  indentOp(s.to, that);
  if (s.step) {
    indentOp(s.step, that);
  }
}

void StatementViewer::absorb(const Go &s) {
  printtab(n, "GO%s %i", s.isSub ? "SUB" : "TO", s.lineNumber);
}

void StatementViewer::absorb(const When &s) {
  printtab(n, "GO%sIF %i", s.isSub ? "SUB" : "TO", s.lineNumber);
  indentOp(s.predicate, that);
}

void StatementViewer::absorb(const If &s) {
  printtab(n, "IF");
  indentOp(s.predicate, that);
  for (auto &statement : s.consequent) {
    indentOp(statement, this);
  }
}

void StatementViewer::absorb(const Data &s) {
  printtab(n, "DATA");
  for (auto &record : s.records) {
    indentOp(record, that);
  }
}

void StatementViewer::absorb(const Print &s) {
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

void StatementViewer::absorb(const Input &s) {
  printtab(n, "INPUT");
  if (s.prompt) {
    indentOp(s.prompt, that);
  }
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementViewer::absorb(const End & /*statement*/) { printtab(n, "END"); }

void StatementViewer::absorb(const On &s) {
  printtab(n, "ON..GO%s", s.isSub ? "SUB" : "TO");
  indentOp(s.branchIndex, that);
  for (auto &lineNumber : s.branchTable) {
    printtab(n + 1, "%i", lineNumber);
  }
}

void StatementViewer::absorb(const Next &s) {
  printtab(n, "NEXT");
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementViewer::absorb(const Dim &s) {
  printtab(n, "DIM");
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementViewer::absorb(const Read &s) {
  printtab(n, "READ");
  for (auto &variable : s.variables) {
    indentOp(variable, that);
  }
}

void StatementViewer::absorb(const Let &s) {
  printtab(n, "LET");
  indentOp(s.lhs, that);
  indentOp(s.rhs, that);
}

void StatementViewer::absorb(const Accum &s) {
  printtab(n, "ACCUM");
  indentOp(s.lhs, that);
  indentOp(s.rhs, that);
}

void StatementViewer::absorb(const Decum &s) {
  printtab(n, "DECUM");
  indentOp(s.lhs, that);
  indentOp(s.rhs, that);
}

void StatementViewer::absorb(const Necum &s) {
  printtab(n, "NECUM");
  indentOp(s.lhs, that);
  indentOp(s.rhs, that);
}

void StatementViewer::absorb(const Run &s) {
  printtab(n, "RUN");
  if (s.hasLineNumber)
    printtab(n + 1, "%i", s.lineNumber);
}

void StatementViewer::absorb(const Restore & /*statement*/) {
  printtab(n, "RESTORE");
}

void StatementViewer::absorb(const Return & /*statement*/) {
  printtab(n, "RETURN");
}

void StatementViewer::absorb(const Stop & /*statement*/) {
  printtab(n, "STOP");
}

void StatementViewer::absorb(const Poke &s) {
  printtab(n, "POKE");
  indentOp(s.dest, that);
  indentOp(s.val, that);
}

void StatementViewer::absorb(const Clear &s) {
  printtab(n, "CLEAR");
  if (s.size) {
    indentOp(s.size, that);
  }
}

void StatementViewer::absorb(const Set &s) {
  printtab(n, "SET");
  indentOp(s.x, that);
  indentOp(s.y, that);
  if (s.c) {
    indentOp(s.c, that);
  }
}

void StatementViewer::absorb(const Reset &s) {
  printtab(n, "RESET");
  indentOp(s.x, that);
  indentOp(s.y, that);
}

void StatementViewer::absorb(const Cls &s) {
  printtab(n, "CLS");
  if (s.color) {
    indentOp(s.color, that);
  }
}

void StatementViewer::absorb(const Sound &s) {
  printtab(n, "SOUND");
  indentOp(s.pitch, that);
  indentOp(s.duration, that);
}

void StatementViewer::absorb(const Exec &s) {
  printtab(n, "EXEC");
  indentOp(s.address, that);
}

void StatementViewer::absorb(const Error &s) {
  printtab(n, "ERROR");
  indentOp(s.errorCode, that);
}
