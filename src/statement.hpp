// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef STATEMENT_HPP
#define STATEMENT_HPP

#include <memory>
#include <string>
#include <vector>

#include "constants.hpp"
#include "expression.hpp"
#include "symboltable.hpp"

// for simplicity use a single non-const void visitor
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

class StatementOp {
public:
  virtual void operate(Rem & /*statement*/) {}
  virtual void operate(For & /*statement*/) {}
  virtual void operate(Go & /*statement*/) {}
  virtual void operate(When & /*statement*/) {}
  virtual void operate(If & /*statement*/) {}
  virtual void operate(Data & /*statement*/) {}
  virtual void operate(Print & /*statement*/) {}
  virtual void operate(Input & /*statement*/) {}
  virtual void operate(End & /*statement*/) {}
  virtual void operate(On & /*statement*/) {}
  virtual void operate(Next & /*statement*/) {}
  virtual void operate(Dim & /*statement*/) {}
  virtual void operate(Read & /*statement*/) {}
  virtual void operate(Let & /*statement*/) {}
  virtual void operate(Inc & /*statement*/) {}
  virtual void operate(Dec & /*statement*/) {}
  virtual void operate(Run & /*statement*/) {}
  virtual void operate(Restore & /*statement*/) {}
  virtual void operate(Return & /*statement*/) {}
  virtual void operate(Stop & /*statement*/) {}
  virtual void operate(Poke & /*statement*/) {}
  virtual void operate(Clear & /*statement*/) {}
  virtual void operate(Set & /*statement*/) {}
  virtual void operate(Reset & /*statement*/) {}
  virtual void operate(Cls & /*statement*/) {}
  virtual void operate(Sound & /*statement*/) {}
  virtual void operate(Error & /*statement*/) {}
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

  virtual void operate(StatementOp * /*op*/) {}
  virtual std::string statementName() { return ""; }
};

class For : public Statement {
public:
  std::unique_ptr<NumericVariableExpr> iter;
  std::unique_ptr<NumericExpr> from;
  std::unique_ptr<NumericExpr> to;
  std::unique_ptr<NumericExpr> step;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "FOR"; }
};

class Go : public Statement {
public:
  int lineNumber;
  bool isSub;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return isSub ? "GOSUB" : "GOTO"; }
};

class Rem : public Statement {
public:
  std::string comment;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "REM"; }
};

class When : public Statement {
public:
  bool isSub;
  std::unique_ptr<NumericExpr> predicate;
  int lineNumber;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override {
    return isSub ? "WHEN..GOSUB" : "WHEN..GOTO";
  }
};

class If : public Statement {
public:
  std::unique_ptr<NumericExpr> predicate;
  std::vector<std::unique_ptr<Statement>> consequent;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "IF"; }
};

class Data : public Statement {
public:
  std::vector<std::unique_ptr<StringConstantExpr>> records;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "DATA"; }
};

class Print : public Statement {
public:
  std::unique_ptr<NumericExpr> at;
  std::vector<std::unique_ptr<StringExpr>> printExpr;
  void append(std::unique_ptr<StringExpr> e) {
    printExpr.emplace_back(std::move(e));
  }
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "PRINT"; }
};

class Input : public Statement {
public:
  std::unique_ptr<StringConstantExpr> prompt;
  std::vector<std::unique_ptr<Expr>> variables;
  void append(Expr *e) { variables.emplace_back(e); }
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "INPUT"; }
};

class End : public Statement {
public:
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "END"; }
};

class On : public Statement {
public:
  std::unique_ptr<NumericExpr> branchIndex;
  std::vector<int> branchTable;
  bool isSub;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override {
    return isSub ? "ON..GOSUB" : "ON..GOTO";
  }
};

class Next : public Statement {
public:
  std::vector<std::unique_ptr<NumericVariableExpr>> variables;
  void appendVar(NumericVariableExpr *v) { variables.emplace_back(v); }
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "NEXT"; }
};

class Dim : public Statement {
public:
  std::vector<std::unique_ptr<Expr>> variables;
  void append(Expr *e) { variables.emplace_back(e); }
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "DIM"; }
};

class Read : public Statement {
public:
  std::vector<std::unique_ptr<Expr>> variables;
  void append(Expr *e) { variables.emplace_back(e); }
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "READ"; }
};

class Let : public Statement {
public:
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  Let(Expr *l, Expr *r) : lhs(l), rhs(r) {}
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "LET"; }
};

class Run : public Statement {
public:
  int lineNumber;
  bool hasLineNumber;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "RUN"; }
};

class Inc : public Statement {
public:
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  Inc(Expr *l, Expr *r) : lhs(l), rhs(r) {}
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "LET"; }
};

class Dec : public Statement {
public:
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  Dec(Expr *l, Expr *r) : lhs(l), rhs(r) {}
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "LET"; }
};

class Restore : public Statement {
public:
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "RESTORE"; }
};

class Return : public Statement {
public:
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "RETURN"; }
};

class Stop : public Statement {
public:
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "STOP"; }
};

class Poke : public Statement {
public:
  std::unique_ptr<NumericExpr> dest;
  std::unique_ptr<NumericExpr> val;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "POKE"; }
};

class Clear : public Statement {
public:
  std::unique_ptr<NumericExpr> size;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "CLEAR"; }
};

class Set : public Statement {
public:
  std::unique_ptr<NumericExpr> x;
  std::unique_ptr<NumericExpr> y;
  std::unique_ptr<NumericExpr> c;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "SET"; }
};

class Reset : public Statement {
public:
  std::unique_ptr<NumericExpr> x;
  std::unique_ptr<NumericExpr> y;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "RESET"; }
};

class Cls : public Statement {
public:
  std::unique_ptr<NumericExpr> color;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "CLS"; }
};

class Sound : public Statement {
public:
  std::unique_ptr<NumericExpr> pitch;
  std::unique_ptr<NumericExpr> duration;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "SOUND"; }
};

class Error : public Statement {
public:
  std::unique_ptr<NumericExpr> errorCode;
  void operate(StatementOp *op) override { op->operate(*this); }
  std::string statementName() override { return "ERROR"; }
};
#endif
