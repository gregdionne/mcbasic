// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_GERRIEMANDERER_HPP
#define OPTIMIZER_GERRIEMANDERER_HPP

#include "ast/nullexprtransmutator.hpp"
#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// searches for "gerrieatric expressions" of the following forms:
//   Form 1:  ON  -boolean    GOTO/GOSUB label : statements
//   Form 2:  ON 1 - boolean  GOTO/GOSUB label : statements
// replaces with:
//   Form 1: WHEN     boolean GOTO/GOSUB label : statements
//   Form 2: WHEN NOT boolean GOTO/GOSUB label : statements
//
// TODO: implement the other gerrieatric forms:
// TODO:   Form 3:  ON boolean+2 GOSUB label1,label2
// TODO:   Form 4:  ON 1-boolean GOSUB label1,label2
// TODO: replacing with:
// TODO:   Form 3:  IF boolean THEN GOSUB label1 ELSE GOSUB label2 ENDIF
// TODO:   Form 4:  IF boolean THEN GOSUB label2 ELSE GOSUB label1 ENDIF

class ExprGerriemanderer : public NullExprTransmutator {
public:
  up<NumericExpr> mutate(AdditiveExpr &e) override;

private:
  using NullExprTransmutator::mutate;
};

class StatementGerriemanderer : public NullStatementTransmutator {
public:
  StatementGerriemanderer(const Announcer &a, int linenum)
      : announcer(a), lineNumber(linenum) {}
  up<Statement> mutate(If &s) override;
  up<Statement> mutate(On &s) override;

  void gerriemander(std::vector<up<Statement>> &s);

private:
  using NullStatementTransmutator::mutate;
  const Announcer &announcer;
  const int lineNumber;
};

class Gerriemanderer : public ProgramOp {
public:
  explicit Gerriemanderer(const Option &option) : announcer(option) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
};

#endif
