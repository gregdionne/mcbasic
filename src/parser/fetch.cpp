// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "fetch.hpp"

#include <cctype>  //isxdigit
#include <cmath>   //pow
#include <cstdarg> //va_list, va_start
#include <cstdio>  //f...
#include <cstdlib> //perror
#include <cstring> //strlen

#include <string>

#include "mcbasic/options.hpp"

#ifdef _MSC_VER
#define strncasecmp _strnicmp
#define strcasecmp _stricmp
#endif

//  This file was originally a K&R C file.
//  Then it bacame ANSI C.
//  Then it became C++ (98).
//
//  The author has given it just enough attention to survive being called
//  from classes created in C++11 and then C++14.
//
//  It could use const correctness and up<> hints.
//
//  It will then need to be modernized again in another ten years.

void fetch::init() {
  processOpts();
  if (!openNext()) {
    usage(argv);
  }
}

void fetch::processOpts() {
  argcnt = 1;
  while (argcnt < argc && (strncmp(argv[argcnt], "-", 1) == 0) &&
         (strcmp(argv[argcnt], "--") != 0)) {
    argcnt++;
  }

  if (argcnt < argc && (strcmp(argv[argcnt], "--") == 0)) {
    argcnt++;
  }
}

void fetch::spitLine() {
  if ((linenum != 0) && (argcnt != 0) && argcnt < argc) {
    fprintf(stderr, "%s(%i): %s", argv[argfile], linenum, buf);
  }
}

static std::string strEscape(std::string const &in) {
  std::string out;
  const char *in_c = in.c_str();
  const char *hex_digits = "0123456789ABCDEF";
  char c;
  while ((c = *in_c++) != 0) {
    out += c == '\t'   ? std::string("\t")
           : c == '\r' ? std::string("\r")
           : c == '\n' ? std::string("\n")
           : isprint(c) != 0 || (c & 0x80) != 0
               ? std::string(1, c)
               : std::string("\\x") + hex_digits[(c & 0xf0) >> 4] +
                     hex_digits[c & 0x0f];
  }
  return out;
}

void fetch::sputter(const char *formatstr, va_list &vl) {

  if ((linenum != 0) && (argcnt != 0) && argfile < argc) {
    int len = fprintf(stderr, "%s(%i): ", argv[argfile], linenum);
    fprintf(stderr, "%s", strEscape(buf).c_str());
    for (int i = 0; i < len + colnum; i++) {
      fprintf(stderr, " ");
    }
    fprintf(stderr, "^\n");
  }
  vfprintf(stderr, formatstr, vl);
  fprintf(stderr, "\n");
}

void fetch::sputter(const char *formatstr, ...) {
  va_list vl;
  va_start(vl, formatstr);
  sputter(formatstr, vl);
  va_end(vl);
}

void fetch::die(const char *formatstr, ...) {
  va_list vl;
  va_start(vl, formatstr);
  sputter(formatstr, vl);
  va_end(vl);
  exit(1);
}

bool fetch::openNext() {
  if (argcnt < argc) {
    fp = fopen(argv[argcnt], "r");
    if (!fp) {
      fprintf(stderr, "%s: ", argv[0]);
      perror(argv[argcnt]);
      exit(1);
    }
    argfile = argcnt;
    argcnt++;
    return true;
  }
  argcnt = 0;
  return false;
}

// convert CR or CRLF terminations to LF
char *fetch::efgets(char *str, int bufsiz, FILE *stream) {
  int c = getc(stream);
  if (c == EOF) {
    return nullptr;
  }

  int n = 0;
  while (c != EOF && c != '\n' && c != '\r' && n < bufsiz - 1) {
    str[n++] = static_cast<char>(c);
    c = getc(stream);
  }

  if (c == EOF) {
    str[n] = '\0';
    return str;
  }

  if (n == bufsiz - 1) {
    ungetc(c, stream);
    str[n] = '\0';
    return str;
  }

  str[n++] = '\n';
  str[n] = '\0';

  // if a CR-LF, discard the LF.
  if (c == '\r') {
    c = getc(stream);
    if (c != '\n') {
      ungetc(c, stream);
    }
  }

  return str;
}

char *fetch::getFileLine() {
  if (!efgets(buf, BUFSIZ, fp)) {
    fclose(fp);
    linenum = 0;
    return nullptr;
  }

  if (fp) {
    ++linenum;
    linelen = static_cast<int>(strlen(buf));
    colnum = 0;
  }
  return buf;
}

char *fetch::getLine() {
  while (!efgets(buf, BUFSIZ, fp)) {
    fclose(fp);
    linenum = 0;
    if (!openNext()) {
      return nullptr;
    }
  }

  if (fp) {
    ++linenum;
    linelen = static_cast<int>(strlen(buf));
    colnum = 0;
  }
  return buf;
}

void fetch::expandTabs(char *b, int m, int n) {
  int i = 0;
  while ((b[i] != 0) && b[i] != '\t') {
    ++i;
  }

  if (b[i] == '\t') {
    b[i] = ' ';
    expandTabs(b + i + 1, m + n - i % n, n);
  }

  do {
    b[i + m] = b[i];
  } while ((i--) != 0);

  while (m != 0) {
    b[--m] = ' ';
  }
}

void fetch::expandTabs(int n) { expandTabs(buf, 0, n); }

bool fetch::isWhitespace() {
  char c = buf[colnum];
  return c == ' ' || c == '\t';
}

bool fetch::skipWhitespace() {
  bool flag = isWhitespace();
  while (isWhitespace()) {
    ++colnum;
  }
  return flag;
}

void fetch::matchWhitespace() {
  if (!isWhitespace()) {
    die("whitespace expected");
  }
  skipWhitespace();
}

