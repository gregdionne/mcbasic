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
#include "ifmerger.hpp"
#include "lister.hpp"
#include "merger.hpp"
#include "onmerger.hpp"
#include "reachchecker.hpp"
#include "symbolpruner.hpp"
#include "symboltabulator.hpp"
#include "warner.hpp"
#include "whenifier.hpp"
#include "whenmerger.hpp"

// for debug
// #include "grapher.hpp"

void Optimizer::optimize(Program &p) {
  Gerriemanderer gm;
  gm.operate(p);

  Whenifier w;
  w.operate(p);

  // Grapher gr;
  // gr.operate(p);

  ConstFolder cf;
  cf.operate(p);

  DataTabulator dt(dataTable);
  dt.operate(p);

  dataTable.floatDiagnostic(options.Wfloat);

  if (!options.list) {
    DataPruner dp;
    dp.operate(p);
  }

  SymbolTabulator st(symbolTable);
  st.operate(p);

  SymbolPruner sp(symbolTable, options.Wuninit);
  sp.operate(p);

  FloatPromoter fp(dataTable, symbolTable, Warner(options.Wfloat, "Wfloat"));
  fp.operate(p);

  Merger m(symbolTable);
  m.operate(p);

  cf.operate(p);

  OnMerger om(Warner(options.Wbranch, "Wbranch"));
  om.operate(p);

  IfMerger im(Warner(options.Wbranch, "Wbranch"));
  im.operate(p);

  WhenMerger wm(Warner(options.Wbranch, "Wbranch"));
  wm.operate(p);

  if (options.Wunreached) {
    ReachChecker rc;
    rc.operate(p);
  }

  Accumulizer a;
  a.operate(p);
  m.operate(p);

  ConstTabulator ct(constTable);
  ct.operate(p);

  if (options.list) {
    Lister l;
    l.operate(p);
    fprintf(stderr, "%s\n", l.result.c_str());
  }
}
