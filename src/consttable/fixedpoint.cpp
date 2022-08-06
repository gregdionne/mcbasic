// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "fixedpoint.hpp"

#include <cstdio>

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

double FixedPoint::to_double() const {
  return static_cast<double>(wholenum) * 65536 + static_cast<double>(fraction);
}

bool FixedPoint::operator==(const FixedPoint &x) const {
  return wholenum == x.wholenum && fraction == x.fraction;
}

bool FixedPoint::operator<(const FixedPoint &x) const {
  return to_double() < x.to_double();
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

bool FixedPoint::isPowerOfTwo() const {
  return (
      (wholenum == 0 && fraction != 0 && (fraction & (fraction - 1)) == 0) ||
      (fraction == 0 && wholenum != 0 && (wholenum & (wholenum - 1)) == 0));
}

FixedPoint FixedPoint::abs() const {
  auto x = FixedPoint(0);

  x.wholenum = wholenum < 0 && fraction != 0   ? ~wholenum
               : wholenum < 0 && fraction == 0 ? -wholenum
                                               : wholenum;

  x.fraction = wholenum < 0 && fraction != 0 ? 65536 - fraction : fraction;

  return x;
}

int FixedPoint::log2abs() const {
  auto x = (wholenum < 0) ? abs() : *this;
  int n = 0;
  if (x.wholenum > 0) {
    while (x.wholenum > 1) {
      x.wholenum >>= 1;
      ++n;
    }
  } else if ((x.fraction & 0x0ffff) != 0) {
    while ((x.fraction & 0x10000) == 0) {
      x.fraction <<= 1;
      --n;
    }
  }

  return n;
}

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
            static_cast<int>(100000.0 * abs_fraction / 65536.0));
  }
  return {buf};
}