bool fetch::iseol() {
  char c = buf[colnum];
  return c == '\n' || c == '\r' || c == '\0';
}

bool fetch::isBlankLine() {
  int savecol = colnum;
  skipWhitespace();
  bool isblank = iseol();
  colnum = savecol;
  return isblank;
}

void fetch::matcheol() {
  skipWhitespace();
  if (!iseol()) {
    die("unexpected characters at end of line");
  }
}

char fetch::prevChar() {
  if (colnum == 0) {
    die("internal error: prevChar() called at start of line");
  }
  return buf[colnum - 1];
}

char fetch::peekChar() { return buf[colnum]; }

bool fetch::skipChar(char c) {
  if (c != buf[colnum]) {
    return false;
  }
  colnum++;
  return true;
}

char fetch::getChar() {
  char c = peekChar();
  if (!iseol()) {
    ++colnum;
  }
  return c;
}

void fetch::ungetChar() {
  if (colnum != 0) {
    --colnum;
  }
}

void fetch::matchChar(char c) {
  if (c != buf[colnum]) {
    die("\"%c\" expected", c);
  }
  ++colnum;
}

bool fetch::isChar(char c) { return c == buf[colnum]; }

bool fetch::isAlpha() { return isalpha(buf[colnum]) != 0; }

bool fetch::isAlnum() { return isalnum(buf[colnum]) != 0; }

char *fetch::peekLine() { return &buf[colnum]; }

void fetch::advance(int n) { colnum += n; }

bool fetch::peekKeyword(const char *const keywords[]) {
  for (int i = 0; keywords[i]; i++) {
    if (strncasecmp(keywords[i], peekLine(), strlen(keywords[i])) == 0) {
      keyID = i;
      return true;
    }
  }
  return false;
}

bool fetch::skipKeyword(const char *const keywords[]) {
  bool flag = peekKeyword(keywords);

  if (flag) {
    advance(static_cast<int>(strlen(keywords[keyID])));
  }

  return flag;
}

static int isbdigit(int c) { return static_cast<int>(c == '0' || c == '1'); }

static int digit(int c) { return c - '0'; }

static int xdigit(int c) {
  return 'a' <= c && c <= 'f'   ? c - 'a' + 10
         : 'A' <= c && c <= 'F' ? c - 'A' + 10
                                : digit(c);
}

bool fetch::isNumber(int (*id)(int), int (*d)(int), int m, int limit) {
  int saveColnum = colnum;
  int c = peekChar();
  int x = 0;

  if (id(c) == 0) {
    return false;
  }

  while (id(c) != 0) {
    x *= m;
    x += d(c);
    if (x > limit) {
      colnum = saveColnum;
      return false;
    }
    advance(1);
    c = peekChar();
  }
  colnum = saveColnum;
  return true;
}

bool fetch::isBinaryByte() { return isNumber(isbdigit, digit, 2, 0xff); }

bool fetch::isDecimalByte() { return isNumber(isdigit, digit, 10, 0xff); }

bool fetch::isHexadecimalByte() { return isNumber(isxdigit, digit, 10, 0xff); }

bool fetch::isBinaryWord() { return isNumber(isbdigit, digit, 2, 0xffff); }

bool fetch::isDecimalWord() { return isNumber(isdigit, digit, 10, 0xffff); }

bool fetch::isHexadecimalWord() {
  return isNumber(isxdigit, xdigit, 16, 0xffff);
}

int fetch::getNumber(int (*id)(int), int (*d)(int), int m, int limit,
                     const char *errmsg) {
  int c = peekChar();
  int x = 0;

  if (id(c) == 0) {
    die(errmsg);
  }

  while (id(c) != 0) {
    x *= m;
    x += d(c);
    if (x > limit) {
      die(limit == 0xff ? "Value too big to fit in one byte"
                        : "Value too big to fit in two bytes");
    }
    advance(1);
    c = peekChar();
  }
  return x;
}

int fetch::getBinaryByte() {
  return getNumber(isbdigit, digit, 2, 0xff, "binary digit expected");
}

int fetch::getBinaryWord() {
  return getNumber(isbdigit, digit, 2, 0xffff, "binary digit expected");
}

int fetch::getDecimalByte() {
  return getNumber(isdigit, digit, 10, 0xff, "decimal digit expected");
}

int fetch::getDecimalWord() {
  return getNumber(isdigit, digit, 10, 0xffff, "decimal digit expected");
}

int fetch::getHexadecimalByte() {
  return getNumber(isxdigit, xdigit, 16, 0xff, "hexadecimal digit expected");
}

int fetch::getHexadecimalWord() {
  return getNumber(isxdigit, xdigit, 16, 0xffff, "hexdecimal digit expected");
}

bool fetch::isBasicFloat() {
  int c = peekChar();
  return (isdigit(c) != 0) || c == '.';
}

double fetch::getBasicFloat() {
  double v = 0;
  int c = peekChar();
  while (isdigit(c) != 0) {
    v = v * 10 + c - '0';
    advance(1);
    c = peekChar();
  }

  if (c == '.') {
    double f = 0;
    double m = 1;
    advance(1);
    c = peekChar();
    while (isdigit(c) != 0) {
      f = f * 10 + c - '0';
      m = m * 10;
      advance(1);
      c = peekChar();
    }
    v += f / m;
  }

  if (c == 'E') {
    advance(1);
    c = peekChar();
    int sgn = 1;
    while (c == '-' || c == '+') {
      if (c == '-') {
        sgn = -sgn;
      }
      advance(1);
      c = peekChar();
    }
    if (!isdigit(c)) {
      die("Exponent expected");
    }
    double e = getDecimalWord();
    v *= std::pow(10, sgn * e);
  }

  return v;
}
