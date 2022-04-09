// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_NATIVETARGET_HPP
#define BACKEND_NATIVETARGET_HPP

#include "coretarget.hpp"

// top level target code generator for native

class NativeTarget : public CoreTarget {
protected:
  std::string generateCode(InstQueue &queue) override;
  up<Dispatcher> makeDispatcher() override;
};

#endif
