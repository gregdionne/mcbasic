// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "parser.hpp"
#include "mcbasic/constants.hpp"

#include <cstring>

//  This file was originally a K&R C file.
//  Then it bacame ANSI C.
//  Then it became C++ (98).
//
//  The author has given it just enough attention to survive being called
//  from classes created in C++11 and then C++14.
//
//  It could use more const correctness and std::unique_ptr<> hints.
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
  return in.peekKeyword(keywords) && (strcmp(keywords[in.keyID], keyword) == 0);
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
    if (!emptyLineNumbers) {
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

std::unique_ptr<StringConstantExpr> Parser::getUnquotedDataRecord() {
  std::string s;
  in.skipWhitespace();
  while (!in.isChar(',') && !in.iseol()) {
    s += in.getChar();
  }
  return std::make_unique<StringConstantExpr>(s);
}

std::unique_ptr<ArrayIndicesExpr> Parser::getArrayIndices() {
  in.skipWhitespace();
  in.matchChar('(');
  std::unique_ptr<ArrayIndicesExpr> expr = std::make_unique<ArrayIndicesExpr>();
  do {
    expr->operands.emplace_back(numeric(&Parser::getOrExpression));
    in.skipWhitespace();
  } while (in.skipChar(','));
  in.skipWhitespace();
  in.matchChar(')');
  return expr;
}

std::unique_ptr<NumericConstantExpr> Parser::seekNumericConst() {
  in.skipWhitespace();
  if (in.isBasicFloat()) {
    return std::make_unique<NumericConstantExpr>(in.getBasicFloat());
  }

  return std::unique_ptr<NumericConstantExpr>();
}

std::unique_ptr<StringConstantExpr> Parser::seekStringConst() {
  in.skipWhitespace();
  if (in.skipChar('"')) {
    std::string s;
    while (!in.skipChar('"') && !in.iseol()) {
      s += in.getChar();
    }
    return std::make_unique<StringConstantExpr>(s);
  }
  return std::unique_ptr<StringConstantExpr>();
}

std::unique_ptr<Expr> Parser::seekConst() {
  if (std::unique_ptr<Expr> numConst = seekNumericConst()) {
    return numConst;
  }

  if (std::unique_ptr<Expr> strConst = seekStringConst()) {
    return strConst;
  }

  return std::unique_ptr<Expr>();
}

std::unique_ptr<Expr> Parser::seekDataVar() {
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
    auto expr =
        in.skipChar('$')
            ? std::unique_ptr<Expr>(std::make_unique<StringVariableExpr>(name))
            : std::unique_ptr<Expr>(
                  std::make_unique<NumericVariableExpr>(name));

    in.skipWhitespace();
    if (in.isChar('(')) {
      in.die("input/data variable must not be an array");
    }

    return expr;
  }
  return std::unique_ptr<Expr>();
}

std::unique_ptr<Expr> Parser::seekVarOrArray() {
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
        auto arrexpr = std::make_unique<StringArrayExpr>();
        arrexpr->varexp = std::make_unique<StringVariableExpr>(name);
        in.skipWhitespace();
        arrexpr->indices = getArrayIndices();
        return arrexpr;
      } else {
        return std::make_unique<StringVariableExpr>(name);
      }
    } else {
      if (in.isChar('(')) {
        auto arrexpr = std::make_unique<NumericArrayExpr>();
        arrexpr->varexp = std::make_unique<NumericVariableExpr>(name);
        in.skipWhitespace();
        arrexpr->indices = getArrayIndices();
        return arrexpr;
      } else {
        return std::make_unique<NumericVariableExpr>(name);
      }
    }
  }
  return std::unique_ptr<Expr>();
}

std::unique_ptr<Expr> Parser::seekParenthetical() {
  in.skipWhitespace();
  if (!in.skipChar('(')) {
    return std::unique_ptr<Expr>();
  }
  auto expr = getOrExpression();
  in.skipWhitespace();
  in.matchChar(')');
  return expr;
}

