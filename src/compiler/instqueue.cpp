// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "instqueue.hpp"

#include <algorithm>

void InstQueue::reserve(int n) {
  maxRegisterCount = std::max(maxRegisterCount, registerCount + n);
}

int InstQueue::allocRegister() {
  maxRegisterCount = std::max(maxRegisterCount, ++registerCount);
  return registerCount;
}

void InstQueue::clearRegisters() { registerCount = 0; }

up<AddressMode> InstQueue::append(up<Instruction> inst) {
  queue.emplace_back(mv(inst));
  if (queue.back()->result->isRegister()) {
    registerCount = queue.back()->result->getRegister();
    maxRegisterCount = std::max(maxRegisterCount, registerCount);
  }
  return queue.back()->result->clone();
}

up<AddressMode> InstQueue::alloc(up<AddressMode> result) {
  if (!result->isRegister()) {
    result = makeup<AddressModeReg>(allocRegister(), result->dataType);
  }
  return result;
}

up<AddressMode> InstQueue::load(up<AddressMode> result) {
  if (!result->isRegister()) {
    auto dataType = result->dataType;
    result = append(makeup<InstLd>(
        makeup<AddressModeReg>(allocRegister(), dataType), mv(result)));
  }
  return result;
}
