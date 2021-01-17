// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef WRITER_HPP
#define WRITER_HPP

#include "options.hpp"
#include <stdio.h>
#include <string>

class Writer {
public:
  int argc;
  char **argv;
  int filecnt;
  int argcnt;
  Writer(int argc_in, char *argv_in[])
      : argc(argc_in), argv(argv_in), filecnt(0) {
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

  Options opts;
  FILE *fp;
};
#endif
