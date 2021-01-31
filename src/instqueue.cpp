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

std::unique_ptr<AddressMode>
InstQueue::append(std::unique_ptr<Instruction> inst) {
  queue.emplace_back(std::move(inst));
  if (queue.back()->result->isRegister()) {
    registerCount = queue.back()->result->getRegister();
    maxRegisterCount = std::max(maxRegisterCount, registerCount);
  }
  return queue.back()->result->clone();
}

std::unique_ptr<AddressMode>
InstQueue::alloc(std::unique_ptr<AddressMode> result) {
  if (!result->isRegister()) {
    result =
        std::make_unique<AddressModeReg>(allocRegister(), result->dataType);
  }
  return result;
}

std::unique_ptr<AddressMode>
InstQueue::load(std::unique_ptr<AddressMode> result) {
  if (!result->isRegister()) {
    auto dataType = result->dataType;
    result = append(std::make_unique<InstLd>(
        std::make_unique<AddressModeReg>(allocRegister(), dataType),
        std::move(result)));
  }
  return result;
}
