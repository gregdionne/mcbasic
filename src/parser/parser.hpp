// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef PARSER_PARSER_HPP
#define PARSER_PARSER_HPP
#include "ast/program.hpp"
#include "mcbasic/mcbasicclioptions.hpp"
#include "utils/fetcher.hpp"
#include "utils/fileread.hpp"

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
  Parser(const char *progname, const char *filename,
         const MCBASICCLIOptions &opts)
      : in(progname, filename, fileread(progname, filename)), options(opts) {}
  Program parse();

private:
  bool isKeyword(const char *keyword);
  bool skipKeyword(const char *keyword);
  bool matchEitherKeyword(const char *k1, const char *k2);

  int getLineNumber();
  up<StringConstantExpr> getUnquotedDataRecord();
  up<ArrayIndicesExpr> getArrayIndices();

  up<NumericConstantExpr> seekNumericConst();
  up<StringConstantExpr> seekStringConst();
  up<StringConstantExpr> seekDataRecord();
  up<Expr> seekConst();
  up<Expr> seekVarOrArray();
  up<Expr> seekDataVar();
  up<Expr> seekParenthetical();

  up<NumericExpr> numeric(up<Expr> expr);
  up<NumericExpr> numeric(up<Expr> (Parser::*expr)());
  up<StringExpr> string(up<Expr> expr);
  up<StringExpr> string(up<Expr> (Parser::*expr)());

  up<Expr> matchTypes(Expr *lhs, up<Expr> (Parser::*expr)());

  up<NumericVariableExpr> getIterationVar();
  std::string getNumericArrayName();
  up<Expr> getVarOrArray();
  up<Expr> getParenthetical();
  up<Expr> getPrimitive();
  up<Expr> getSgnFunction();
  up<Expr> getIntFunction();
  up<Expr> getAbsFunction();
  up<Expr> getRndFunction();
  up<Expr> getSqrFunction();
  up<Expr> getLogFunction();
  up<Expr> getExpFunction();
  up<Expr> getSinFunction();
  up<Expr> getCosFunction();
  up<Expr> getTanFunction();
  up<Expr> getPeekFunction();
  up<Expr> getLenFunction();
  up<Expr> getStrFunction();
  up<Expr> getValFunction();
  up<Expr> getAscFunction();
  up<Expr> getChrFunction();
  up<Expr> getPointFunction();
  up<Expr> getLeftFunction();
  up<Expr> getRightFunction();
  up<Expr> getMidFunction();
  up<Expr> getFunction();
  up<Expr> getPowerExpression();
  up<Expr> getSignedFactor();
  up<Expr> getTerm();
  up<Expr> getAdditiveExpression();
  up<Expr> getRelationalExpression();
  up<Expr> getNotExpression();
  up<Expr> getAndExpression();
  up<Expr> getOrExpression();
  up<Expr> getNumericArgument();
  up<Expr> getStringArgument();
  up<Expr> unimplementedKeywordExpression();
  up<Statement> getFor();
  up<Statement> getGoto(bool isSub);
  up<Statement> getRem();
  up<Statement> getIf();
  up<Statement> getData();
  up<Statement> getPrint(bool lprint);
  up<Statement> getOn();
  up<Statement> getInput();
  up<Statement> getEnd();
  up<Statement> getNext();
  up<Statement> getDim();
  up<Statement> getRead();
  up<Statement> getLet();
  up<Statement> getRun();
  up<Statement> getRestore();
  up<Statement> getReturn();
  up<Statement> getStop();
  up<Statement> getPoke();
  up<Statement> getClear();
  up<Statement> getCLoad();
  up<Statement> getCSave();
  up<Statement> getSet();
  up<Statement> getReset();
  up<Statement> getCls();
  up<Statement> getSound();
  up<Statement> getExec();
  up<Statement> unimplementedKeyword();
  up<Statement> getStatement();

  static up<Statement> getError(uint8_t errorCode);
  void getLine(Program &p);
  void getEndLines(Program &p);
  void cleanupLines(Program &p);

  Fetcher in;
  const MCBASICCLIOptions &options;
};
#endif