std::unique_ptr<NumericExpr> Parser::numeric(std::unique_ptr<Expr> expr) {
  auto *nexpr = dynamic_cast<NumericExpr *>(expr.get());

  if (nexpr == nullptr) {
    in.die("numeric expression expected");
  }

  static_cast<void>(expr.release());
  return std::unique_ptr<NumericExpr>(nexpr);
}

std::unique_ptr<NumericExpr>
Parser::numeric(std::unique_ptr<Expr> (Parser::*expr)()) {
  int savecol = in.colnum;
  std::unique_ptr<Expr> e = (this->*expr)();
  auto *nexpr = dynamic_cast<NumericExpr *>(e.get());

  if (nexpr == nullptr) {
    in.colnum = savecol;
    in.die("numeric expression expected");
  }

  static_cast<void>(e.release());
  return std::unique_ptr<NumericExpr>(nexpr);
}

std::unique_ptr<StringExpr> Parser::string(std::unique_ptr<Expr> expr) {
  auto *sexpr = dynamic_cast<StringExpr *>(expr.get());
  if (sexpr == nullptr) {
    in.die("string expression expected");
  }

  static_cast<void>(expr.release());
  return std::unique_ptr<StringExpr>(sexpr);
}

std::unique_ptr<StringExpr>
Parser::string(std::unique_ptr<Expr> (Parser::*expr)()) {
  int savecol = in.colnum;
  std::unique_ptr<Expr> e = (this->*expr)();
  auto *sexpr = dynamic_cast<StringExpr *>(e.get());
  if (sexpr == nullptr) {
    in.colnum = savecol;
    in.die("numeric expression expected");
  }
  static_cast<void>(e.release());
  return std::unique_ptr<StringExpr>(sexpr);
}

std::unique_ptr<Expr>
Parser::matchTypes(Expr *lhs, std::unique_ptr<Expr> (Parser::*expr)()) {
  int savecol = in.colnum;
  std::unique_ptr<Expr> rhs = (this->*expr)();

  if ((lhs->isString() && !rhs->isString()) ||
      (!lhs->isString() && rhs->isString())) {
    in.colnum = savecol;
    in.die("type mismatch");
  }
  return rhs;
}

std::unique_ptr<NumericVariableExpr> Parser::getIterationVar() {
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

    auto expr = std::make_unique<NumericVariableExpr>(name);

    in.skipWhitespace();

    if (in.isChar('(')) {
      in.die("iteration variable must not be an array");
    }

    return expr;
  }
  return std::unique_ptr<NumericVariableExpr>();
}

std::unique_ptr<Expr> Parser::getVarOrArray() {
  if (auto expr = seekVarOrArray()) {
    return expr;
  }

  in.die("variable or array expected");
  return std::unique_ptr<Expr>();
}

std::unique_ptr<Expr> Parser::getParenthetical() {
  in.skipWhitespace();
  in.matchChar('(');
  std::unique_ptr<Expr> expr = getOrExpression();
  in.skipWhitespace();
  in.matchChar(')');
  in.skipWhitespace();
  return expr;
}

std::unique_ptr<Expr> Parser::getPrimitive() {
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
  return std::unique_ptr<Expr>();
}

