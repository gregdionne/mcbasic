// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_CONSTINSPECTOR_HPP
#define OPTIMIZER_CONSTINSPECTOR_HPP

#include "ast/expression.hpp"
#include "symboltable/symboltable.hpp"

class ConstInspector : public ExprInspector<utils::optional<double>,
                                            utils::optional<std::string>> {
public:
  //  explicit ConstInspector(SymbolTable &st) : symbolTable(st) {}

  utils::optional<double> inspect(const NumericConstantExpr &e) const {
    return utils::optional<double>(e.value);
  }
  utils::optional<double> inspect(const ArrayIndicesExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const NumericArrayExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const NumericVariableExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const NaryNumericExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const NegatedExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const PowerExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const IntegerDivisionExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const MultiplicativeExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const AdditiveExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const ComplementedExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const RelationalExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const AndExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const OrExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const ShiftExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const SgnExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const IntExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const AbsExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const SqrExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const ExpExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const LogExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const SinExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const CosExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const TanExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const RndExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const PeekExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const LenExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const ValExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const AscExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const PointExpr & /*expr*/) const {
    return utils::optional<double>();
  }
  utils::optional<double> inspect(const MemExpr & /*expr*/) const {
    return utils::optional<double>();
  }

  utils::optional<std::string> inspect(const StringConstantExpr &e) const {
    return utils::optional<std::string>(e.value);
  }
  utils::optional<std::string> inspect(const StringArrayExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string>
  inspect(const StringVariableExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string>
  inspect(const StringConcatenationExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const PrintTabExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const PrintCRExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const PrintCommaExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const PrintSpaceExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const StrExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const ChrExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const LeftExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const RightExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const MidExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }
  utils::optional<std::string> inspect(const InkeyExpr & /*expr*/) const {
    return utils::optional<std::string>();
  }

  inline bool isEqual(const NumericExpr *e, double value) {
    auto val = e->constify(this);
    return val && *val == value;
  }

  inline bool isPositive(const NumericExpr *e) {
    auto val = e->constify(this);
    return val && *val > 0;
  }

private:
  //  SymbolTable &symbolTable;
};

#endif
