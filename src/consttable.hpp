// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef CONSTTABLE_HPP
#define CONSTTABLE_HPP

#include <vector>

#include "fixedpoint.hpp"

class ConstTable {
public:
  ConstTable() = default;
  std::vector<FixedPoint> flts;
  std::vector<int> ints;
  void add(double value);
  void sort();
};

#endif
