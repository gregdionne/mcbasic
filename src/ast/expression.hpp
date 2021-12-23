// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_EXPRESSIONS_HPP
#define AST_EXPRESSIONS_HPP

#include "utils/optional.hpp"

#include <memory>
#include <string>
#include <utility>
#include <vector>

// Expression visitors

class Expr;
class StringExpr;
class NumericExpr;
class ArrayIndicesExpr;
class NumericConstantExpr;
class StringConstantExpr;
class NumericVariableExpr;
class StringVariableExpr;
class NumericArrayExpr;
class StringArrayExpr;
class NaryNumericExpr;
class StringConcatenationExpr;
class PrintTabExpr;
class PrintSpaceExpr;
class PrintCRExpr;
class PrintCommaExpr;
class NegatedExpr;
class PowerExpr;
class IntegerDivisionExpr;
class MultiplicativeExpr;
class AdditiveExpr;
class ComplementedExpr;
class RelationalExpr;
class AndExpr;
class OrExpr;
class ShiftExpr;
class SgnExpr;
class IntExpr;
class AbsExpr;
class SqrExpr;
class ExpExpr;
class LogExpr;
class SinExpr;
class CosExpr;
class TanExpr;
class RndExpr;
class PeekExpr;
class LenExpr;
class StrExpr;
class ValExpr;
class AscExpr;
class ChrExpr;
class LeftExpr;
class RightExpr;
class MidExpr;
class PointExpr;
class InkeyExpr;
class MemExpr;

template <typename Number, typename String> class ExprMutator {
public:
  virtual Number mutate(ArrayIndicesExpr & /*expr*/) = 0;
  virtual Number mutate(NumericConstantExpr & /*expr*/) = 0;
  virtual String mutate(StringConstantExpr & /*expr*/) = 0;
  virtual Number mutate(NumericArrayExpr & /*expr*/) = 0;
  virtual String mutate(StringArrayExpr & /*expr*/) = 0;
  virtual Number mutate(NumericVariableExpr & /*expr*/) = 0;
  virtual String mutate(StringVariableExpr & /*expr*/) = 0;
  virtual Number mutate(NaryNumericExpr & /*expr*/) = 0;
  virtual String mutate(StringConcatenationExpr & /*expr*/) = 0;
  virtual String mutate(PrintTabExpr & /*expr*/) = 0;
  virtual String mutate(PrintSpaceExpr & /*expr*/) = 0;
  virtual String mutate(PrintCRExpr & /*expr*/) = 0;
  virtual String mutate(PrintCommaExpr & /*expr*/) = 0;
  virtual Number mutate(NegatedExpr & /*expr*/) = 0;
  virtual Number mutate(PowerExpr & /*expr*/) = 0;
  virtual Number mutate(IntegerDivisionExpr & /*expr*/) = 0;
  virtual Number mutate(MultiplicativeExpr & /*expr*/) = 0;
  virtual Number mutate(AdditiveExpr & /*expr*/) = 0;
  virtual Number mutate(ComplementedExpr & /*expr*/) = 0;
  virtual Number mutate(RelationalExpr & /*expr*/) = 0;
  virtual Number mutate(AndExpr & /*expr*/) = 0;
  virtual Number mutate(OrExpr & /*expr*/) = 0;
  virtual Number mutate(ShiftExpr & /*expr*/) = 0;
  virtual Number mutate(SgnExpr & /*expr*/) = 0;
  virtual Number mutate(IntExpr & /*expr*/) = 0;
  virtual Number mutate(AbsExpr & /*expr*/) = 0;
  virtual Number mutate(SqrExpr & /*expr*/) = 0;
  virtual Number mutate(ExpExpr & /*expr*/) = 0;
  virtual Number mutate(LogExpr & /*expr*/) = 0;
  virtual Number mutate(SinExpr & /*expr*/) = 0;
  virtual Number mutate(CosExpr & /*expr*/) = 0;
  virtual Number mutate(TanExpr & /*expr*/) = 0;
  virtual Number mutate(RndExpr & /*expr*/) = 0;
  virtual Number mutate(PeekExpr & /*expr*/) = 0;
  virtual Number mutate(LenExpr & /*expr*/) = 0;
  virtual String mutate(StrExpr & /*expr*/) = 0;
  virtual Number mutate(ValExpr & /*expr*/) = 0;
  virtual Number mutate(AscExpr & /*expr*/) = 0;
  virtual String mutate(ChrExpr & /*expr*/) = 0;
  virtual String mutate(LeftExpr & /*expr*/) = 0;
  virtual String mutate(RightExpr & /*expr*/) = 0;
  virtual String mutate(MidExpr & /*expr*/) = 0;
  virtual Number mutate(PointExpr & /*expr*/) = 0;
  virtual String mutate(InkeyExpr & /*expr*/) = 0;
  virtual Number mutate(MemExpr & /*expr*/) = 0;
};

