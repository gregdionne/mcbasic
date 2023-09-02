// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_MCBASICCLIOPTIONS_HPP
#define MCBASIC_MCBASICCLIOPTIONS_HPP

#include "utils/clioptions.hpp"

class MCBASICCLIOptions : public utils::CLIOptions {
public:
  MCBASICCLIOptions();
  BinaryOption native;
  BinaryOption g;
  BinaryOption v;
  BinaryOption list;
  BinaryOption el;
  BinaryOption ul;
  BinaryOption mcode;
  BinaryOption undoc;
  BinaryOption S;
  BinaryOption c;
  BinaryOption Wfloat;
  BinaryOption Wduplicate;
  BinaryOption Wunreached;
  BinaryOption Wuninit;
  BinaryOption Wunused;
  BinaryOption Wbranch;
  BinaryOption dash;
};

#endif
