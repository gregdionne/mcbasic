// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_CONSTINSPECTOR_HPP
#define OPTIMIZER_CONSTINSPECTOR_HPP

#include "ast/expression.hpp"
#include "symboltable/symboltable.hpp"

class ConstInspector : public ExprInspector<utils::optional<double>,
                                            utils::optional<std::string>> {
public:
  utils::optional<double> inspect(const NumericConstantExpr &e) const override {
    return utils::optional<double>(e.value);
  }
  utils::optional<double>
  inspect(const ArrayIndicesExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const NumericArrayExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const NumericVariableExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const NaryNumericExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const PowerExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const IntegerDivisionExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const MultiplicativeExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const AdditiveExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const ComplementedExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const RelationalExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const AndExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const OrExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const ShiftExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const SgnExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const IntExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const AbsExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const SqrExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const ExpExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const LogExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const SinExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const CosExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const TanExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const RndExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const PeekExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const LenExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const ValExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const AscExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const PointExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const MemExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const SquareExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const PosExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double> inspect(const TimerExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<double>
  inspect(const PeekWordExpr & /*expr*/) const override {
    return {};
  }

  utils::optional<std::string>
  inspect(const StringConstantExpr &e) const override {
    return utils::optional<std::string>(e.value);
  }
  utils::optional<std::string>
  inspect(const StringArrayExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const StringVariableExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const StringConcatenationExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const PrintTabExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const PrintCRExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const PrintCommaExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const PrintSpaceExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const StrExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const ChrExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const LeftExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const RightExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const MidExpr & /*expr*/) const override {
    return {};
  }
  utils::optional<std::string>
  inspect(const InkeyExpr & /*expr*/) const override {
    return {};
  }

  inline bool isEqual(const Expr *e, double value) {
    if (const auto *ne = dynamic_cast<const NumericExpr *>(e)) {
      auto val = ne->constify(this);
      return val && *val == value;
    }
    return false;
  }

  inline bool isEqual(const NumericExpr *e, double value) {
    auto val = e->constify(this);
    return val && *val == value;
  }

  inline bool isPositive(const NumericExpr *e) {
    auto val = e->constify(this);
    return val && *val > 0;
  }
};

#endif
