// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_ARGUMENTS_HPP
#define MCBASIC_ARGUMENTS_HPP

#include "clioptions.hpp"

struct Arguments {
  Arguments(int argc, const char *const argv[]);
  const char *progname;
  std::vector<const char *> filenames;
  CLIOptions options;
};

#endif
