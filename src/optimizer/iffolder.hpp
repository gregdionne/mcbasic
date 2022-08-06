// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_IFFOLDER_HPP
#define OPTIMIZER_IFFOLDER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// removes IF..THEN statements with constant argument

class IfStatementFolder : public NullStatementMutator {
public:
  IfStatementFolder(int linenum, const Announcer &w)
      : lineNumber(linenum), announcer(w) {}
  void mutate(If &s) override;

  using NullStatementMutator::mutate;

  void fold(std::vector<up<Statement>> &statements);

private:
  const int lineNumber;
  const Announcer &announcer;
  bool needsReplacement = false;
  std::vector<up<Statement>> replacement;
};

class IfFolder : public ProgramOp {
public:
  explicit IfFolder(Announcer &&w) : announcer(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
  std::vector<up<Line>>::iterator itCurrentLine;
};

#endif
