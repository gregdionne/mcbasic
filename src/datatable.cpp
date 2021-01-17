// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "datatable.hpp"

#include <stdio.h>

#include <algorithm>
#include <limits>

void DataTable::add(std::string &entry) { data.push_back(entry); }

void DataTable::testPurity() {
  pureInteger = true;
  pureNumeric = true;
  pureStrings = true;

  minValue = std::numeric_limits<double>::infinity();
  maxValue = -std::numeric_limits<double>::infinity();
  for (const auto &entry : data) {
    try {
      double d = std::stod(entry);
      pureStrings = false;
      if (d != static_cast<double>(static_cast<int>(d))) {
        pureInteger = false;
      }
      minValue = std::min(minValue, d);
      maxValue = std::max(maxValue, d);
    } catch (...) {
      pureNumeric = false;
    }
  }

  if (!data.empty() && pureNumeric) {
    pureUnsigned = minValue >= 0;
    pureByte = pureInteger && ((-128 <= minValue && maxValue <= 127) ||
                               (0 <= minValue && maxValue <= 255));
    pureWord = pureInteger && ((-32768 <= minValue && maxValue <= 32767) ||
                               (0 <= minValue && maxValue <= 65535));
  } else {
    pureUnsigned = false;
    pureByte = false;
    pureWord = false;
  }
}

void DataTable::floatDiagnostic(bool generate) const {
  if (generate && !data.empty()) {
    if (pureStrings) {
      fprintf(stderr, "DATA values consist of pure strings\n");
    } else {
      fprintf(stderr, "DATA values are %s %s in the range [%f, %f]\n",
              pureNumeric ? "pure" : "a mix of strings and",
              pureByte      ? "bytes"
              : pureWord    ? "words"
              : pureInteger ? "integers"
                            : "numbers",
              minValue, maxValue);
    }
  }
}
