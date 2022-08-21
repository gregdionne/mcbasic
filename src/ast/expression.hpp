// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License

#ifndef AST_EXPRESSIONS_HPP
#define AST_EXPRESSIONS_HPP

#include "utils/memutils.hpp" // up<T>, makeup<T>, mv()
#include "utils/optional.hpp" // utils::optional<T>

#include <cmath>
#include <string>
#include <vector>

// forward declarations for visitors

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

// extensions
class SquareExpr;
class TimerExpr;
class PosExpr;
class PeekWordExpr;

// Expression Visitors
//
// The abstract syntax tree (AST) has a few flavors of
// visitors to help with const correctness and friendly return values.
//
//  ASTVisitor | visit()   | visitor  | AST
// ------------+-----------+----------+---------
//   inspector | inspect() | const    | const
//   absorber  | absorb()  | mutable  | const
// * exuder    | exude()   | const    | mutable
//   mutator   | mutate()  | mutable  | mutable
//
// * not yet implemented.
//
// The accept methods have more diverse names depending on return values.
//
//   check()       - calls an inspector with boolean return
//   constify()    - calls an inspector returning utils::optional
//   select()      - calls an inspector returning a branch of the AST
//   inspect()     - calls an inspector with no (void) return
//   soak()        - calls an absorber with no (void) return
//   mutate()      - calls a mutator with no (void) return
//   transmutate() - calls a mutator that returns a new branch of the AST.

// ExprMutator
//   Changes an expression in-place.
//   Return values templetized according to string/numeric type
template <typename Number, typename String> class ExprMutator {
public:
  ExprMutator() = default;
  ExprMutator(const ExprMutator &) = delete;
  ExprMutator(ExprMutator &&) = delete;
  ExprMutator &operator=(const ExprMutator &) = delete;
  ExprMutator &operator=(ExprMutator &&) = delete;
  virtual ~ExprMutator() = default;

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
  virtual Number mutate(SquareExpr & /*expr*/) = 0;
  virtual Number mutate(TimerExpr & /*expr*/) = 0;
  virtual Number mutate(PosExpr & /*expr*/) = 0;
  virtual Number mutate(PeekWordExpr & /*expr*/) = 0;
};

// ExprInspector
//   Examines an expression (but cannot change it)
//   Return values templetized according to string/numeric type
template <typename Number, typename String> class ExprInspector {
public:
  ExprInspector() = default;
  ExprInspector(const ExprInspector &) = delete;
  ExprInspector(ExprInspector &&) = delete;
  ExprInspector &operator=(const ExprInspector &) = delete;
  ExprInspector &operator=(ExprInspector &&) = delete;
  virtual ~ExprInspector() = default;

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
  virtual Number inspect(const SquareExpr & /*expr*/) const = 0;
  virtual Number inspect(const TimerExpr & /*expr*/) const = 0;
  virtual Number inspect(const PosExpr & /*expr*/) const = 0;
  virtual Number inspect(const PeekWordExpr & /*expr*/) const = 0;
};

// ExprAbsorber
//   Changes internal state via examining an expression.
//   Return values templetized according to string/numeric type
template <typename Number, typename String> class ExprAbsorber {
public:
  ExprAbsorber() = default;
  ExprAbsorber(const ExprAbsorber &) = delete;
  ExprAbsorber(ExprAbsorber &&) = delete;
  ExprAbsorber &operator=(const ExprAbsorber &) = delete;
  ExprAbsorber &operator=(ExprAbsorber &&) = delete;
  virtual ~ExprAbsorber() = default;

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
  virtual Number absorb(const PosExpr & /*expr*/) = 0;
  virtual Number absorb(const MemExpr & /*expr*/) = 0;
  virtual Number absorb(const SquareExpr & /*expr*/) = 0;
  virtual Number absorb(const TimerExpr & /*expr*/) = 0;
  virtual Number absorb(const PeekWordExpr & /*expr*/) = 0;
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
  virtual bool isVar() const { return false; }
  virtual bool isConst(double & /*val*/) const { return false; }
  virtual bool isConst(std::string & /*val*/) const { return false; }

  virtual bool check(const ExprInspector<bool, bool> * /*op*/) const = 0;
  virtual void inspect(const ExprInspector<void, void> * /*op*/) const = 0;
  virtual void soak(ExprAbsorber<void, void> * /*op*/) const = 0;
  virtual void mutate(ExprMutator<void, void> * /*op*/) = 0;

  // downconversions
  virtual NumericExpr *numExpr() { return nullptr; }
  virtual StringExpr *strExpr() { return nullptr; }
  virtual const NumericExpr *numExpr() const { return nullptr; }
  virtual const StringExpr *strExpr() const { return nullptr; }
};

