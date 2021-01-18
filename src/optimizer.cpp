// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "optimizer.hpp"

#include "accumulizer.hpp"
#include "constfolder.hpp"
#include "consttabulator.hpp"
#include "datapruner.hpp"
#include "datatabulator.hpp"
#include "floatpromoter.hpp"
#include "gerriemanderer.hpp"
#include "lister.hpp"
#include "merger.hpp"
#include "onmerger.hpp"
#include "reachchecker.hpp"
#include "symboltabulator.hpp"
#include "whenifier.hpp"

// for debug
// #include "grapher.hpp"

void Optimizer::optimize(Program &p) {
  Gerriemanderer gm;
  gm.operate(p);

  Whenifier w;
  w.operate(p);

  ConstFolder cf;
  cf.operate(p);

  DataTabulator dt(dataTable);
  dt.operate(p);

  dataTable.floatDiagnostic(Wfloat);

  if (!list) {
    DataPruner dp;
    dp.operate(p);
  }

  SymbolTabulator st(symbolTable);
  st.operate(p);

  FloatPromoter fp(dataTable, symbolTable, Wfloat);
  fp.operate(p);

  Merger m(symbolTable);
  m.operate(p);

  //  Grapher gr;
  //  gr.operate(p);

  cf.operate(p);

  OnMerger om;
  om.operate(p);

  ReachChecker rc;
  rc.operate(p);

  Accumulizer a;
  a.operate(p);
  m.operate(p);

  ConstTabulator ct(constTable);
  ct.operate(p);

  if (list) {
    Lister l;
    l.operate(p);
    fprintf(stderr, "%s\n", l.result.c_str());
  }
}
