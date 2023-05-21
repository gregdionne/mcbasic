// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_OPTIONS_HPP
#define MCBASIC_OPTIONS_HPP

#include "utils/binaryoptions.hpp"

class CLIOptions : public utils::BinaryOptions {
public:
  CLIOptions();
  BinaryOption native;
  BinaryOption g;
  BinaryOption v;
  BinaryOption list;
  BinaryOption el;
  BinaryOption ul;
  BinaryOption mcode;
  BinaryOption undoc;
  BinaryOption Wfloat;
  BinaryOption Wduplicate;
  BinaryOption Wunreached;
  BinaryOption Wuninit;
  BinaryOption Wunused;
  BinaryOption Wbranch;
  BinaryOption dash;
};

#endif
