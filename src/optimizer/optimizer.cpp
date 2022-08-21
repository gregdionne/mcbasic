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
#include "symboltable/symboltabulator.hpp"
#include "symboltable/uninitsymbolpruner.hpp"
#include "unusedassignmentpruner.hpp"
#include "utils/announcer.hpp"
#include "whenfolder.hpp"
#include "whenifier.hpp"

// for debug
// #include "ast/viewer.hpp"

void Optimizer::optimize(Program &p) {
  //  Viewer v;
  //  v.operate(p);

  BranchValidator bv(options.ul);
  bv.operate(p);

  Gerriemanderer gm(Announcer(options.v, "verbose"));
  gm.operate(p);

  Whenifier w(Announcer(options.v, "verbose"));
  w.operate(p);

  ConstFolder cf;
  cf.operate(p);

  DataTabulator dt(dataTable);
  dt.operate(p);

  dataTable.floatDiagnostic(options.v);

  if (!options.list) {
    DataPruner dp;
    dp.operate(p);
  }

  SymbolTabulator st(symbolTable);
  st.operate(p);

  UninitSymbolPruner usp(symbolTable, Announcer(options.Wuninit, "Wuninit"));
  usp.operate(p);

  UnusedAssignmentPruner uap(symbolTable,
                             Announcer(options.Wunused, "Wunused"));
  uap.operate(p);

  FloatPromoter fp(dataTable, symbolTable, Announcer(options.Wfloat, "Wfloat"));
  fp.operate(p);

  Merger m(symbolTable);
  m.operate(p);

  cf.operate(p);

  OnFolder of(Announcer(options.Wbranch, "Wbranch"));
  of.operate(p);

  IfFolder ifld(Announcer(options.Wbranch, "Wbranch"));
  ifld.operate(p);

  WhenFolder wf(Announcer(options.Wbranch, "Wbranch"));
  wf.operate(p);

  if (options.Wunreached) {
    ReachChecker rc(Announcer(options.Wunreached, "Wunreached"));
    rc.operate(p);
  }

  Accumulizer a(Announcer(options.v, "verbose"));
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
