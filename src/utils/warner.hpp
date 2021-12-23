// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef UTILS_WARNER_HPP
#define UTILS_WARNER_HPP

#include <string>

class Warner {
public:
  Warner(bool w, const char *f) : warn(w), flag(f) {}

  void start(int lineNumber) const;
  void say(const char *formatstr, ...) const;
  void finish(const char *formatstr, ...) const;

private:
  const bool warn;
  const std::string flag;
};

#endif
