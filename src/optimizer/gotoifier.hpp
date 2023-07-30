// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_GOTOIFIER_HPP
#define OPTIMIZER_GOTOIFIER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// turns a GOSUB into a GOTO
class StatementEngotoifier : public NullStatementMutator {
public:
  void mutate(Go &s) override { s.isSub = false; }
  void mutate(On &s) override { s.isSub = false; }

private:
  using NullStatementMutator::mutate;
};

// replaces a GOSUB statement immediately followed by
// a RETURN statement with an equivalent GOTO
// within a line
class StatementGotoifier : public NullStatementMutator {
public:
  StatementGotoifier(int linenum, const Announcer &a)
      : lineNumber(linenum), announcer(a) {}
  void mutate(If &s) override;

  void gotoify(std::vector<up<Statement>> &statements);

private:
  using NullStatementMutator::mutate;

  void engoto(const std::vector<up<Statement>>::iterator &it, const char *fmt);
  const int lineNumber;
  const Announcer &announcer;
};

// replaces GOSUB statements immediately followed by
// a RETURN statement with an equivalent GOTO
// over the entire program
class Gotoifier : public ProgramOp {
public:
  explicit Gotoifier(const BinaryOption &option) : announcer(option) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
};

#endif
