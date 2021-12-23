// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISFLOAT_HPP
#define OPTIMIZER_ISFLOAT_HPP

#include "ast/pessimisticexprchecker.hpp"
#include "datatable/datatable.hpp"
#include "symboltable/symboltable.hpp"

class IsFloat : public PessimisticExprChecker {
public:
  SymbolTable &symbolTable;
  explicit IsFloat(SymbolTable &st) : symbolTable(st) {}
  bool inspect(const ValExpr &e) const override;
  bool inspect(const AbsExpr &e) const override;
  bool inspect(const ShiftExpr &e) const override;
  bool inspect(const NegatedExpr &e) const override;
  bool inspect(const PowerExpr &e) const override;
  bool inspect(const MultiplicativeExpr &e) const override;
  bool inspect(const AdditiveExpr &e) const override;
  bool inspect(const SqrExpr &e) const override;
  bool inspect(const ExpExpr &e) const override;
  bool inspect(const LogExpr &e) const override;
  bool inspect(const SinExpr &e) const override;
  bool inspect(const CosExpr &e) const override;
  bool inspect(const TanExpr &e) const override;
  bool inspect(const RndExpr &e) const override;
  bool inspect(const NumericConstantExpr &e) const override;
  bool inspect(const NumericVariableExpr &e) const override;
  bool inspect(const NumericArrayExpr &e) const override;
};

#endif
