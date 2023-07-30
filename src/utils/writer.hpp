// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef UTILS_WRITER_HPP
#define UTILS_WRITER_HPP

#include "mcbasic/clioptions.hpp"
#include <cstdio>
#include <string>

class Writer {
public:
  Writer(const char *p, const char *f, const CLIOptions &opts)
      : progname(p), filename(f), options(opts) {}

  void write(const std::string &ops);

private:
  void open();
  void close();
  void writeHeader();
  void writeString(const std::string &ops);

  const char *progname;
  const char *filename;
  const CLIOptions &options;

  FILE *fp{nullptr};
};
#endif
