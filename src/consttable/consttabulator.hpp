// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef CONSTTABLE_CONSTTABULATOR_HPP
#define CONSTTABLE_CONSTTABULATOR_HPP

#include "ast/nullstatementinspector.hpp"
#include "ast/program.hpp"
#include "consttable.hpp"

// fills the specified table with all the constants in the program AST

class ExprConstTabulator : public ExprInspector<void, void> {
public:
  explicit ExprConstTabulator(ConstTable &ct) : constTable(ct) {}
  void inspect(const StringConstantExpr &e) const override;
  void inspect(const StringConcatenationExpr &e) const override;
  void inspect(const StringArrayExpr &e) const override;
  void inspect(const LeftExpr &e) const override;
  void inspect(const MidExpr &e) const override;
  void inspect(const RightExpr &e) const override;
  void inspect(const LenExpr &e) const override;
  void inspect(const StrExpr &e) const override;
  void inspect(const ValExpr &e) const override;
  void inspect(const AscExpr &e) const override;
  void inspect(const ChrExpr &e) const override;
  void inspect(const NumericConstantExpr &e) const override;
  void inspect(const NumericArrayExpr &e) const override;
  void inspect(const ArrayIndicesExpr &e) const override;
  void inspect(const PrintTabExpr &e) const override;
  void inspect(const NegatedExpr &e) const override;
  void inspect(const PowerExpr &e) const override;
  void inspect(const IntegerDivisionExpr &e) const override;
  void inspect(const MultiplicativeExpr &e) const override;
  void inspect(const AdditiveExpr &e) const override;
  void inspect(const ComplementedExpr &e) const override;
  void inspect(const AndExpr &e) const override;
  void inspect(const OrExpr &e) const override;
  void inspect(const ShiftExpr &e) const override;
  void inspect(const SgnExpr &e) const override;
  void inspect(const IntExpr &e) const override;
  void inspect(const AbsExpr &e) const override;
  void inspect(const SqrExpr &e) const override;
  void inspect(const ExpExpr &e) const override;
  void inspect(const LogExpr &e) const override;
  void inspect(const SinExpr &e) const override;
  void inspect(const CosExpr &e) const override;
  void inspect(const TanExpr &e) const override;
  void inspect(const RndExpr &e) const override;
  void inspect(const PeekExpr &e) const override;
  void inspect(const RelationalExpr &e) const override;
  void inspect(const PointExpr &e) const override;

  void inspect(const NumericVariableExpr &) const override{};
  void inspect(const StringVariableExpr &) const override{};
  void inspect(const NaryNumericExpr &) const override{};
  void inspect(const PrintSpaceExpr &) const override{};
  void inspect(const PrintCRExpr &) const override{};
  void inspect(const PrintCommaExpr &) const override{};
  void inspect(const InkeyExpr &) const override{};
  void inspect(const MemExpr &) const override{};

private:
  ConstTable &constTable;
};

class StatementConstTabulator : public NullStatementInspector {
public:
  explicit StatementConstTabulator(ConstTable &ct) : op(ct), that(&op) {}
  void inspect(const For &s) const override;
  void inspect(const When &s) const override;
  void inspect(const If &s) const override;
  void inspect(const Print &s) const override;
  void inspect(const Input &s) const override;
  void inspect(const On &s) const override;
  void inspect(const Dim &s) const override;
  void inspect(const Let &s) const override;
  void inspect(const Inc &s) const override;
  void inspect(const Dec &s) const override;
  void inspect(const Poke &s) const override;
  void inspect(const Clear &s) const override;
  void inspect(const Set &s) const override;
  void inspect(const Reset &s) const override;
  void inspect(const Cls &s) const override;
  void inspect(const Sound &s) const override;

private:
  using NullStatementInspector::inspect;
  ExprConstTabulator op;
  ExprInspector<void, void> *that;
};

class ConstTabulator : public ProgramOp {
public:
  explicit ConstTabulator(ConstTable &ct) : constTable(ct), op(ct), that(&op) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  using ProgramOp::operate;
  ConstTable &constTable;
  StatementConstTabulator op;
  StatementInspector<void> *that;
};
#endif
