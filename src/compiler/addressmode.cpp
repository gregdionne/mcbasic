// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "addressmode.hpp"
#include "utils/strescape.hpp"

// TODO: modernize this with assembler

std::string AddressModeStk::postoperands() {
  std::string out;
  out += std::to_string(labels.size()) + "\n\t.word\t";
  if (dataType == DataType::Int) {
    for (std::size_t i = 0; i < labels.size(); ++i) {
      out += labels[i] == constants::unlistedLineNumber
                 ? "LUNLIST"
                 : "LINE_" + std::to_string(labels[i]);
      out += i + 1 == labels.size() ? "" : ", ";
    }
  } else {
    out = std::to_string(text.length()) + ", ";
    out += "\"" + strEscapeTASM(text) + "\"";
  }
  return out;
}
