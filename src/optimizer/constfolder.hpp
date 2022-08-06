// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_CONSTFOLDER_HPP
#define OPTIMIZER_CONSTFOLDER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"

// combines operations on immediately resolvable constants

class ExprConstFolder : public ExprMutator<void, void> {
public:
  void mutate(StringConstantExpr &e) override;
  void mutate(StringVariableExpr &e) override;
  void mutate(StringConcatenationExpr &e) override;
  void mutate(StringArrayExpr &e) override;
  void mutate(PrintTabExpr &e) override;
  void mutate(PrintSpaceExpr &e) override;
  void mutate(PrintCRExpr &e) override;
  void mutate(LeftExpr &e) override;
  void mutate(MidExpr &e) override;
  void mutate(RightExpr &e) override;
  void mutate(LenExpr &e) override;
  void mutate(StrExpr &e) override;
  void mutate(ValExpr &e) override;
  void mutate(AscExpr &e) override;
  void mutate(ChrExpr &e) override;
  void mutate(NumericConstantExpr &e) override;
  void mutate(NumericVariableExpr &e) override;
  void mutate(NumericArrayExpr &e) override;
  void mutate(ArrayIndicesExpr &e) override;
  void mutate(PowerExpr &e) override;
  void mutate(IntegerDivisionExpr &e) override;
  void mutate(MultiplicativeExpr &e) override;
  void mutate(AdditiveExpr &e) override;
  void mutate(ComplementedExpr &e) override;
  void mutate(AndExpr &e) override;
  void mutate(OrExpr &e) override;
  void mutate(ShiftExpr &e) override;
  void mutate(SgnExpr &e) override;
  void mutate(IntExpr &e) override;
  void mutate(AbsExpr &e) override;
  void mutate(SqrExpr &e) override;
  void mutate(ExpExpr &e) override;
  void mutate(LogExpr &e) override;
  void mutate(SinExpr &e) override;
  void mutate(CosExpr &e) override;
  void mutate(TanExpr &e) override;
  void mutate(RndExpr &e) override;
  void mutate(PeekExpr &e) override;
  void mutate(RelationalExpr &e) override;
  void mutate(PointExpr &e) override;
  void mutate(InkeyExpr &e) override;
  void mutate(MemExpr &e) override;
  void mutate(SquareExpr &e) override;
  void mutate(PosExpr &e) override;
  void mutate(TimerExpr &e) override;
  void mutate(PeekWordExpr &e) override;

  void mutate(NaryNumericExpr & /*e*/) override { gotConst = false; };
  void mutate(PrintCommaExpr & /*e*/) override { gotConst = false; };

  bool fold(up<Expr> &expr);
  bool fold(up<NumericExpr> &expr);
  bool fold(up<StringExpr> &expr);

private:
  bool gotConst{false};
  double dvalue{0};
  std::string svalue;
  double fetchConst(NumericExpr &e);
  std::string fetchConst(StringExpr &e);

  bool fold(up<NumericExpr> &expr, double &value);
  bool fold(up<StringExpr> &expr, std::string &value);

  void fold(std::vector<up<NumericExpr>> &operands, bool &enableFold,
            bool &folded, int &iOffset, double &value,
            void (*op)(double &value, double v));
};

class StatementConstFolder : public StatementMutator<void> {
public:
  StatementConstFolder() = default;

  void mutate(For &s) override;
  void mutate(When &s) override;
  void mutate(If &s) override;
  void mutate(Print &s) override;
  void mutate(Input &s) override;
  void mutate(On &s) override;
  void mutate(Dim &s) override;
  void mutate(Read &s) override;
  void mutate(Let &s) override;
  void mutate(Accum &s) override;
  void mutate(Decum &s) override;
  void mutate(Necum &s) override;
  void mutate(Poke &s) override;
  void mutate(Clear &s) override;
  void mutate(Set &s) override;
  void mutate(Reset &s) override;
  void mutate(Cls &s) override;
  void mutate(Sound &s) override;
  void mutate(Exec &s) override;

  void mutate(Rem & /*s*/) override {}
  void mutate(Go & /*s*/) override {}
  void mutate(Data & /*s*/) override {}
  void mutate(End & /*s*/) override {}
  void mutate(Next & /*s*/) override {}
  void mutate(Run & /*s*/) override {}
  void mutate(Restore & /*s*/) override {}
  void mutate(Return & /*s*/) override {}
  void mutate(Stop & /*s*/) override {}
  void mutate(Error & /*s*/) override {}

private:
  ExprConstFolder cfe;
};

class ConstFolder : public ProgramOp {
public:
  ConstFolder() : that(&cfs) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  StatementConstFolder cfs;
  StatementMutator<void> *that;
};
#endif
