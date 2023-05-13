// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_OPTIMIZER_HPP
#define OPTIMIZER_OPTIMIZER_HPP

#include "ast/program.hpp"
#include "ast/text.hpp"
#include "mcbasic/clioptions.hpp"

// given the program AST, calls all optimizations
// builds final data table, constant table, and symbol table (variables/arrays)

class Optimizer {
public:
  explicit Optimizer(const CLIOptions &opts) : options(opts) {}

  Text optimize(Program &p);

private:
  const CLIOptions &options;
};

#endif
