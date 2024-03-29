// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_LISTER_HPP
#define AST_LISTER_HPP

#include "nullstatementmutator.hpp"
#include "program.hpp"

// Debugging aid
// Print the program's abstract syntax tree

class ExprLister : public ExprAbsorber<void, void> {
public:
  ExprLister() = default;
  ExprLister(const ExprLister &) = delete;
  ExprLister(ExprLister &&) = delete;
  ExprLister &operator=(const ExprLister &) = delete;
  ExprLister &operator=(ExprLister &&) = delete;
  ~ExprLister() override = default;

  void absorb(const NumericConstantExpr &e) override;
  void absorb(const StringConstantExpr &e) override;
  void absorb(const NumericVariableExpr &e) override;
  void absorb(const StringVariableExpr &e) override;
  void absorb(const NaryNumericExpr &e) override;
  void absorb(const StringConcatenationExpr &e) override;
  void absorb(const ArrayIndicesExpr &e) override;
  void absorb(const PrintTabExpr &e) override;
  void absorb(const PrintCommaExpr &e) override;
  void absorb(const PrintSpaceExpr &e) override;
  void absorb(const PrintCRExpr &e) override;
  void absorb(const NumericArrayExpr &e) override;
  void absorb(const StringArrayExpr &e) override;
  void absorb(const PowerExpr &e) override;
  void absorb(const IntegerDivisionExpr &e) override;
  void absorb(const MultiplicativeExpr &e) override {
    e.NaryNumericExpr::soak(this);
  }
  void absorb(const AdditiveExpr &e) override { e.NaryNumericExpr::soak(this); }
  void absorb(const ComplementedExpr &e) override;
  void absorb(const AndExpr &e) override { e.NaryNumericExpr::soak(this); }
  void absorb(const OrExpr &e) override { e.NaryNumericExpr::soak(this); }
  void absorb(const ShiftExpr &e) override;
  void absorb(const SgnExpr &e) override;
  void absorb(const IntExpr &e) override;
  void absorb(const AbsExpr &e) override;
  void absorb(const SqrExpr &e) override;
  void absorb(const ExpExpr &e) override;
  void absorb(const LogExpr &e) override;
  void absorb(const SinExpr &e) override;
  void absorb(const CosExpr &e) override;
  void absorb(const TanExpr &e) override;
  void absorb(const RndExpr &e) override;
  void absorb(const PeekExpr &e) override;
  void absorb(const LenExpr &e) override;
  void absorb(const StrExpr &e) override;
  void absorb(const ValExpr &e) override;
  void absorb(const AscExpr &e) override;
  void absorb(const ChrExpr &e) override;
  void absorb(const RelationalExpr &e) override;
  void absorb(const LeftExpr &e) override;
  void absorb(const RightExpr &e) override;
  void absorb(const MidExpr &e) override;
  void absorb(const PointExpr &e) override;
  void absorb(const InkeyExpr &e) override;
  void absorb(const MemExpr &e) override;
  void absorb(const SquareExpr &e) override;
  void absorb(const FractExpr &e) override;
  void absorb(const TimerExpr &e) override;
  void absorb(const PosExpr &e) override;
  void absorb(const PeekWordExpr &e) override;
  std::string result;
};

class StatementLister : public StatementAbsorber<void> {
public:
  StatementLister() = default;
  StatementLister(const StatementLister &) = delete;
  StatementLister(StatementLister &&) = delete;
  StatementLister &operator=(const StatementLister &) = delete;
  StatementLister &operator=(StatementLister &&) = delete;
  ~StatementLister() override = default;

  void absorb(const Rem &s) override;
  void absorb(const For &s) override;
  void absorb(const Go &s) override;
  void absorb(const When &s) override;
  void absorb(const If &s) override;
  void absorb(const Data &s) override;
  void absorb(const Print &s) override;
  void absorb(const Input &s) override;
  void absorb(const End &s) override;
  void absorb(const On &s) override;
  void absorb(const Next &s) override;
  void absorb(const Dim &s) override;
  void absorb(const Read &s) override;
  void absorb(const Let &s) override;
  void absorb(const Accum &s) override;
  void absorb(const Decum &s) override;
  void absorb(const Necum &s) override;
  void absorb(const Eval &s) override;
  void absorb(const Run &s) override;
  void absorb(const Restore &s) override;
  void absorb(const Return &s) override;
  void absorb(const Stop &s) override;
  void absorb(const Poke &s) override;
  void absorb(const Clear &s) override;
  void absorb(const CLoadM &s) override;
  void absorb(const CLoadStar &s) override;
  void absorb(const CSaveStar &s) override;
  void absorb(const Set &s) override;
  void absorb(const Reset &s) override;
  void absorb(const Cls &s) override;
  void absorb(const Sound &s) override;
  void absorb(const Exec &s) override;
  void absorb(const Error &s) override;
  std::string result;
  bool generatePredicates{true};
};

class Lister : public ProgramOp {
public:
  void operate(Program &p) override;
  void operate(Line &l) override;
  std::string result;
};
#endif
