// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "accumulizer.hpp"

#include <string>

#include "isequal.hpp"

void Accumulizer::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Accumulizer::operate(Line &l) {
  StatementAccumulizer accumulizer;
  accumulizer.accumulize(l.statements);
}

std::unique_ptr<Statement> StatementAccumulizer::mutate(If &s) {
  accumulize(s.consequent);
  return std::unique_ptr<Statement>();
}

std::unique_ptr<Statement> StatementAccumulizer::mutate(Let &s) {
  IsEqual isEqual(s.lhs.get());

  auto *addExpr = dynamic_cast<AdditiveExpr *>(s.rhs.get());

  if (addExpr != nullptr) {
    for (auto itOp = addExpr->operands.begin(); itOp != addExpr->operands.end();
         ++itOp) {
      if ((*itOp)->inspect(&isEqual)) {
        addExpr->operands.erase(itOp);
        if (addExpr->operands.empty()) {
          std::swap(addExpr->operands, addExpr->invoperands);
          return std::make_unique<Dec>(std::move(s.lhs), std::move(s.rhs));
        } else {
          return std::make_unique<Inc>(std::move(s.lhs), std::move(s.rhs));
        }
      }
    }
  }

  return std::unique_ptr<Statement>();
}

void StatementAccumulizer::accumulize(
    std::vector<std::unique_ptr<Statement>> &statements) {
  for (auto &statement : statements) {
    if (auto accumulant = statement->mutate(this)) {
      statement = std::move(accumulant);
    }
  }
}
