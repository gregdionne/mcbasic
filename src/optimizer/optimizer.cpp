// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "optimizer.hpp"

#include "accumulizer.hpp"
#include "ast/lister.hpp"
#include "ast/text.hpp"
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
#include "whenfolder.hpp"
#include "whenifier.hpp"

// for debug
// #include "ast/viewer.hpp"

Text Optimizer::optimize(Program &p) {
  Text t;

  //  Viewer v;
  //  v.operate(p);

  BranchValidator bv(options.ul);
  bv.operate(p);

  Gerriemanderer gm(options.v);
  gm.operate(p);

  Whenifier w(options.v);
  w.operate(p);

  ConstFolder cf;
  cf.operate(p);

  DataTabulator dt(t.dataTable);
  dt.operate(p);

  t.dataTable.floatDiagnostic(options.v);

  if (!options.list.isEnabled()) {
    DataPruner dp;
    dp.operate(p);
  }

  SymbolTabulator st(t.symbolTable);
  st.operate(p);

  UninitSymbolPruner usp(t.symbolTable, options.Wuninit);
  usp.operate(p);

  UnusedAssignmentPruner uap(t.symbolTable, options.Wunused);
  uap.operate(p);

  FloatPromoter fp(t.dataTable, t.symbolTable, options.Wfloat);
  fp.operate(p);

  Merger m(t.symbolTable);
  m.operate(p);

  cf.operate(p);

  OnFolder of(options.Wbranch);
  of.operate(p);

  IfFolder ifld(options.Wbranch);
  ifld.operate(p);

  WhenFolder wf(options.Wbranch);
  wf.operate(p);

  if (options.Wunreached.isEnabled()) {
    ReachChecker rc(options.Wunreached);
    rc.operate(p);
  }

  Accumulizer a(options.v);
  a.operate(p);

  m.operate(p);

  ConstTabulator ct(t.constTable);
  ct.operate(p);

  if (options.list.isEnabled()) {
    Lister l;
    l.operate(p);
    fprintf(stderr, "%s\n", l.result.c_str());
  }

  return t;
}
