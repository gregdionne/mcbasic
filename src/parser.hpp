// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef PARSER_HPP
#define PARSER_HPP
#include "fetch.hpp"
#include "program.hpp"

//  This file was originally a K&R C file.
//  Then it bacame ANSI C.
//  Then it became C++ (98).
//
//  The author has given it just enough attention to survive being called
//  from classes created in C++11 and then C++14.
//
//  It could use const correctness and std::unique_ptr<> hints.
//
//  It will then need to be modernized again in another ten years.

class Parser {
public:
  Parser(int c, char *v[]) : in(c, v) {}
  Program parse();
  fetch in;

private:
  bool isKeyword(const char *keyword);
  bool skipKeyword(const char *keyword);
  bool matchEitherKeyword(const char *k1, const char *k2);
  int getLineNumber();
  bool seekNumericConst(Expr *&expr);
  std::string getDataRecord();
  bool seekDataRecord(StringConstantExpr *&expr);
  std::string getString();
  bool seekStringConst(StringConstantExpr *&expr);
  bool seekStringConst(Expr *&expr);
  bool seekConst(Expr *&expr);
  ArrayIndicesExpr *getArrayIndices();
  bool seekVar(Expr *&expr);
  bool seekDataVar(Expr *&expr);
  bool seekIterationVar(NumericVariableExpr *&expr);
  bool seekParenthetical(Expr *&expr);
  Expr *matchTypes(Expr *lhs, Expr *(Parser::*expr)());
  Expr *getParenthetical();
  Expr *getPrimitive();
  Expr *getPointFunction();
  Expr *getLeftFunction();
  Expr *getRightFunction();
  Expr *getMidFunction();
  Expr *getFunction();
  Expr *getPowerExpression();
  Expr *getSignedFactor();
  Expr *getTerm();
  Expr *getAdditiveExpression();
  Expr *getRelationalExpression();
  Expr *getNotExpression();
  Expr *getAndExpression();
  Expr *getOrExpression();
  Expr *getNumericArgument();
  Expr *getStringArgument();
  Expr *unimplementedKeywordExpression();
  Statement *getFor();
  Statement *getGoto(bool isSub);
  Statement *getRem();
  Statement *getIf();
  Statement *getData();
  Statement *getPrint();
  Statement *getOn();
  Statement *getInput();
  Statement *getEnd();
  Statement *getNext();
  Statement *getDim();
  Statement *getRead();
  Statement *getLet();
  Statement *getRun();
  Statement *getRestore();
  Statement *getReturn();
  Statement *getStop();
  Statement *getPoke();
  Statement *getClear();
  Statement *getSet();
  Statement *getReset();
  Statement *getCls();
  Statement *getSound();
  Statement *unimplementedKeyword();
  Statement *getStatement();
  void getLine(Program &p);
  void getEndLine(Program &p);

  std::unique_ptr<NumericExpr> numeric(Expr *expr);
  std::unique_ptr<NumericExpr> numeric(Expr *(Parser::*expr)());
  std::unique_ptr<StringExpr> string(Expr *expr);
  std::unique_ptr<StringExpr> string(Expr *(Parser::*expr)());
};
#endif
