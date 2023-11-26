// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_FWDDECLEXPRESSION_HPP
#define AST_FWDDECLEXPRESSION_HPP

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
class PrintSpaceExpr;
class PrintCRExpr;
class PrintCommaExpr;      // TOKEN
class PrintTabExpr;        // $A1
class ComplementedExpr;    // $A4
class AdditiveExpr;        // $A7,$A8 (+,-)
class MultiplicativeExpr;  // $A9,$AA (*,/)
class IntegerDivisionExpr; // $AA
class PowerExpr;           // $AB
class AndExpr;             // $AC
class OrExpr;              // $AD
class RelationalExpr;      // $AE,$AF,$B0 (>,=,<)
class SgnExpr;             // $B1
class IntExpr;             // $B2
class AbsExpr;             // $B3
class RndExpr;             // $B5
class SqrExpr;             // $B6
class LogExpr;             // $B7
class ExpExpr;             // $B8
class SinExpr;             // $B9
class CosExpr;             // $BA
class TanExpr;             // $BB
class PeekExpr;            // $BC
class LenExpr;             // $BD
class StrExpr;             // $BE
class ValExpr;             // $BF
class AscExpr;             // $C0
class ChrExpr;             // $C1
class LeftExpr;            // $C2
class RightExpr;           // $C3
class MidExpr;             // $C4
class PointExpr;           // $C5
class InkeyExpr;           // $C6
class MemExpr;             // $C7

// extensions
class ShiftExpr;
class SquareExpr;
class FractExpr;
class TimerExpr;
class PosExpr;
class PeekWordExpr;

#endif
