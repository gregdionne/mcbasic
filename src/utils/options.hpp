// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef UTILS_OPTIONS_HPP
#define UTILS_OPTIONS_HPP

#include "option.hpp"

#include <vector>

namespace utils {

class Options {
public:
  std::vector<const char *> parse(int argc, const char *const argv[]);
  const std::vector<Option *> &getTable() const { return table; }
  void addOption(Option *option) { table.push_back(option); }

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

} // namespace utils

#endif
