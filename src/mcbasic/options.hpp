// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_OPTIONS_HPP
#define MCBASIC_OPTIONS_HPP

#include "utils/options.hpp"

class Options : public utils::Options {
public:
  Options();
  Option native;
  Option g;
  Option v;
  Option list;
  Option el;
  Option ul;
  Option mcode;
  Option undoc;
  Option Wfloat;
  Option Wduplicate;
  Option Wunreached;
  Option Wuninit;
  Option Wunused;
  Option Wbranch;
  Option dash;
};

#endif
