// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COMPILER_COMPILER_HPP
#define COMPILER_COMPILER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "consttable/consttable.hpp"
#include "datatable/datatable.hpp"
#include "instqueue.hpp"
#include "symboltable/symboltable.hpp"

// Compiles the program AST into (virtual) instructions

class Compiler : public ProgramOp {
public:
  Compiler(DataTable &dt_in, ConstTable &ct_in, SymbolTable &st_in,
           InstQueue &queue_in, bool g)
      : dataTable(dt_in), constTable(ct_in), symbolTable(st_in),
        queue(queue_in), generateLines(g) {}
  void operate(Program &p) override;
  void operate(Line &l) override;
  DataTable &dataTable;
  ConstTable &constTable;
  SymbolTable &symbolTable;
  InstQueue &queue;
  bool generateLines;
  int firstLine{0};
  std::vector<up<Line>>::iterator itCurrentLine;
};

class StatementCompiler : public StatementAbsorber<void> {
public:
  StatementCompiler(ConstTable &ct_in, SymbolTable &st_in, DataTable &dt_in,
                    InstQueue &queue_in, int firstLine_in,
                    std::vector<up<Line>>::iterator &itCurLine, bool g_in)
      : constTable(ct_in), symbolTable(st_in), dataTable(dt_in),
        queue(queue_in), firstLine(firstLine_in), itCurrentLine(itCurLine),
        generateLines(g_in) {}
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
  void absorb(const Set &s) override;
  void absorb(const Reset &s) override;
  void absorb(const Cls &s) override;
  void absorb(const Sound &s) override;
  void absorb(const Exec &s) override;
  void absorb(const Error &s) override;
  ConstTable &constTable;
  SymbolTable &symbolTable;
  DataTable &dataTable;
  InstQueue &queue;
  int firstLine;
  std::vector<up<Line>>::iterator &itCurrentLine;
  bool generateLines;
};

class ExprCompiler : public ExprAbsorber<void, void> {
public:
  ExprCompiler(ConstTable &ct_in, SymbolTable &st_in, InstQueue &queue_in)
      : constTable(ct_in), symbolTable(st_in), queue(queue_in), arrayRef(false),
        arrayDim(false){};
  explicit ExprCompiler(ExprCompiler *a)
      : constTable(a->constTable), symbolTable(a->symbolTable), queue(a->queue),
        arrayRef(false), arrayDim(false){};
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
  void absorb(const TimerExpr &e) override;
  void absorb(const PosExpr &e) override;
  void absorb(const PeekWordExpr &e) override;

  void absorb(const NaryNumericExpr &e) override {
    fprintf(stderr, "panic! %s\n", e.funcName.c_str());
  }

  ConstTable &constTable;
  SymbolTable &symbolTable;
  InstQueue &queue;
  up<AddressMode> result;
  bool arrayRef;
  bool arrayDim;
};

#endif
