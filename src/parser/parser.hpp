// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef PARSER_PARSER_HPP
#define PARSER_PARSER_HPP
#include "ast/program.hpp"
#include "fetch.hpp"
#include "mcbasic/options.hpp"

//  This file was originally a K&R C file.
//  Then it bacame ANSI C.
//  Then it became C++ (98).
//
//  The author has given it just enough attention to survive being called
//  from classes created in C++11 and then C++14.
//
//  It could use const correctness hints.
//
//  It will then need to be modernized again in another ten years.

class Parser {
public:
  Parser(int c, char *v[], Options &opts)
      : in(c, v), emptyLineNumbers(opts.el), unlistedLineNumbers(opts.ul) {}
  Program parse();
  fetch in;

private:
  bool isKeyword(const char *keyword);
  bool skipKeyword(const char *keyword);
  bool matchEitherKeyword(const char *k1, const char *k2);

  int getLineNumber();
  std::unique_ptr<StringConstantExpr> getUnquotedDataRecord();
  std::unique_ptr<ArrayIndicesExpr> getArrayIndices();

  std::unique_ptr<NumericConstantExpr> seekNumericConst();
  std::unique_ptr<StringConstantExpr> seekStringConst();
  std::unique_ptr<StringConstantExpr> seekDataRecord();
  std::unique_ptr<Expr> seekConst();
  std::unique_ptr<Expr> seekVarOrArray();
  std::unique_ptr<Expr> seekDataVar();
  std::unique_ptr<Expr> seekParenthetical();

  std::unique_ptr<NumericExpr> numeric(std::unique_ptr<Expr> expr);
  std::unique_ptr<NumericExpr> numeric(std::unique_ptr<Expr> (Parser::*expr)());
  std::unique_ptr<StringExpr> string(std::unique_ptr<Expr> expr);
  std::unique_ptr<StringExpr> string(std::unique_ptr<Expr> (Parser::*expr)());

  std::unique_ptr<Expr> matchTypes(Expr *lhs,
                                   std::unique_ptr<Expr> (Parser::*expr)());

  std::unique_ptr<NumericVariableExpr> getIterationVar();
  std::unique_ptr<Expr> getVarOrArray();
  std::unique_ptr<Expr> getParenthetical();
  std::unique_ptr<Expr> getPrimitive();
  std::unique_ptr<Expr> getSgnFunction();
  std::unique_ptr<Expr> getIntFunction();
  std::unique_ptr<Expr> getAbsFunction();
  std::unique_ptr<Expr> getRndFunction();
  std::unique_ptr<Expr> getSqrFunction();
  std::unique_ptr<Expr> getLogFunction();
  std::unique_ptr<Expr> getExpFunction();
  std::unique_ptr<Expr> getSinFunction();
  std::unique_ptr<Expr> getCosFunction();
  std::unique_ptr<Expr> getTanFunction();
  std::unique_ptr<Expr> getPeekFunction();
  std::unique_ptr<Expr> getLenFunction();
  std::unique_ptr<Expr> getStrFunction();
  std::unique_ptr<Expr> getValFunction();
  std::unique_ptr<Expr> getAscFunction();
  std::unique_ptr<Expr> getChrFunction();
  std::unique_ptr<Expr> getPointFunction();
  std::unique_ptr<Expr> getLeftFunction();
  std::unique_ptr<Expr> getRightFunction();
  std::unique_ptr<Expr> getMidFunction();
  std::unique_ptr<Expr> getFunction();
  std::unique_ptr<Expr> getPowerExpression();
  std::unique_ptr<Expr> getSignedFactor();
  std::unique_ptr<Expr> getTerm();
  std::unique_ptr<Expr> getAdditiveExpression();
  std::unique_ptr<Expr> getRelationalExpression();
  std::unique_ptr<Expr> getNotExpression();
  std::unique_ptr<Expr> getAndExpression();
  std::unique_ptr<Expr> getOrExpression();
  std::unique_ptr<Expr> getNumericArgument();
  std::unique_ptr<Expr> getStringArgument();
  std::unique_ptr<Expr> unimplementedKeywordExpression();
  std::unique_ptr<Statement> getFor();
  std::unique_ptr<Statement> getGoto(bool isSub);
  std::unique_ptr<Statement> getRem();
  std::unique_ptr<Statement> getIf();
  std::unique_ptr<Statement> getData();
  std::unique_ptr<Statement> getPrint();
  std::unique_ptr<Statement> getOn();
  std::unique_ptr<Statement> getInput();
  std::unique_ptr<Statement> getEnd();
  std::unique_ptr<Statement> getNext();
  std::unique_ptr<Statement> getDim();
  std::unique_ptr<Statement> getRead();
  std::unique_ptr<Statement> getLet();
  std::unique_ptr<Statement> getRun();
  std::unique_ptr<Statement> getRestore();
  std::unique_ptr<Statement> getReturn();
  std::unique_ptr<Statement> getStop();
  std::unique_ptr<Statement> getPoke();
  std::unique_ptr<Statement> getClear();
  std::unique_ptr<Statement> getSet();
  std::unique_ptr<Statement> getReset();
  std::unique_ptr<Statement> getCls();
  std::unique_ptr<Statement> getSound();
  std::unique_ptr<Statement> unimplementedKeyword();
  std::unique_ptr<Statement> getStatement();

  std::unique_ptr<Statement> getError(uint8_t errorCode);
  void getLine(Program &p);
  void getEndLines(Program &p);

  bool emptyLineNumbers = false;
  bool unlistedLineNumbers = false;
};
#endif
