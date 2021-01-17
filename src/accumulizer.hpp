// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef ACCUMULIZER_HPP
#define ACCUMULIZER_HPP

#include "program.hpp"

// perform transformations:
//    Let X = X + expression -> X += expression
//    Let X = X - expression -> X -= expression
//
// where X may be a numeric variable or array reference.

class Accumulizer : public ProgramOp {
public:
  Accumulizer() = default;
  void operate(Program &p) override;
  void operate(Line &l) override;
  bool result{false};
  std::unique_ptr<Statement> accumulant;
};

class StatementAccumulizer : public StatementOp {
public:
  explicit StatementAccumulizer(std::unique_ptr<Statement> &acc)
      : accumulant(acc), result(false) {}
  void operate(If &s) override;
  void operate(Let &s) override;
  std::unique_ptr<Statement> &accumulant;
  bool result;

private:
  using StatementOp::operate;
};

template <typename T>
inline bool boperate(T &thing, StatementAccumulizer *accumulizer) {
  accumulizer->result = false;
  thing->operate(accumulizer);
  return accumulizer->result;
}

#endif
