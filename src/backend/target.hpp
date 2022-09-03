// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_TARGET_HPP
#define BACKEND_TARGET_HPP

#include "ast/text.hpp"
#include "coder.hpp"
#include "compiler/instqueue.hpp"
#include "mcbasic/options.hpp"

// Top level class to generate assembly for the target.

class Target {
public:
  Target() = default;
  Target(const Target &) = delete;
  Target(Target &&) = delete;
  Target &operator=(const Target &) = delete;
  Target &operator=(Target &&) = delete;
  virtual ~Target() = default;

  virtual std::string generateAssembly(Text &text, InstQueue &queue,
                                       const Options &options) = 0;
};

#endif
