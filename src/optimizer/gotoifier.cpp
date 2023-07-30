// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "gotoifier.hpp"
#include "ast/lister.hpp"
#include "isgosub.hpp"
#include "isongosub.hpp"
#include "isreturn.hpp"

static std::string list(const Statement *s) {
  StatementLister sl;
  s->soak(&sl);
  return sl.result;
}

void Gotoifier::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Gotoifier::operate(Line &l) {
  StatementGotoifier sg(l.lineNumber, announcer);
  sg.gotoify(l.statements);
}

void StatementGotoifier::mutate(If &s) { gotoify(s.consequent); }

void StatementGotoifier::engoto(const std::vector<up<Statement>>::iterator &it,
                                const char *fmt) {
  auto before = list(it->get());
  StatementEngotoifier se;
  (*it)->mutate(&se);
  auto after = list(it->get());
  announcer.start(lineNumber);
  announcer.finish(fmt, before.c_str(), after.c_str());
}

void StatementGotoifier::gotoify(std::vector<up<Statement>> &statements) {
  IsGosubStatement isGosub;
  IsOnGosubStatement isOnGosub;
  IsReturnStatement isReturn;

  auto it = statements.begin();
  while (it != statements.end()) {
    // descend into any IF statement
    (*it)->mutate(this);

    auto inxt = std::next(it);
    if (inxt != statements.end() && (*inxt)->check(&isReturn)) {
      if ((*it)->check(&isGosub)) {

        // replace GOSUB with GOTO
        engoto(it, "replaced \"%s:RETURN\" with \"%s\"");

        // delete (since RETURN can no longer be reached)
        statements.erase(inxt);

      } else if ((*it)->check(&isOnGosub)) {
        // replace ON..GOSUB with ON..GOTO
        // keep RETURN in case branch index out of range
        engoto(it, "replaced \"%s:RETURN\" with \"%s:RETURN\"");
      }
    }
    ++it;
  }
}
