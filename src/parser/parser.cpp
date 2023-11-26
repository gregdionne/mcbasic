// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "parser.hpp"
#include "mcbasic/constants.hpp"
#include "utils/announcer.hpp"

#include <algorithm>
#include <cstring>

//  This file was originally a K&R C file.
//  Then it bacame ANSI C.
//  Then it became C++ (98).
//
//  The author has given it just enough attention to survive being called
//  from classes created in C++11 and then C++14.
//
//  It could use more const correctness and up<> hints.
//  It probably could call a more modern "fetcher" that also
//  wasn't originally written in K&R C and begrudgingly upgraded.
//
//  It will then need to be modernized again in another ten years.

static const char *const keywords[] = {
    "FOR",    "GOTO",    "GOSUB",  "REM",    "IF",    "DATA",   "PRINT",
    "ON",     "INPUT",   "END",    "NEXT",   "DIM",   "READ",   "LET",
    "RUN",    "RESTORE", "RETURN", "STOP",   "POKE",  "CONT",   "LIST",
    "CLEAR",  "NEW",     "CLOAD",  "CSAVE",  "LLIST", "LPRINT", "SET",
    "RESET",  "CLS",     "SOUND",  "EXEC",   "SKIPF", "TAB(",   "TO",
    "THEN",   "NOT",     "STEP",   "OFF",    "+",     "-",      "*",
    "/",      "^",       "AND",    "OR",     "<>",    "<=",     "=<",
    "=>",     ">=",      "><",     "<",      "=",     ">",      "SGN",
    "INT",    "ABS",     "USR",    "RND",    "SQR",   "LOG",    "EXP",
    "SIN",    "COS",     "TAN",    "PEEK",   "LEN",   "STR$",   "VAL",
    "ASC",    "CHR$",    "LEFT$",  "RIGHT$", "MID$",  "POINT",  "VARPTR",
    "INKEY$", "MEM",     nullptr};

bool Parser::isKeyword(const char *const keyword) {
  in.skipWhitespace();
  return in.peekKeyword(keywords) &&
         (strcmp(keywords[in.lastKeyID()], keyword) == 0);
}

bool Parser::skipKeyword(const char *const keyword) {
  in.skipWhitespace();
  if (isKeyword(keyword)) {
    in.skipKeyword(keywords);
    in.skipWhitespace();
    return true;
  }
  return false;
}

bool Parser::matchEitherKeyword(const char *const k1, const char *const k2) {
  if (isKeyword(k1)) {
    skipKeyword(k1);
    in.skipWhitespace();
    return true;
  }
  if (isKeyword(k2)) {
    skipKeyword(k2);
    in.skipWhitespace();
  } else {
    in.die("internal error");
  }
  return false;
}

int Parser::getLineNumber() {
  in.skipWhitespace();
  if (in.iseol() || in.isChar(':') || in.isChar(',')) {
    if (!options.el.isEnabled()) {
      in.sputter("error: empty (missing) line number.");
      fprintf(stderr, "\n");
      fprintf(stderr, "This is almost always an error, unless of course it was "
                      "done deliberately.\n");
      fprintf(stderr, "If done deliberately, use '-el' to redirect empty line "
                      "numbers to line 0.\n");
      exit(0);
    }
    return 0;
  }
  if (!in.isDecimalWord()) {
    in.die("line number expected");
  }
  int lineNumber = in.getDecimalWord();
  in.skipWhitespace();
  return lineNumber;
}

up<StringConstantExpr> Parser::getUnquotedDataRecord() {
  std::string s;
  in.skipWhitespace();
  while (!in.isChar(',') && !in.iseol()) {
    s += in.getChar();
  }
  return makeup<StringConstantExpr>(s);
}

up<ArrayIndicesExpr> Parser::getArrayIndices() {
  in.skipWhitespace();
  in.matchChar('(');
  up<ArrayIndicesExpr> expr = makeup<ArrayIndicesExpr>();
  do {
    expr->operands.emplace_back(numeric(&Parser::getOrExpression));
    in.skipWhitespace();
  } while (in.skipChar(','));
  in.skipWhitespace();
  in.matchChar(')');
  return expr;
}

up<NumericConstantExpr> Parser::seekNumericConst() {
  in.skipWhitespace();
  if (in.isFloat()) {
    return makeup<NumericConstantExpr>(in.getFloat());
  }

  return {};
}

