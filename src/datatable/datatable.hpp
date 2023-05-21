// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef DATATABLE_DATATABLE_HPP
#define DATATABLE_DATATABLE_HPP

#include "utils/binaryoption.hpp"

#include <string>
#include <vector>

// table of DATA from program AST
//
// We do a purity test to see if the target can compress these
// to pure byte, integer or floating constants rather than as
// naked strings.

class DataTable {
public:
  void add(std::string &entry);
  void testPurity();
  void floatDiagnostic(const BinaryOption &generate) const;
  bool isPureUnsigned() const { return pureUnsigned; }
  bool isPureByte() const { return pureByte; }
  bool isPureWord() const { return pureWord; }
  bool isPureInteger() const { return pureInteger; }
  bool isPureNumeric() const { return pureNumeric; }
  bool isPureStrings() const { return pureStrings; }
  std::vector<std::string> getData() const { return data; }

private:
  std::vector<std::string> data;
  bool pureUnsigned{false};
  bool pureByte{false};
  bool pureWord{false};
  bool pureInteger{false};
  bool pureNumeric{false};
  bool pureStrings{false};
  double minValue;
  double maxValue;
};

#endif
