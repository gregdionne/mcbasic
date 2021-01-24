// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isfloat.hpp"

void IsFloat::operate(ValExpr & /*expr*/) { result = true; }

void IsFloat::operate(AbsExpr &e) { e.expr->operate(this); }

void IsFloat::operate(ShiftExpr &e) {
  if (e.rhs < 0) {
    result = true;
  } else {
    e.expr->operate(this);
  }
}

void IsFloat::operate(NegatedExpr &e) { e.expr->operate(this); }

void IsFloat::operate(MultiplicativeExpr &e) {
  if (!e.invoperands.empty()) {
    result = true;
    return;
  }

  for (auto &operand : e.operands) {
    operand->operate(this);
    if (result) {
      return;
    }
  }
}

void IsFloat::operate(AdditiveExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
    if (result) {
      return;
    }
  }

  for (auto &operand : e.invoperands) {
    operand->operate(this);
    if (result) {
      return;
    }
  }
}

void IsFloat::operate(RndExpr &e) {
  double value;
  result = !(e.expr->isConst(value) && value >= 1);
}

void IsFloat::operate(SinExpr & /*e*/) { result = true; }

void IsFloat::operate(CosExpr & /*e*/) { result = true; }

void IsFloat::operate(TanExpr & /*e*/) { result = true; }

void IsFloat::operate(NumericConstantExpr &e) {
  result = e.value != static_cast<double>(static_cast<int>(e.value));
}

void IsFloat::operate(NumericVariableExpr &e) {
  for (Symbol &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      if (symbol.isFloat) {
        result = true;
      }
      return;
    }
  }
}

void IsFloat::operate(NumericArrayExpr &e) {
  for (Symbol &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      if (symbol.isFloat) {
        result = true;
      }
      return;
    }
  }
}