up<StringConstantExpr> Parser::seekStringConst() {
  in.skipWhitespace();
  if (in.skipChar('"')) {
    std::string s;
    while (!in.skipChar('"') && !in.iseol()) {
      s += in.getChar();
    }
    return makeup<StringConstantExpr>(s);
  }
  return {};
}

up<Expr> Parser::seekConst() {
  if (up<Expr> numConst = seekNumericConst()) {
    return numConst;
  }

  if (up<Expr> strConst = seekStringConst()) {
    return strConst;
  }

  return {};
}

up<Expr> Parser::seekDataVar() {
  in.skipWhitespace();
  if (!in.peekKeyword(keywords) && in.isAlpha()) {
    std::string name;
    name += in.getChar();
    if (!in.peekKeyword(keywords) && in.isAlnum()) {
      name += in.getChar();
    }
    while (!in.peekKeyword(keywords) && in.isAlnum()) {
      in.getChar();
    }

    in.skipWhitespace();
    auto expr = in.skipChar('$') ? up<Expr>(makeup<StringVariableExpr>(name))
                                 : up<Expr>(makeup<NumericVariableExpr>(name));

    in.skipWhitespace();
    if (in.isChar('(')) {
      in.die("input/data variable must not be an array");
    }

    return expr;
  }
  return {};
}

up<Expr> Parser::seekVarOrArray() {
  in.skipWhitespace();
  if (!in.peekKeyword(keywords) && in.isAlpha()) {
    std::string name;
    name += in.getChar();
    if (!in.peekKeyword(keywords) && in.isAlnum()) {
      name += in.getChar();
    }
    while (!in.peekKeyword(keywords) && in.isAlnum()) {
      in.getChar();
    }

    in.skipWhitespace();
    if (in.skipChar('$')) {
      in.skipWhitespace();
      if (in.isChar('(')) {
        auto arrexpr = makeup<StringArrayExpr>();
        arrexpr->varexp = makeup<StringVariableExpr>(name);
        in.skipWhitespace();
        arrexpr->indices = getArrayIndices();
        return arrexpr;
      }
      return makeup<StringVariableExpr>(name);

    } else {
      if (in.isChar('(')) {
        auto arrexpr = makeup<NumericArrayExpr>();
        arrexpr->varexp = makeup<NumericVariableExpr>(name);
        in.skipWhitespace();
        arrexpr->indices = getArrayIndices();
        return arrexpr;
      }
      return makeup<NumericVariableExpr>(name);
    }
  }
  return {};
}

up<Expr> Parser::seekParenthetical() {
  in.skipWhitespace();
  if (!in.skipChar('(')) {
    return {};
  }
  auto expr = getOrExpression();
  in.skipWhitespace();
  in.matchChar(')');
  return expr;
}

up<NumericExpr> Parser::numeric(up<Expr> expr) {
  auto *nexpr = expr->numExpr();

  if (!nexpr) {
    in.die("numeric expression expected");
  }

  static_cast<void>(expr.release());
  return up<NumericExpr>(nexpr);
}

up<NumericExpr> Parser::numeric(up<Expr> (Parser::*expr)()) {
  int savecol = in.getColumn();
  up<Expr> e = (this->*expr)();
  auto *nexpr = e->numExpr();

  if (!nexpr) {
    in.setColumn(savecol);
    in.die("numeric expression expected");
  }

  static_cast<void>(e.release());
  return up<NumericExpr>(nexpr);
}

up<StringExpr> Parser::string(up<Expr> expr) {
  auto *sexpr = expr->strExpr();
  if (!sexpr) {
    in.die("string expression expected");
  }

  static_cast<void>(expr.release());
  return up<StringExpr>(sexpr);
}

up<StringExpr> Parser::string(up<Expr> (Parser::*expr)()) {
  int savecol = in.getColumn();
  up<Expr> e = (this->*expr)();
  auto *sexpr = e->strExpr();
  if (!sexpr) {
    in.setColumn(savecol);
    in.die("string expression expected");
  }
  static_cast<void>(e.release());
  return up<StringExpr>(sexpr);
}

up<Expr> Parser::matchTypes(Expr *lhs, up<Expr> (Parser::*expr)()) {
  int savecol = in.getColumn();
  up<Expr> rhs = (this->*expr)();

  if ((lhs->isString() && !rhs->isString()) ||
      (!lhs->isString() && rhs->isString())) {
    in.setColumn(savecol);
    in.die("type mismatch");
  }
  return rhs;
}

