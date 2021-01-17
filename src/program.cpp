// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "program.hpp"

#include <algorithm>

void Program::sortlines() {
  struct {
    bool operator()(std::unique_ptr<Line> &a, std::unique_ptr<Line> &b) const {
      return a->lineNumber < b->lineNumber;
    }
  } linecmp;

  std::sort(lines.begin(), lines.end(), linecmp);
}