template <typename Number, typename String> class ExprInspector {
public:
  virtual Number inspect(const ArrayIndicesExpr & /*expr*/) const = 0;
  virtual Number inspect(const NumericConstantExpr & /*expr*/) const = 0;
  virtual String inspect(const StringConstantExpr & /*expr*/) const = 0;
  virtual Number inspect(const NumericArrayExpr & /*expr*/) const = 0;
  virtual String inspect(const StringArrayExpr & /*expr*/) const = 0;
  virtual Number inspect(const NumericVariableExpr & /*expr*/) const = 0;
  virtual String inspect(const StringVariableExpr & /*expr*/) const = 0;
  virtual Number inspect(const NaryNumericExpr & /*expr*/) const = 0;
  virtual String inspect(const StringConcatenationExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintTabExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintSpaceExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintCRExpr & /*expr*/) const = 0;
  virtual String inspect(const PrintCommaExpr & /*expr*/) const = 0;
  virtual Number inspect(const NegatedExpr & /*expr*/) const = 0;
  virtual Number inspect(const PowerExpr & /*expr*/) const = 0;
  virtual Number inspect(const IntegerDivisionExpr & /*expr*/) const = 0;
  virtual Number inspect(const MultiplicativeExpr & /*expr*/) const = 0;
  virtual Number inspect(const AdditiveExpr & /*expr*/) const = 0;
  virtual Number inspect(const ComplementedExpr & /*expr*/) const = 0;
  virtual Number inspect(const RelationalExpr & /*expr*/) const = 0;
  virtual Number inspect(const AndExpr & /*expr*/) const = 0;
  virtual Number inspect(const OrExpr & /*expr*/) const = 0;
  virtual Number inspect(const ShiftExpr & /*expr*/) const = 0;
  virtual Number inspect(const SgnExpr & /*expr*/) const = 0;
  virtual Number inspect(const IntExpr & /*expr*/) const = 0;
  virtual Number inspect(const AbsExpr & /*expr*/) const = 0;
  virtual Number inspect(const SqrExpr & /*expr*/) const = 0;
  virtual Number inspect(const ExpExpr & /*expr*/) const = 0;
  virtual Number inspect(const LogExpr & /*expr*/) const = 0;
  virtual Number inspect(const SinExpr & /*expr*/) const = 0;
  virtual Number inspect(const CosExpr & /*expr*/) const = 0;
  virtual Number inspect(const TanExpr & /*expr*/) const = 0;
  virtual Number inspect(const RndExpr & /*expr*/) const = 0;
  virtual Number inspect(const PeekExpr & /*expr*/) const = 0;
  virtual Number inspect(const LenExpr & /*expr*/) const = 0;
  virtual String inspect(const StrExpr & /*expr*/) const = 0;
  virtual Number inspect(const ValExpr & /*expr*/) const = 0;
  virtual Number inspect(const AscExpr & /*expr*/) const = 0;
  virtual String inspect(const ChrExpr & /*expr*/) const = 0;
  virtual String inspect(const LeftExpr & /*expr*/) const = 0;
  virtual String inspect(const RightExpr & /*expr*/) const = 0;
  virtual String inspect(const MidExpr & /*expr*/) const = 0;
  virtual Number inspect(const PointExpr & /*expr*/) const = 0;
  virtual String inspect(const InkeyExpr & /*expr*/) const = 0;
  virtual Number inspect(const MemExpr & /*expr*/) const = 0;
};

