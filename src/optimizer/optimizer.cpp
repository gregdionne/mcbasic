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
#include "gotoifier.hpp"
#include "iffolder.hpp"
#include "merger.hpp"
#include "onfolder.hpp"
#include "reachchecker.hpp"
#include "symboltable/symboltabulator.hpp"
#include "symboltable/uninitsymbolpruner.hpp"
#include "unusedassignmentpruner.hpp"
#include "whenfolder.hpp"
#include "whenifier.hpp"

// for debug (display the abstract syntax tree)
// #include "ast/viewer.hpp"

// prune the program, returning the optimized text segment
Text Optimizer::optimize(Program &p) {

  //  (holds DATA, symbol and constant tables)
  Text t;

  // display the abstract syntax tree
  // Viewer().operate(p);

  // make sure labels of GOTO/GOSUB are valid
  BranchValidator(options.ul).operate(p);

  // replace GOSUB:RETURN statements with GOTO
  // replace ON..GOSUB:RETURN statements with ON..GOTO:RETURN
  Gotoifier(options.v).operate(p);

  // replace Gerrieatric expressions with WHEN statements
  Gerriemanderer(options.v).operate(p);

  // replace trailing (fall-through) IF..GOTO/GOSUB with WHEN statements
  Whenifier(options.v).operate(p);

  // do a quick pass on constant folding
  ConstFolder().operate(p);

  // fetch the symbol table
  SymbolTabulator(t.symbolTable).operate(p);

  // replace uninitialized variables with defaults
  UninitSymbolPruner(t.symbolTable, options.Wuninit).operate(p);

  // remove any unused assignments
  UnusedAssignmentPruner(t.symbolTable, options.Wunused).operate(p);

  // fetch the data table text segment
  DataTabulator(t.dataTable).operate(p);

  // inform user what kind of data is present
  t.dataTable.floatDiagnostic(options.v);

  // don't report DATA listing in .ASM file if -list isn't used
  if (!options.list.isEnabled()) {
    DataPruner dp;
    dp.operate(p);
  }

  // promote variables to floating point if need be
  FloatPromoter(t.dataTable, t.symbolTable, options.Wfloat).operate(p);

  // simplify expressions once float promotion is complete
  Merger(t.symbolTable).operate(p);

  // fold any new constants
  ConstFolder().operate(p);

  // fold any ON with a constant branch index
  OnFolder(options.Wbranch).operate(p);

  // fold any IF with constant predicate
  IfFolder(options.Wbranch).operate(p);

  // fold any WHEN with constant predicate
  WhenFolder(options.Wbranch).operate(p);

  // inform user if there are unreachable statements
  if (options.Wunreached.isEnabled()) {
    ReachChecker(options.Wunreached).operate(p);
  }

  // use Accum, Decum, and Necum statements
  Accumulizer(options.v).operate(p);

  // one more pass at expression optimization
  Merger(t.symbolTable).operate(p);

  // fetch (large/floating point) numeric constant text segment
  ConstTabulator(t.constTable).operate(p);

  // list program to stderr when -list is used
  if (options.list.isEnabled()) {
    Lister l;
    l.operate(p);
    fprintf(stderr, "%s\n", l.result.c_str());
  }

  // return text segment
  return t;
}
