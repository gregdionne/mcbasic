// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "optimizer.hpp"

#include "accumulizer.hpp"
#include "ast/lister.hpp"
#include "branchvalidator.hpp"
#include "constfolder.hpp"
#include "consttable/consttabulator.hpp"
#include "datatable/datapruner.hpp"
#include "datatabulator.hpp"
#include "floatpromoter.hpp"
#include "gerriemanderer.hpp"
#include "iffolder.hpp"
#include "merger.hpp"
#include "onfolder.hpp"
#include "reachchecker.hpp"
#include "symboltable/symbolpruner.hpp"
#include "symboltable/symboltabulator.hpp"
#include "utils/warner.hpp"
#include "whenfolder.hpp"
#include "whenifier.hpp"

// for debug
// #include "ast/viewer.hpp"

void Optimizer::optimize(Program &p) {
  //  Viewer v;
  //  v.operate(p);

  BranchValidator bv(options.ul);
  bv.operate(p);

  Gerriemanderer gm;
  gm.operate(p);

  Whenifier w;
  w.operate(p);

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

  OnFolder of(Warner(options.Wbranch, "Wbranch"));
  of.operate(p);

  IfFolder ifld(Warner(options.Wbranch, "Wbranch"));
  ifld.operate(p);

  WhenFolder wf(Warner(options.Wbranch, "Wbranch"));
  wf.operate(p);

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
