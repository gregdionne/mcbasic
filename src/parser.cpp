// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "parser.hpp"

#include "string.h"

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
  if (!in.isDecimalWord()) {
    in.die("line number expected");
  }
  int lineNumber = in.getDecimalWord();
  in.skipWhitespace();
  return lineNumber;
}

bool Parser::seekNumericConst(Expr *&expr) {
  in.skipWhitespace();
  if (in.isBasicFloat()) {
    expr = new NumericConstantExpr(in.getBasicFloat());
    in.skipWhitespace();
    return true;
  }

  return false;
}

std::string Parser::getString() {
  std::string s;
  in.matchChar('"');
  while (!in.skipChar('"') && !in.iseol()) {
    s += in.getChar();
  }
  in.skipWhitespace();
  return s;
}

bool Parser::seekStringConst(StringConstantExpr *&expr) {
  in.skipWhitespace();
  if (in.isChar('"')) {
    expr = new StringConstantExpr(getString());
    return true;
  }
  return false;
}

bool Parser::seekStringConst(Expr *&expr) {
  StringConstantExpr *sexpr;
  if (seekStringConst(sexpr)) {
    expr = sexpr;
    return true;
  }

  return false;
}

std::string Parser::getDataRecord() {
  std::string s;
  while (!in.isChar(',') && !in.iseol()) {
    s += in.getChar();
  }
  return s;
}

bool Parser::seekDataRecord(StringConstantExpr *&expr) {
  in.skipWhitespace();
  expr = new StringConstantExpr(getDataRecord());
  return true;
}

bool Parser::seekConst(Expr *&expr) {
  return seekNumericConst(expr) || seekStringConst(expr);
}

ArrayIndicesExpr *Parser::getArrayIndices() {
  in.skipWhitespace();
  in.matchChar('(');
  ArrayIndicesExpr *expr = new ArrayIndicesExpr();
  do {
    expr->append(numeric(&Parser::getOrExpression));
  } while (in.skipChar(','));
  in.matchChar(')');
  in.skipWhitespace();
  return expr;
}

bool Parser::seekDataVar(Expr *&expr) {
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
      expr = new StringVariableExpr(name);
    } else {
      expr = new NumericVariableExpr(name);
    }

    in.skipWhitespace();

    if (in.isChar('(')) {
      in.die("input/data variable must not be an array");
    }

    return true;
  }
  return false;
}

bool Parser::seekIterationVar(NumericVariableExpr *&expr) {
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

    expr = new NumericVariableExpr(name);

    in.skipWhitespace();

    if (in.isChar('(')) {
      in.die("iteration variable must not be an array");
    }

    return true;
  }
  return false;
}

bool Parser::seekVar(Expr *&expr) {
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

    expr = in.skipChar('$')
               ? static_cast<Expr *>(new StringVariableExpr(name))
               : static_cast<Expr *>(new NumericVariableExpr(name));

    in.skipWhitespace();

    if (in.isChar('(')) {
      expr = expr->makeArray(getArrayIndices());
    }
    in.skipWhitespace();

    return true;
  }
  return false;
}

bool Parser::seekParenthetical(Expr *&expr) {
  in.skipWhitespace();
  if (!in.skipChar('(')) {
    return false;
  }
  expr = getOrExpression();
  in.matchChar(')');
  in.skipWhitespace();
  return true;
}

std::unique_ptr<NumericExpr> Parser::numeric(Expr *expr) {
  NumericExpr *nexpr = dynamic_cast<NumericExpr *>(expr);

  if (expr->isString() || (nexpr == nullptr)) {
    in.die("ooo numeric expression expected");
  }

  return std::unique_ptr<NumericExpr>(nexpr);
}

std::unique_ptr<NumericExpr> Parser::numeric(Expr *(Parser::*expr)()) {
  int savecol = in.colnum;
  Expr *e = (this->*expr)();
  NumericExpr *nexpr = dynamic_cast<NumericExpr *>(e);

  if (e->isString() || (nexpr == nullptr)) {
    in.colnum = savecol;
    in.die("numeric expression expected");
  }

  return std::unique_ptr<NumericExpr>(nexpr);
}

std::unique_ptr<StringExpr> Parser::string(Expr *expr) {
  StringExpr *sexpr = dynamic_cast<StringExpr *>(expr);
  if (!expr->isString() || (sexpr == nullptr)) {
    in.die("string expression expected");
  }

  return std::unique_ptr<StringExpr>(sexpr);
}

