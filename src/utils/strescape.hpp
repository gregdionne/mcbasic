// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef UTILS_STRESCAPE_HPP
#define UTILS_STRESCAPE_HPP

#include <string>

// make special characters suitable for tasm6801
std::string strEscapeTASM(std::string const &in);

// make special characters suitable for LIST
std::string strEscapeLIST(std::string const &in);

#endif
