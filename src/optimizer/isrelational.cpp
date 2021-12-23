// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isrelational.hpp"

bool IsRelational::inspect(const RelationalExpr & /*expr*/) const {
  return true;
}
