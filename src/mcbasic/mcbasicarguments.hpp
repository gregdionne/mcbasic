// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_MCBASICARGUMENTS_HPP
#define MCBASIC_MCBASICARGUMENTS_HPP

#include "mcbasicclioptions.hpp"

struct MCBASICArguments {
  MCBASICArguments(int argc, const char *const argv[]);
  const char *progname;
  std::vector<const char *> filenames;
  MCBASICCLIOptions options;
};

#endif
