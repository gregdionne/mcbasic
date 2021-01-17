// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef CONSTFOLDER_HPP
#define CONSTFOLDER_HPP

#include "program.hpp"

// combines operations on immediately resolvable constants

class ExprConstFolder : public ExprOp {
public:
  void operate(StringConstantExpr &e) override;
  void operate(StringVariableExpr &e) override;
  void operate(StringConcatenationExpr &e) override;
  void operate(StringArrayExpr &e) override;
  void operate(PrintTabExpr &e) override;
  void operate(PrintSpaceExpr &e) override;
  void operate(PrintCRExpr &e) override;
  void operate(LeftExpr &e) override;
  void operate(MidExpr &e) override;
  void operate(RightExpr &e) override;
  void operate(LenExpr &e) override;
  void operate(StrExpr &e) override;
  void operate(ValExpr &e) override;
  void operate(AscExpr &e) override;
  void operate(ChrExpr &e) override;
  void operate(NumericConstantExpr &e) override;
  void operate(NumericVariableExpr &e) override;
  void operate(NumericArrayExpr &e) override;
  void operate(ArrayIndicesExpr &e) override;
  void operate(NegatedExpr &e) override;
  void operate(MultiplicativeExpr &e) override;
  void operate(AdditiveExpr &e) override;
  void operate(ComplementedExpr &e) override;
  void operate(AndExpr &e) override;
  void operate(OrExpr &e) override;
  void operate(SgnExpr &e) override;
  void operate(IntExpr &e) override;
  void operate(AbsExpr &e) override;
  void operate(RndExpr &e) override;
  void operate(PeekExpr &e) override;
  void operate(RelationalExpr &e) override;
  void operate(PointExpr &e) override;
  void operate(InkeyExpr &e) override;

  bool gotConst;
  double dvalue;
  std::string svalue;
  double fetchConst(NumericExpr &e);
  std::string fetchConst(StringExpr &e);

  bool fold(std::unique_ptr<Expr> &expr);
  bool fold(std::unique_ptr<NumericExpr> &expr);
  bool fold(std::unique_ptr<StringExpr> &expr);
  bool fold(std::unique_ptr<NumericExpr> &expr, double &value);
  bool fold(std::unique_ptr<StringExpr> &expr, std::string &value);

  void fold(std::vector<std::unique_ptr<NumericExpr>> &operands,
            bool &enableFold, bool &folded, int &iOffset, double &value,
            void (*op)(double &value, double v));
};

class StatementConstFolder : public StatementOp {
public:
  StatementConstFolder() = default;
  void operate(For &s) override;
  void operate(When &s) override;
  void operate(If &s) override;
  void operate(Print &s) override;
  void operate(On &s) override;
  void operate(Dim &s) override;
  void operate(Let &s) override;
  void operate(Poke &s) override;
  void operate(Clear &s) override;
  void operate(Set &s) override;
  void operate(Reset &s) override;
  void operate(Cls &s) override;
  void operate(Sound &s) override;

  ExprConstFolder cfe;
};

class ConstFolder : public ProgramOp {
public:
  ConstFolder() : that(&cfs) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  StatementConstFolder cfs;
  StatementOp *that;
};
#endif
