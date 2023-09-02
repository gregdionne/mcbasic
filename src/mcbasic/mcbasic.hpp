// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef MCBASIC_MCBASIC_HPP
#define MCBASIC_MCBASIC_HPP

#include "mcbasicclioptions.hpp"

#include <string>

std::string mcbasic(const char *progname, const char *filename,
                    const MCBASICCLIOptions &options);

#endif
