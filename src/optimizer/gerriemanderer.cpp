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
  StatementGerriemanderer gms;
  gms.gerriemander(l.statements);
}

std::unique_ptr<Statement> StatementGerriemanderer::mutate(If &s) {
  gerriemander(s.consequent);
  return std::unique_ptr<Statement>();
}

std::unique_ptr<Statement> StatementGerriemanderer::mutate(On &s) {
  ExprIsGerrieatric isGerrieatric;
  if (s.branchTable.size() == 1 && s.branchIndex->inspect(&isGerrieatric)) {
    ExprGerriemanderer gme;
    auto when = std::make_unique<When>();
    when->isSub = s.isSub;
    when->predicate = s.branchIndex->transmutate(&gme);
    when->lineNumber = s.branchTable[0];
    return when;
  }
  return std::unique_ptr<Statement>();
}

std::unique_ptr<NumericExpr> ExprGerriemanderer::mutate(NegatedExpr &e) {
  IsBoolean isBoolean;
  if (e.expr->inspect(&isBoolean)) {
    return std::move(e.expr);
  } else {
    fprintf(stderr, "Got caught gerriemandering\n");
    exit(1);
  }
  return std::unique_ptr<NumericExpr>();
}

std::unique_ptr<NumericExpr> ExprGerriemanderer::mutate(AdditiveExpr &e) {
  IsBoolean isBoolean;
  ConstInspector constInspector;
  if (e.operands.size() == 1 &&
      constInspector.isEqual(e.operands[0].get(), 1) &&
      e.invoperands.size() == 1 && e.invoperands[0]->inspect(&isBoolean)) {
    Complementer comp;
    return e.invoperands[0]->transmutate(&comp);
  } else {
    fprintf(stderr, "Got caught gerriemandering\n");
    exit(1);
  }
  return std::unique_ptr<NumericExpr>();
}

void StatementGerriemanderer::gerriemander(
    std::vector<std::unique_ptr<Statement>> &statements) {
  for (auto &statement : statements) {
    if (auto when = statement->mutate(this)) {
      statement = std::move(when);
    }
  }
}
