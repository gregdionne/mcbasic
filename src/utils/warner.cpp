// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#include "warner.hpp"

#include <stdarg.h>
#include <stdio.h>

void Warner::start(int lineNumber) const {
  if (warn) {
    fprintf(stderr, "%s: line %i: ", flag.c_str(), lineNumber);
  }
}

void Warner::say(const char *formatstr, ...) const {
  va_list vl;
  if (warn) {
    va_start(vl, formatstr);
    vfprintf(stderr, formatstr, vl);
  }
}

void Warner::finish(const char *formatstr, ...) const {
  va_list vl;
  if (warn) {
    va_start(vl, formatstr);
    vfprintf(stderr, formatstr, vl);
    fprintf(stderr, "\n");
  }
}
