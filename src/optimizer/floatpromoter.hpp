// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_FLOATPROMOTER_HPP
#define OPTIMIZER_FLOATPROMOTER_HPP

#include "ast/lister.hpp"
#include "ast/nullexprmutator.hpp"
#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "isfloat.hpp"
#include "utils/announcer.hpp"

// Promotes numeric symbol, <s>, to floating point
// upon assignment for the following cases:
//
// * LET <s> = <expr>
//   when <expr> evaluates to a floating point value
//
// * READ <s>
//   when any data entry in dataTable has a floating point value
//
// * RND(<expr>)
//   when <expr> is not a positive constant.
//
// * FOR <s> = <start> TO <stop> STEP <step>
//   when either <start> or <step> has a floating point value.
//
// * INPUT <s>
//   always promotes
//
// The algorithm loops through the program AST and promotes the symbol
// when any of the above conditions are met.  The algorithm stops when no
// more promotions can be made.

class ExprFloatPromoter : public NullExprMutator {
public:
  ExprFloatPromoter(bool &gf, SymbolTable &st, const BinaryOption &wf)
      : gotFloat(gf), symbolTable(st), announcer(wf) {}
  bool makeFloat(std::vector<Symbol> &table, std::string &symbolName);
  void mutate(NumericVariableExpr &e) override;
  void mutate(NumericArrayExpr &e) override;

  void setLineNumber(int line) { lineNumber = line; }
  void listStatement(const Statement *s);

private:
  bool &gotFloat;
  SymbolTable &symbolTable;
  const Announcer announcer;
  int lineNumber{0};
  StatementLister ls;
};

class StatementFloatPromoter : public NullStatementMutator {
public:
  StatementFloatPromoter(bool &gf, DataTable &dt, SymbolTable &st, IsFloat &isf,
                         const BinaryOption &wf)
      : dataTable(dt), isFloat(isf), fe(gf, st, wf) {}
  void mutate(If &s) override;
  void mutate(Let &s) override;
  void mutate(Accum &s) override;
  void mutate(Decum &s) override;
  void mutate(Necum &s) override;
  void mutate(For &s) override;
  void mutate(Read &s) override;
  void mutate(Input &s) override;

  void setLineNumber(int line) { lineNumber = line; }

private:
  DataTable &dataTable;
  IsFloat &isFloat;
  ExprFloatPromoter fe;
  int lineNumber{0};
};

class FloatPromoter : public ProgramOp {
public:
  FloatPromoter(DataTable &dt, SymbolTable &st, const BinaryOption &wf)
      : symbolTable(st), isFloat(st), fs(gotFloat, dt, st, isFloat, wf) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  bool gotFloat{false};
  SymbolTable &symbolTable;
  IsFloat isFloat;
  StatementFloatPromoter fs;
};

#endif
