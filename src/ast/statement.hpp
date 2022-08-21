// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_STATEMENT_HPP
#define AST_STATEMENT_HPP

#include <string>
#include <vector>

#include "expression.hpp"
#include "utils/memutils.hpp" // up<T>, makeup<T>, mv()

// forward declarations for visitors

class Statement;
class Rem;
class For;
class Go;
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
class Exec;

// extensions
class When;
class Accum;
class Decum;
class Necum;
class Eval;
class Error;

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

// StatementMutater
//   change a statement in-place

template <typename T> class StatementMutator {
public:
  StatementMutator() = default;
  StatementMutator(const StatementMutator &) = delete;
  StatementMutator(StatementMutator &&) = delete;
  StatementMutator &operator=(const StatementMutator &) = delete;
  StatementMutator &operator=(StatementMutator &&) = delete;
  virtual ~StatementMutator() = default;

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
  virtual T mutate(Accum & /*s*/) = 0;
  virtual T mutate(Decum & /*s*/) = 0;
  virtual T mutate(Necum & /*s*/) = 0;
  virtual T mutate(Eval & /*s*/) = 0;
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
  virtual T mutate(Exec & /*s*/) = 0;
  virtual T mutate(Error & /*s*/) = 0;
};

// StatementInspector
//   provide a result of examination

template <typename T> class StatementInspector {
public:
  StatementInspector() = default;
  StatementInspector(const StatementInspector &) = delete;
  StatementInspector(StatementInspector &&) = delete;
  StatementInspector &operator=(const StatementInspector &) = delete;
  StatementInspector &operator=(StatementInspector &&) = delete;
  virtual ~StatementInspector() = default;

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
  virtual T inspect(const Accum & /*s*/) const = 0;
  virtual T inspect(const Decum & /*s*/) const = 0;
  virtual T inspect(const Necum & /*s*/) const = 0;
  virtual T inspect(const Eval & /*s*/) const = 0;
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
  virtual T inspect(const Exec & /*s*/) const = 0;
  virtual T inspect(const Error & /*s*/) const = 0;
};

// StatementAbsorber
//   changes state as a result of examination

template <typename T> class StatementAbsorber {
public:
  StatementAbsorber() = default;
  StatementAbsorber(const StatementAbsorber &) = delete;
  StatementAbsorber(StatementAbsorber &&) = delete;
  StatementAbsorber &operator=(const StatementAbsorber &) = delete;
  StatementAbsorber &operator=(StatementAbsorber &&) = delete;
  virtual ~StatementAbsorber() = default;

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
  virtual T absorb(const Accum & /*s*/) = 0;
  virtual T absorb(const Decum & /*s*/) = 0;
  virtual T absorb(const Necum & /*s*/) = 0;
  virtual T absorb(const Eval & /*s*/) = 0;
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
  virtual T absorb(const Exec & /*s*/) = 0;
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
  up<NumericExpr> at;
  std::vector<up<StringExpr>> printExpr;
  std::string statementName() const override { return "PRINT"; }
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
  std::string statementName() const override { return "CLEAR"; }
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
