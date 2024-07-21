// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COMPILER_COMPILER_HPP
#define COMPILER_COMPILER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "ast/text.hpp"
#include "instqueue.hpp"

// Compiles the program AST into (virtual) instructions

class Compiler {
public:
  Compiler(const Text &text_in, const BinaryOption &g)
      : text(text_in), generateLines(g) {}
  InstQueue compile(Program &p);
  const Text &text;
  const BinaryOption &generateLines;
};

class StatementCompiler : public StatementAbsorber<void> {
public:
  StatementCompiler(const Text &text_in, InstQueue &queue_in, int firstLine_in,
                    std::vector<up<Line>>::iterator &itCurLine, bool g_in)
      : text(text_in), queue(queue_in), firstLine(firstLine_in),
        itCurrentLine(itCurLine), generateLines(g_in) {}
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
  const Text &text;
  InstQueue &queue;
  int firstLine;
  std::vector<up<Line>>::iterator &itCurrentLine;
  bool generateLines;
};

class ExprCompiler : public ExprAbsorber<void, void> {
public:
  ExprCompiler(const Text &text_in, InstQueue &queue_in)
      : text(text_in), queue(queue_in), arrayRef(false), arrayDim(false){};
  explicit ExprCompiler(ExprCompiler *a)
      : text(a->text), queue(a->queue), arrayRef(false), arrayDim(false){};
  void absorb(const NumericConstantExpr &e) override;
  void absorb(const StringConstantExpr &e) override;
  void absorb(const NumericVariableExpr &e) override;
  void absorb(const StringVariableExpr &e) override;
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
  void absorb(const MultiplicativeExpr &e) override;
  void absorb(const AdditiveExpr &e) override;
  void absorb(const ComplementedExpr &e) override;
  void absorb(const AndExpr &e) override;
  void absorb(const OrExpr &e) override;
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

  const Text &text;
  InstQueue &queue;
  up<AddressMode> result;
  bool arrayRef;
  bool arrayDim;

private:
  void absorb(const NaryNumericExpr & /*e*/) override {}
};

#endif
