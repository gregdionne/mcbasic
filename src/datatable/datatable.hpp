// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef DATATABLE_DATATABLE_HPP
#define DATATABLE_DATATABLE_HPP

#include <string>
#include <vector>

// table of DATA from program AST
//
// We do a purity test to see if the target can compress these
// to pure byte, integer or floating constants rather than as
// naked strings.

class DataTable {
public:
  DataTable() = default;
  std::vector<std::string> data;
  void add(std::string &entry);
  void testPurity();
  void floatDiagnostic(bool generate) const;

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
