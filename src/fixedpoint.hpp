// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef FIXEDPOINT_HPP
#define FIXEDPOINT_HPP

#include <string>

struct FixedPoint {
  explicit FixedPoint(double entry);
  bool operator==(const FixedPoint &x) const;
  bool operator<(const FixedPoint &x) const;

  // true if fraction is non-zero
  bool isFloat() const;

  // true if fraction is zero
  bool isInteger() const;

  // true if result can fit in either signed or unsigned 16 bit word.
  bool isWord() const;

  // true if positive or negative
  bool isPositive() const;
  bool isNegative() const;

  // true if (wholenum>>16) == 0
  bool isPosWord() const;

  // true if (wholenum>>16) == -1
  bool isNegWord() const;

  // return a TASM label for the constant
  std::string label() const;

  // 24 bit two's complement
  int wholenum;

  // 16 bit fraction
  int fraction;
};

#endif
