// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_PROGRAM_HPP
#define AST_PROGRAM_HPP

#include "statement.hpp"

// For simplicity, use a single non-const void visitor
class Line;
class Program;

class ProgramOp {
public:
  ProgramOp() = default;
  ProgramOp(const ProgramOp &) = delete;
  ProgramOp(ProgramOp &&) = delete;
  ProgramOp &operator=(const ProgramOp &) = delete;
  ProgramOp &operator=(ProgramOp &&) = delete;
  virtual ~ProgramOp() = default;

  virtual void operate(Line & /*l*/){};
  virtual void operate(Program & /*p*/){};
};

class Line {
public:
  int lineNumber;
  std::vector<up<Statement>> statements;
  void operate(ProgramOp *op) { op->operate(*this); }
};

class Program {
public:
  std::vector<up<Line>> lines;
  void operate(ProgramOp *op) { op->operate(*this); }
  void sortLines();
  void removeDuplicateLines(bool warn);
};

#endif
