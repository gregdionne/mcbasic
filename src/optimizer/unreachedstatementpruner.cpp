// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "unreachedstatementpruner.hpp"
#include "ast/lister.hpp"
#include "isexecutable.hpp"
#include "isterminal.hpp"

void UnreachedStatementPruner::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void UnreachedStatementPruner::operate(Line &l) {
  StatementUnreachedPruner src(announcer, l.lineNumber);
  src.prune(l.statements);
}

void StatementUnreachedPruner::mutate(If &s) { prune(s.consequent); }

void StatementUnreachedPruner::prune(std::vector<up<Statement>> &statements) {

  IsExecutableStatement isExecutable;
  IsTerminalStatement isTerminal;

  std::string terminator;

  auto it = statements.begin();
  while (it != statements.end()) {
    if ((*it)->check(&isExecutable) && !terminator.empty()) {
      announcer.start(lineNumber);
      announcer.say("removed unreached %s statement after %s\n",
                    (*it)->statementName().c_str(), terminator.c_str());

      // if this is an IF statement
      if (auto *pIf = dynamic_cast<If *>(it->get())) {
        // hoist the consequent
        // in case it contains a DATA statement
        std::vector<up<Statement>> replacement;
        replacement.insert(replacement.begin(),
                           std::make_move_iterator(pIf->consequent.begin()),
                           std::make_move_iterator(pIf->consequent.end()));

        it = statements.insert(statements.erase(it),
                               std::make_move_iterator(replacement.begin()),
                               std::make_move_iterator(replacement.end()));
      } else {
        // otherwise just delete the statement
        it = statements.erase(it);
      }
    } else if ((*it)->check(&isTerminal)) {
      StatementLister sl;
      (*it)->soak(&sl);
      terminator = sl.result;
      ++it;
    } else {
      ++it;
    }
  }
}