template <typename Number, typename String> class ExprAbsorber {
public:
  virtual Number absorb(const ArrayIndicesExpr & /*expr*/) = 0;
  virtual Number absorb(const NumericConstantExpr & /*expr*/) = 0;
  virtual String absorb(const StringConstantExpr & /*expr*/) = 0;
  virtual Number absorb(const NumericArrayExpr & /*expr*/) = 0;
  virtual String absorb(const StringArrayExpr & /*expr*/) = 0;
  virtual Number absorb(const NumericVariableExpr & /*expr*/) = 0;
  virtual String absorb(const StringVariableExpr & /*expr*/) = 0;
  virtual Number absorb(const NaryNumericExpr & /*expr*/) = 0;
  virtual String absorb(const StringConcatenationExpr & /*expr*/) = 0;
  virtual String absorb(const PrintTabExpr & /*expr*/) = 0;
  virtual String absorb(const PrintSpaceExpr & /*expr*/) = 0;
  virtual String absorb(const PrintCRExpr & /*expr*/) = 0;
  virtual String absorb(const PrintCommaExpr & /*expr*/) = 0;
  virtual Number absorb(const NegatedExpr & /*expr*/) = 0;
  virtual Number absorb(const PowerExpr & /*expr*/) = 0;
  virtual Number absorb(const IntegerDivisionExpr & /*expr*/) = 0;
  virtual Number absorb(const MultiplicativeExpr & /*expr*/) = 0;
  virtual Number absorb(const AdditiveExpr & /*expr*/) = 0;
  virtual Number absorb(const ComplementedExpr & /*expr*/) = 0;
  virtual Number absorb(const RelationalExpr & /*expr*/) = 0;
  virtual Number absorb(const AndExpr & /*expr*/) = 0;
  virtual Number absorb(const OrExpr & /*expr*/) = 0;
  virtual Number absorb(const ShiftExpr & /*expr*/) = 0;
  virtual Number absorb(const SgnExpr & /*expr*/) = 0;
  virtual Number absorb(const IntExpr & /*expr*/) = 0;
  virtual Number absorb(const AbsExpr & /*expr*/) = 0;
  virtual Number absorb(const SqrExpr & /*expr*/) = 0;
  virtual Number absorb(const ExpExpr & /*expr*/) = 0;
  virtual Number absorb(const LogExpr & /*expr*/) = 0;
  virtual Number absorb(const SinExpr & /*expr*/) = 0;
  virtual Number absorb(const CosExpr & /*expr*/) = 0;
  virtual Number absorb(const TanExpr & /*expr*/) = 0;
  virtual Number absorb(const RndExpr & /*expr*/) = 0;
  virtual Number absorb(const PeekExpr & /*expr*/) = 0;
  virtual Number absorb(const LenExpr & /*expr*/) = 0;
  virtual String absorb(const StrExpr & /*expr*/) = 0;
  virtual Number absorb(const ValExpr & /*expr*/) = 0;
  virtual Number absorb(const AscExpr & /*expr*/) = 0;
  virtual String absorb(const ChrExpr & /*expr*/) = 0;
  virtual String absorb(const LeftExpr & /*expr*/) = 0;
  virtual String absorb(const RightExpr & /*expr*/) = 0;
  virtual String absorb(const MidExpr & /*expr*/) = 0;
  virtual Number absorb(const PointExpr & /*expr*/) = 0;
  virtual String absorb(const InkeyExpr & /*expr*/) = 0;
  virtual Number absorb(const MemExpr & /*expr*/) = 0;
};

// define expressions in the statement's AST

class Expr {
public:
  Expr() = default;
  Expr(const Expr &) = delete;
  Expr(Expr &&) = default;
  Expr &operator=(const Expr &) = delete;
  Expr &operator=(Expr &&) = default;
  virtual ~Expr() = default;

