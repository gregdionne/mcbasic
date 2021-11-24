// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef WARNER_HPP
#define WARNER_HPP

#include <string>

class Warner {
public:
  Warner(bool w, const char *f) : warn(w), flag(f) {}

  void start(int lineNumber);
  void say(const char *formatstr, ...);
  void finish(const char *formatstr, ...);

private:
  bool warn;
  std::string flag;
};

#endif
