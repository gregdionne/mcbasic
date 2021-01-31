// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef EXPRESSIONS_HPP
#define EXPRESSIONS_HPP

#include <memory>
#include <string>
#include <utility>
#include <vector>

// Expression Visitor
//   For simplicity, we use just one non-const void visitor.

class Expr;
class StringExpr;
class NumericExpr;
class ArrayIndicesExpr;
class UnaryNumericExpr;
class UnaryStringExpr;
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

class ExprOp {
public:
  virtual void operate(Expr & /*expr*/) {}
  virtual void operate(StringExpr & /*expr*/) {}
  virtual void operate(NumericExpr & /*expr*/) {}
  virtual void operate(ArrayIndicesExpr & /*expr*/) {}
  virtual void operate(UnaryNumericExpr & /*expr*/) {}
  virtual void operate(UnaryStringExpr & /*expr*/) {}
  virtual void operate(NumericConstantExpr & /*expr*/) {}
  virtual void operate(StringConstantExpr & /*expr*/) {}
  virtual void operate(NumericArrayExpr & /*expr*/) {}
  virtual void operate(StringArrayExpr & /*expr*/) {}
  virtual void operate(NumericVariableExpr & /*expr*/) {}
  virtual void operate(StringVariableExpr & /*expr*/) {}
  virtual void operate(NaryNumericExpr & /*expr*/) {}
  virtual void operate(StringConcatenationExpr & /*expr*/) {}
  virtual void operate(PrintTabExpr & /*expr*/) {}
  virtual void operate(PrintSpaceExpr & /*expr*/) {}
  virtual void operate(PrintCRExpr & /*expr*/) {}
  virtual void operate(PrintCommaExpr & /*expr*/) {}
  virtual void operate(NegatedExpr & /*expr*/) {}
  virtual void operate(PowerExpr & /*expr*/) {}
  virtual void operate(MultiplicativeExpr & /*expr*/) {}
  virtual void operate(AdditiveExpr & /*expr*/) {}
  virtual void operate(ComplementedExpr & /*expr*/) {}
  virtual void operate(RelationalExpr & /*expr*/) {}
  virtual void operate(AndExpr & /*expr*/) {}
  virtual void operate(OrExpr & /*expr*/) {}
  virtual void operate(ShiftExpr & /*expr*/) {}
  virtual void operate(SgnExpr & /*expr*/) {}
  virtual void operate(IntExpr & /*expr*/) {}
  virtual void operate(AbsExpr & /*expr*/) {}
  virtual void operate(SqrExpr & /*expr*/) {}
  virtual void operate(ExpExpr & /*expr*/) {}
  virtual void operate(LogExpr & /*expr*/) {}
  virtual void operate(SinExpr & /*expr*/) {}
  virtual void operate(CosExpr & /*expr*/) {}
  virtual void operate(TanExpr & /*expr*/) {}
  virtual void operate(RndExpr & /*expr*/) {}
  virtual void operate(PeekExpr & /*expr*/) {}
  virtual void operate(LenExpr & /*expr*/) {}
  virtual void operate(StrExpr & /*expr*/) {}
  virtual void operate(ValExpr & /*expr*/) {}
  virtual void operate(AscExpr & /*expr*/) {}
  virtual void operate(ChrExpr & /*expr*/) {}
  virtual void operate(LeftExpr & /*expr*/) {}
  virtual void operate(RightExpr & /*expr*/) {}
  virtual void operate(MidExpr & /*expr*/) {}
  virtual void operate(PointExpr & /*expr*/) {}
  virtual void operate(InkeyExpr & /*expr*/) {}
};

// define Expressions in the statement's AST

class Expr {
public:
  Expr() = default;
  Expr(const Expr &) = delete;
  Expr(Expr &&) = default;
  Expr &operator=(const Expr &) = delete;
  Expr &operator=(Expr &&) = default;
  virtual ~Expr() = default;

  virtual bool isBoolean() { return false; }
  virtual bool isRelational() { return false; }
  virtual bool isString() { return false; }
  virtual void operate(ExprOp * /*op*/) {}
  virtual bool isConst(double & /*val*/) { return false; }
  virtual bool isVar() { return false; }
  virtual bool isConst(std::string & /*val*/) { return false; }
  virtual Expr *makeArray(ArrayIndicesExpr * /*expr*/) { return nullptr; }
};

class StringExpr : public Expr {
  bool isString() override { return true; }
};

class NumericExpr : public Expr {
  bool isString() override { return false; } // not needed...
};

class ArrayIndicesExpr : public NumericExpr {
public:
  std::vector<std::unique_ptr<NumericExpr>> operands;
  void append(std::unique_ptr<NumericExpr> e) {
    operands.emplace_back(std::move(e));
  }
  void operate(ExprOp *op) override { op->operate(*this); }
};

