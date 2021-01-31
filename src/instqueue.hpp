// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef INSTQUEUE_HPP
#define INSTQUEUE_HPP

#include <memory>
#include <vector>

#include "addressmode.hpp"
#include "instruction.hpp"

// virtual instruction queue

struct InstQueue {
  InstQueue() = default;

  // reserve (but do not allocate) n registers after the active register
  //
  // TODO: we should really make the compiler unaware of any register
  // implementation.  Failing that, the compiler should be unaware of
  // how many registers each instruction allocates internally, or
  // perhaps the implementation should never allocate another register
  // (perhaps using the stack instead).
  //
  // Otherwise, consider delegating this task to an InstructionOp.
  void reserve(int n);

  // allocate register on register stack
  int allocRegister();

  // reset register stack to zero
  void clearRegisters();

  // append virtual instruction to the queue.
  // return the result (address mode)
  std::unique_ptr<AddressMode> append(std::unique_ptr<Instruction> inst);

  // allocate a new register on the stack
  std::unique_ptr<AddressMode> alloc(std::unique_ptr<AddressMode> result);

  // perform a virtual LD on the provided result if not already in a register
  std::unique_ptr<AddressMode> load(std::unique_ptr<AddressMode> result);

  // instruction queue
  std::vector<std::unique_ptr<Instruction>> queue;

  // active register
  int registerCount{0};

  // keeps track of the maximum number of registers used for any statement
  int maxRegisterCount{1};
};

#endif
