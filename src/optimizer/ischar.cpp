// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#include "ischar.hpp"
#include "constinspector.hpp"

bool IsChar::inspect(const StringConstantExpr &e) const {
  return e.value.length() < 2;
}

bool IsChar::inspect(const ChrExpr & /*expr*/) const { return true; }

bool IsChar::inspect(const InkeyExpr & /*expr*/) const { return true; }

bool IsChar::inspect(const MidExpr &e) const {

  // if length is known...
  if (e.len) {
    ConstInspector constInspector;
    if (auto value = e.len->constify(&constInspector)) {
      if (*value < 2) {
        return true;
      }
    }
  }

  // otherwise see if string itself passes
  return e.str->inspect(this);
}

bool IsChar::inspect(const LeftExpr &e) const {
  // if length is known...
  ConstInspector constInspector;
  if (auto value = e.len->constify(&constInspector)) {
    if (*value < 2)
      return true;
  }

  // otherwise see if string itself passes
  return e.str->inspect(this);
}
