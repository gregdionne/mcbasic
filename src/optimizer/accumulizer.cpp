// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "accumulizer.hpp"

#include <string>

#include "ast/lister.hpp"
#include "isequal.hpp"

void Accumulizer::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Accumulizer::operate(Line &l) {
  StatementAccumulizer accumulizer(announcer, l.lineNumber);
  accumulizer.accumulize(l.statements);
}

up<Statement> StatementAccumulizer::mutate(If &s) {
  accumulize(s.consequent);
  return up<Statement>();
}

up<Statement> StatementAccumulizer::mutate(Let &s) {
  IsEqual isEqual(s.lhs.get());

  auto *addExpr = dynamic_cast<AdditiveExpr *>(s.rhs.get());

  if (addExpr != nullptr) {
    for (auto itOp = addExpr->operands.begin(); itOp != addExpr->operands.end();
         ++itOp) {
      if ((*itOp)->check(&isEqual)) {
        addExpr->operands.erase(itOp);
        ExprLister el;
        s.lhs->soak(&el);
        announcer.start(lineNumber);
        announcer.say("%s assignment replaced with ", el.result.c_str());
        if (addExpr->operands.empty()) {
          std::swap(addExpr->operands, addExpr->invoperands);
          announcer.finish("-=");
          return makeup<Decum>(mv(s.lhs), mv(s.rhs));
        } else {
          announcer.finish("+=");
          return makeup<Accum>(mv(s.lhs), mv(s.rhs));
        }
      }
    }

    for (auto itOp = addExpr->invoperands.begin();
         itOp != addExpr->invoperands.end(); ++itOp) {
      if ((*itOp)->check(&isEqual)) {
        addExpr->invoperands.erase(itOp);
        ExprLister el;
        s.lhs->soak(&el);
        announcer.start(lineNumber);
        announcer.say("%s assignment replaced with ", el.result.c_str());
        announcer.finish("Negate-accumulate");
        return makeup<Necum>(mv(s.lhs), mv(s.rhs));
      }
    }
  }

  return up<Statement>();
}

void StatementAccumulizer::accumulize(std::vector<up<Statement>> &statements) {
  for (auto &statement : statements) {
    if (auto accumulant = statement->transmutate(this)) {
      statement = mv(accumulant);
    }
  }
}
