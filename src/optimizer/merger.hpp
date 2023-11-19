// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_MERGER_HPP
#define OPTIMIZER_MERGER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "constfolder.hpp"
#include "isfloat.hpp"

// Perform strength reduction and remove (merge)
// expressions with redundant operations.

class Merger : public ProgramOp {
public:
  Merger(SymbolTable &st, const BinaryOption &opt)
      : option(opt), symbolTable(st) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const BinaryOption &option;
  SymbolTable &symbolTable;
};

// TODO:
//   Replace each private method with its own dedicated ExprOp
//   Replace this class with one to manage the others.

class ExprMerger : public ExprMutator<void, void> {
public:
  ExprMerger(SymbolTable &st, const BinaryOption &opt)
      : isFloat(st), option(opt), exprConstFolder(opt), announcer(opt) {}
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
  void mutate(SqrExpr &e) override;
  void mutate(ExpExpr &e) override;
  void mutate(LogExpr &e) override;
  void mutate(SinExpr &e) override;
  void mutate(CosExpr &e) override;
  void mutate(TanExpr &e) override;
  void mutate(RndExpr &e) override;
  void mutate(PeekExpr &e) override;
  void mutate(RelationalExpr &e) override;
  void mutate(PointExpr &e) override;
  void mutate(PrintTabExpr &e) override;
  void mutate(PeekWordExpr &e) override;
  void mutate(SquareExpr &e) override;
  void mutate(FractExpr &e) override;
  void mutate(ShiftExpr &e) override;

  void mutate(NumericConstantExpr & /*e*/) override {}
  void mutate(StringConstantExpr & /*e*/) override {}
  void mutate(NumericVariableExpr & /*e*/) override {}
  void mutate(StringVariableExpr & /*e*/) override {}
  void mutate(NaryNumericExpr & /*e*/) override {}
  void mutate(PrintSpaceExpr & /*e*/) override {}
  void mutate(PrintCRExpr & /*e*/) override {}
  void mutate(PrintCommaExpr & /*e*/) override {}
  void mutate(InkeyExpr & /*e*/) override {}
  void mutate(MemExpr & /*e*/) override {}
  void mutate(PosExpr & /*e*/) override {}
  void mutate(TimerExpr & /*e*/) override {}

  void merge(up<NumericExpr> &expr);
  void merge(up<StringExpr> &expr);
  void merge(up<Expr> &expr);
  void merge(NaryNumericExpr &e);

  void setLineNumber(int n) { lineNumber = n; }

private:
  // remove identity elements from N-ary argument list
  void pruneIdentity(std::vector<up<NumericExpr>> &operands, double identity);

  // remove multiplication if only one argument
  // remove addition if only one argument
  //
  void reduceNaryExpr(up<NumericExpr> &expr);

  // replace
  //   - ( - <expr1> * <expr2> ) with <expr1> * <expr2>
  //   - (   <expr1> / -<expr2>) with <expr1> * <expr2>
  //
  void mergeNegatedMultiplication(up<NumericExpr> &expr);

  // replace
  //    <integer> *   <boolean> with <boolean> AND - <integer>
  //    <boolean> *   <integer> with <boolean> AND - <integer>
  //  - <integer> *   <boolean> with <boolean> AND <integer>
  //    <boolean> * - <integer> with <boolean> AND <integer>
  //
  void reduceRelationalMultiplication(up<NumericExpr> &expr, IsFloat &isFloat);
  // replace
  //    2^<integer>  with SHIFT(1, <integer>) for non-zero N
  void reducePowerOfTwo(up<NumericExpr> &expr, IsFloat &isFloat);

  // replace
  //    <number> * F, where F = 2^N  with SHIFT(<number>, N) for non-zero N
  //    <number> / F, where F = 2^N  with SHIFT(<number>,-N) for non-zero N
  //                                      <number>           for N zero.
  //
  void reducePowerOfTwoMultiplication(up<NumericExpr> &expr);
  bool reducePowerOfTwoMultiplication(up<NumericExpr> &expr,
                                      std::vector<up<NumericExpr>> &ops,
                                      int sign);

  // replace
  //    X*X with SQ(X)
  void reduceSquaredMultiplication(std::vector<up<NumericExpr>> &ops);

  // replace
  //    X^2 with SQ(X)
  void reduceSquarePower(up<NumericExpr> &expr);

  // replace
  //   <expr>-INT(<expr>) with FRACT(<expr>)
  bool reduceProperFraction(std::vector<up<NumericExpr>> &ops1,
                            std::vector<up<NumericExpr>> &ops2);

  // replace
  //   INT(<expr1>/<expr2>) with IDIV(<expr1>,<expr2>)
  void reduceIntegerDivision(up<NumericExpr> &expr);

  // replace <expr>*-1 or <expr>/-1 with -<expr>
  //
  void reduceMultiplyByNegativeOne(up<NumericExpr> &expr);

  // replace SHIFT(SHIFT(<expr>, m), n) with SHIFT(<expr>, m+n)
  //
  void mergeDoubleShift(up<NumericExpr> &expr);

  // replace expressions involving consecutive PEEKS
  //
  void mergeDoublePeek(up<NumericExpr> &expr);
  bool mergeDoublePeek(std::vector<up<NumericExpr>> &ops);

  // replace PEEK(9)*256+PEEK(10) with TIMER
  //
  bool mergeWithTimer(PeekExpr *peek1, std::vector<up<NumericExpr>> &ops);

  // replace (PEEK(17024)AND1)*256+PEEK(17025) with POS
  //
  bool mergeWithPos(PeekExpr *peek1, std::vector<up<NumericExpr>> &ops);

  // replace PEEK(<expr>)*256+PEEK(<expr>+1) with PEEK(<expr>)
  //   for <expr> either constant or a variable name
  bool mergeWithPeekWord(PeekExpr *peek1, std::vector<up<NumericExpr>> &ops);

  // move relational operators earlier in expression
  //   (delays promoting bool to integer)
  // move constants and variables towards end of expression
  //   (reduce register pressure)
  //
  static void knead(std::vector<up<NumericExpr>> &operands);

  IsFloat isFloat;
  const BinaryOption &option;
  ExprConstFolder exprConstFolder;
  Announcer announcer;
  int lineNumber = -1;
};

class StatementMerger : public NullStatementMutator {
public:
  StatementMerger(SymbolTable &st, const BinaryOption &option)
      : announcer(option), merger(st, option) {}
  void mutate(For &s) override;
  void mutate(When &s) override;
  void mutate(If &s) override;
  void mutate(Print &s) override;
  void mutate(On &s) override;
  void mutate(Dim &s) override;
  void mutate(Let &s) override;
  void mutate(Accum &s) override;
  void mutate(Decum &s) override;
  void mutate(Necum &s) override;
  void mutate(Eval &s) override;
  void mutate(Poke &s) override;
  void mutate(Clear &s) override;
  void mutate(Set &s) override;
  void mutate(Reset &s) override;
  void mutate(Cls &s) override;
  void mutate(Sound &s) override;
  void mutate(Exec &s) override;

  void setLineNumber(int lineNumber) { merger.setLineNumber(lineNumber); }

private:
  using NullStatementMutator::mutate;
  Announcer announcer;
  ExprMerger merger;
};

#endif