class NumericExpr : public Expr {
public:
  bool isString() override { return false; } // not needed...
  NumericExpr *numExpr() override { return this; }
  const NumericExpr *numExpr() const override { return this; }

  virtual up<NumericExpr>
  transmutate(ExprMutator<up<NumericExpr>, up<StringExpr>> *transmutator) = 0;

  virtual utils::optional<double> constify(
      const ExprInspector<utils::optional<double>, utils::optional<std::string>>
          *constifier) const = 0;

  virtual utils::optional<double>
  constify(ExprMutator<utils::optional<double>, utils::optional<std::string>>
               *constifier) = 0;

  virtual const NumericExpr *
  select(const ExprInspector<const NumericExpr *, const StringExpr *> *selector)
      const = 0;
};

template <typename T> class OperableNumericExpr : public NumericExpr {
public:
  bool check(const ExprInspector<bool, bool> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void inspect(const ExprInspector<void, void> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void soak(ExprAbsorber<void, void> *op) const override {
    return op->absorb(*static_cast<const T *>(this));
  }

  up<NumericExpr> transmutate(
      ExprMutator<up<NumericExpr>, up<StringExpr>> *transmutator) override {
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

  utils::optional<double>
  constify(ExprMutator<utils::optional<double>, utils::optional<std::string>>
               *constifier) override {
    return constifier->mutate(*static_cast<T *>(this));
  }

  const NumericExpr *
  select(const ExprInspector<const NumericExpr *, const StringExpr *> *selector)
      const override {
    return selector->inspect(*static_cast<const T *>(this));
  }
};

class StringExpr : public Expr {
public:
  bool isString() override { return true; }
  StringExpr *strExpr() override { return this; }
  const StringExpr *strExpr() const override { return this; }

  virtual up<StringExpr>
  transmutate(ExprMutator<up<NumericExpr>, up<StringExpr>> *transmutator) = 0;

  virtual utils::optional<std::string> constify(
      const ExprInspector<utils::optional<double>, utils::optional<std::string>>
          *obtainer) const = 0;

  virtual utils::optional<std::string>
  constify(ExprMutator<utils::optional<double>, utils::optional<std::string>>
               *obtainer) = 0;

  virtual const StringExpr *
  select(const ExprInspector<const NumericExpr *, const StringExpr *> *selector)
      const = 0;
};

template <typename T> class OperableStringExpr : public StringExpr {
public:
  bool check(const ExprInspector<bool, bool> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void inspect(const ExprInspector<void, void> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }

  void soak(ExprAbsorber<void, void> *op) const override {
    return op->absorb(*static_cast<const T *>(this));
  }

  up<StringExpr> transmutate(
      ExprMutator<up<NumericExpr>, up<StringExpr>> *transmutator) override {
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

  utils::optional<std::string>
  constify(ExprMutator<utils::optional<double>, utils::optional<std::string>>
               *constifier) override {
    return constifier->mutate(*static_cast<T *>(this));
  }

  const StringExpr *
  select(const ExprInspector<const NumericExpr *, const StringExpr *> *selector)
      const override {
    return selector->inspect(*static_cast<const T *>(this));
  }
};

class ArrayIndicesExpr : public OperableNumericExpr<ArrayIndicesExpr> {
public:
  std::vector<up<NumericExpr>> operands;
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
  explicit StringConstantExpr(std::string v) : value(mv(v)) {}
  bool isConst(std::string &val) const override {
    val = value;
    return true;
  }
};

class NumericArrayExpr : public OperableNumericExpr<NumericArrayExpr> {
public:
  up<NumericVariableExpr> varexp;
  up<ArrayIndicesExpr> indices;
};

class StringArrayExpr : public OperableStringExpr<StringArrayExpr> {
public:
  up<StringVariableExpr> varexp;
  up<ArrayIndicesExpr> indices;
};

class NumericVariableExpr : public OperableNumericExpr<NumericVariableExpr> {
public:
  std::string varname;
  explicit NumericVariableExpr(std::string v) : varname(mv(v)) {}
  bool isVar() const override { return true; }
};

class StringVariableExpr : public OperableStringExpr<StringVariableExpr> {
public:
  std::string varname;
  explicit StringVariableExpr(std::string v) : varname(mv(v)) {}
  bool isVar() const override { return true; }
};

class NaryNumericExpr : public OperableNumericExpr<NaryNumericExpr> {
public:
  std::vector<up<NumericExpr>> operands;
  std::vector<up<NumericExpr>> invoperands;
  NaryNumericExpr(double id, double a, const char *fn,
                  double (*f)(double, double), const char *in,
                  double (*i)(double, double))
      : identity(id), annihilator(a), funcName(fn), function(f), invName(in),
        inverse(i) {}
  double identity;
  double annihilator;
  std::string funcName;
  double (*function)(double, double);
  std::string invName;
  double (*inverse)(double, double);
};

template <typename T> class OperableNaryNumericExpr : public NaryNumericExpr {
public:
  OperableNaryNumericExpr(
      double id, double a, const char *fn, double (*f)(double, double),
      const char *in = "",
      double (*i)(double, double) = [](double a, double) -> double {
        return a;
      })
      : NaryNumericExpr(id, a, fn, f, in, i) {}

  bool check(const ExprInspector<bool, bool> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }
  void inspect(const ExprInspector<void, void> *op) const override {
    return op->inspect(*static_cast<const T *>(this));
  }
  up<NumericExpr> transmutate(
      ExprMutator<up<NumericExpr>, up<StringExpr>> *transmutator) override {
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
  std::vector<up<StringExpr>> operands;
  explicit StringConcatenationExpr(up<StringExpr> e) {
    operands.emplace_back(mv(e));
  }
};

class PrintTabExpr : public OperableStringExpr<PrintTabExpr> {
public:
  up<NumericExpr> tabstop;
  explicit PrintTabExpr(up<NumericExpr> e) : tabstop(mv(e)) {}
};

class PrintSpaceExpr : public OperableStringExpr<PrintSpaceExpr> {};

class PrintCRExpr : public OperableStringExpr<PrintCRExpr> {};

class PrintCommaExpr : public OperableStringExpr<PrintCommaExpr> {};

class PowerExpr : public OperableNumericExpr<PowerExpr> {
public:
  up<NumericExpr> base;
  up<NumericExpr> exponent;
  std::string funcName = "^";
  PowerExpr(up<NumericExpr> b, up<NumericExpr> e)
      : base(mv(b)), exponent(mv(e)) {}
};

class IntegerDivisionExpr : public OperableNumericExpr<IntegerDivisionExpr> {
public:
  up<NumericExpr> dividend;
  up<NumericExpr> divisor;
  std::string funcName = "^";
  IntegerDivisionExpr(up<NumericExpr> num, up<NumericExpr> den)
      : dividend(mv(num)), divisor(mv(den)) {}
};

class MultiplicativeExpr : public OperableNaryNumericExpr<MultiplicativeExpr> {
public:
  MultiplicativeExpr() : OperableNaryNumericExpr(1, 0, "*", mul_, "/", div_) {}
  explicit MultiplicativeExpr(up<NumericExpr> e)
      : OperableNaryNumericExpr(1, 0, "*", mul_, "/", div_) {
    operands.emplace_back(mv(e));
  }
  static double mul_(double a, double b) { return a * b; }
  static double div_(double a, double b) { return a / b; }
};

class AdditiveExpr : public OperableNaryNumericExpr<AdditiveExpr> {
public:
  AdditiveExpr() : OperableNaryNumericExpr(0, NAN, "+", add_, "-", sub_) {}
  explicit AdditiveExpr(up<NumericExpr> e)
      : OperableNaryNumericExpr(0, NAN, "+", add_, "-", sub_) {
    operands.emplace_back(mv(e));
  }
  static double add_(double a, double b) { return a + b; }
  static double sub_(double a, double b) { return a - b; }
};

class ComplementedExpr : public OperableNumericExpr<ComplementedExpr> {
public:
  up<NumericExpr> expr;
  explicit ComplementedExpr(up<NumericExpr> e) : expr(mv(e)) {}
};

class RelationalExpr : public OperableNumericExpr<RelationalExpr> {
public:
  std::string comparator;
  up<Expr> lhs;
  up<Expr> rhs;
  RelationalExpr(std::string c, up<Expr> le, up<Expr> re)
      : comparator(mv(c)), lhs(mv(le)), rhs(mv(re)) {}
};

class AndExpr : public OperableNaryNumericExpr<AndExpr> {
public:
  AndExpr() : OperableNaryNumericExpr(-1, 0, "AND", and_) {}
  explicit AndExpr(up<NumericExpr> e)
      : OperableNaryNumericExpr(-1, 0, "AND", and_) {
    operands.emplace_back(mv(e));
  }
  static double and_(double a, double b) {
    return static_cast<int>(a) & static_cast<int>(b);
  }
};

class OrExpr : public OperableNaryNumericExpr<OrExpr> {
public:
  OrExpr() : OperableNaryNumericExpr(0, -1, "OR", or_) {}
  explicit OrExpr(up<NumericExpr> e)
      : OperableNaryNumericExpr(0, -1, "OR", or_) {
    operands.emplace_back(mv(e));
  }
  static double or_(double a, double b) {
    return static_cast<int>(a) | static_cast<int>(b);
  }
};

class ShiftExpr : public OperableNumericExpr<ShiftExpr> {
public:
  up<NumericExpr> expr;
  up<NumericExpr> count;
  ShiftExpr(up<NumericExpr> e, up<NumericExpr> n) : expr(mv(e)), count(mv(n)) {}
};

class SgnExpr : public OperableNumericExpr<SgnExpr> {
public:
  up<NumericExpr> expr;
};

class IntExpr : public OperableNumericExpr<IntExpr> {
public:
  up<NumericExpr> expr;
};

class AbsExpr : public OperableNumericExpr<AbsExpr> {
public:
  up<NumericExpr> expr;
};

class SqrExpr : public OperableNumericExpr<SqrExpr> {
public:
  up<NumericExpr> expr;
};

class ExpExpr : public OperableNumericExpr<ExpExpr> {
public:
  up<NumericExpr> expr;
};

class LogExpr : public OperableNumericExpr<LogExpr> {
public:
  up<NumericExpr> expr;
};

class SinExpr : public OperableNumericExpr<SinExpr> {
public:
  up<NumericExpr> expr;
};

class CosExpr : public OperableNumericExpr<CosExpr> {
public:
  up<NumericExpr> expr;
};

class TanExpr : public OperableNumericExpr<TanExpr> {
public:
  up<NumericExpr> expr;
};

class RndExpr : public OperableNumericExpr<RndExpr> {
public:
  up<NumericExpr> expr;
};

class PeekExpr : public OperableNumericExpr<PeekExpr> {
public:
  up<NumericExpr> expr;
};

class LenExpr : public OperableNumericExpr<LenExpr> {
public:
  up<StringExpr> expr;
};

class StrExpr : public OperableStringExpr<StrExpr> {
public:
  up<NumericExpr> expr;
};

class ValExpr : public OperableNumericExpr<ValExpr> {
public:
  up<StringExpr> expr;
};

class AscExpr : public OperableNumericExpr<AscExpr> {
public:
  up<StringExpr> expr;
};

class ChrExpr : public OperableStringExpr<ChrExpr> {
public:
  up<NumericExpr> expr;
};

class LeftExpr : public OperableStringExpr<LeftExpr> {
public:
  up<StringExpr> str;
  up<NumericExpr> len;
};

class RightExpr : public OperableStringExpr<RightExpr> {
public:
  up<StringExpr> str;
  up<NumericExpr> len;
};

class MidExpr : public OperableStringExpr<MidExpr> {
public:
  up<StringExpr> str;
  up<NumericExpr> start;
  up<NumericExpr> len;
};

class PointExpr : public OperableNumericExpr<PointExpr> {
public:
  up<NumericExpr> x;
  up<NumericExpr> y;
};

class InkeyExpr : public OperableStringExpr<InkeyExpr> {};

class MemExpr : public OperableNumericExpr<MemExpr> {};

class SquareExpr : public OperableNumericExpr<SquareExpr> {
public:
  up<NumericExpr> expr;
};

class TimerExpr : public OperableNumericExpr<TimerExpr> {};

class PosExpr : public OperableNumericExpr<PosExpr> {};

class PeekWordExpr : public OperableNumericExpr<PeekWordExpr> {
public:
  up<NumericExpr> expr;
};
#endif
