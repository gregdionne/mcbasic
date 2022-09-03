// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef UTILS_ANNOUNCER_HPP
#define UTILS_ANNOUNCER_HPP

#include "mcbasic/option.hpp"

#include <string>

class Announcer {
public:
  explicit Announcer(const Option &opt) : option(opt) {}

  void start(int lineNumber) const;
  void say(const char *formatstr, ...) const;
  void finish(const char *formatstr, ...) const;

private:
  const Option &option;
};

#endif
