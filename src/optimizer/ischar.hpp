// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISCHAR_HPP
#define OPTIMIZER_ISCHAR_HPP

#include "ast/pessimisticexprchecker.hpp"

class IsChar : public PessimisticExprChecker {
public:
  bool inspect(const StringConstantExpr &e) const override;
  bool inspect(const ChrExpr &e) const override;
  bool inspect(const InkeyExpr &e) const override;
  bool inspect(const MidExpr &e) const override;
  bool inspect(const LeftExpr &e) const override;
};

#endif
