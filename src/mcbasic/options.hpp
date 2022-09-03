// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_OPTIONS_HPP
#define MCBASIC_OPTIONS_HPP

#include "option.hpp"

#include <vector>

class Options {
public:
  Options();
  std::vector<const char *> parse(int argc, const char *const argv[]);
  const std::vector<Option *> &getTable() const { return table; }
  Option native;
  Option g;
  Option v;
  Option list;
  Option el;
  Option ul;
  Option mcode;
  Option undoc;
  Option Wfloat;
  Option Wduplicate;
  Option Wunreached;
  Option Wuninit;
  Option Wunused;
  Option Wbranch;
  Option dash;

private:
  Option *findOption(const char *arg);
  Option *findOnSwitch(const char *arg);
  Option *findOffSwitch(const char *arg);
  void usage(const char *progname) const;
  void helpOptionSummary(const Option *option) const;
  void helpOptionDetails(const Option *option) const;
  void helpOptions() const;
  void helpTopic(const char *progname, const char *target) const;
  std::vector<Option *> table;
  const int nWrap = 65;
};

#endif