up<NumericVariableExpr> Parser::getIterationVar() {
  in.skipWhitespace();
  if (!in.peekKeyword(keywords) && in.isAlpha()) {
    std::string name;
    name += in.getChar();
    if (!in.peekKeyword(keywords) && in.isAlnum()) {
      name += in.getChar();
    }
    while (!in.peekKeyword(keywords) && in.isAlnum()) {
      in.getChar();
    }

    in.skipWhitespace();

    if (in.isChar('$')) {
      in.die("iteration variable must be numeric");
    }

    auto expr = makeup<NumericVariableExpr>(name);

    in.skipWhitespace();

    if (in.isChar('(')) {
      in.die("iteration variable must not be an array");
    }

    return expr;
  }
  return {};
}

std::string Parser::getNumericArrayName() {

  in.skipWhitespace();
  if (in.peekKeyword(keywords) && !in.isAlpha()) {
    in.die("array name expected");
    return {};
  }

  std::string name;
  name += in.getChar();
  if (!in.peekKeyword(keywords) && in.isAlnum()) {
    name += in.getChar();
  }
  while (!in.peekKeyword(keywords) && in.isAlnum()) {
    in.getChar();
  }

  in.skipWhitespace();

  if (in.isChar('$')) {
    in.die("array name must be numeric");
  }

  return name;
}

up<Expr> Parser::getVarOrArray() {
  if (auto expr = seekVarOrArray()) {
    return expr;
  }

  in.die("variable or array expected");
  return {};
}

up<Expr> Parser::getParenthetical() {
  in.skipWhitespace();
  in.matchChar('(');
  up<Expr> expr = getOrExpression();
  in.skipWhitespace();
  in.matchChar(')');
  in.skipWhitespace();
  return expr;
}

up<Expr> Parser::getPrimitive() {
  if (auto expr = seekParenthetical()) {
    return expr;
  }

  if (auto expr = seekConst()) {
    return expr;
  }

  if (auto expr = seekVarOrArray()) {
    return expr;
  }

  in.die("constant, variable, or array expected");
  return {};
}

