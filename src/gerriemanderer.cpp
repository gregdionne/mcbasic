// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "gerriemanderer.hpp"
#include "complementer.hpp"

void Gerriemanderer::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

static void gerriemander(std::unique_ptr<Statement> &statement,
                         StatementGerriemanderer &gms) {

  auto when = std::make_unique<When>();

  when->isSub = gms.isSub;
  when->predicate = std::move(gms.predicate);
  when->lineNumber = gms.lineNumber;

  statement = std::move(when);
}

void Gerriemanderer::operate(Line &l) {
  for (auto &statement : l.statements) {
    if (boperate(statement, gms)) {
      gerriemander(statement, gms);
    }
  }
}

void StatementGerriemanderer::operate(If &s) {
  for (auto &statement : s.consequent) {
    if (boperate(statement, *this)) {
      gerriemander(statement, *this);
      result = false;
    }
  }
}

void StatementGerriemanderer::operate(On &s) {
  if (s.branchTable.size() == 1 && boperate(s.branchIndex, isGerrieatric)) {
    s.branchIndex->operate(&gme);
    predicate = std::move(gme.predicate);

    lineNumber = s.branchTable[0];
    isSub = s.isSub;
    result = true;
  }
}

void ExprGerriemanderer::operate(NegatedExpr &e) {
  if (e.expr->isBoolean()) {
    predicate = std::move(e.expr);
  } else {
    fprintf(stderr, "Got caught gerriemandering\n");
    exit(1);
  }
}

void ExprGerriemanderer::operate(AdditiveExpr &e) {
  double val;
  if (e.operands.size() == 1 && e.operands[0]->isConst(val) && val == 1 &&
      e.invoperands.size() == 1 && e.invoperands[0]->isBoolean()) {
    Complementer comp;
    e.invoperands[0]->operate(&comp);
    predicate = std::move(comp.complement);
  } else {
    fprintf(stderr, "Got caught gerriemandering\n");
    exit(1);
  }
}
