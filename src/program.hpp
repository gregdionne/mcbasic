// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef PROGRAM_HPP
#define PROGRAM_HPP

#include "consttable.hpp"
#include "datatable.hpp"
#include "statement.hpp"
#include "symboltable.hpp"

// For simplicity, use a single non-const void visitor
class Line;
class Program;

class ProgramOp {
public:
  virtual void operate(Line & /*l*/){};
  virtual void operate(Program & /*p*/){};
};

class Line {
public:
  int lineNumber;
  std::vector<std::unique_ptr<Statement>> statements;
  void operate(ProgramOp *op) { op->operate(*this); }
};

class Program {
public:
  std::vector<std::unique_ptr<Line>> lines;
  void operate(ProgramOp *op) { op->operate(*this); }
  void sortlines();
};

#endif
