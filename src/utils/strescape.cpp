// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "strescape.hpp"

std::string strEscapeTASM(std::string const &in) {
  std::string out;
  const char *in_c = in.c_str();
  const char *hex_digits = "0123456789ABCDEF";
  char c;
  while ((c = *in_c++) != 0) {
    out += c == '"'    ? std::string("\\\"")
           : c == '\t' ? std::string("\\t")
           : c == '\n' ? std::string("\\n")
           : c == '\r' ? std::string("\\r")
           : c == '\\' ? std::string("\\\\")
           : isprint(c) != 0
               ? std::string(1, c)
               : std::string("\\x") + hex_digits[(c & 0xf0) >> 4] +
                     hex_digits[c & 0x0f];
  }
  return out;
}

std::string strEscapeLIST(std::string const &in) {
  std::string out;
  const char *in_c = in.c_str();
  const char *hex_digits = "0123456789ABCDEF";
  char c;
  while ((c = *in_c++) != 0) {
    out += c == '"'    ? std::string("\\\"")
           : c == '\t' ? std::string("\\t")
           : c == '\n' ? std::string("\\n")
           : c == '\r' ? std::string("\\r")
           : c == '\\' ? std::string("\\\\")
           : isprint(c) != 0 || (c & 0x80) != 0
               ? std::string(1, c)
               : std::string("\\x") + hex_digits[(c & 0xf0) >> 4] +
                     hex_digits[c & 0x0f];
  }
  return out;
}
