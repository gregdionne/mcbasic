// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_STATEMENT_HPP
#define AST_STATEMENT_HPP

#include <memory>
#include <string>
#include <vector>

#include "expression.hpp"

// Forward-declare for visitors
class Statement;
class Rem;
class For;
class Go;
class When;
class If;
class Data;
class Print;
class Input;
class End;
class On;
class Next;
class Dim;
class Read;
class Let;
class Inc;
class Dec;
class Run;
class Restore;
class Return;
class Stop;
class Poke;
class Clear;
class Set;
class Reset;
class Cls;
class Sound;
class Error;

// StatementMutater
//   change a statement in-place

template <typename T> class StatementMutator {
public:
  virtual T mutate(Rem & /*s*/) = 0;
  virtual T mutate(For & /*s*/) = 0;
  virtual T mutate(Go & /*s*/) = 0;
  virtual T mutate(When & /*s*/) = 0;
  virtual T mutate(If & /*s*/) = 0;
  virtual T mutate(Data & /*s*/) = 0;
  virtual T mutate(Print & /*s*/) = 0;
  virtual T mutate(Input & /*s*/) = 0;
  virtual T mutate(End & /*s*/) = 0;
  virtual T mutate(On & /*s*/) = 0;
  virtual T mutate(Next & /*s*/) = 0;
  virtual T mutate(Dim & /*s*/) = 0;
  virtual T mutate(Read & /*s*/) = 0;
  virtual T mutate(Let & /*s*/) = 0;
  virtual T mutate(Inc & /*s*/) = 0;
  virtual T mutate(Dec & /*s*/) = 0;
  virtual T mutate(Run & /*s*/) = 0;
  virtual T mutate(Restore & /*s*/) = 0;
  virtual T mutate(Return & /*s*/) = 0;
  virtual T mutate(Stop & /*s*/) = 0;
  virtual T mutate(Poke & /*s*/) = 0;
  virtual T mutate(Clear & /*s*/) = 0;
  virtual T mutate(Set & /*s*/) = 0;
  virtual T mutate(Reset & /*s*/) = 0;
  virtual T mutate(Cls & /*s*/) = 0;
  virtual T mutate(Sound & /*s*/) = 0;
  virtual T mutate(Error & /*s*/) = 0;
};

// StatementInspector
//   provide a result of examination

template <typename T> class StatementInspector {
public:
  virtual T inspect(const Rem & /*s*/) const = 0;
  virtual T inspect(const For & /*s*/) const = 0;
  virtual T inspect(const Go & /*s*/) const = 0;
  virtual T inspect(const When & /*s*/) const = 0;
  virtual T inspect(const If & /*s*/) const = 0;
  virtual T inspect(const Data & /*s*/) const = 0;
  virtual T inspect(const Print & /*s*/) const = 0;
  virtual T inspect(const Input & /*s*/) const = 0;
  virtual T inspect(const End & /*s*/) const = 0;
  virtual T inspect(const On & /*s*/) const = 0;
  virtual T inspect(const Next & /*s*/) const = 0;
  virtual T inspect(const Dim & /*s*/) const = 0;
  virtual T inspect(const Read & /*s*/) const = 0;
  virtual T inspect(const Let & /*s*/) const = 0;
  virtual T inspect(const Inc & /*s*/) const = 0;
  virtual T inspect(const Dec & /*s*/) const = 0;
  virtual T inspect(const Run & /*s*/) const = 0;
  virtual T inspect(const Restore & /*s*/) const = 0;
  virtual T inspect(const Return & /*s*/) const = 0;
  virtual T inspect(const Stop & /*s*/) const = 0;
  virtual T inspect(const Poke & /*s*/) const = 0;
  virtual T inspect(const Clear & /*s*/) const = 0;
  virtual T inspect(const Set & /*s*/) const = 0;
  virtual T inspect(const Reset & /*s*/) const = 0;
  virtual T inspect(const Cls & /*s*/) const = 0;
  virtual T inspect(const Sound & /*s*/) const = 0;
  virtual T inspect(const Error & /*s*/) const = 0;
};

// StatementAbsorber
//   changes state as a result of examination

