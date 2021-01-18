// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef GERRIEMANDERER_HPP
#define GERRIEMANDERER_HPP

#include "isgerrieatric.hpp"
#include "program.hpp"

// searches for "gerrieatric expressions" of the following forms:
//   Form 1:  ON  -boolean    GOTO/GOSUB label
//   Form 2:  ON 1 - boolean  GOTO/GOSUB label : statements
// replaces with:
//   Form 1: IF     boolean GOTO/GOSUB label ELSE <statements>
//   Form 2: IF NOT boolean GOTO/GOSUB label ELSE <statements>
//
// TODO: implement the other gerrieatric forms:
// TODO:   Form 3:  ON boolean+2 GOSUB label1,label2
// TODO:   Form 4:  ON 1-boolean GOSUB label1,label2
// TODO: replacing with:
// TODO:   Form 3:  IF boolean THEN GOSUB label1 ELSE GOSUB label2 ENDIF
// TODO:   Form 4:  IF boolean THEN GOSUB label2 ELSE GOSUB label1 ENDIF

class ExprGerriemanderer : public ExprOp {
public:
  void operate(AdditiveExpr &e) override;
  void operate(NegatedExpr &e) override;

  std::unique_ptr<NumericExpr> predicate;
};

class StatementGerriemanderer : public StatementOp {
public:
  StatementGerriemanderer() = default;
  void operate(If &s) override;
  void operate(On &s) override;

  bool result;

  std::unique_ptr<NumericExpr> predicate;
  bool isSub;
  int lineNumber;

  ExprIsGerrieatric isGerrieatric;
  ExprGerriemanderer gme;
};

class Gerriemanderer : public ProgramOp {
public:
  Gerriemanderer() = default;
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  StatementGerriemanderer gms;
};

template <typename T>
inline bool boperate(T &thing, StatementGerriemanderer &gs) {
  gs.result = false;
  thing->operate(&gs);
  return gs.result;
}

#endif
