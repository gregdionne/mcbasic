// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_WRITER_HPP
#define BACKEND_WRITER_HPP

#include "mcbasic/options.hpp"
#include <cstdio>
#include <string>

class Writer {
public:
  Writer(int argc_in, char *argv_in[]) : argc(argc_in), argv(argv_in) {
    init();
  }

  // opens files for output based upon command line order
  bool openNext();

  // closes current file
  void close();

  // write header
  void writeHeader();

  // writes string to output file
  void writeString(const std::string &ops);

private:
  void init();
  void processOpts();

  int argc;
  char **argv;
  int filecnt{0};
  int argcnt{0};
  Options opts;
  FILE *fp{nullptr};
};
#endif
