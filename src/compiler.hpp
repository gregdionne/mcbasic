// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COMPILER_HPP
#define COMPILER_HPP

#include "instqueue.hpp"
#include "program.hpp"

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
  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

class StatementCompiler : public StatementOp {
public:
  StatementCompiler(ConstTable &ct_in, SymbolTable &st_in, DataTable &dt_in,
                    InstQueue &queue_in, int firstLine_in,
                    std::vector<std::unique_ptr<Line>>::iterator &itCurLine,
                    bool g_in)
      : constTable(ct_in), symbolTable(st_in), dataTable(dt_in),
        queue(queue_in), firstLine(firstLine_in), itCurrentLine(itCurLine),
        generateLines(g_in) {}
  void operate(Rem &s) override;
  void operate(For &s) override;
  void operate(Go &s) override;
  void operate(When &s) override;
  void operate(If &s) override;
  void operate(Data &s) override;
  void operate(Print &s) override;
  void operate(Input &s) override;
  void operate(End &s) override;
  void operate(On &s) override;
  void operate(Next &s) override;
  void operate(Dim &s) override;
  void operate(Read &s) override;
  void operate(Let &s) override;
  void operate(Inc &s) override;
  void operate(Dec &s) override;
  void operate(Run &s) override;
  void operate(Restore &s) override;
  void operate(Return &s) override;
  void operate(Stop &s) override;
  void operate(Poke &s) override;
  void operate(Clear &s) override;
  void operate(Set &s) override;
  void operate(Reset &s) override;
  void operate(Cls &s) override;
  void operate(Sound &s) override;
  ConstTable &constTable;
  SymbolTable &symbolTable;
  DataTable &dataTable;
  InstQueue &queue;
  int firstLine;
  std::vector<std::unique_ptr<Line>>::iterator &itCurrentLine;
  bool generateLines;
};

class ExprCompiler : public ExprOp {
public:
  ExprCompiler(ConstTable &ct_in, SymbolTable &st_in, InstQueue &queue_in)
      : constTable(ct_in), symbolTable(st_in), queue(queue_in), arrayRef(false),
        arrayDim(false){};
  explicit ExprCompiler(ExprCompiler *a)
      : constTable(a->constTable), symbolTable(a->symbolTable), queue(a->queue),
        arrayRef(false), arrayDim(false){};
  void operate(NumericConstantExpr &e) override;
  void operate(StringConstantExpr &e) override;
  void operate(NumericVariableExpr &e) override;
  void operate(StringVariableExpr &e) override;
  void operate(StringConcatenationExpr &e) override;
  void operate(ArrayIndicesExpr &e) override;
  void operate(PrintTabExpr &e) override;
  void operate(PrintCommaExpr &e) override;
  void operate(PrintSpaceExpr &e) override;
  void operate(PrintCRExpr &e) override;
  void operate(NumericArrayExpr &e) override;
  void operate(StringArrayExpr &e) override;
  void operate(NegatedExpr &e) override;
  void operate(PowerExpr &e) override;
  void operate(MultiplicativeExpr &e) override;
  void operate(AdditiveExpr &e) override;
  void operate(ComplementedExpr &e) override;
  void operate(AndExpr &e) override;
  void operate(OrExpr &e) override;
  void operate(ShiftExpr &e) override;
  void operate(SgnExpr &e) override;
  void operate(IntExpr &e) override;
  void operate(AbsExpr &e) override;
  void operate(SqrExpr &e) override;
  void operate(ExpExpr &e) override;
  void operate(LogExpr &e) override;
  void operate(SinExpr &e) override;
  void operate(CosExpr &e) override;
  void operate(TanExpr &e) override;
  void operate(RndExpr &e) override;
  void operate(PeekExpr &e) override;
  void operate(LenExpr &e) override;
  void operate(StrExpr &e) override;
  void operate(ValExpr &e) override;
  void operate(AscExpr &e) override;
  void operate(ChrExpr &e) override;
  void operate(RelationalExpr &e) override;
  void operate(LeftExpr &e) override;
  void operate(RightExpr &e) override;
  void operate(MidExpr &e) override;
  void operate(PointExpr &e) override;
  void operate(InkeyExpr &e) override;
  ConstTable &constTable;
  SymbolTable &symbolTable;
  InstQueue &queue;
  std::unique_ptr<AddressMode> result;
  bool arrayRef;
  bool arrayDim;
};

#endif
