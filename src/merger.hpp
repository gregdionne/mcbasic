// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MERGER_HPP
#define MERGER_HPP

#include "isfloat.hpp"
#include "program.hpp"

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

class ExprMerger : public ExprOp {
public:
  explicit ExprMerger(SymbolTable &st) : isFloat(st) {}
  void operate(StringConcatenationExpr &e) override;
  void operate(StringArrayExpr &e) override;
  void operate(LeftExpr &e) override;
  void operate(MidExpr &e) override;
  void operate(RightExpr &e) override;
  void operate(LenExpr &e) override;
  void operate(StrExpr &e) override;
  void operate(ValExpr &e) override;
  void operate(AscExpr &e) override;
  void operate(ChrExpr &e) override;
  void operate(NumericArrayExpr &e) override;
  void operate(ArrayIndicesExpr &e) override;
  void operate(NegatedExpr &e) override;
  void operate(PowerExpr &e) override;
  void operate(IntegerDivisionExpr &e) override;
  void operate(MultiplicativeExpr &e) override;
  void operate(AdditiveExpr &e) override;
  void operate(ComplementedExpr &e) override;
  void operate(AndExpr &e) override;
  void operate(OrExpr &e) override;
  void operate(SgnExpr &e) override;
  void operate(IntExpr &e) override;
  void operate(AbsExpr &e) override;
  void operate(RndExpr &e) override;
  void operate(PeekExpr &e) override;
  void operate(RelationalExpr &e) override;
  void operate(PointExpr &e) override;
  void operate(PrintTabExpr &e) override;

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

class StatementMerger : public StatementOp {
public:
  explicit StatementMerger(SymbolTable &st) : merger(st) {}
  void operate(For &s) override;
  void operate(When &s) override;
  void operate(If &s) override;
  void operate(Print &s) override;
  void operate(On &s) override;
  void operate(Dim &s) override;
  void operate(Let &s) override;
  void operate(Inc &s) override;
  void operate(Dec &s) override;
  void operate(Poke &s) override;
  void operate(Clear &s) override;
  void operate(Set &s) override;
  void operate(Reset &s) override;
  void operate(Cls &s) override;
  void operate(Sound &s) override;

  ExprMerger merger;
};

#endif
