// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef CONSTANTS_HPP
#define CONSTANTS_HPP

#include <cstdint>

namespace constants {

constexpr int illegalLineNumber = -1;
constexpr int lastLineNumber = 65534;
constexpr int unlistedLineNumber = 65535;

constexpr uint8_t NFError = 0x00; // NEXT without FOR
constexpr uint8_t SNError = 0x02; // Syntax Error
constexpr uint8_t RGError = 0x04; // RETURN without GOSUB
constexpr uint8_t ODError = 0x06; // Out of DATA
constexpr uint8_t FCError = 0x08; // Illegal Function Call
constexpr uint8_t OVError = 0x0A; // Overflow
constexpr uint8_t OMError = 0x0C; // Out of Memory
constexpr uint8_t ULError = 0x0E; // Undefined Line
constexpr uint8_t BSError = 0x10; // Bad Subscript
constexpr uint8_t DDError = 0x12; // Double Dimensioned Array
constexpr uint8_t D0Error = 0x14; // Division by 0
constexpr uint8_t IDError = 0x16; // Input Direct
constexpr uint8_t TMError = 0x18; // Type Mismatch
constexpr uint8_t OSError = 0x1A; // Out of String Space
constexpr uint8_t LSError = 0x1C; // String too Long
constexpr uint8_t STError = 0x1E; // String Formula too Complex
constexpr uint8_t CNError = 0x20; // Can't Continue
constexpr uint8_t IOError = 0x22; // Input/Output Error
constexpr uint8_t FMError = 0x24; // File Mode Error
} // namespace constants

#endif
