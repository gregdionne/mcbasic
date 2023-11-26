// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_STATEMENT_HPP
#define AST_STATEMENT_HPP

#include "expression.hpp"

// Statement Visitors
//
// The abstract syntax tree (AST) has a few visitors
// to help with const correctness and friendly return values.
//
//  ASTVisitor | visit()   | visitor  | AST
// ------------+-----------+----------+---------
//   inspector | inspect() | const    | const
//   absorber  | absorb()  | mutable  | const
// * exuder    | exude()   | const    | mutable
//   mutator   | mutate()  | mutable  | mutable
//
// * not yet implemented.
//
// The accept methods have more diverse names depending on return values.
//
//   check()       - calls an inspector with boolean return
//   inspect()     - calls an inspector with no (void) return
//   soak()        - calls an absorber with no (void) return
//   mutate()      - calls a mutator with no (void) return
//   transmutate() - calls a mutator that returns a new branch of the AST.

#include "statementabsorber.hpp"
#include "statementinspector.hpp"
#include "statementmutator.hpp"

#include "utils/memutils.hpp" // up<T>, makeup<T>, mv()
#include <string>
#include <vector>

// AST structure for statements
class Statement {
public:
  Statement() = default;
  Statement(const Statement &) = delete;
  Statement(Statement &&) = default;
  Statement &operator=(const Statement &) = delete;
  Statement &operator=(Statement &&) = default;
  virtual ~Statement() = default;

  virtual up<Statement>
  transmutate(StatementMutator<up<Statement>> * /*transmutator*/) = 0;
  virtual void mutate(StatementMutator<void> * /*op*/) = 0;
  virtual bool check(const StatementInspector<bool> * /*checker*/) const = 0;
  virtual void
  inspect(const StatementInspector<void> * /*inspector*/) const = 0;
  virtual void soak(StatementAbsorber<void> * /*absorber*/) const = 0;
  virtual std::string statementName() const { return ""; }
};

template <typename T> class OperableStatement : public Statement {
public:
  up<Statement> transmutate(StatementMutator<up<Statement>> *mutator) override {
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
  up<NumericVariableExpr> iter;
  up<NumericExpr> from;
  up<NumericExpr> to;
  up<NumericExpr> step;
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
  up<NumericExpr> predicate;
  int lineNumber;
  std::string statementName() const override {
    return isSub ? "WHEN..GOSUB" : "WHEN..GOTO";
  }
};

class If : public OperableStatement<If> {
public:
  up<NumericExpr> predicate;
  std::vector<up<Statement>> consequent;
  std::string statementName() const override { return "IF"; }
};

class Data : public OperableStatement<Data> {
public:
  std::vector<up<StringConstantExpr>> records;
  std::string statementName() const override { return "DATA"; }
};

class Print : public OperableStatement<Print> {
public:
  bool isLPrint = false;
  explicit Print(bool lprint) : isLPrint(lprint) {}
  up<NumericExpr> at;
  std::vector<up<StringExpr>> printExpr;
  std::string statementName() const override {
    return isLPrint ? "LPRINT" : "PRINT";
  }
};

class Input : public OperableStatement<Input> {
public:
  up<StringConstantExpr> prompt;
  std::vector<up<Expr>> variables;
  std::string statementName() const override { return "INPUT"; }
};

class End : public OperableStatement<End> {
public:
  std::string statementName() const override { return "END"; }
};

class On : public OperableStatement<On> {
public:
  up<NumericExpr> branchIndex;
  std::vector<int> branchTable;
  bool isSub;
  std::string statementName() const override {
    return isSub ? "ON..GOSUB" : "ON..GOTO";
  }
};

class Next : public OperableStatement<Next> {
public:
  std::vector<up<NumericVariableExpr>> variables;
  std::string statementName() const override { return "NEXT"; }
};

class Dim : public OperableStatement<Dim> {
public:
  std::vector<up<Expr>> variables;
  std::string statementName() const override { return "DIM"; }
};

class Read : public OperableStatement<Read> {
public:
  std::vector<up<Expr>> variables;
  std::string statementName() const override { return "READ"; }
};

class Let : public OperableStatement<Let> {
public:
  up<Expr> lhs;
  up<Expr> rhs;
  Let(up<Expr> l, up<Expr> r) : lhs(mv(l)), rhs(mv(r)) {}
  std::string statementName() const override { return "LET"; }
};

class Run : public OperableStatement<Run> {
public:
  int lineNumber;
  bool hasLineNumber;
  std::string statementName() const override { return "RUN"; }
};

class Accum : public OperableStatement<Accum> {
public:
  up<Expr> lhs;
  up<Expr> rhs;
  Accum(up<Expr> l, up<Expr> r) : lhs(mv(l)), rhs(mv(r)) {}
  std::string statementName() const override { return "ACCUM"; }
};

class Decum : public OperableStatement<Decum> {
public:
  up<Expr> lhs;
  up<Expr> rhs;
  Decum(up<Expr> l, up<Expr> r) : lhs(mv(l)), rhs(mv(r)) {}
  std::string statementName() const override { return "DECUM"; }
};

class Necum : public OperableStatement<Necum> {
public:
  up<Expr> lhs;
  up<Expr> rhs;
  explicit Necum(up<Expr> l, up<Expr> r) : lhs(mv(l)), rhs(mv(r)) {}
  std::string statementName() const override { return "NECUM"; }
};

class Eval : public OperableStatement<Eval> {
public:
  std::vector<up<Expr>> operands;
  std::string statementName() const override { return "EVAL"; }
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
  up<NumericExpr> dest;
  up<NumericExpr> val;
  std::string statementName() const override { return "POKE"; }
};

class Clear : public OperableStatement<Clear> {
public:
  up<NumericExpr> size;
  up<NumericExpr> address;
  std::string statementName() const override { return "CLEAR"; }
};

class CLoadM : public OperableStatement<CLoadM> {
public:
  up<StringExpr> filename;
  up<NumericExpr> offset;
  std::string statementName() const override { return "CLOADM"; }
};

class CLoadStar : public OperableStatement<CLoadStar> {
public:
  std::string arrayName;
  up<StringExpr> filename;
  std::string statementName() const override { return "CLOAD*"; }
};

class CSaveStar : public OperableStatement<CSaveStar> {
public:
  std::string arrayName;
  up<StringExpr> filename;
  std::string statementName() const override { return "CSAVE*"; }
};

class Set : public OperableStatement<Set> {
public:
  up<NumericExpr> x;
  up<NumericExpr> y;
  up<NumericExpr> c;
  std::string statementName() const override { return "SET"; }
};

class Reset : public OperableStatement<Reset> {
public:
  up<NumericExpr> x;
  up<NumericExpr> y;
  std::string statementName() const override { return "RESET"; }
};

class Cls : public OperableStatement<Cls> {
public:
  up<NumericExpr> color;
  std::string statementName() const override { return "CLS"; }
};

class Sound : public OperableStatement<Sound> {
public:
  up<NumericExpr> pitch;
  up<NumericExpr> duration;
  std::string statementName() const override { return "SOUND"; }
};

class Exec : public OperableStatement<Exec> {
public:
  up<NumericExpr> address;
  std::string statementName() const override { return "EXEC"; }
};

class Error : public OperableStatement<Error> {
public:
  up<NumericExpr> errorCode;
  std::string statementName() const override { return "ERROR"; }
};
#endif