class UnaryNumericExpr : public NumericExpr {
public:
  std::string funcName;
  explicit UnaryNumericExpr(std::string f) : funcName(std::move(f)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class UnaryStringExpr : public StringExpr {
public:
  std::string funcName;
  explicit UnaryStringExpr(std::string f) : funcName(std::move(f)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class NumericConstantExpr : public NumericExpr {
public:
  double value;
  explicit NumericConstantExpr(double v) : value(v) {}
  void operate(ExprOp *op) override { op->operate(*this); }
  bool isConst(double &val) override {
    val = value;
    return true;
  }
  bool isBoolean() override { return value == 0 || value == -1; }
};

class StringConstantExpr : public StringExpr {
public:
  std::string value;
  explicit StringConstantExpr(std::string v) : value(std::move(v)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
  bool isConst(std::string &val) override {
    val = value;
    return true;
  }
};

class NumericArrayExpr : public NumericExpr {
public:
  std::unique_ptr<NumericVariableExpr> varexp;
  std::unique_ptr<ArrayIndicesExpr> indices;
  NumericArrayExpr(NumericVariableExpr *v, ArrayIndicesExpr *i)
      : varexp(v), indices(i) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class StringArrayExpr : public StringExpr {
public:
  std::unique_ptr<StringVariableExpr> varexp;
  std::unique_ptr<ArrayIndicesExpr> indices;
  StringArrayExpr(StringVariableExpr *v, ArrayIndicesExpr *i)
      : varexp(v), indices(i) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class NumericVariableExpr : public NumericExpr {
public:
  std::string varname;
  explicit NumericVariableExpr(std::string v) : varname(std::move(v)) {}
  Expr *makeArray(ArrayIndicesExpr *indices) override {
    return new NumericArrayExpr(this, indices);
  }
  void operate(ExprOp *op) override { op->operate(*this); }
  bool isVar() override { return true; }
};

class StringVariableExpr : public StringExpr {
public:
  std::string varname;
  explicit StringVariableExpr(std::string v) : varname(std::move(v)) {}
  Expr *makeArray(ArrayIndicesExpr *indices) override {
    return new StringArrayExpr(this, indices);
  }
  void operate(ExprOp *op) override { op->operate(*this); }
  bool isVar() override { return true; }
};

class NaryNumericExpr : public NumericExpr {
public:
  std::vector<std::unique_ptr<NumericExpr>> operands;
  std::vector<std::unique_ptr<NumericExpr>> invoperands;
  std::string funcName;
  std::string invName;
  void append(bool isOp, std::unique_ptr<NumericExpr> e) {
    if (isOp) {
      operands.emplace_back(std::move(e));
    } else {
      invoperands.emplace_back(std::move(e));
    }
  }
  void operate(ExprOp *op) override { op->operate(*this); }
};

class StringConcatenationExpr : public StringExpr {
public:
  std::vector<std::unique_ptr<StringExpr>> operands;
  explicit StringConcatenationExpr(std::unique_ptr<StringExpr> e) {
    operands.emplace_back(std::move(e));
  }
  void append(std::unique_ptr<StringExpr> e) {
    operands.emplace_back(std::move(e));
  }
  void operate(ExprOp *op) override { op->operate(*this); }
};

class PrintTabExpr : public StringExpr {
public:
  std::unique_ptr<NumericExpr> tabstop;
  explicit PrintTabExpr(std::unique_ptr<NumericExpr> e)
      : tabstop(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class PrintSpaceExpr : public StringExpr {
public:
  void operate(ExprOp *op) override { op->operate(*this); }
};

class PrintCRExpr : public StringExpr {
public:
  void operate(ExprOp *op) override { op->operate(*this); }
};

class PrintCommaExpr : public StringExpr {
public:
  void operate(ExprOp *op) override { op->operate(*this); }
};

class NegatedExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit NegatedExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("-"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class PowerExpr : public NumericExpr {
public:
  std::unique_ptr<NumericExpr> base;
  std::unique_ptr<NumericExpr> exponent;
  std::string funcName = "^";
  PowerExpr(std::unique_ptr<NumericExpr> b, std::unique_ptr<NumericExpr> e)
      : base(std::move(b)), exponent(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class MultiplicativeExpr : public NaryNumericExpr {
public:
  explicit MultiplicativeExpr(std::unique_ptr<NumericExpr> e) {
    funcName = "*";
    invName = "/";
    operands.emplace_back(std::move(e));
  }
  void operate(ExprOp *op) override { op->operate(*this); }
};

class AdditiveExpr : public NaryNumericExpr {
public:
  explicit AdditiveExpr(std::unique_ptr<NumericExpr> e) {
    funcName = "+";
    invName = "-";
    operands.emplace_back(std::move(e));
  }
  void operate(ExprOp *op) override { op->operate(*this); }
};

class ComplementedExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit ComplementedExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("NOT"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
  bool isBoolean() override { return expr->isBoolean(); }
};

class RelationalExpr : public NumericExpr {
public:
  std::string comparator;
  std::unique_ptr<Expr> lhs;
  std::unique_ptr<Expr> rhs;
  RelationalExpr(std::string c, Expr *le, Expr *re)
      : comparator(std::move(c)), lhs(le), rhs(re) {}
  bool isBoolean() override { return true; }
  bool isRelational() override { return true; }
  void operate(ExprOp *op) override { op->operate(*this); }
};

class AndExpr : public NaryNumericExpr {
public:
  explicit AndExpr(std::unique_ptr<NumericExpr> e) {
    funcName = "AND";
    operands.emplace_back(std::move(e));
  }
  void append(std::unique_ptr<NumericExpr> e) {
    operands.emplace_back(std::move(e));
  }
  void operate(ExprOp *op) override { op->operate(*this); }
  bool isBoolean() override {
    for (auto &operand : operands) {
      if (!operand->isBoolean()) {
        return false;
      }
    }
    return true;
  }
};

class OrExpr : public NaryNumericExpr {
public:
  explicit OrExpr(std::unique_ptr<NumericExpr> e) {
    funcName = "OR";
    operands.emplace_back(std::move(e));
  }
  void append(std::unique_ptr<NumericExpr> e) {
    operands.emplace_back(std::move(e));
  }
  void operate(ExprOp *op) override { op->operate(*this); }
  bool isBoolean() override {
    for (auto &operand : operands) {
      if (!operand->isBoolean()) {
        return false;
      }
    }
    return true;
  }
};

class ShiftExpr : public NumericExpr {
public:
  std::string funcName = "SHIFT";
  std::unique_ptr<NumericExpr> expr;
  int rhs;
  ShiftExpr(std::unique_ptr<NumericExpr> e, int n)
      : expr(std::move(e)), rhs(n) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class SgnExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit SgnExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("SGN"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class IntExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit IntExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("INT"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class AbsExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit AbsExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("ABS"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class SqrExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit SqrExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("SQR"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class ExpExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit ExpExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("EXP"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class LogExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit LogExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("LOG"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class SinExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit SinExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("SIN"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class CosExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit CosExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("COS"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class TanExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit TanExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("TAN"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class RndExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit RndExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("RND"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class PeekExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit PeekExpr(std::unique_ptr<NumericExpr> e)
      : UnaryNumericExpr("PEEK"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class LenExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<StringExpr> expr;
  explicit LenExpr(std::unique_ptr<StringExpr> e)
      : UnaryNumericExpr("LEN"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class StrExpr : public UnaryStringExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit StrExpr(std::unique_ptr<NumericExpr> e)
      : UnaryStringExpr("STR$"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class ValExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<StringExpr> expr;
  explicit ValExpr(std::unique_ptr<StringExpr> e)
      : UnaryNumericExpr("VAL"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class AscExpr : public UnaryNumericExpr {
public:
  std::unique_ptr<StringExpr> expr;
  explicit AscExpr(std::unique_ptr<StringExpr> e)
      : UnaryNumericExpr("ASC"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class ChrExpr : public UnaryStringExpr {
public:
  std::unique_ptr<NumericExpr> expr;
  explicit ChrExpr(std::unique_ptr<NumericExpr> e)
      : UnaryStringExpr("CHR$"), expr(std::move(e)) {}
  void operate(ExprOp *op) override { op->operate(*this); }
};

class LeftExpr : public StringExpr {
public:
  std::unique_ptr<StringExpr> str;
  std::unique_ptr<NumericExpr> len;
  void operate(ExprOp *op) override { op->operate(*this); }
};

class RightExpr : public StringExpr {
public:
  std::unique_ptr<StringExpr> str;
  std::unique_ptr<NumericExpr> len;
  void operate(ExprOp *op) override { op->operate(*this); }
};

class MidExpr : public StringExpr {
public:
  std::unique_ptr<StringExpr> str;
  std::unique_ptr<NumericExpr> start;
  std::unique_ptr<NumericExpr> len;
  void operate(ExprOp *op) override { op->operate(*this); }
};

class PointExpr : public NumericExpr {
public:
  std::unique_ptr<NumericExpr> x;
  std::unique_ptr<NumericExpr> y;
  void operate(ExprOp *op) override { op->operate(*this); }
};

class InkeyExpr : public StringExpr {
public:
  void operate(ExprOp *op) override { op->operate(*this); }
};
#endif
