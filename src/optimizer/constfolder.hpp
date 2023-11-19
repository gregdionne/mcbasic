// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_CONSTFOLDER_HPP
#define OPTIMIZER_CONSTFOLDER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "constinspector.hpp"
#include "utils/announcer.hpp"

// combines operations on immediately resolvable constants

class ExprConstFolder : public ExprMutator<utils::optional<double>,
                                           utils::optional<std::string>> {
public:
  explicit ExprConstFolder(const BinaryOption &option) : announcer(option) {}
  utils::optional<std::string> mutate(StringConstantExpr &e) override;
  utils::optional<std::string> mutate(StringVariableExpr &e) override;
  utils::optional<std::string> mutate(StringConcatenationExpr &e) override;
  utils::optional<std::string> mutate(StringArrayExpr &e) override;
  utils::optional<std::string> mutate(PrintTabExpr &e) override;
  utils::optional<std::string> mutate(PrintSpaceExpr &e) override;
  utils::optional<std::string> mutate(PrintCRExpr &e) override;
  utils::optional<std::string> mutate(LeftExpr &e) override;
  utils::optional<std::string> mutate(MidExpr &e) override;
  utils::optional<std::string> mutate(RightExpr &e) override;
  utils::optional<double> mutate(LenExpr &e) override;
  utils::optional<std::string> mutate(StrExpr &e) override;
  utils::optional<double> mutate(ValExpr &e) override;
  utils::optional<double> mutate(AscExpr &e) override;
  utils::optional<std::string> mutate(ChrExpr &e) override;
  utils::optional<double> mutate(NumericConstantExpr &e) override;
  utils::optional<double> mutate(NumericVariableExpr &e) override;
  utils::optional<double> mutate(NumericArrayExpr &e) override;
  utils::optional<double> mutate(ArrayIndicesExpr &e) override;
  utils::optional<double> mutate(PowerExpr &e) override;
  utils::optional<double> mutate(IntegerDivisionExpr &e) override;
  utils::optional<double> mutate(MultiplicativeExpr &e) override;
  utils::optional<double> mutate(AdditiveExpr &e) override;
  utils::optional<double> mutate(ComplementedExpr &e) override;
  utils::optional<double> mutate(AndExpr &e) override;
  utils::optional<double> mutate(OrExpr &e) override;
  utils::optional<double> mutate(ShiftExpr &e) override;
  utils::optional<double> mutate(SgnExpr &e) override;
  utils::optional<double> mutate(IntExpr &e) override;
  utils::optional<double> mutate(AbsExpr &e) override;
  utils::optional<double> mutate(SqrExpr &e) override;
  utils::optional<double> mutate(ExpExpr &e) override;
  utils::optional<double> mutate(LogExpr &e) override;
  utils::optional<double> mutate(SinExpr &e) override;
  utils::optional<double> mutate(CosExpr &e) override;
  utils::optional<double> mutate(TanExpr &e) override;
  utils::optional<double> mutate(RndExpr &e) override;
  utils::optional<double> mutate(PeekExpr &e) override;
  utils::optional<double> mutate(RelationalExpr &e) override;
  utils::optional<double> mutate(PointExpr &e) override;
  utils::optional<std::string> mutate(InkeyExpr &e) override;
  utils::optional<double> mutate(MemExpr &e) override;
  utils::optional<double> mutate(SquareExpr &e) override;
  utils::optional<double> mutate(FractExpr &e) override;
  utils::optional<double> mutate(PosExpr &e) override;
  utils::optional<double> mutate(TimerExpr &e) override;
  utils::optional<double> mutate(PeekWordExpr &e) override;

  utils::optional<double> mutate(NaryNumericExpr & /*e*/) override;
  utils::optional<std::string> mutate(PrintCommaExpr & /*e*/) override;

  void fold(up<Expr> &expr);
  utils::optional<double> fold(up<NumericExpr> &expr);
  utils::optional<std::string> fold(up<StringExpr> &expr);

  void setLineNumber(int n) { lineNumber = n; }

private:
  void fold(std::vector<up<NumericExpr>> &operands, bool &enableFold,
            bool &folded, int &iOffset, double &value,
            void (*op)(double &value, double v));
  ConstInspector constInspector;
  Announcer announcer;
  int lineNumber = -1;
};

class StatementConstFolder : public StatementMutator<void> {
public:
  explicit StatementConstFolder(const BinaryOption &option) : cfe(option) {}
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
  void mutate(Eval &s) override;
  void mutate(Poke &s) override;
  void mutate(Clear &s) override;
  void mutate(CLoadM &s) override;
  void mutate(CLoadStar &s) override;
  void mutate(CSaveStar &s) override;
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

  void setLineNumber(int n) { cfe.setLineNumber(n); }

private:
  ExprConstFolder cfe;
  ConstInspector constInspector;
};

class ConstFolder : public ProgramOp {
public:
  explicit ConstFolder(const BinaryOption &option) : cfs(option), that(&cfs) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  StatementConstFolder cfs;
  StatementMutator<void> *that;
};
#endif
