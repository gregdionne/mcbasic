// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "consttable.hpp"

#include <cstdio>

#include <algorithm>
#include <cmath>

void ConstTable::add(double value) {
  FixedPoint flt_entry(value);

  if (flt_entry.fraction == 0) {
    for (auto entry : ints) {
      if (entry == flt_entry.wholenum) {
        return;
      }
    }
    ints.push_back(flt_entry.wholenum);
  } else {
    for (auto entry : flts) {
      if (entry == flt_entry) {
        return;
      }
    }
    flts.push_back(flt_entry);
  }
}

void ConstTable::sort() {
  std::sort(ints.begin(), ints.end());
  std::sort(flts.begin(), flts.end());
}
