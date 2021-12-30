// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#include "announcer.hpp"

#include <stdarg.h>
#include <stdio.h>

void Announcer::start(int lineNumber) const {
  if (warn) {
    fprintf(stderr, "%s: line %i: ", flag.c_str(), lineNumber);
  }
}

void Announcer::say(const char *formatstr, ...) const {
  va_list vl;
  if (warn) {
    va_start(vl, formatstr);
    vfprintf(stderr, formatstr, vl);
  }
}

void Announcer::finish(const char *formatstr, ...) const {
  va_list vl;
  if (warn) {
    va_start(vl, formatstr);
    vfprintf(stderr, formatstr, vl);
    fprintf(stderr, "\n");
  }
}
