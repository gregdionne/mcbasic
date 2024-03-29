// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_OPTIMIZER_HPP
#define OPTIMIZER_OPTIMIZER_HPP

#include "ast/program.hpp"
#include "ast/text.hpp"
#include "mcbasic/mcbasicclioptions.hpp"

// given the program AST, calls all optimizations
// builds final data table, constant table, and symbol table (variables/arrays)

class Optimizer {
public:
  explicit Optimizer(const MCBASICCLIOptions &opts) : options(opts) {}

  Text optimize(Program &p);

private:
  const MCBASICCLIOptions &options;
};

#endif
