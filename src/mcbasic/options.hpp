// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_OPTIONS_HPP
#define MCBASIC_OPTIONS_HPP

struct Options {
  // bool gline_tables_only
  // bool ftrapv = false;
  bool native = false;
  bool g = false;
  bool list = false;
  bool Wfloat = true;
  bool Wduplicate = true;
  bool Wunreached = true;
  bool Wuninit = true;
  bool Wbranch = true;
  bool el = false;
  bool ul = false;
  bool undoc = false;
  int argcnt = 0;

  // check option list, generate usage if invalid options detected
  void init(int argc, char *argv[]);

private:
  static void validate(int argc, char *argv[]);
  void process(int argc, char *argv[]);
};

// NOTE: usage() is a holdover from an old C program
// This should eventually get moved into the options parser
//
// generate a (globally accessible) usage message to stderr.

void usage(char *argv[]);

#endif