std::unique_ptr<StringExpr> Parser::string(Expr *(Parser::*expr)()) {
  int savecol = in.colnum;
  Expr *e = (this->*expr)();
  StringExpr *sexpr = dynamic_cast<StringExpr *>(e);
  if (!e->isString() || (sexpr == nullptr)) {
    in.colnum = savecol;
    in.die("numeric expression expected");
  }

  return std::unique_ptr<StringExpr>(sexpr);
}

Expr *Parser::matchTypes(Expr *lhs, Expr *(Parser::*expr)()) {
  int savecol = in.colnum;
  Expr *rhs = (this->*expr)();

  if ((lhs->isString() && !rhs->isString()) ||
      (!lhs->isString() && rhs->isString())) {
    in.colnum = savecol;
    in.die("type mismatch");
  }
  return rhs;
}

Expr *Parser::getParenthetical() {
  in.skipWhitespace();
  in.matchChar('(');
  Expr *expr = getOrExpression();
  in.skipWhitespace();
  in.matchChar(')');
  in.skipWhitespace();
  return expr;
}

Expr *Parser::getPrimitive() {
  Expr *expr;
  if (!seekParenthetical(expr) && !seekConst(expr) && !seekVar(expr)) {
    in.die("constant, variable, or array expected");
  }
  return expr;
}

Expr *Parser::getPointFunction() {
  PointExpr *point = new PointExpr;
  in.skipWhitespace();
  in.matchChar('(');
  point->x = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  point->y = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return point;
}

Expr *Parser::getLeftFunction() {
  LeftExpr *left = new LeftExpr;
  in.skipWhitespace();
  in.matchChar('(');
  left->str = std::unique_ptr<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  left->len = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return left;
}

Expr *Parser::getRightFunction() {
  RightExpr *right = new RightExpr;
  in.skipWhitespace();
  in.matchChar('(');
  right->str = std::unique_ptr<StringExpr>(string(&Parser::getOrExpression));
  in.matchChar(',');
  right->len = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  return right;
}

