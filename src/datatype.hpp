// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef DATATYPE_HPP
#define DATATYPE_HPP

// BASIC datatypes for program symbols
//
// for numeric types, we promote to float
// when we cannot guarantee the result is
// integral-valued, otherwise we favor INT.

enum class DataType { Str, Int, Flt, Null };

#endif
