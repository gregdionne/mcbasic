// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ONMERGER_HPP
#define OPTIMIZER_ONMERGER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// removes ON..GOTO and ON..GOSUB statements with constant argument

class OnStatementFolder : public NullStatementTransmutator {
public:
  OnStatementFolder(int linenum, const Announcer &a)
      : lineNumber(linenum), announcer(a) {}
  OnStatementFolder(const OnStatementFolder &) = delete;
  OnStatementFolder(OnStatementFolder &&) = delete;
  OnStatementFolder &operator=(const OnStatementFolder &) = delete;
  OnStatementFolder &operator=(OnStatementFolder &&) = delete;

  ~OnStatementFolder() override = default;

  up<Statement> mutate(If &s) override;
  up<Statement> mutate(On &s) override;

  using NullStatementTransmutator::mutate;

  void fold(std::vector<up<Statement>> &statements);

private:
  const int lineNumber;
  const Announcer &announcer;
};

class OnFolder : public ProgramOp {
public:
  explicit OnFolder(const BinaryOption &option) : announcer(option) {}
  OnFolder(const OnFolder &) = delete;
  OnFolder(OnFolder &&) = delete;
  OnFolder &operator=(const OnFolder &) = delete;
  OnFolder &operator=(OnFolder &&) = delete;
  ~OnFolder() override = default;

  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
};

#endif
