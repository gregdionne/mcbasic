// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "accumulizer.hpp"

#include <string>

#include "isequal.hpp"

void Accumulizer::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }

  result = false;
}

void Accumulizer::operate(Line &l) {
  StatementAccumulizer that(accumulant);
  for (auto &statement : l.statements) {
    if (boperate(statement, &that)) {
      statement = std::move(accumulant);
    }
  }

  result = false;
}

void StatementAccumulizer::operate(If &s) {
  for (auto &itStatement : s.consequent) {
    if (boperate(itStatement, this)) {
      itStatement = std::move(accumulant);
    }
  }

  result = false;
}

void StatementAccumulizer::operate(Let &s) {
  IsEqual isEqual(s.lhs.get());

  auto *addExpr = dynamic_cast<AdditiveExpr *>(s.rhs.get());

  if (addExpr != nullptr) {
    for (auto itOp = addExpr->operands.begin(); itOp != addExpr->operands.end();
         ++itOp) {
      if (boperate(*itOp, isEqual)) {
        addExpr->operands.erase(itOp);
        if (addExpr->operands.empty()) {
          std::swap(addExpr->operands, addExpr->invoperands);
          accumulant = std::make_unique<Dec>(s.lhs.release(), s.rhs.release());
        } else {
          accumulant = std::make_unique<Inc>(s.lhs.release(), s.rhs.release());
        }
        result = true;
        return;
      }
    }
  }

  result = false;
}