template <typename T> class StatementAbsorber {
public:
  virtual T absorb(const Rem & /*s*/) = 0;
  virtual T absorb(const For & /*s*/) = 0;
  virtual T absorb(const Go & /*s*/) = 0;
  virtual T absorb(const When & /*s*/) = 0;
  virtual T absorb(const If & /*s*/) = 0;
  virtual T absorb(const Data & /*s*/) = 0;
  virtual T absorb(const Print & /*s*/) = 0;
  virtual T absorb(const Input & /*s*/) = 0;
  virtual T absorb(const End & /*s*/) = 0;
  virtual T absorb(const On & /*s*/) = 0;
  virtual T absorb(const Next & /*s*/) = 0;
  virtual T absorb(const Dim & /*s*/) = 0;
  virtual T absorb(const Read & /*s*/) = 0;
  virtual T absorb(const Let & /*s*/) = 0;
  virtual T absorb(const Inc & /*s*/) = 0;
  virtual T absorb(const Dec & /*s*/) = 0;
  virtual T absorb(const Run & /*s*/) = 0;
  virtual T absorb(const Restore & /*s*/) = 0;
  virtual T absorb(const Return & /*s*/) = 0;
  virtual T absorb(const Stop & /*s*/) = 0;
  virtual T absorb(const Poke & /*s*/) = 0;
  virtual T absorb(const Clear & /*s*/) = 0;
  virtual T absorb(const Set & /*s*/) = 0;
  virtual T absorb(const Reset & /*s*/) = 0;
  virtual T absorb(const Cls & /*s*/) = 0;
  virtual T absorb(const Sound & /*s*/) = 0;
  virtual T absorb(const Error & /*s*/) = 0;
};

// AST structure for statements
class Statement {
public:
  Statement() = default;
  Statement(const Statement &) = delete;
  Statement(Statement &&) = default;
  Statement &operator=(const Statement &) = delete;
  Statement &operator=(Statement &&) = default;
  virtual ~Statement() = default;

  virtual std::unique_ptr<Statement>
  mutate(StatementMutator<std::unique_ptr<Statement>> * /*transmutator*/) = 0;
  virtual void mutate(StatementMutator<void> * /*op*/) = 0;
  virtual bool check(const StatementInspector<bool> * /*checker*/) const = 0;
  virtual void
  inspect(const StatementInspector<void> * /*inspector*/) const = 0;
  virtual void soak(StatementAbsorber<void> * /*absorber*/) const = 0;
  virtual std::string statementName() const { return ""; }
};

template <typename T> class OperableStatement : public Statement {
public:
  std::unique_ptr<Statement>
  mutate(StatementMutator<std::unique_ptr<Statement>> *mutator) override {
    return mutator->mutate(*static_cast<T *>(this));
  }
  void mutate(StatementMutator<void> *mutator) override {
    return mutator->mutate(*static_cast<T *>(this));
  }
  bool check(const StatementInspector<bool> *checker) const override {
    return checker->inspect(*static_cast<const T *>(this));
  }
  void inspect(const StatementInspector<void> *inspector) const override {
    return inspector->inspect(*static_cast<const T *>(this));
  }
  void soak(StatementAbsorber<void> *absorber) const override {
    return absorber->absorb(*static_cast<const T *>(this));
  }
};

class For : public OperableStatement<For> {
public:
  std::unique_ptr<NumericVariableExpr> iter;
  std::unique_ptr<NumericExpr> from;
  std::unique_ptr<NumericExpr> to;
  std::unique_ptr<NumericExpr> step;
  std::string statementName() const override { return "FOR"; }
};

class Go : public OperableStatement<Go> {
public:
  int lineNumber;
  bool isSub;
  std::string statementName() const override {
    return isSub ? "GOSUB" : "GOTO";
  }
};

class Rem : public OperableStatement<Rem> {
public:
  std::string comment;
  std::string statementName() const override { return "REM"; }
};

class When : public OperableStatement<When> {
public:
  bool isSub;
  std::unique_ptr<NumericExpr> predicate;
  int lineNumber;
  std::string statementName() const override {
    return isSub ? "WHEN..GOSUB" : "WHEN..GOTO";
  }
};

class If : public OperableStatement<If> {
public:
  std::unique_ptr<NumericExpr> predicate;
  std::vector<std::unique_ptr<Statement>> consequent;
  std::string statementName() const override { return "IF"; }
};

