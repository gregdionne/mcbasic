// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "arguments.hpp"

Arguments::Arguments(int argc, const char *const argv[]) : progname(argv[0]) {
  filenames = options.parse(argc, argv);
}
