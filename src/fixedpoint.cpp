// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "fixedpoint.hpp"

#include <stdio.h>

#include <cmath>
#include <cstdint>
#include <cstdlib>

FixedPoint::FixedPoint(double entry) {
  auto quantized = static_cast<std::int64_t>(std::round(entry * 65536));
  fraction = static_cast<int>(quantized & 0x0ffff);
  wholenum = static_cast<int>(quantized >> 16);
  if (wholenum > 0x7fffff || wholenum < -0x0800000) {
    fprintf(stderr, "constant %f is out of range\n", entry);
    fprintf(stderr, "wholenum %08x is out of range\n", wholenum);
    exit(1);
  }
}

bool FixedPoint::operator==(const FixedPoint &x) const {
  return wholenum == x.wholenum && fraction == x.fraction;
}

bool FixedPoint::operator<(const FixedPoint &x) const {
  return double(wholenum) * 65536 + double(fraction) <
         double(x.wholenum) * 65536 + double(x.fraction);
}

bool FixedPoint::isFloat() const { return fraction != 0; }

bool FixedPoint::isInteger() const { return fraction == 0; }

bool FixedPoint::isWord() const {
  return !isFloat() && -0x010000 < wholenum && wholenum < 0x010000;
}

bool FixedPoint::isPositive() const { return wholenum >= 0; }

bool FixedPoint::isNegative() const { return wholenum < 0; }

bool FixedPoint::isPosWord() const { return isPositive() && isWord(); }

bool FixedPoint::isNegWord() const { return isNegative() && isWord(); }

std::string FixedPoint::label() const {
  char buf[1024];

  if (fraction == 0) {
    const char *sgn = wholenum < 0 ? "m" : "";
    int abs_wholenum = wholenum < 0 ? -wholenum : wholenum;
    sprintf(buf, "INT_%s%i", sgn, abs_wholenum);
  } else {
    const char *sgn = wholenum < 0 ? "m" : "";
    int abs_wholenum = wholenum < 0 ? -(wholenum + 1) : wholenum;
    int abs_fraction = wholenum < 0 ? 65536 - fraction : fraction;
    sprintf(buf, "FLT_%s%ip%05i", sgn, abs_wholenum,
            int(100000.0 * abs_fraction / 65536.0));
  }
  return std::string(buf);
}
