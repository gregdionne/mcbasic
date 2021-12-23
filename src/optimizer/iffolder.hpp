// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_IFFOLDER_HPP
#define OPTIMIZER_IFFOLDER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "utils/warner.hpp"

// removes IF..THEN statements with constant argument

class IfStatementFolder : public NullStatementMutator {
public:
  IfStatementFolder(int linenum, Warner &w) : lineNumber(linenum), warner(w) {}
  void mutate(If &s) override;

  using NullStatementMutator::mutate;

  void fold(std::vector<std::unique_ptr<Statement>> &statements);

  const int lineNumber;
  Warner &warner;
  bool needsReplacement = false;
  std::vector<std::unique_ptr<Statement>> replacement;
};

class IfFolder : public ProgramOp {
public:
  explicit IfFolder(Warner w) : warner(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  Warner warner;
  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
