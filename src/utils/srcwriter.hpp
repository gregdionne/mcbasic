// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef UTILS_SRCWRITER_HPP
#define UTILS_SRCWRITER_HPP

#include "mcbasic/mcbasicclioptions.hpp"
#include <cstdio>
#include <string>

class SrcWriter {
public:
  SrcWriter(const char *p, const char *f, const MCBASICCLIOptions &opts)
      : progname(p), filename(f), options(opts) {
    init();
  }

  void write(const std::string &ops);
  const char *getOutname() { return outname; }

private:
  void init();
  void open();
  void close();
  void writeString(const std::string &ops);

  const char *progname;
  const char *filename;
  MCBASICCLIOptions options;

  FILE *fp{nullptr};
  char outname[BUFSIZ];
};
#endif