Expr *Parser::getMidFunction() {
  MidExpr *mid = new MidExpr;
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

Expr *Parser::unimplementedKeywordExpression() {
  in.die("unimplemented keyword: \"%s\"", keywords[in.keyID]);
  return nullptr;
}

Expr *Parser::getFunction() {
  return !in.peekKeyword(keywords) ? (getPrimitive())
         : skipKeyword("SGN")
             ? (new SgnExpr(numeric(&Parser::getParenthetical)))
         : skipKeyword("INT")
             ? (new IntExpr(numeric(&Parser::getParenthetical)))
         : skipKeyword("ABS")
             ? (new AbsExpr(numeric(&Parser::getParenthetical)))
         : skipKeyword("RND")
             ? (new RndExpr(numeric(&Parser::getParenthetical)))
         : skipKeyword("PEEK")
             ? (new PeekExpr(numeric(&Parser::getParenthetical)))
         : skipKeyword("LEN") ? (new LenExpr(string(&Parser::getParenthetical)))
         : skipKeyword("STR$")
             ? (new StrExpr(numeric(&Parser::getParenthetical)))
         : skipKeyword("VAL") ? (new ValExpr(string(&Parser::getParenthetical)))
         : skipKeyword("ASC") ? (new AscExpr(string(&Parser::getParenthetical)))
         : skipKeyword("CHR$")
             ? (new ChrExpr(numeric(&Parser::getParenthetical)))
         : skipKeyword("LEFT$")  ? getLeftFunction()
         : skipKeyword("RIGHT$") ? getRightFunction()
         : skipKeyword("MID$")   ? getMidFunction()
         : skipKeyword("POINT")  ? getPointFunction()
         : skipKeyword("INKEY$") ? (new InkeyExpr())
                                 : unimplementedKeywordExpression();
}

Expr *Parser::getSignedFactor() {
  bool negate = false;

  while (skipKeyword("+") || isKeyword("-")) {
    if (skipKeyword("-")) {
      negate = !negate;
    }
  }

  return negate ? new NegatedExpr(numeric(&Parser::getFunction))
                : getFunction();
}

Expr *Parser::getTerm() {
  Expr *expr = getSignedFactor();

  if (isKeyword("*") || isKeyword("/")) {
    MultiplicativeExpr *mulExpr = new MultiplicativeExpr(numeric(expr));
    while (isKeyword("*") || isKeyword("/")) {
      bool isMul = matchEitherKeyword("*", "/");
      mulExpr->append(isMul, numeric(&Parser::getSignedFactor));
    }
    expr = mulExpr;
  }

  return expr;
}

Expr *Parser::getAdditiveExpression() {
  Expr *expr = getTerm();

  if (isKeyword("+") && expr->isString()) {
    StringConcatenationExpr *catExpr =
        new StringConcatenationExpr(string(expr));
    while (skipKeyword("+")) {
      catExpr->append(string(&Parser::getTerm));
    }
    expr = catExpr;
  } else if (isKeyword("+") || isKeyword("-")) {
    AdditiveExpr *addExpr = new AdditiveExpr(numeric(expr));
    while (isKeyword("+") || isKeyword("-")) {
      bool isAdd = matchEitherKeyword("+", "-");
      addExpr->append(isAdd, numeric(&Parser::getTerm));
    }
    expr = addExpr;
  }
  return expr;
}

Expr *Parser::getRelationalExpression() {
  Expr *expr = getAdditiveExpression();

  while (skipKeyword("<>") || skipKeyword("<=") || skipKeyword(">=") ||
         skipKeyword("><") || skipKeyword("=>") || skipKeyword("=<") ||
         skipKeyword("<") || skipKeyword("=") || skipKeyword(">")) {
    expr = new RelationalExpr(keywords[in.keyID], expr,
                              matchTypes(expr, &Parser::getAdditiveExpression));
  }

  return expr;
}

Expr *Parser::getNotExpression() {
  return skipKeyword("NOT") ? static_cast<Expr *>(new ComplementedExpr(
                                  numeric(&Parser::getRelationalExpression)))
                            : getRelationalExpression();
}

Expr *Parser::getAndExpression() {
  Expr *expr = getNotExpression();
  if (isKeyword("AND")) {
    auto *andExpr = new AndExpr(numeric(expr));
    while (skipKeyword("AND")) {
      andExpr->append(numeric(&Parser::getNotExpression));
    }
    expr = andExpr;
  }
  return expr;
}

Expr *Parser::getOrExpression() {
  Expr *expr = getAndExpression();
  if (isKeyword("OR")) {
    auto *orExpr = new OrExpr(numeric(expr));
    while (skipKeyword("OR")) {
      orExpr->append(numeric(&Parser::getAndExpression));
    }
    expr = orExpr;
  }
  in.skipWhitespace();
  return expr;
}

Statement *Parser::getFor() {
  For *forloop = new For();
  NumericVariableExpr *iter;
  if (!seekIterationVar(iter)) {
    in.die("Iteration variable expected");
  }
  forloop->iter = std::unique_ptr<NumericVariableExpr>(iter);

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

Statement *Parser::getGoto(bool isSub) {
  Go *go = new Go;
  go->isSub = isSub;
  go->lineNumber = getLineNumber();
  return go;
}

Statement *Parser::getRem() {
  Rem *rem = new Rem;
  rem->comment = in.peekLine();
  while (!in.iseol()) {
    in.getChar();
  }
  return rem;
}

Statement *Parser::getIf() {
  If *ifthen = new If;

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

Statement *Parser::getData() {
  Data *data = new Data;
  StringConstantExpr *record;
  do {
    if (seekStringConst(record)) {
      data->records.emplace_back(std::unique_ptr<StringConstantExpr>(record));
    } else if (seekDataRecord(record)) {
      data->records.emplace_back(std::unique_ptr<StringConstantExpr>(record));
    } else {
      in.die("empty data record");
    }
    in.skipWhitespace();
  } while (in.skipChar(','));

  in.skipWhitespace();
  return data;
}

Statement *Parser::getPrint() {
  Print *print = new Print;

  in.skipWhitespace();
  if (in.skipChar('@')) {
    print->at = numeric(&Parser::getOrExpression);
    in.matchChar(',');
    in.skipWhitespace();
  }

  bool needsCR = true;
  while (!in.iseol() && !in.isChar(':')) {
    needsCR = true;
    if (skipKeyword("TAB(")) {
      print->append(std::unique_ptr<StringExpr>(
          new PrintTabExpr(numeric(&Parser::getOrExpression))));
      in.matchChar(')');
      needsCR = false;
    } else if (in.skipChar(',')) {
      print->append(std::unique_ptr<StringExpr>(new PrintCommaExpr()));
    } else if (in.skipChar(';')) {
      needsCR = false;
    } else {
      Expr *exp = getOrExpression();
      if (exp->isString()) {
        print->append(string(exp));
      } else {
        print->append(std::unique_ptr<StringExpr>(new StrExpr(numeric(exp))));
        print->append(std::unique_ptr<StringExpr>(new PrintSpaceExpr()));
      }
    }
    in.skipWhitespace();
  }

  if (needsCR) {
    print->printExpr.emplace_back(new PrintCRExpr());
  }

  return print;
}

Statement *Parser::getInput() {
  Input *input = new Input;
  StringConstantExpr *prompt;

  in.skipWhitespace();
  if (seekStringConst(prompt)) {
    input->prompt = std::unique_ptr<StringConstantExpr>(prompt);
    in.matchChar(';');
    in.skipWhitespace();
  }

  do {
    Expr *expr;
    if (!seekVar(expr)) {
      in.die("variable expected");
    }
    input->append(expr);
    in.skipWhitespace();
  } while (in.skipChar(','));

  return input;
}

Statement *Parser::getEnd() {
  in.skipWhitespace();
  return new End();
}

Statement *Parser::getOn() {
  On *on = new On;
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

Statement *Parser::getNext() {
  Next *next = new Next();
  NumericVariableExpr *iter;
  if (!in.iseol() && !in.isChar(':')) {
    do {
      if (!seekIterationVar(iter)) {
        in.die("Iteration variable expected");
      }
      next->appendVar(iter);
      in.skipWhitespace();
    } while (in.skipChar(','));
  }
  return next;
}

Statement *Parser::getDim() {
  Dim *dim = new Dim;
  in.skipWhitespace();
  do {
    Expr *exp;
    if (!seekVar(exp)) {
      in.die("variable or array expected");
    }
    dim->append(exp);
    in.skipWhitespace();
  } while (in.skipChar(','));
  return dim;
}

Statement *Parser::getRead() {
  Read *read = new Read;
  in.skipWhitespace();
  do {
    Expr *exp;
    if (!seekVar(exp)) {
      in.die("variable or array expected");
    }
    read->append(exp);
    in.skipWhitespace();
  } while (in.skipChar(','));
  return read;
}

Statement *Parser::getLet() {
  Expr *lhs;
  if (!seekVar(lhs)) {
    in.die("Variable expected");
  }
  in.skipWhitespace();
  in.matchChar('=');
  return new Let(lhs, matchTypes(lhs, &Parser::getOrExpression));
}

Statement *Parser::getRun() {
  Run *run = new Run;
  in.skipWhitespace();
  run->hasLineNumber = !in.iseol() && !in.isChar(':');
  if (run->hasLineNumber) {
    run->lineNumber = getLineNumber();
  }
  return run;
}

Statement *Parser::getRestore() {
  in.skipWhitespace();
  return new Restore();
}

Statement *Parser::getReturn() {
  in.skipWhitespace();
  return new Return();
}

Statement *Parser::getStop() {
  in.skipWhitespace();
  return new Stop();
}

Statement *Parser::getPoke() {
  Poke *poke = new Poke;

  in.skipWhitespace();
  poke->dest = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  poke->val = numeric(&Parser::getOrExpression);

  return poke;
}

Statement *Parser::getClear() {
  Clear *clear = new Clear;
  in.skipWhitespace();
  if (!in.iseol() && !in.isChar(':')) {
    clear->size = numeric(&Parser::getOrExpression);
  }
  return clear;
}

Statement *Parser::getSet() {
  Set *set = new Set;
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

Statement *Parser::getReset() {
  Reset *reset = new Reset;
  in.skipWhitespace();
  in.matchChar('(');
  reset->x = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  reset->y = numeric(&Parser::getOrExpression);
  in.matchChar(')');
  in.skipWhitespace();
  return reset;
}

Statement *Parser::getCls() {
  Cls *cls = new Cls;
  in.skipWhitespace();
  if (!in.iseol() && !in.isChar(':')) {
    cls->color = numeric(&Parser::getOrExpression);
  }
  return cls;
}

Statement *Parser::getSound() {
  Sound *sound = new Sound;

  in.skipWhitespace();
  sound->pitch = numeric(&Parser::getOrExpression);
  in.matchChar(',');
  sound->duration = numeric(&Parser::getOrExpression);
  return sound;
}

Statement *Parser::unimplementedKeyword() {
  in.die("unimplemented keyword: \"%s\"", keywords[in.keyID]);
  return nullptr;
}

Statement *Parser::getStatement() {
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
                                     : unimplementedKeyword();
}

void Parser::getLine(Program &p) {
  in.skipWhitespace();
  if (in.iseol()) {
    return;
  }

  Line *line = new Line;
  line->lineNumber = getLineNumber();

  while (!in.iseol()) {
    line->statements.emplace_back(getStatement());
    if (!in.iseol()) {
      in.matchChar(':');
    }
  }
  p.lines.emplace_back(line);
}

void Parser::getEndLine(Program &p) {
  Line *line = new Line;
  line->lineNumber = 65535;
  line->statements.emplace_back(getEnd());
  p.lines.emplace_back(line);
}

Program Parser::parse() {
  Program p;
  while (in.getFileLine() != nullptr) {
    getLine(p);
  }
  getEndLine(p);
  return p;
}
