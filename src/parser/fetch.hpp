// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef PARSER_FETCH_HPP
#define PARSER_FETCH_HPP

//  This file was originally a K&R C file.
//  Then it bacame ANSI C.
//  Then it became C++ (98).
//
//  The author has given it just enough attention to survive being called
//  from classes created in C++11 and then C++14.
//
//  It could use const correctness.
//
//  It will then need to be modernized again in another ten years.

#include <cstdarg>
#include <cstdio>

class fetch {
public:
  fetch(int argc_in, char *argv_in[]) : argc(argc_in), argv(argv_in) { init(); }

  int currentArgNum() const { return argfile; }
  void processOpts();
  bool openNext();
  char *getFileLine();
  char *getLine();
  void spitLine();
  void sputter(const char *formatstr, va_list &vl);
  void sputter(const char *formatstr, ...);
  void die(const char *formatstr, ...);
  void expandTabs(int n);
  bool isWhitespace();
  bool skipWhitespace();
  void matchWhitespace();
  bool iseol();
  bool isBlankLine();
  void matcheol();
  char prevChar();
  char peekChar();
  bool skipChar(char c);
  char getChar();
  void ungetChar();
  void matchChar(char c);
  bool isChar(char c);
  bool isAlpha();
  bool isAlnum();
  char *peekLine();
  void advance(int n);
  bool peekKeyword(const char *const keywords[]);
  bool skipKeyword(const char *const keywords[]);
  bool isNumber(int (*id)(int), int (*d)(int), int m, int limit);
  bool isBinaryByte();
  bool isDecimalByte();
  bool isHexadecimalByte();
  bool isBinaryWord();
  bool isDecimalWord();
  bool isHexadecimalWord();
  int getNumber(int (*id)(int), int (*d)(int), int m, int limit,
                const char *errmsg);
  int getBinaryByte();
  int getBinaryWord();
  int getHexadecimalByte();
  int getHexadecimalWord();
  int getDecimalByte();
  int getDecimalWord();
  bool isBasicFloat();
  double getBasicFloat();
  // accessors
  int lastKeyID() const { return keyID; }
  int getColumn() const { return colnum; }
  void setColumn(int n) { colnum = n; }

private:
  void init();
  char *efgets(char *str, int bufsiz, FILE *stream);
  void expandTabs(char *b, int m, int n);

  char buf[BUFSIZ];
  int argc;
  char **argv;
  int argcnt{0};
  int argfile{0};
  int linenum{0};
  int linelen{0};
  int colnum{0};
  int keyID{0};
  FILE *fp{nullptr};
};
#endif