std::unique_ptr<Expr> Parser::getSgnFunction() {
  auto e = std::make_unique<SgnExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getIntFunction() {
  auto e = std::make_unique<IntExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getAbsFunction() {
  auto e = std::make_unique<AbsExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getRndFunction() {
  auto e = std::make_unique<RndExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getSqrFunction() {
  auto e = std::make_unique<SqrExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getLogFunction() {
  auto e = std::make_unique<LogExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getExpFunction() {
  auto e = std::make_unique<ExpExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getSinFunction() {
  auto e = std::make_unique<SinExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getCosFunction() {
  auto e = std::make_unique<CosExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getTanFunction() {
  auto e = std::make_unique<TanExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getPeekFunction() {
  auto e = std::make_unique<PeekExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getLenFunction() {
  auto e = std::make_unique<LenExpr>();
  e->expr = string(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getStrFunction() {
  auto e = std::make_unique<StrExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getValFunction() {
  auto e = std::make_unique<ValExpr>();
  e->expr = string(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getAscFunction() {
  auto e = std::make_unique<AscExpr>();
  e->expr = string(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getChrFunction() {
  auto e = std::make_unique<ChrExpr>();
  e->expr = numeric(&Parser::getParenthetical);
  return e;
}

std::unique_ptr<Expr> Parser::getPointFunction() {
  auto point = std::make_unique<PointExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  point->x = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  point->y = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return point;
}

std::unique_ptr<Expr> Parser::getLeftFunction() {
  auto left = std::make_unique<LeftExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  left->str = std::unique_ptr<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  left->len = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return left;
}

std::unique_ptr<Expr> Parser::getRightFunction() {
  std::unique_ptr<RightExpr> right = std::make_unique<RightExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  right->str = std::unique_ptr<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  right->len = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return right;
}

std::unique_ptr<Expr> Parser::getMidFunction() {
  std::unique_ptr<MidExpr> mid = std::make_unique<MidExpr>();
  in.skipWhitespace();
  in.matchChar('(');
  mid->str = std::unique_ptr<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  mid->start = numeric(&Parser::getOrExpression);
  if (in.skipChar(',')) {
    mid->len = numeric(&Parser::getOrExpression);
  }
  in.matchChar(')');
  return mid;
}

std::unique_ptr<Expr> Parser::unimplementedKeywordExpression() {
  in.die("unimplemented keyword: \"%s\"", keywords[in.keyID]);
  return nullptr;
}

std::unique_ptr<Expr> Parser::getFunction() {
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
         : skipKeyword("MEM")      ? (std::make_unique<MemExpr>())
         : skipKeyword("INKEY$")   ? (std::make_unique<InkeyExpr>())
                                   : unimplementedKeywordExpression();
}

std::unique_ptr<Expr> Parser::getPowerExpression() {
  std::unique_ptr<Expr> expr = getFunction();

  if (skipKeyword("^")) {
    expr = std::make_unique<PowerExpr>(numeric(std::move(expr)),
                                       numeric(&Parser::getSignedFactor));
  }

  return expr;
}

std::unique_ptr<Expr> Parser::getSignedFactor() {
  bool negate = false;

  while (skipKeyword("+") || isKeyword("-")) {
    if (skipKeyword("-")) {
      negate = !negate;
    }
  }

  return negate ? std::make_unique<NegatedExpr>(
                      numeric(&Parser::getPowerExpression))
                : getPowerExpression();
}

std::unique_ptr<Expr> Parser::getTerm() {
  std::unique_ptr<Expr> expr = getSignedFactor();

  if (isKeyword("*") || isKeyword("/")) {
    std::unique_ptr<MultiplicativeExpr> mulExpr =
        std::make_unique<MultiplicativeExpr>(numeric(std::move(expr)));
    while (isKeyword("*") || isKeyword("/")) {
      if (matchEitherKeyword("*", "/")) {
        mulExpr->operands.emplace_back(numeric(&Parser::getSignedFactor));
      } else {
        mulExpr->invoperands.emplace_back(numeric(&Parser::getSignedFactor));
      }
    }
    expr = std::move(mulExpr);
  }

  return expr;
}

std::unique_ptr<Expr> Parser::getAdditiveExpression() {
  std::unique_ptr<Expr> expr = getTerm();

  if (isKeyword("+") && expr->isString()) {
    std::unique_ptr<StringConcatenationExpr> catExpr =
        std::make_unique<StringConcatenationExpr>(string(std::move(expr)));
    while (skipKeyword("+")) {
      catExpr->operands.emplace_back(string(&Parser::getTerm));
    }
    expr = std::move(catExpr);
  } else if (isKeyword("+") || isKeyword("-")) {
    std::unique_ptr<AdditiveExpr> addExpr =
        std::make_unique<AdditiveExpr>(numeric(std::move(expr)));
    while (isKeyword("+") || isKeyword("-")) {
      if (matchEitherKeyword("+", "-")) {
        addExpr->operands.emplace_back(numeric(&Parser::getTerm));
      } else {
        addExpr->invoperands.emplace_back(numeric(&Parser::getTerm));
      }
    }
    expr = std::move(addExpr);
  }
  return expr;
}

std::unique_ptr<Expr> Parser::getRelationalExpression() {
  std::unique_ptr<Expr> expr = getAdditiveExpression();

  while (skipKeyword("<>") || skipKeyword("<=") || skipKeyword(">=") ||
         skipKeyword("><") || skipKeyword("=>") || skipKeyword("=<") ||
         skipKeyword("<") || skipKeyword("=") || skipKeyword(">")) {
    const char *keyword = keywords[in.keyID];
    auto rhs = matchTypes(expr.get(), &Parser::getAdditiveExpression);
    expr = std::make_unique<RelationalExpr>(keyword, std::move(expr),
                                            std::move(rhs));
  }

  return expr;
}

std::unique_ptr<Expr> Parser::getNotExpression() {
  return skipKeyword("NOT") ? static_cast<std::unique_ptr<Expr>>(
                                  std::make_unique<ComplementedExpr>(numeric(
                                      &Parser::getRelationalExpression)))
                            : getRelationalExpression();
}

std::unique_ptr<Expr> Parser::getAndExpression() {
  std::unique_ptr<Expr> expr = getNotExpression();
  if (isKeyword("AND")) {
    auto andExpr = std::make_unique<AndExpr>(numeric(std::move(expr)));
    while (skipKeyword("AND")) {
      andExpr->operands.emplace_back(numeric(&Parser::getNotExpression));
    }
    expr = std::move(andExpr);
  }
  return expr;
}

std::unique_ptr<Expr> Parser::getOrExpression() {
  std::unique_ptr<Expr> expr = getAndExpression();
  if (isKeyword("OR")) {
    auto orExpr = std::make_unique<OrExpr>(numeric(std::move(expr)));
    while (skipKeyword("OR")) {
      orExpr->operands.emplace_back(numeric(&Parser::getAndExpression));
    }
    expr = std::move(orExpr);
  }
  in.skipWhitespace();
  return expr;
}

std::unique_ptr<Statement> Parser::getFor() {
  auto forloop = std::make_unique<For>();
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

std::unique_ptr<Statement> Parser::getGoto(bool isSub) {
  auto go = std::make_unique<Go>();
  go->isSub = isSub;
  go->lineNumber = getLineNumber();
  return go;
}

std::unique_ptr<Statement> Parser::getRem() {
  auto rem = std::make_unique<Rem>();
  rem->comment = in.peekLine();
  while (!in.iseol()) {
    in.getChar();
  }
  return rem;
}

std::unique_ptr<Statement> Parser::getIf() {
  auto ifthen = std::make_unique<If>();

  ifthen->predicate = numeric(&Parser::getOrExpression);

  if (skipKeyword("GOTO")) {
    ifthen->consequent.emplace_back(getGoto(false));
  } else if (skipKeyword("THEN")) {
    in.skipWhitespace();
    if (in.isDecimalWord()) {
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

std::unique_ptr<Statement> Parser::getData() {
  auto data = std::make_unique<Data>();
  do {
    if (auto record = seekStringConst()) {
      data->records.emplace_back(std::move(record));
    } else {
      data->records.emplace_back(getUnquotedDataRecord());
    }
    in.skipWhitespace();
  } while (in.skipChar(','));

  return data;
}

std::unique_ptr<Statement> Parser::getPrint() {
  auto print = std::make_unique<Print>();

  bool needsCR = true;

  in.skipWhitespace();
  if (in.skipChar('@')) {
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
          std::make_unique<PrintTabExpr>(numeric(&Parser::getOrExpression)));
      in.matchChar(')');
      needsCR = false;
    } else if (in.skipChar(',')) {
      print->printExpr.emplace_back(std::make_unique<PrintCommaExpr>());
    } else if (in.skipChar(';')) {
      needsCR = false;
    } else {
      std::unique_ptr<Expr> exp = getOrExpression();
      if (exp->isString()) {
        print->printExpr.emplace_back(string(std::move(exp)));
      } else {
        std::unique_ptr<StrExpr> se = std::make_unique<StrExpr>();
        se->expr = numeric(std::move(exp));
        print->printExpr.emplace_back(std::move(se));
        print->printExpr.emplace_back(std::make_unique<PrintSpaceExpr>());
      }
    }
    in.skipWhitespace();
  }

  if (needsCR) {
    print->printExpr.emplace_back(std::make_unique<PrintCRExpr>());
  }

  return print;
}

std::unique_ptr<Statement> Parser::getInput() {
  auto input = std::make_unique<Input>();
  std::unique_ptr<StringConstantExpr> prompt;

  if (auto prompt = seekStringConst()) {
    input->prompt = std::move(prompt);
    in.skipWhitespace();
    in.matchChar(';');
  }

  do {
    input->variables.emplace_back(getVarOrArray());
    in.skipWhitespace();
  } while (in.skipChar(','));

  return input;
}

std::unique_ptr<Statement> Parser::getEnd() {
  in.skipWhitespace();
  return std::make_unique<End>();
}

std::unique_ptr<Statement> Parser::getError(uint8_t errorCode) {
  auto error = std::make_unique<Error>();
  error->errorCode = std::make_unique<NumericConstantExpr>(errorCode);
  return error;
}

std::unique_ptr<Statement> Parser::getOn() {
  auto on = std::make_unique<On>();
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

std::unique_ptr<Statement> Parser::getNext() {
  auto next = std::make_unique<Next>();
  std::unique_ptr<NumericVariableExpr> iter;
  if (!in.iseol() && !in.isChar(':')) {
    do {
      next->variables.emplace_back(getIterationVar());
      in.skipWhitespace();
    } while (in.skipChar(','));
  }
  return next;
}

std::unique_ptr<Statement> Parser::getDim() {
  auto dim = std::make_unique<Dim>();
  do {
    dim->variables.emplace_back(getVarOrArray());
    in.skipWhitespace();
  } while (in.skipChar(','));
  return dim;
}

std::unique_ptr<Statement> Parser::getRead() {
  auto read = std::make_unique<Read>();
  in.skipWhitespace();
  do {
    read->variables.emplace_back(getVarOrArray());
    in.skipWhitespace();
  } while (in.skipChar(','));
  return read;
}

std::unique_ptr<Statement> Parser::getLet() {
  auto lhs = getVarOrArray();
  in.skipWhitespace();
  in.matchChar('=');
  auto rhs = matchTypes(lhs.get(), &Parser::getOrExpression);
  return std::make_unique<Let>(std::move(lhs), std::move(rhs));
}

std::unique_ptr<Statement> Parser::getRun() {
  auto run = std::make_unique<Run>();
  in.skipWhitespace();
  run->hasLineNumber = !in.iseol() && !in.isChar(':');
  if (run->hasLineNumber) {
    run->lineNumber = getLineNumber();
  }
  return run;
}

std::unique_ptr<Statement> Parser::getRestore() {
  in.skipWhitespace();
  return std::make_unique<Restore>();
}

std::unique_ptr<Statement> Parser::getReturn() {
  in.skipWhitespace();
  return std::make_unique<Return>();
}

std::unique_ptr<Statement> Parser::getStop() {
  in.skipWhitespace();
  return std::make_unique<Stop>();
}

std::unique_ptr<Statement> Parser::getPoke() {
  auto poke = std::make_unique<Poke>();

  in.skipWhitespace();
  poke->dest = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  poke->val = numeric(&Parser::getOrExpression);

  return poke;
}

std::unique_ptr<Statement> Parser::getClear() {
  auto clear = std::make_unique<Clear>();
  in.skipWhitespace();
  if (!in.iseol() && !in.isChar(':')) {
    clear->size = numeric(&Parser::getOrExpression);
  }
  return clear;
}

std::unique_ptr<Statement> Parser::getSet() {
  auto set = std::make_unique<Set>();
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

std::unique_ptr<Statement> Parser::getReset() {
  auto reset = std::make_unique<Reset>();
  in.skipWhitespace();
  in.matchChar('(');
  reset->x = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  reset->y = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  in.skipWhitespace();
  return reset;
}

std::unique_ptr<Statement> Parser::getCls() {
  auto cls = std::make_unique<Cls>();
  in.skipWhitespace();
  if (!in.iseol() && !in.isChar(':')) {
    cls->color = numeric(&Parser::getOrExpression);
  }
  return cls;
}

std::unique_ptr<Statement> Parser::getSound() {
  auto sound = std::make_unique<Sound>();

  in.skipWhitespace();
  sound->pitch = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  sound->duration = numeric(&Parser::getOrExpression);
  return sound;
}

std::unique_ptr<Statement> Parser::getExec() {
  if (!enableMachineCode) {
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
    exit(0);
  }

  auto exec = std::make_unique<Exec>();
  in.skipWhitespace();
  if (in.iseol() || in.isChar(':')) {
    in.die("the compiler requires an address when invoking EXEC");
  }

  exec->address = numeric(&Parser::getOrExpression);
  return exec;
}

std::unique_ptr<Statement> Parser::unimplementedKeyword() {
  in.die("unimplemented keyword: \"%s\"", keywords[in.keyID]);
  return std::unique_ptr<Statement>();
}

std::unique_ptr<Statement> Parser::getStatement() {
  do {
    in.skipWhitespace();
  } while (in.skipChar(':'));

  return in.skipChar('?')            ? getPrint()
         : !in.peekKeyword(keywords) ? getLet()
         : skipKeyword("FOR")        ? getFor()
         : skipKeyword("GOTO")       ? getGoto(false)
         : skipKeyword("GOSUB")      ? getGoto(true)
         : skipKeyword("REM")        ? getRem()
         : skipKeyword("IF")         ? getIf()
         : skipKeyword("DATA")       ? getData()
         : skipKeyword("PRINT")      ? getPrint()
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
         : skipKeyword("SET")        ? getSet()
         : skipKeyword("RESET")      ? getReset()
         : skipKeyword("CLS")        ? getCls()
         : skipKeyword("SOUND")      ? getSound()
         : skipKeyword("EXEC")       ? getExec()
                                     : unimplementedKeyword();
}

void Parser::getLine(Program &p) {
  in.skipWhitespace();
  if (in.iseol()) {
    return;
  }

  auto line = std::make_unique<Line>();
  line->lineNumber = getLineNumber();

  while (!in.iseol()) {
    line->statements.emplace_back(getStatement());
    in.skipWhitespace();
    if (!in.iseol()) {
      in.matchChar(':');
    }
  }
  p.lines.emplace_back(std::move(line));
}

void Parser::getEndLines(Program &p) {
  auto line = std::make_unique<Line>();
  line->lineNumber = constants::lastLineNumber;
  line->statements.emplace_back(getEnd());
  p.lines.emplace_back(std::move(line));

  if (unlistedLineNumbers) {
    line = std::make_unique<Line>();
    line->lineNumber = constants::unlistedLineNumber;
    line->statements.emplace_back(getError(constants::ULError));
    p.lines.emplace_back(std::move(line));
  }
}

Program Parser::parse() {
  Program p;
  while (in.getFileLine() != nullptr) {
    getLine(p);
  }
  getEndLines(p);
  return p;
}
