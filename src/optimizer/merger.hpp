// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_MERGER_HPP
#define OPTIMIZER_MERGER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "isfloat.hpp"

// Perform strength reduction and remove (merge)
// expressions with redundant operations.

class Merger : public ProgramOp {
public:
  explicit Merger(SymbolTable &st) : symbolTable(st) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  SymbolTable &symbolTable;
};

// TODO:
//   Replace each private method with its own dedicated ExprOp
//   Replace this class with one to manage the others.

class ExprMerger : public ExprMutator<void, void> {
public:
  explicit ExprMerger(SymbolTable &st) : isFloat(st) {}
  void mutate(StringConcatenationExpr &e) override;
  void mutate(StringArrayExpr &e) override;
  void mutate(LeftExpr &e) override;
  void mutate(MidExpr &e) override;
  void mutate(RightExpr &e) override;
  void mutate(LenExpr &e) override;
  void mutate(StrExpr &e) override;
  void mutate(ValExpr &e) override;
  void mutate(AscExpr &e) override;
  void mutate(ChrExpr &e) override;
  void mutate(NumericArrayExpr &e) override;
  void mutate(ArrayIndicesExpr &e) override;
  void mutate(NegatedExpr &e) override;
  void mutate(PowerExpr &e) override;
  void mutate(IntegerDivisionExpr &e) override;
  void mutate(MultiplicativeExpr &e) override;
  void mutate(AdditiveExpr &e) override;
  void mutate(ComplementedExpr &e) override;
  void mutate(AndExpr &e) override;
  void mutate(OrExpr &e) override;
  void mutate(SgnExpr &e) override;
  void mutate(IntExpr &e) override;
  void mutate(AbsExpr &e) override;
  void mutate(RndExpr &e) override;
  void mutate(PeekExpr &e) override;
  void mutate(RelationalExpr &e) override;
  void mutate(PointExpr &e) override;
  void mutate(PrintTabExpr &e) override;

  void mutate(NumericConstantExpr &) override {}
  void mutate(StringConstantExpr &) override {}
  void mutate(NumericVariableExpr &) override {}
  void mutate(StringVariableExpr &) override {}
  void mutate(NaryNumericExpr &) override {}
  void mutate(PrintSpaceExpr &) override {}
  void mutate(PrintCRExpr &) override {}
  void mutate(PrintCommaExpr &) override {}
  void mutate(ShiftExpr &) override {}
  void mutate(SqrExpr &) override {}
  void mutate(ExpExpr &) override {}
  void mutate(LogExpr &) override {}
  void mutate(SinExpr &) override {}
  void mutate(CosExpr &) override {}
  void mutate(TanExpr &) override {}
  void mutate(InkeyExpr &) override {}
  void mutate(MemExpr &) override {}

  void merge(std::unique_ptr<NumericExpr> &expr);
  void merge(std::unique_ptr<StringExpr> &expr);
  void merge(std::unique_ptr<Expr> &expr);
  void merge(NaryNumericExpr &e);

  IsFloat isFloat;

private:
  // replace an empty N-ary exprssion with its identity
  static void reduceNullOp(std::unique_ptr<NumericExpr> &expr);

  // remove identity elements from N-ary argument list
  static void pruneIdentity(std::vector<std::unique_ptr<NumericExpr>> &operands,
                            double identity);
  // remove multiplication if only one argument
  // remove addition if only one argument
  // replace subtraction with negation if only one argument
  //
  static void mergeUnaryOp(std::unique_ptr<NumericExpr> &expr);

  // replace
  //    <integer> *   <boolean> with <boolean> AND - <integer>
  //    <boolean> *   <integer> with <boolean> AND - <integer>
  //  - <integer> *   <boolean> with <boolean> AND <integer>
  //    <boolean> * - <integer> with <boolean> AND <integer>
  //
  static void reduceRelationalMultiplication(std::unique_ptr<NumericExpr> &expr,
                                             IsFloat &isFloat,
                                             ExprMerger *that);
  // replace
  //    2^<integer>  with SHIFT(1, <integer>) for non-zero N
  static void reducePowerOfTwo(std::unique_ptr<NumericExpr> &expr,
                               IsFloat &isFloat, ExprMerger *that);

  // replace
  //    <number> * F, where F = 2^N  with SHIFT(<number>, N) for non-zero N
  //    <number> / F, where F = 2^N  with SHIFT(<number>,-N) for non-zero N
  //                                      <number>           for N zero.
  //
  static void reducePowerOfTwoMultiplication(std::unique_ptr<NumericExpr> &expr,
                                             ExprMerger *that);

  // replace
  //   INT(X/Y) with IDIV(X,Y)
  static void mergeIntegerDivision(std::unique_ptr<NumericExpr> &expr,
                                   ExprMerger *that);

  // replace - ( -(<expr1>) * <expr2> ) with <expr1>*<expr2>
  //
  static void mergeNegatedMultiplication(std::unique_ptr<NumericExpr> &expr);

  // replace - ( <expr1> - <expr2>  ) with <expr2> - <expr1>
  //
  static void mergeNegatedSum(std::unique_ptr<NumericExpr> &expr);

  // replace - ( - (<expr> ) ) with <expr>
  //
  static void mergeDoubleNegation(std::unique_ptr<NumericExpr> &expr);

  // replace SHIFT(SHIFT(<expr>, m), n) with SHIFT(<expr>, m+n)
  //
  static void mergeDoubleShift(std::unique_ptr<NumericExpr> &expr,
                               ExprMerger *that);

  // move relational operators earlier in expression
  //   (delays promoting bool to integer)
  // move constants and variables towards end of expression
  //   (reduce register pressure)
  //
  static void knead(std::vector<std::unique_ptr<NumericExpr>> &operands);
};

class StatementMerger : public NullStatementMutator {
public:
  explicit StatementMerger(SymbolTable &st) : merger(st) {}
  void mutate(For &s) override;
  void mutate(When &s) override;
  void mutate(If &s) override;
  void mutate(Print &s) override;
  void mutate(On &s) override;
  void mutate(Dim &s) override;
  void mutate(Let &s) override;
  void mutate(Inc &s) override;
  void mutate(Dec &s) override;
  void mutate(Poke &s) override;
  void mutate(Clear &s) override;
  void mutate(Set &s) override;
  void mutate(Reset &s) override;
  void mutate(Cls &s) override;
  void mutate(Sound &s) override;

  ExprMerger merger;
};

#endif
