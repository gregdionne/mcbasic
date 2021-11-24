// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "program.hpp"

#include <algorithm>

void Program::sortLines() {
  struct {
    bool operator()(const std::unique_ptr<Line> &a,
                    const std::unique_ptr<Line> &b) const {
      return a->lineNumber < b->lineNumber;
    }
  } linecmp;

  std::stable_sort(lines.begin(), lines.end(), linecmp);
}

void Program::removeDuplicateLines(bool warn) {
  auto itLine = lines.begin();
  if (itLine != lines.end()) {
    auto itOldLine = itLine;
    while (++itLine != lines.end()) {
      if ((*itLine)->lineNumber == (*itOldLine)->lineNumber) {
        if (warn) {
          fprintf(stderr, "Warning: removed duplicate line %i\n",
                  (*itOldLine)->lineNumber);
        }
        itLine = lines.erase(itOldLine);
      }
      itOldLine = itLine;
    }
  }
}