class Data : public OperableStatement<Data> {
public:
  std::vector<std::unique_ptr<StringConstantExpr>> records;
  std::string statementName() const override { return "DATA"; }
};

class Print : public OperableStatement<Print> {
public:
  std::unique_ptr<NumericExpr> at;
  std::vector<std::unique_ptr<StringExpr>> printExpr;
  std::string statementName() const override { return "PRINT"; }
};

class Input : public OperableStatement<Input> {
public:
  std::unique_ptr<StringConstantExpr> prompt;
  std::vector<std::unique_ptr<Expr>> variables;
  std::string statementName() const override { return "INPUT"; }
};

class End : public OperableStatement<End> {
public:
  std::string statementName() const override { return "END"; }
};

class On : public OperableStatement<On> {
public:
  std::unique_ptr<NumericExpr> branchIndex;
  std::vector<int> branchTable;
  bool isSub;
  std::string statementName() const override {
    return isSub ? "ON..GOSUB" : "ON..GOTO";
  }
};

class Next : public OperableStatement<Next> {
public:
  std::vector<std::unique_ptr<NumericVariableExpr>> variables;
  std::string statementName() const override { return "NEXT"; }
};

class Dim : public OperableStatement<Dim> {
public:
  std::vector<std::unique_ptr<Expr>> variables;
  std::string statementName() const override { return "DIM"; }
};

class Read : public OperableStatement<Read> {
public:
  std::vector<std::unique_ptr<Expr>> variables;
  std::string statementName() const override { return "READ"; }
};

class Let : public OperableStatement<Let> {
public:
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  Let(std::unique_ptr<Expr> l, std::unique_ptr<Expr> r)
      : lhs(std::move(l)), rhs(std::move(r)) {}
  std::string statementName() const override { return "LET"; }
};

class Run : public OperableStatement<Run> {
public:
  int lineNumber;
  bool hasLineNumber;
  std::string statementName() const override { return "RUN"; }
};

class Inc : public OperableStatement<Inc> {
public:
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  Inc(std::unique_ptr<Expr> l, std::unique_ptr<Expr> r)
      : lhs(std::move(l)), rhs(std::move(r)) {}
  std::string statementName() const override { return "LET"; }
};

class Dec : public OperableStatement<Dec> {
public:
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  Dec(std::unique_ptr<Expr> l, std::unique_ptr<Expr> r)
      : lhs(std::move(l)), rhs(std::move(r)) {}
  std::string statementName() const override { return "LET"; }
};

class Restore : public OperableStatement<Restore> {
public:
  std::string statementName() const override { return "RESTORE"; }
};

class Return : public OperableStatement<Return> {
public:
  std::string statementName() const override { return "RETURN"; }
};

class Stop : public OperableStatement<Stop> {
public:
  std::string statementName() const override { return "STOP"; }
};

class Poke : public OperableStatement<Poke> {
public:
  std::unique_ptr<NumericExpr> dest;
  std::unique_ptr<NumericExpr> val;
  std::string statementName() const override { return "POKE"; }
};

class Clear : public OperableStatement<Clear> {
public:
  std::unique_ptr<NumericExpr> size;
  std::string statementName() const override { return "CLEAR"; }
};

class Set : public OperableStatement<Set> {
public:
  std::unique_ptr<NumericExpr> x;
  std::unique_ptr<NumericExpr> y;
  std::unique_ptr<NumericExpr> c;
  std::string statementName() const override { return "SET"; }
};

class Reset : public OperableStatement<Reset> {
public:
  std::unique_ptr<NumericExpr> x;
  std::unique_ptr<NumericExpr> y;
  std::string statementName() const override { return "RESET"; }
};

class Cls : public OperableStatement<Cls> {
public:
  std::unique_ptr<NumericExpr> color;
  std::string statementName() const override { return "CLS"; }
};

class Sound : public OperableStatement<Sound> {
public:
  std::unique_ptr<NumericExpr> pitch;
  std::unique_ptr<NumericExpr> duration;
  std::string statementName() const override { return "SOUND"; }
};

class Error : public OperableStatement<Error> {
public:
  std::unique_ptr<NumericExpr> errorCode;
  std::string statementName() const override { return "ERROR"; }
};
#endif
