// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "gerriemanderer.hpp"

void Gerriemanderer::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

static void gerriemander(std::unique_ptr<Statement> &statement,
                         std::vector<std::unique_ptr<Statement>> &statements,
                         StatementGerriemanderer &gms) {
  if (statement.get() != std::prev(statements.end())->get()) {
    auto goif = std::make_unique<When>();
    goif->isSub = gms.isSub;
    goif->predicate = std::move(gms.predicate);
    goif->lineNumber = gms.lineNumber;
    statement = std::move(goif);
  } else {
    auto localIf = std::make_unique<If>();
    auto localGo = std::make_unique<Go>();
    localGo->isSub = gms.isSub;
    localGo->lineNumber = gms.lineNumber;
    localIf->predicate = std::move(gms.predicate);
    localIf->consequent.emplace_back(std::move(localGo));
    statement = std::move(localIf);
  }
}

void Gerriemanderer::operate(Line &l) {
  for (auto &statement : l.statements) {
    if (boperate(statement, gms)) {
      gerriemander(statement, l.statements, gms);
    }
  }
}

void StatementGerriemanderer::operate(If &s) {
  for (auto &statement : s.consequent) {
    if (boperate(statement, *this)) {
      gerriemander(statement, s.consequent, *this);
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

void ExprGerriemanderer::operate(NegatedExpr &e) { e.expr->operate(this); }

void ExprGerriemanderer::operate(AdditiveExpr &e) {
  double val;
  if (e.operands.size() == 1 && e.operands[0]->isConst(val) && val == 1 &&
      e.invoperands.size() == 1 && e.invoperands[0]->isBoolean()) {
    predicate = std::move(e.invoperands[0]);
  } else if (e.operands.size() == 1 && e.operands[0]->isBoolean() &&
             e.invoperands.size() == 1 && e.invoperands[0]->isConst(val) &&
             val == -1) {
    predicate = std::move(e.operands[0]);
  } else {
    fprintf(stderr, "Got caught gerriemandering\n");
    exit(1);
  }
}

void ExprGerriemanderer::operate(AndExpr &e) {
  std::unique_ptr<OrExpr> orExpr;

  for (auto &operand : e.operands) {
    operand->operate(this);
    if (!orExpr) {
      orExpr = std::make_unique<OrExpr>(std::move(predicate));
    } else {
      orExpr->append(std::move(predicate));
    }
  }
  predicate = std::move(orExpr);
}

void ExprGerriemanderer::operate(OrExpr &e) {
  std::unique_ptr<AndExpr> andExpr;

  for (auto &operand : e.operands) {
    operand->operate(this);
    if (!andExpr) {
      andExpr = std::make_unique<AndExpr>(std::move(predicate));
    } else {
      andExpr->append(std::move(predicate));
    }
  }
  predicate = std::move(andExpr);
}

void ExprGerriemanderer::operate(ComplementedExpr &e) {
  predicate = std::move(e.expr);
}

void ExprGerriemanderer::operate(RelationalExpr &e) {
  e.comparator = e.comparator == "<"                            ? ">="
                 : e.comparator == "<=" || e.comparator == "=<" ? ">"
                 : e.comparator == "="                          ? "<>"
                 : e.comparator == ">=" || e.comparator == "=>" ? "<"
                 : e.comparator == ">"                          ? "<="
                                                                : "=";
  predicate = std::make_unique<RelationalExpr>(e.comparator, e.lhs.release(),
                                               e.rhs.release());
}

void ExprGerriemanderer::operate(NumericConstantExpr &e) {
  predicate = std::make_unique<NumericConstantExpr>(1 - e.value);
}