  virtual bool isString() { return false; }
  virtual bool isConst(double & /*val*/) const { return false; }
  virtual bool isVar() { return false; }
  virtual bool isConst(std::string & /*val*/) const { return false; }

  virtual bool inspect(const ExprInspector<bool, bool> * /*op*/) const = 0;
  virtual void inspect(const ExprInspector<void, void> * /*op*/) const = 0;
  virtual void soak(ExprAbsorber<void, void> * /*op*/) const = 0;
  virtual void mutate(ExprMutator<void, void> * /*op*/) = 0;
};

class NumericExpr : public Expr {
public:
  bool isString() override { return false; } // not needed...

  virtual std::unique_ptr<NumericExpr> transmutate(
      ExprMutator<std::unique_ptr<NumericExpr>, std::unique_ptr<StringExpr>>
          *transmutator) = 0;

  virtual utils::optional<double> constify(
      const ExprInspector<utils::optional<double>, utils::optional<std::string>>
          *constifier) const = 0;
};

template <typename T> class OperableNumericExpr : public NumericExpr {
public:
  bool inspect(const ExprInspector<bool, bool> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void inspect(const ExprInspector<void, void> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void soak(ExprAbsorber<void, void> *op) const override {
    return op->absorb(*static_cast<const T *>(this));
  }

  std::unique_ptr<NumericExpr> transmutate(
      ExprMutator<std::unique_ptr<NumericExpr>, std::unique_ptr<StringExpr>>
          *transmutator) override {
    return transmutator->mutate(*static_cast<T *>(this));
  }

  void mutate(ExprMutator<void, void> *op) override {
    op->mutate(*static_cast<T *>(this));
  }

  utils::optional<double> constify(
      const ExprInspector<utils::optional<double>, utils::optional<std::string>>
          *constifier) const override {
    return constifier->inspect(*static_cast<const T *>(this));
  }
};

class StringExpr : public Expr {
public:
  bool isString() override { return true; }

  virtual std::unique_ptr<StringExpr> transmutate(
      ExprMutator<std::unique_ptr<NumericExpr>, std::unique_ptr<StringExpr>>
          *transmutator) = 0;

  virtual utils::optional<std::string> constify(
      const ExprInspector<utils::optional<double>, utils::optional<std::string>>
          *obtainer) const = 0;
};

template <typename T> class OperableStringExpr : public StringExpr {
public:
  bool inspect(const ExprInspector<bool, bool> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void inspect(const ExprInspector<void, void> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void soak(ExprAbsorber<void, void> *op) const override {
    return op->absorb(*static_cast<const T *>(this));
  }

  std::unique_ptr<StringExpr> transmutate(
      ExprMutator<std::unique_ptr<NumericExpr>, std::unique_ptr<StringExpr>>
          *transmutator) override {
    return transmutator->mutate(*static_cast<T *>(this));
  }

  void mutate(ExprMutator<void, void> *op) override {
    op->mutate(*static_cast<T *>(this));
  }

  utils::optional<std::string> constify(
      const ExprInspector<utils::optional<double>, utils::optional<std::string>>
          *constifier) const override {
    return constifier->inspect(*static_cast<const T *>(this));
  }
};

class ArrayIndicesExpr : public OperableNumericExpr<ArrayIndicesExpr> {
public:
  std::vector<std::unique_ptr<NumericExpr>> operands;
};

class NumericConstantExpr : public OperableNumericExpr<NumericConstantExpr> {
public:
  double value;
  explicit NumericConstantExpr(double v) : value(v) {}
  bool isConst(double &val) const override {
    val = value;
    return true;
  }
};

class StringConstantExpr : public OperableStringExpr<StringConstantExpr> {
public:
  std::string value;
  explicit StringConstantExpr(std::string v) : value(std::move(v)) {}
  bool isConst(std::string &val) const override {
    val = value;
    return true;
  }
};

class NumericArrayExpr : public OperableNumericExpr<NumericArrayExpr> {
public:
  std::unique_ptr<NumericVariableExpr> varexp;
  std::unique_ptr<ArrayIndicesExpr> indices;
};

class StringArrayExpr : public OperableStringExpr<StringArrayExpr> {
public:
  std::unique_ptr<StringVariableExpr> varexp;
  std::unique_ptr<ArrayIndicesExpr> indices;
};

class NumericVariableExpr : public OperableNumericExpr<NumericVariableExpr> {
public:
  std::string varname;
  explicit NumericVariableExpr(std::string v) : varname(std::move(v)) {}
  bool isVar() override { return true; }
};

class StringVariableExpr : public OperableStringExpr<StringVariableExpr> {
public:
  std::string varname;
  explicit StringVariableExpr(std::string v) : varname(std::move(v)) {}
  bool isVar() override { return true; }
};

class NaryNumericExpr : public OperableNumericExpr<NaryNumericExpr> {
public:
  std::vector<std::unique_ptr<NumericExpr>> operands;
  std::vector<std::unique_ptr<NumericExpr>> invoperands;
  NaryNumericExpr(double id, const char *func, const char *inv)
      : identity(id), funcName(func), invName(inv) {}
  double identity;
  std::string funcName;
  std::string invName;
};

template <typename T> class OperableNaryNumericExpr : public NaryNumericExpr {
public:
  OperableNaryNumericExpr(double id, const char *func, const char *inv = "")
      : NaryNumericExpr(id, func, inv) {}

  bool inspect(const ExprInspector<bool, bool> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }
  void inspect(const ExprInspector<void, void> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }
  std::unique_ptr<NumericExpr> transmutate(
      ExprMutator<std::unique_ptr<NumericExpr>, std::unique_ptr<StringExpr>>
          *transmutator) override {
    return transmutator->mutate(*static_cast<T *>(this));
  }
  void mutate(ExprMutator<void, void> *op) override {
    op->mutate(*static_cast<T *>(this));
  }
  void soak(ExprAbsorber<void, void> *op) const override {
    op->absorb(*static_cast<const T *>(this));
  }
};

class StringConcatenationExpr
    : public OperableStringExpr<StringConcatenationExpr> {
public:
  std::vector<std::unique_ptr<StringExpr>> operands;
  explicit StringConcatenationExpr(std::unique_ptr<StringExpr> e) {
    operands.emplace_back(std::move(e));
  }
};

class PrintTabExpr : public OperableStringExpr<PrintTabExpr> {
public:
  std::unique_ptr<NumericExpr> tabstop;
  explicit PrintTabExpr(std::unique_ptr<NumericExpr> e)
      : tabstop(std::move(e)) {}
};

class PrintSpaceExpr : public OperableStringExpr<PrintSpaceExpr> {};

class PrintCRExpr : public OperableStringExpr<PrintCRExpr> {};

class PrintCommaExpr : public OperableStringExpr<PrintCommaExpr> {};

class NegatedExpr : public OperableNumericExpr<NegatedExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit NegatedExpr(std::unique_ptr<NumericExpr> e) : expr(std::move(e)) {}
};

class PowerExpr : public OperableNumericExpr<PowerExpr> {
public:
  std::unique_ptr<NumericExpr> base;
  std::unique_ptr<NumericExpr> exponent;
  std::string funcName = "^";
  PowerExpr(std::unique_ptr<NumericExpr> b, std::unique_ptr<NumericExpr> e)
      : base(std::move(b)), exponent(std::move(e)) {}
};

class IntegerDivisionExpr : public OperableNumericExpr<IntegerDivisionExpr> {
public:
  std::unique_ptr<NumericExpr> dividend;
  std::unique_ptr<NumericExpr> divisor;
  std::string funcName = "^";
  IntegerDivisionExpr(std::unique_ptr<NumericExpr> num,
                      std::unique_ptr<NumericExpr> den)
      : dividend(std::move(num)), divisor(std::move(den)) {}
};

class MultiplicativeExpr : public OperableNaryNumericExpr<MultiplicativeExpr> {
public:
  MultiplicativeExpr() : OperableNaryNumericExpr(1, "*", "/") {}
  explicit MultiplicativeExpr(std::unique_ptr<NumericExpr> e)
      : OperableNaryNumericExpr(1, "*", "/") {
    operands.emplace_back(std::move(e));
  }
};

class AdditiveExpr : public OperableNaryNumericExpr<AdditiveExpr> {
public:
  AdditiveExpr() : OperableNaryNumericExpr(0, "+", "-") {}
  explicit AdditiveExpr(std::unique_ptr<NumericExpr> e)
      : OperableNaryNumericExpr(0, "+", "-") {
    operands.emplace_back(std::move(e));
  }
};

class ComplementedExpr : public OperableNumericExpr<ComplementedExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit ComplementedExpr(std::unique_ptr<NumericExpr> e)
      : expr(std::move(e)) {}
};

class RelationalExpr : public OperableNumericExpr<RelationalExpr> {
public:
  std::string comparator;
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  RelationalExpr(std::string c, std::unique_ptr<Expr> le,
                 std::unique_ptr<Expr> re)
      : comparator(std::move(c)), lhs(std::move(le)), rhs(std::move(re)) {}
};

class AndExpr : public OperableNaryNumericExpr<AndExpr> {
public:
  AndExpr() : OperableNaryNumericExpr(-1, "AND") {}
  explicit AndExpr(std::unique_ptr<NumericExpr> e)
      : OperableNaryNumericExpr(-1, "AND") {
    operands.emplace_back(std::move(e));
  }
};

class OrExpr : public OperableNaryNumericExpr<OrExpr> {
public:
  OrExpr() : OperableNaryNumericExpr(0, "OR") {}
  explicit OrExpr(std::unique_ptr<NumericExpr> e)
      : OperableNaryNumericExpr(0, "OR") {
    operands.emplace_back(std::move(e));
  }
};

class ShiftExpr : public OperableNumericExpr<ShiftExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
  std::unique_ptr<NumericExpr> count;
  ShiftExpr(std::unique_ptr<NumericExpr> e, std::unique_ptr<NumericExpr> n)
      : expr(std::move(e)), count(std::move(n)) {}
};

class SgnExpr : public OperableNumericExpr<SgnExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class IntExpr : public OperableNumericExpr<IntExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class AbsExpr : public OperableNumericExpr<AbsExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class SqrExpr : public OperableNumericExpr<SqrExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class ExpExpr : public OperableNumericExpr<ExpExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class LogExpr : public OperableNumericExpr<LogExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class SinExpr : public OperableNumericExpr<SinExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class CosExpr : public OperableNumericExpr<CosExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class TanExpr : public OperableNumericExpr<TanExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class RndExpr : public OperableNumericExpr<RndExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class PeekExpr : public OperableNumericExpr<PeekExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class LenExpr : public OperableNumericExpr<LenExpr> {
public:
  std::unique_ptr<StringExpr> expr;
};

class StrExpr : public OperableStringExpr<StrExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class ValExpr : public OperableNumericExpr<ValExpr> {
public:
  std::unique_ptr<StringExpr> expr;
};

class AscExpr : public OperableNumericExpr<AscExpr> {
public:
  std::unique_ptr<StringExpr> expr;
};

class ChrExpr : public OperableStringExpr<ChrExpr> {
public:
  std::unique_ptr<NumericExpr> expr;
};

class LeftExpr : public OperableStringExpr<LeftExpr> {
public:
  std::unique_ptr<StringExpr> str;
  std::unique_ptr<NumericExpr> len;
};

class RightExpr : public OperableStringExpr<RightExpr> {
public:
  std::unique_ptr<StringExpr> str;
  std::unique_ptr<NumericExpr> len;
};

class MidExpr : public OperableStringExpr<MidExpr> {
public:
  std::unique_ptr<StringExpr> str;
  std::unique_ptr<NumericExpr> start;
  std::unique_ptr<NumericExpr> len;
};

class PointExpr : public OperableNumericExpr<PointExpr> {
public:
  std::unique_ptr<NumericExpr> x;
  std::unique_ptr<NumericExpr> y;
};

class InkeyExpr : public OperableStringExpr<InkeyExpr> {};

class MemExpr : public OperableNumericExpr<MemExpr> {};
#endif