up<Expr> Parser::getSgnFunction() {
  auto e = makeup<SgnExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getIntFunction() {
  auto e = makeup<IntExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getAbsFunction() {
  auto e = makeup<AbsExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getRndFunction() {
  auto e = makeup<RndExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getSqrFunction() {
  auto e = makeup<SqrExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getLogFunction() {
  auto e = makeup<LogExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getExpFunction() {
  auto e = makeup<ExpExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getSinFunction() {
  auto e = makeup<SinExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getCosFunction() {
  auto e = makeup<CosExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getTanFunction() {
  auto e = makeup<TanExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getPeekFunction() {
  auto e = makeup<PeekExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getLenFunction() {
  auto e = makeup<LenExpr>();
  e->expr = string(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getStrFunction() {
  auto e = makeup<StrExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getValFunction() {
  auto e = makeup<ValExpr>();
  e->expr = string(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getAscFunction() {
  auto e = makeup<AscExpr>();
  e->expr = string(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getChrFunction() {
  auto e = makeup<ChrExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

up<Expr> Parser::getPointFunction() {
  auto point = makeup<PointExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  point->x = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  point->y = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return point;
}

up<Expr> Parser::getLeftFunction() {
  auto left = makeup<LeftExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  left->str = up<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  left->len = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return left;
}

up<Expr> Parser::getRightFunction() {
  up<RightExpr> right = makeup<RightExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  right->str = up<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  right->len = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return right;
}

up<Expr> Parser::getMidFunction() {
  up<MidExpr> mid = makeup<MidExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  mid->str = up<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  mid->start = numeric(&Parser::getOrExpression);
  if (in.skipChar(',')) {
    mid->len = numeric(&Parser::getOrExpression);
  }
  in.matchChar(')');
  return mid;
}

up<Expr> Parser::unimplementedExpressionKeyword() {
  in.die("unimplemented keyword: \"%s\"", keywords[in.lastKeyID()]);
  return nullptr;
}

up<Expr> Parser::unexpectedExpressionKeyword() {
  in.die("unexpected keyword: \"%s\"", keywords[in.lastKeyID()]);
  return nullptr;
}

up<Expr> Parser::getFunction() {
  return !in.peekKeyword(keywords) ? getPrimitive()
         : skipKeyword("SGN")      ? getSgnFunction()
         : skipKeyword("INT")      ? getIntFunction()
         : skipKeyword("ABS")      ? getAbsFunction()
         : skipKeyword("RND")      ? getRndFunction()
         : skipKeyword("SQR")      ? getSqrFunction()
         : skipKeyword("LOG")      ? getLogFunction()
         : skipKeyword("EXP")      ? getExpFunction()
         : skipKeyword("SIN")      ? getSinFunction()
         : skipKeyword("COS")      ? getCosFunction()
         : skipKeyword("TAN")      ? getTanFunction()
         : skipKeyword("PEEK")     ? getPeekFunction()
         : skipKeyword("LEN")      ? getLenFunction()
         : skipKeyword("STR$")     ? getStrFunction()
         : skipKeyword("VAL")      ? getValFunction()
         : skipKeyword("ASC")      ? getAscFunction()
         : skipKeyword("CHR$")     ? getChrFunction()
         : skipKeyword("LEFT$")    ? getLeftFunction()
         : skipKeyword("RIGHT$")   ? getRightFunction()
         : skipKeyword("MID$")     ? getMidFunction()
         : skipKeyword("POINT")    ? getPointFunction()
         : skipKeyword("MEM")      ? (makeup<MemExpr>())
         : skipKeyword("INKEY$")   ? (makeup<InkeyExpr>())
         : skipKeyword("USR")      ? unimplementedExpressionKeyword()
         : skipKeyword("VARPTR")   ? unimplementedExpressionKeyword()
                                   : unexpectedExpressionKeyword();
}

up<Expr> Parser::getPowerExpression() {
  up<Expr> expr = getFunction();

  if (skipKeyword("^")) {
    expr =
        makeup<PowerExpr>(numeric(mv(expr)), numeric(&Parser::getSignedFactor));
  }

  return expr;
}

up<Expr> Parser::getSignedFactor() {
  bool negate = false;

  while (skipKeyword("+") || isKeyword("-")) {
    if (skipKeyword("-")) {
      negate = !negate;
    }
  }

  up<Expr> expr = getPowerExpression();

  if (negate) {
    auto addExpr = makeup<AdditiveExpr>();
    addExpr->invoperands.emplace_back(numeric(mv(expr)));
    expr = mv(addExpr);
  }

  return expr;
}

up<Expr> Parser::getTerm() {
  up<Expr> expr = getSignedFactor();

  if (isKeyword("*") || isKeyword("/")) {
    up<MultiplicativeExpr> mulExpr =
        makeup<MultiplicativeExpr>(numeric(mv(expr)));
    while (isKeyword("*") || isKeyword("/")) {
      if (matchEitherKeyword("*", "/")) {
        mulExpr->operands.emplace_back(numeric(&Parser::getSignedFactor));
      } else {
        mulExpr->invoperands.emplace_back(numeric(&Parser::getSignedFactor));
      }
    }
    expr = mv(mulExpr);
  }

  return expr;
}

up<Expr> Parser::getAdditiveExpression() {
  up<Expr> expr = getTerm();

  if (isKeyword("+") && expr->isString()) {
    up<StringConcatenationExpr> catExpr =
        makeup<StringConcatenationExpr>(string(mv(expr)));
    while (skipKeyword("+")) {
      catExpr->operands.emplace_back(string(&Parser::getTerm));
    }
    expr = mv(catExpr);
  } else if (isKeyword("+") || isKeyword("-")) {
    up<AdditiveExpr> addExpr = makeup<AdditiveExpr>(numeric(mv(expr)));
    while (isKeyword("+") || isKeyword("-")) {
      if (matchEitherKeyword("+", "-")) {
        addExpr->operands.emplace_back(numeric(&Parser::getTerm));
      } else {
        addExpr->invoperands.emplace_back(numeric(&Parser::getTerm));
      }
    }
    expr = mv(addExpr);
  }
  return expr;
}

up<Expr> Parser::getRelationalExpression() {
  up<Expr> expr = getAdditiveExpression();

  while (skipKeyword("<>") || skipKeyword("<=") || skipKeyword(">=") ||
         skipKeyword("><") || skipKeyword("=>") || skipKeyword("=<") ||
         skipKeyword("<") || skipKeyword("=") || skipKeyword(">")) {
    const char *keyword = keywords[in.lastKeyID()];
    auto rhs = matchTypes(expr.get(), &Parser::getAdditiveExpression);
    expr = makeup<RelationalExpr>(keyword, mv(expr), mv(rhs));
  }

  return expr;
}

up<Expr> Parser::getNotExpression() {
  return skipKeyword("NOT") ? static_cast<up<Expr>>(makeup<ComplementedExpr>(
                                  numeric(&Parser::getRelationalExpression)))
                            : getRelationalExpression();
}

up<Expr> Parser::getAndExpression() {
  up<Expr> expr = getNotExpression();
  if (isKeyword("AND")) {
    auto andExpr = makeup<AndExpr>(numeric(mv(expr)));
    while (skipKeyword("AND")) {
      andExpr->operands.emplace_back(numeric(&Parser::getNotExpression));
    }
    expr = mv(andExpr);
  }
  return expr;
}

up<Expr> Parser::getOrExpression() {
  up<Expr> expr = getAndExpression();
  if (isKeyword("OR")) {
    auto orExpr = makeup<OrExpr>(numeric(mv(expr)));
    while (skipKeyword("OR")) {
      orExpr->operands.emplace_back(numeric(&Parser::getAndExpression));
    }
    expr = mv(orExpr);
  }
  in.skipWhitespace();
  return expr;
}

up<Statement> Parser::getFor() {
  auto forloop = makeup<For>();
  forloop->iter = getIterationVar();

  in.skipWhitespace();
  in.matchChar('=');
  forloop->from = numeric(&Parser::getOrExpression);
  if (!skipKeyword("TO")) {
    in.die("TO expected");
  }
  in.skipWhitespace();
  forloop->to = numeric(&Parser::getOrExpression);
  if (skipKeyword("STEP")) {
    forloop->step = numeric(&Parser::getOrExpression);
  }
  return forloop;
}

up<Statement> Parser::getGoto(bool isSub) {
  auto go = makeup<Go>();
  go->isSub = isSub;
  go->lineNumber = getLineNumber();
  return go;
}

up<Statement> Parser::getRem() {
  auto rem = makeup<Rem>();
  rem->comment = in.peekLine();
  while (!in.iseol()) {
    in.getChar();
  }
  return rem;
}

up<Statement> Parser::getIf() {
  auto ifthen = makeup<If>();

  ifthen->predicate = numeric(&Parser::getOrExpression);

  if (skipKeyword("GOTO")) {
    ifthen->consequent.emplace_back(getGoto(false));
  } else if (skipKeyword("THEN")) {
    in.skipWhitespace();
    if (in.iseol()) {
      return ifthen;
    } else if (in.isDecimalWord()) {
      ifthen->consequent.emplace_back(getGoto(false));
    } else {
      ifthen->consequent.emplace_back(getStatement());
    }
  } else {
    in.die("THEN or GOTO expected");
  }

  in.skipWhitespace();
  while (!in.iseol()) {
    in.matchChar(':');
    in.skipWhitespace();
    if (!in.iseol() && !in.isChar(':')) {
      ifthen->consequent.emplace_back(getStatement());
      in.skipWhitespace();
    }
  }
  return ifthen;
}

up<Statement> Parser::getData() {
  auto data = makeup<Data>();
  do {
    if (auto record = seekStringConst()) {
      data->records.emplace_back(mv(record));
    } else {
      data->records.emplace_back(getUnquotedDataRecord());
    }
    in.skipWhitespace();
  } while (in.skipChar(','));

  return data;
}

up<Statement> Parser::getPrint(bool isLPrint) {
  auto print = makeup<Print>(isLPrint);

  bool needsCR = true;

  in.skipWhitespace();
  if (!isLPrint && in.skipChar('@')) {
    print->at = numeric(&Parser::getOrExpression);
    in.skipWhitespace();
    if (!in.iseol() && !in.isChar(':')) {
      in.matchChar(',');
      in.skipWhitespace();
      needsCR = false;
    }
  }

  while (!in.iseol() && !in.isChar(':')) {
    needsCR = true;
    if (skipKeyword("TAB(")) {
      print->printExpr.emplace_back(
          makeup<PrintTabExpr>(numeric(&Parser::getOrExpression)));
      in.matchChar(')');
      needsCR = false;
    } else if (in.skipChar(',')) {
      print->printExpr.emplace_back(makeup<PrintCommaExpr>());
    } else if (in.skipChar(';')) {
      needsCR = false;
    } else {
      up<Expr> exp = getOrExpression();
      if (exp->isString()) {
        print->printExpr.emplace_back(string(mv(exp)));
      } else {
        up<StrExpr> se = makeup<StrExpr>();
        se->expr = numeric(mv(exp));
        print->printExpr.emplace_back(mv(se));
        print->printExpr.emplace_back(makeup<PrintSpaceExpr>());
      }
    }
    in.skipWhitespace();
  }

  if (needsCR) {
    print->printExpr.emplace_back(makeup<PrintCRExpr>());
  }

  return print;
}

up<Statement> Parser::getInput() {
  auto input = makeup<Input>();
  up<StringConstantExpr> prompt;

  if (auto prompt = seekStringConst()) {
    input->prompt = mv(prompt);
    in.skipWhitespace();
    in.matchChar(';');
  }

  do {
    input->variables.emplace_back(getVarOrArray());
    in.skipWhitespace();
  } while (in.skipChar(','));

  return input;
}

up<Statement> Parser::getEnd() {
  in.skipWhitespace();
  return makeup<End>();
}

up<Statement> Parser::getError(uint8_t errorCode) {
  auto error = makeup<Error>();
  error->errorCode = makeup<NumericConstantExpr>(errorCode);
  return error;
}

up<Statement> Parser::getOn() {
  auto on = makeup<On>();
  on->branchIndex = numeric(&Parser::getOrExpression);

  on->isSub = skipKeyword("GOSUB");
  if (on->isSub || skipKeyword("GOTO")) {
    do {
      in.skipWhitespace();
      on->branchTable.push_back(getLineNumber());
      in.skipWhitespace();
    } while (in.skipChar(','));
  } else {
    in.die("GOTO or GOSUB expected");
  }
  return on;
}

up<Statement> Parser::getNext() {
  auto next = makeup<Next>();
  up<NumericVariableExpr> iter;
  if (!in.iseol() && !in.isChar(':')) {
    do {
      next->variables.emplace_back(getIterationVar());
      in.skipWhitespace();
    } while (in.skipChar(','));
  }
  return next;
}

up<Statement> Parser::getDim() {
  auto dim = makeup<Dim>();
  do {
    dim->variables.emplace_back(getVarOrArray());
    in.skipWhitespace();
  } while (in.skipChar(','));
  return dim;
}

up<Statement> Parser::getRead() {
  auto read = makeup<Read>();
  in.skipWhitespace();
  do {
    read->variables.emplace_back(getVarOrArray());
    in.skipWhitespace();
  } while (in.skipChar(','));
  return read;
}

up<Statement> Parser::getLet() {
  auto lhs = getVarOrArray();
  in.skipWhitespace();
  in.matchChar('=');
  auto rhs = matchTypes(lhs.get(), &Parser::getOrExpression);
  return makeup<Let>(mv(lhs), mv(rhs));
}

up<Statement> Parser::getRun() {
  auto run = makeup<Run>();
  in.skipWhitespace();
  run->hasLineNumber = !in.iseol() && !in.isChar(':');
  if (run->hasLineNumber) {
    run->lineNumber = getLineNumber();
  }
  return run;
}

up<Statement> Parser::getRestore() {
  in.skipWhitespace();
  return makeup<Restore>();
}

up<Statement> Parser::getReturn() {
  in.skipWhitespace();
  return makeup<Return>();
}

up<Statement> Parser::getStop() {
  in.skipWhitespace();
  return makeup<Stop>();
}

up<Statement> Parser::getPoke() {
  auto poke = makeup<Poke>();

  in.skipWhitespace();
  poke->dest = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  poke->val = numeric(&Parser::getOrExpression);

  return poke;
}

up<Statement> Parser::getClear() {
  auto clear = makeup<Clear>();
  in.skipWhitespace();
  if (!in.iseol() && !in.isChar(':')) {
    clear->size = numeric(&Parser::getOrExpression);
    in.skipWhitespace();
    if (!in.iseol() && in.skipChar(',')) {
      clear->address = numeric(&Parser::getOrExpression);
    }
  }
  return clear;
}

up<Statement> Parser::getCLoad() {
  in.skipWhitespace();
  if (in.skipChar('*')) {
    auto cloadStar = makeup<CLoadStar>();
    cloadStar->arrayName = getNumericArrayName();
    in.skipWhitespace();
    if (in.skipChar(',')) {
      in.skipWhitespace();
      cloadStar->filename = string(&Parser::getOrExpression);
    }
    return cloadStar;
  }

  if (in.skipChar('M')) {
    in.skipWhitespace();
    auto cloadM = makeup<CLoadM>();
    if (!in.iseol() && !in.isChar(':')) {
      cloadM->filename = string(&Parser::getOrExpression);
      in.skipWhitespace();
      if (in.skipChar(',')) {
        cloadM->offset = numeric(&Parser::getOrExpression);
      }
    }
    return cloadM;
  }

  unimplementedKeyword();
  return {};
}

up<Statement> Parser::getCSave() {
  auto csaveStar = makeup<CSaveStar>();
  in.skipWhitespace();
  if (in.isChar('M')) {
    in.die("CSAVEM not yet supported");
  }
  in.matchChar('*');
  csaveStar->arrayName = getNumericArrayName();
  in.skipWhitespace();
  if (in.skipChar(',')) {
    in.skipWhitespace();
    csaveStar->filename = string(&Parser::getOrExpression);
  }

  return csaveStar;
}

up<Statement> Parser::getSet() {
  auto set = makeup<Set>();
  in.skipWhitespace();
  in.matchChar('(');
  set->x = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  set->y = numeric(&Parser::getOrExpression);
  if (in.skipChar(',')) {
    set->c = numeric(&Parser::getOrExpression);
  }
  in.matchChar(')');
  in.skipWhitespace();
  return set;
}

up<Statement> Parser::getReset() {
  auto reset = makeup<Reset>();
  in.skipWhitespace();
  in.matchChar('(');
  reset->x = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  reset->y = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  in.skipWhitespace();
  return reset;
}

up<Statement> Parser::getCls() {
  auto cls = makeup<Cls>();
  in.skipWhitespace();
  if (!in.iseol() && !in.isChar(':')) {
    cls->color = numeric(&Parser::getOrExpression);
  }
  return cls;
}

up<Statement> Parser::getSound() {
  auto sound = makeup<Sound>();

  in.skipWhitespace();
  sound->pitch = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  sound->duration = numeric(&Parser::getOrExpression);
  return sound;
}

up<Statement> Parser::getExec() {
  if (!options.mcode.isEnabled()) {
    in.sputter(
        "error: machine code invocation without '-mcode' compiler flag.");
    fprintf(stderr, "\n");
    fprintf(stderr, "Sic hunt dracones!\n\n");
    fprintf(stderr, "Most MICROCOLOR BASIC programs that use machine code "
                    "assume the use of the MICROCOLOR BASIC interpreter.\n");
    fprintf(stderr, "These programs often:\n");
    fprintf(stderr, " - expect the BASIC code to reside within its original "
                    "memory location.\n");
    fprintf(stderr, " - expect variables to be formatted identically to "
                    "MICROCOLOR BASIC.\n");
    fprintf(
        stderr,
        " - expect variables to be present in a specific memory location.\n");
    fprintf(stderr, " - expect certain areas of memory to be free for use.\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "EXEC will (usually) work with the compiler if the machine "
                    "code it invokes:\n");
    fprintf(
        stderr,
        " - does not assume the MICROCOLOR BASIC interpreter is running.\n");
    fprintf(stderr, " - is located well beyond the string storage area.\n");
    fprintf(
        stderr,
        " - does not clobber direct page registers used by the compiler.\n\n");
    fprintf(
        stderr,
        "Also, to allow repeated invocation of a compiled program via EXEC, "
        "a design decision was made to:\n");
    fprintf(stderr,
            " - prevent EXEC from clobbering the default EXEC address.\n");
    fprintf(stderr, " - always require EXEC calls to provide an address.\n");
    fprintf(stderr, "\n");
    fprintf(stderr,
            "Should you still wish to traverse these treacherous waters...\n");
    fprintf(stderr, "you can enable machine code by adding the '-mcode' "
                    "command line option.\n\n");
    exit(1);
  }

  auto exec = makeup<Exec>();
  in.skipWhitespace();
  if (in.iseol() || in.isChar(':')) {
    in.die("the compiler requires an address when invoking EXEC");
  }

  exec->address = numeric(&Parser::getOrExpression);
  return exec;
}

up<Statement> Parser::unexpectedKeyword() {
  in.die("unexpected keyword: \"%s\"", keywords[in.lastKeyID()]);
  return {};
}

up<Statement> Parser::unimplementedKeyword() {
  in.die("unimplemented keyword: \"%s\"", keywords[in.lastKeyID()]);
  return {};
}

up<Statement> Parser::getStatement() {
  do {
    in.skipWhitespace();
  } while (in.skipChar(':'));

  return in.skipChar('?')            ? getPrint(false)
         : !in.peekKeyword(keywords) ? getLet()
         : skipKeyword("FOR")        ? getFor()
         : skipKeyword("GOTO")       ? getGoto(false)
         : skipKeyword("GOSUB")      ? getGoto(true)
         : skipKeyword("REM")        ? getRem()
         : skipKeyword("IF")         ? getIf()
         : skipKeyword("DATA")       ? getData()
         : skipKeyword("PRINT")      ? getPrint(false)
         : skipKeyword("ON")         ? getOn()
         : skipKeyword("INPUT")      ? getInput()
         : skipKeyword("END")        ? getEnd()
         : skipKeyword("NEXT")       ? getNext()
         : skipKeyword("DIM")        ? getDim()
         : skipKeyword("READ")       ? getRead()
         : skipKeyword("LET")        ? getLet()
         : skipKeyword("RUN")        ? getRun()
         : skipKeyword("RESTORE")    ? getRestore()
         : skipKeyword("RETURN")     ? getReturn()
         : skipKeyword("STOP")       ? getStop()
         : skipKeyword("POKE")       ? getPoke()
         : skipKeyword("CLEAR")      ? getClear()
         : skipKeyword("CLOAD")      ? getCLoad()
         : skipKeyword("CSAVE")      ? getCSave()
         : skipKeyword("LPRINT")     ? getPrint(true)
         : skipKeyword("SET")        ? getSet()
         : skipKeyword("RESET")      ? getReset()
         : skipKeyword("CLS")        ? getCls()
         : skipKeyword("SOUND")      ? getSound()
         : skipKeyword("EXEC")       ? getExec()
         : isKeyword("NEW")          ? unimplementedKeyword()
         : isKeyword("LLIST")        ? unimplementedKeyword()
         : isKeyword("LIST")         ? unimplementedKeyword()
                                     : unexpectedKeyword();
}

void Parser::getLine(Program &p) {
  in.skipWhitespace();

  if (in.iseol()) {
    return;
  }

  if (in.peekKeyword(keywords) && skipKeyword("REM")) {
    return;
  }

  auto line = makeup<Line>();
  line->lineNumber = getLineNumber();

  do {
    in.skipWhitespace();
  } while (in.skipChar(':'));

  while (!in.iseol()) {
    line->statements.emplace_back(getStatement());
    in.skipWhitespace();
    if (!in.iseol()) {
      in.matchChar(':');
    }
  }
  p.lines.emplace_back(mv(line));
}

void Parser::getEndLines(Program &p) {
  auto line = makeup<Line>();
  line->lineNumber = constants::lastLineNumber;
  line->statements.emplace_back(getEnd());
  p.lines.emplace_back(mv(line));

  if (options.ul.isEnabled()) {
    line = makeup<Line>();
    line->lineNumber = constants::unlistedLineNumber;
    line->statements.emplace_back(getError(constants::ULError));
    p.lines.emplace_back(mv(line));
  }
}

Program Parser::parse() {
  Program p;
  while (in.getLine()) {
    getLine(p);
  }
  getEndLines(p);
  cleanupLines(p);

  return p;
}

void Parser::cleanupLines(Program &p) {
  struct {
    bool operator()(const up<Line> &a, const up<Line> &b) const {
      return a->lineNumber < b->lineNumber;
    }
  } linecmp;

  std::stable_sort(p.lines.begin(), p.lines.end(), linecmp);

  auto itLine = p.lines.begin();
  if (itLine != p.lines.end()) {
    auto itOldLine = itLine;
    while (++itLine != p.lines.end()) {
      if (!linecmp(*itOldLine, *itLine)) {
        Announcer announcer(options.Wduplicate);
        announcer.start((*itLine)->lineNumber);
        announcer.finish("removed duplicate line");
        itLine = p.lines.erase(itOldLine);
      }
      itOldLine = itLine;
    }
  }
}
