// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "gerriemanderer.hpp"
#include "complementer.hpp"
#include "constinspector.hpp"
#include "isboolean.hpp"
#include "isgerrieatric.hpp"

void Gerriemanderer::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Gerriemanderer::operate(Line &l) {
  StatementGerriemanderer gms(announcer, l.lineNumber);
  gms.gerriemander(l.statements);
}

up<Statement> StatementGerriemanderer::mutate(If &s) {
  gerriemander(s.consequent);
  return {};
}

up<Statement> StatementGerriemanderer::mutate(On &s) {
  ExprIsGerrieatric isGerrieatric;
  if (s.branchTable.size() == 1 && s.branchIndex->check(&isGerrieatric)) {
    announcer.start(lineNumber);
    announcer.finish("%s gerriemandered", s.statementName().c_str());
    ExprGerriemanderer gme;
    auto when = makeup<When>();
    when->isSub = s.isSub;
    when->predicate = s.branchIndex->transmutate(&gme);
    when->lineNumber = s.branchTable[0];
    return when;
  }
  return {};
}

up<NumericExpr> ExprGerriemanderer::mutate(AdditiveExpr &e) {
  IsBoolean isBoolean;
  ConstInspector constInspector;

  if (e.invoperands.size() == 1 && e.invoperands[0]->check(&isBoolean)) {
    auto sz = e.operands.size();
    if (sz == 0 || constInspector.isEqual(e.operands[0].get(), 0)) {
      return mv(e.invoperands[0]);
    }
    if (sz == 1 && constInspector.isEqual(e.operands[0].get(), 1)) {
      Complementer comp;
      return e.invoperands[0]->transmutate(&comp);
    } else {
      fprintf(stderr, "Got caught gerriemandering\n");
      exit(1);
    }
  }
  return {};
}

void StatementGerriemanderer::gerriemander(
    std::vector<up<Statement>> &statements) {
  for (auto &statement : statements) {
    if (auto when = statement->transmutate(this)) {
      statement = mv(when);
    }
  }
}
