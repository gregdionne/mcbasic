// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "library.hpp"

#include "backend/assembler/assembler.hpp"

void Library::makeFoundation() {
  foundation["mdalloc"] = Lib{0, mdAlloc(), {}};
  foundation["mdgetlw"] = Lib{0, mdGetLW(), {}};
  foundation["mdref1"] = Lib{0, mdArrayRef1(), {"mdalloc"}};
  foundation["mdref2"] = Lib{0, mdArrayRef2(), {"mdmul12"}};
  foundation["mdref3"] = Lib{0, mdArrayRef3(), {"mdmul12"}};
  foundation["mdref4"] = Lib{0, mdArrayRef4(), {"mdmul12"}};
  foundation["mdref5"] = Lib{0, mdArrayRef5(), {"mdmul12"}};
  foundation["mdrefint"] = Lib{0, mdArrayRefInt(), {}};
  foundation["mdrefflt"] = Lib{0, mdArrayRefFlt(), {}};
  foundation["mddivmod"] = Lib{0, mdDivMod(), {"mdnegx", "mdnegargv"}};
  foundation["mddivflti"] = Lib{0, mdIDivFlt(), {"mddivmod"}};
  foundation["mddivflt"] = Lib{0, mdDivFlt(), {"mddivmod"}};
  foundation["mdmodflt"] = Lib{0, mdModFlt(), {"mddivmod"}};
  foundation["mdinvflt"] = Lib{0, mdInvFlt(), {"mddivflt"}};
  foundation["mdmsbit"] = Lib{0, mdMSBit(), {}};
  foundation["mdsetbit"] = Lib{0, mdSetBit(), {}};
  foundation["mdrmul315"] = Lib{0, mdRMul315(), {"mdmulflt"}};
  foundation["mdshlflt"] = Lib{0, mdShlFlt(), {}};
  foundation["mdshlint"] = Lib{0, mdShlInt(), {}};
  foundation["mdshrflt"] = Lib{0, mdShrFlt(), {}};
  foundation["mdshift"] = Lib{0, mdShift(), {"mdshlflt", "mdshrflt"}};
  foundation["mdmul12"] = Lib{0, mdMul12(), {}};
  foundation["mdmul3f"] = Lib{0, mdMul3F(), {}};
  foundation["mdmul3i"] = Lib{0, mdMul3I(), {}};
  foundation["mdmulbytf"] = Lib{0, mdMulBytF(), {"mdmulbyti"}};
  foundation["mdmulbyti"] = Lib{0, mdMulBytI(), {}};
  foundation["mdmulint"] = Lib{0, mdMulInt(), {}};
  foundation["mdmulhlf"] = Lib{0, mdMulHlf(), {"mdmulint"}};
  foundation["mdmulflt"] = Lib{0, mdMulFlt(), {"mdmulhlf"}};
  foundation["mdpowflt"] = Lib{0, mdPowFlt(), {"mdlog"}};
  foundation["mdpowintn"] = Lib{0, mdPowIntN(), {"mdmulint", "mdx2arg"}};
  foundation["mdpowfltn"] = Lib{0, mdPowFltN(), {"mdmulflt", "mdx2arg"}};
  foundation["mdnegx"] = Lib{0, mdNegX(), {}};
  foundation["mdntmp2xf"] = Lib{0, mdNegTmp2XF(), {}};
  foundation["mdntmp2xi"] = Lib{0, mdNegTmp2XI(), {}};
  foundation["mdnegargv"] = Lib{0, mdNegArgV(), {}};
  foundation["mdnegtmp"] = Lib{0, mdNegTmp(), {}};
  foundation["mdidivb"] = Lib{0, mdIDivByte(), {}};
  foundation["mdimodb"] = Lib{0, mdIModByte(), {}};
  foundation["mdidiv35"] = Lib{0, mdIDiv35(), {"mdidivb", "mdimodb"}};
  foundation["mdidiv5s"] = Lib{0, mdIDiv5S(), {"mdidiv35"}};
  foundation["mdstrflt"] =
      Lib{0, mdStrFlt(), {"mdnegtmp", "mdimodb", "mdidivb"}};
  foundation["mdstrprm"] = Lib{0, mdStrPrm(), {"mdstrdel"}};
  foundation["mdstrrel"] = Lib{0, mdStrRel(), {}};
  foundation["mdstrtmp"] = Lib{0, mdStrTmp(), {}};
  foundation["mdstrdel"] = Lib{0, mdStrDel(), {"mdalloc"}};
  foundation["mdstrval"] =
      Lib{0, mdStrVal(), {"mdnegtmp", "mdstrrel", "mddivflt"}};
  foundation["mdstreqs"] = Lib{0, mdStrEqs(), {"mdstrrel"}};
  foundation["mdstreqbs"] = Lib{0, mdStrEqbs(), {"mdstrrel"}};
  foundation["mdstreqx"] = Lib{0, mdStrEqx(), {"mdstrrel"}};
  foundation["mdstrlo"] = Lib{0, mdStrLo(), {"mdstrrel"}};
  foundation["mdstrlos"] = Lib{0, mdStrLos(), {"mdstrlo"}};
  foundation["mdstrlosr"] = Lib{0, mdStrLosr(), {"mdstrlo"}};
  foundation["mdstrlobs"] = Lib{0, mdStrLobs(), {"mdstrlo"}};
  foundation["mdstrlox"] = Lib{0, mdStrLox(), {"mdstrlo"}};
  foundation["mdstrloxr"] = Lib{0, mdStrLoxr(), {"mdstrlo"}};
  foundation["mdfilename"] = Lib{0, mdFilename(), {}};
  foundation["mdgetarr"] = Lib{0, mdGetArr(), {"mdmul12"}};
  foundation["mdcloadm"] = Lib{0, mdCLoadM(), {}};
  foundation["mdcloadstar"] = Lib{0, mdCLoadStar(), {"mdgetarr"}};
  foundation["mdcsavestar"] = Lib{0, mdCSaveStar(), {"mdgetarr"}};
  foundation["mdtmp2xf"] = Lib{0, mdTmp2XF(), {}};
  foundation["mdtmp2xi"] = Lib{0, mdTmp2XI(), {}};
  foundation["mdarg2x"] = Lib{0, mdArg2X(), {}};
  foundation["mdx2arg"] = Lib{0, mdX2Arg(), {}};
  foundation["mdsqr"] = Lib{0, mdSqr(), {"mdmsbit", "mdsetbit", "mdx2arg"}};
  foundation["mdexp"] =
      Lib{0, mdExp(), {"mdrmul315", "mdmodflt", "mdshift", "mdarg2x"}};
  foundation["mdlog"] =
      Lib{0, mdLog(), {"mdx2arg", "mdarg2x", "mdexp", "mdmsbit", "mddivflt"}};
  foundation["mdsin"] =
      Lib{0, mdSin(), {"mdrmul315", "mdmodflt", "mdarg2x", "mdx2arg"}};
  foundation["mdcos"] = Lib{0, mdCos(), {"mdsin"}};
  foundation["mdtan"] = Lib{0, mdTan(), {"mdsin", "mdcos"}};
  foundation["mdrnd"] = Lib{0, mdRnd(), {}};
  foundation["mdprat"] = Lib{0, mdPrAt(), {}};
  foundation["mdprint"] = Lib{0, mdPrint(), {}};
  foundation["mdprtab"] = Lib{0, mdPrTab(), {}};
  foundation["mdset"] = Lib{0, mdSet(), {}};
  foundation["mdsetc"] = Lib{0, mdSetC(), {"mdset"}};
  foundation["mdpoint"] = Lib{0, mdPoint(), {"mdset"}};
  foundation["mdpeek"] = Lib{0, mdPeek(), {}};
  foundation["mdgeteq"] = Lib{0, mdGetEq(), {}};
  foundation["mdgetne"] = Lib{0, mdGetNe(), {}};
  foundation["mdgetlo"] = Lib{0, mdGetLo(), {}};
  foundation["mdgeths"] = Lib{0, mdGetHs(), {}};
  foundation["mdgetlt"] = Lib{0, mdGetLt(), {}};
  foundation["mdgetge"] = Lib{0, mdGetGe(), {}};
  foundation["mdinput"] = Lib{0, mdInput(), {"mdprint"}};
  foundation["mdrpubyte"] = Lib{0, mdRdPUByte(), {}};
  foundation["mdrpsbyte"] = Lib{0, mdRdPSByte(), {}};
  foundation["mdrpuword"] = Lib{0, mdRdPUWord(), {}};
  foundation["mdrpsword"] = Lib{0, mdRdPSWord(), {}};
  foundation["mdrpnumbr"] = Lib{0, mdRdPNumbr(), {}};
  foundation["mdrpstrng"] = Lib{0, mdRdPStrng(), {}};
  foundation["mdrnstrng"] = Lib{0, mdRdNStrng(), {"mdrpstrng", "mdstrval"}};
  foundation["mdrsubyte"] =
      Lib{0, mdRdSUByte(), {"mdrpubyte", "mdstrdel", "mdstrflt", "mdstrprm"}};
  foundation["mdrssbyte"] =
      Lib{0, mdRdSSByte(), {"mdrpsbyte", "mdstrdel", "mdstrflt", "mdstrprm"}};
  foundation["mdrsuword"] =
      Lib{0, mdRdSUWord(), {"mdrpuword", "mdstrdel", "mdstrflt", "mdstrprm"}};
  foundation["mdrssword"] =
      Lib{0, mdRdSSWord(), {"mdrpsword", "mdstrdel", "mdstrflt", "mdstrprm"}};
  foundation["mdrsnumbr"] =
      Lib{0, mdRdSNumbr(), {"mdrpnumbr", "mdstrdel", "mdstrflt", "mdstrprm"}};
  foundation["mdrsstrng"] = Lib{0, mdRdSStrng(), {"mdrpstrng", "mdstrdel"}};
  foundation["mdtonat"] = Lib{0, mdToNative(), {}};
  foundation["mdtonatgl"] = Lib{0, mdToNativeGenLines(), {}};
  foundation["mdtobc"] = Lib{0, mdToByteCode(), {}};
  foundation["mdtobcgl"] = Lib{0, mdToByteCodeGenLines(), {}};
  foundation["mdbcode"] = Lib{0, mdByteCode(), {}};
}

std::string Library::mdAlloc() {
  Assembler tasm;
  tasm.comment("alloc D bytes in array memory.");
  tasm.comment("then relink strings.");
  tasm.label("alloc");
  tasm.std("tmp1");
  tasm.ldx("strfree");  // probably should be computed in strlink
  tasm.addd("strfree"); // ! register references to strings can be corrupted!
  tasm.std("strfree");  //   so in Clear() auto-Dim any undimmed array.
  tasm.ldd("strend");
  tasm.addd("tmp1");
  tasm.std("strend");
  tasm.sts("tmp2");
  tasm.subd("tmp2");
  tasm.blo("_ok");
  tasm.ldab("#OM_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.lds("strfree");
  tasm.des();
  tasm.label("_again");
  tasm.dex();
  tasm.dex();
  tasm.ldd(",x");
  tasm.pshb();
  tasm.psha();
  tasm.cpx("strbuf");
  tasm.bhi("_again");
  tasm.lds("tmp2");
  tasm.ldx("strbuf");
  tasm.ldd("strbuf");
  tasm.addd("tmp1");
  tasm.std("strbuf");
  tasm.clra();
  tasm.label("_nxtz");
  tasm.staa(",x");
  tasm.inx();
  tasm.cpx("strbuf");
  tasm.blo("_nxtz");
  tasm.ldx("strbuf");

  tasm.comment("relink permanent strings");
  tasm.comment("ENTRY:  X points to offending link word in strbuf");
  tasm.comment("EXIT:   X points to strend");
  tasm.label("strlink");
  tasm.cpx("strend");
  tasm.bhs("_rts");
  tasm.stx("tmp1");
  tasm.ldd("tmp1");
  tasm.addd("#2");
  tasm.ldx(",x");
  tasm.std("1,x");
  tasm.ldab("0,x");
  tasm.ldx("1,x");
  tasm.abx();
  tasm.bra("strlink");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetLW() {
  Assembler tasm;
  tasm.comment("fetch lower word from integer variable descriptor");
  tasm.comment(" ENTRY: D holds integer variable descriptor");
  tasm.comment(" EXIT: D holds lower word of integer variable");
  tasm.label("getlw");
  tasm.std("tmp1");
  tasm.stx("tmp2");
  tasm.ldx("tmp1");
  tasm.ldd("1,x");
  tasm.ldx("tmp2");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdArrayRef1() {
  Assembler tasm;
  tasm.comment("validate offset from 1D descriptor X and argv");
  tasm.comment(
      "if empty desc, then alloc D bytes in array memory and 11 elements.");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref1");
  tasm.std("tmp1");
  tasm.ldd(",x");
  tasm.bne("_preexist");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("#11");
  tasm.std("2,x");
  tasm.ldd("tmp1");
  tasm.pshx();
  tasm.jsr("alloc");
  tasm.pulx();
  tasm.label("_preexist");

  tasm.ldd("0+argv");
  tasm.std("tmp1");
  tasm.subd("2,x");
  tasm.bhs("_err");

  tasm.ldd("tmp1");

  tasm.lsld();
  tasm.rts();
  tasm.label("_err");
  tasm.ldab("#BS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string Library::mdArrayRef2() {
  Assembler tasm;
  tasm.comment("validate offset from 2D descriptor X and argv.");
  tasm.comment("if empty desc, then alloc D bytes in array memory");
  tasm.comment("and 11 elements in each dimension (121 total elements).");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref2");
  tasm.std("tmp1");
  tasm.ldd(",x");
  tasm.bne("_preexist");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("#11");
  tasm.std("2,x");
  tasm.std("4,x");
  tasm.ldd("tmp1");
  tasm.pshx();
  tasm.jsr("alloc");
  tasm.pulx();
  tasm.label("_preexist");

  tasm.ldd("2+argv");
  tasm.std("tmp1");
  tasm.subd("4,x");
  tasm.bhs("_err");

  tasm.ldd("2,x");
  tasm.std("tmp2");
  tasm.subd("0+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("0+argv");
  tasm.std("tmp1");

  tasm.lsld();
  tasm.rts();
  tasm.label("_err");
  tasm.ldab("#BS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string Library::mdArrayRef3() {
  Assembler tasm;
  tasm.comment("validate offset from 3D descriptor X and argv.");
  tasm.comment("if empty desc, then alloc D bytes in array memory");
  tasm.comment("and 11 elements in each dimension (1331 total elements).");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref3");
  tasm.std("tmp1");
  tasm.ldd(",x");
  tasm.bne("_preexist");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("#11");
  tasm.std("2,x");
  tasm.std("4,x");
  tasm.std("6,x");
  tasm.ldd("tmp1");
  tasm.pshx();
  tasm.jsr("alloc");
  tasm.pulx();
  tasm.label("_preexist");

  tasm.ldd("4+argv");
  tasm.std("tmp1");
  tasm.subd("6,x");
  tasm.bhs("_err");

  tasm.ldd("4,x");
  tasm.std("tmp2");
  tasm.subd("2+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("2+argv");
  tasm.std("tmp1");

  tasm.ldd("2,x");
  tasm.std("tmp2");
  tasm.subd("0+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("0+argv");
  tasm.std("tmp1");

  tasm.lsld();
  tasm.rts();
  tasm.label("_err");
  tasm.ldab("#BS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string Library::mdArrayRef4() {
  Assembler tasm;
  tasm.comment("get offset from 4D descriptor X and argv.");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref4");
  tasm.ldd(",x");
  tasm.beq("_err");

  tasm.ldd("6+argv");
  tasm.std("tmp1");
  tasm.subd("8,x");
  tasm.bhs("_err");

  tasm.ldd("6,x");
  tasm.std("tmp2");
  tasm.subd("4+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("4+argv");
  tasm.std("tmp1");

  tasm.ldd("4,x");
  tasm.std("tmp2");
  tasm.subd("2+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("2+argv");
  tasm.std("tmp1");

  tasm.ldd("2,x");
  tasm.std("tmp2");
  tasm.subd("0+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("0+argv");
  tasm.std("tmp1");

  tasm.lsld();
  tasm.rts();
  tasm.label("_err");
  tasm.ldab("#BS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string Library::mdArrayRef5() {
  Assembler tasm;
  tasm.comment("get offset from 5D descriptor X and argv.");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref5");
  tasm.ldd(",x");
  tasm.beq("_err");

  tasm.ldd("8+argv");
  tasm.std("tmp1");
  tasm.subd("10,x");
  tasm.bhs("_err");

  tasm.ldd("8,x");
  tasm.std("tmp2");
  tasm.subd("6+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("6+argv");
  tasm.std("tmp1");

  tasm.ldd("6,x");
  tasm.std("tmp2");
  tasm.subd("4+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("4+argv");
  tasm.std("tmp1");

  tasm.ldd("4,x");
  tasm.std("tmp2");
  tasm.subd("2+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("2+argv");
  tasm.std("tmp1");

  tasm.ldd("2,x");
  tasm.std("tmp2");
  tasm.subd("0+argv");
  tasm.bls("_err");
  tasm.jsr("mul12");
  tasm.addd("0+argv");
  tasm.std("tmp1");

  tasm.lsld();
  tasm.rts();
  tasm.label("_err");
  tasm.ldab("#BS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string Library::mdArrayRefInt() {
  Assembler tasm;
  tasm.comment("return int/str array reference in D/tmp1");
  tasm.label("refint");
  tasm.addd("tmp1");
  tasm.addd("0,x");
  tasm.std("tmp1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdArrayRefFlt() {
  Assembler tasm;
  tasm.comment("return flt array reference in D/tmp1");
  tasm.label("refflt");
  tasm.lsld();
  tasm.addd("tmp1");
  tasm.addd("0,x");
  tasm.std("tmp1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrRel() {
  Assembler tasm;
  tasm.comment("release a temporary string");
  tasm.comment("ENTRY: X holds string start");
  tasm.comment("EXIT:  <all reg's preserved>");
  tasm.comment("sttrel should be called from:");
  tasm.comment(" - ASC, VAL, LEN, PRINT");
  tasm.comment(" - right hand side of strcat");
  tasm.comment(" - relational operators");
  tasm.comment(" - when LEFT$, MID$, RIGHT$ return null");
  tasm.label("strrel");
  tasm.cpx("strend");
  tasm.bls("_rts");
  tasm.cpx("strstop");
  tasm.bhs("_rts");
  tasm.tst("strtcnt");  // note:
  tasm.beq("_panic");   //  relational ops leak when
  tasm.dec("strtcnt");  //  freed in non-reversed alloc
  tasm.beq("_restore"); //  order.  MID$ and RIGHT$
  tasm.stx("strfree");  //  leak if not after a strcat
  tasm.label("_rts");   //  leak persists until g.c.
  tasm.rts();
  tasm.label("_restore");
  tasm.pshx();        // save X
  tasm.ldx("strend"); // garbage collect:
  tasm.inx();         //  restore strfree
  tasm.inx();         //  to two bytes after strend
  tasm.stx("strfree");
  tasm.pulx();
  tasm.rts();
  tasm.label("_panic"); // temporary debug code
  tasm.ldab("#1");      // FS error (free string)
  tasm.jmp("error");    // string never allocated
  return tasm.source();
}

std::string Library::mdStrTmp() {
  Assembler tasm;
  tasm.comment("make a temporary clone of a string");
  tasm.comment("ENTRY: X holds string start");
  tasm.comment("       B holds string length");
  tasm.comment("EXIT:  D holds new string pointer");
  tasm.label("strtmp");
  tasm.cpx("strfree");
  tasm.bls("_reserve");
  tasm.stx("tmp1"); // already in buffer
  tasm.ldd("tmp1"); // nothing to reserve
  tasm.rts();
  tasm.label("_reserve");
  tasm.inc("strtcnt");
  tasm.label("strcat");
  tasm.tstb();
  tasm.beq("_null");
  tasm.sts("tmp1");
  tasm.txs();
  tasm.ldx("strfree");
  tasm.label("_nxtcp");
  tasm.pula();
  tasm.staa(",x");
  tasm.inx();
  tasm.decb();
  tasm.bne("_nxtcp");
  tasm.lds("tmp1");
  tasm.ldd("strfree");
  tasm.stx("strfree");
  tasm.rts();
  tasm.label("_null");
  tasm.ldd("strfree");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrPrm() {
  Assembler tasm;

  tasm.comment("make a permanent string");
  tasm.comment("ENTRY: argv -  input string descriptor");
  tasm.comment("         X  - output string descriptor");

  // if input already permanent?
  //   del output
  //   assign w/out copy
  // elseif output same size?
  //   copy in place
  // elseif output after destination but before temp
  //   copy to tmp
  //   mark src as living in tmp
  //   delete old output
  //   mv to final location
  //   assign
  // else:
  //   delete old output
  //   mv to final location
  //   assign

  tasm.label("strprm");
  tasm.stx("tmp1");
  tasm.ldab("0+argv");
  tasm.beq("_null");
  tasm.decb();
  tasm.beq("_char");
  tasm.ldx("1+argv");
  tasm.cpx("#M_LBUF");
  tasm.blo("_const");
  tasm.cpx("#M_MSTR");
  tasm.blo("_trans");
  tasm.cpx("strbuf");
  tasm.blo("_const");

  // transient: see if same size and dest is in strbuf
  tasm.label("_trans");
  tasm.ldx("tmp1");
  tasm.ldab("0,x");
  tasm.ldx("1,x");
  tasm.cpx("strbuf");
  tasm.blo("_nalloc");
  tasm.cmpb("0+argv");
  tasm.beq("_copyip");

  // needs alloc:  see if in volatile area between
  //               destination and strend
  tasm.label("_nalloc");
  tasm.cpx("1+argv"); // compare old dest with src
  tasm.bhs("_notmp"); // if greater...
  tasm.ldx("1+argv");
  tasm.cpx("strend");
  tasm.bhs("_notmp");

  // move string to tmp
  // mark source as now in strfree
  tasm.ldx("strend");
  tasm.inx();
  tasm.inx();
  tasm.stx("strfree");
  tasm.bsr("_copy");
  tasm.ldd("strfree");
  tasm.std("1+argv");

  // string either in tmp or below dest
  tasm.label("_notmp");
  tasm.ldx("tmp1");
  tasm.pshx(); // delete old string
  tasm.jsr("strdel");
  tasm.pulx();
  tasm.stx("tmp1");

  tasm.ldx("strend"); // store linkback
  tasm.ldd("tmp1");
  tasm.std(",x"); // point strend
  tasm.inx();
  tasm.inx();
  tasm.stx("strfree");
  tasm.cpx("argv+1");
  tasm.beq("_nocopy");
  tasm.bsr("_copy");
  tasm.bra("_ready");

  tasm.label("_nocopy");
  tasm.ldab("0+argv");
  tasm.abx();

  // string is now at strfree
  // x holds new strend
  tasm.label("_ready");
  tasm.stx("strend");
  tasm.ldd("strfree");
  tasm.inx();
  tasm.inx();
  tasm.stx("strfree");
  tasm.clr("strtcnt");
  tasm.ldx("tmp1");
  tasm.std("1,x");
  tasm.ldab("0+argv");
  tasm.stab("0,x");
  tasm.rts();

  // single-char
  tasm.label("_char");
  tasm.ldx("1+argv"); // fetch char
  tasm.ldab(",x");
  // fallthrough
  tasm.label("_null");
  tasm.ldaa("#charpage>>8");
  tasm.std("1+argv");
  // fallthrough
  tasm.label("_const");
  tasm.ldx("tmp1"); // delete output
  tasm.pshx();
  tasm.jsr("strdel"); // clobbers tmp1 and tmp2
  tasm.pulx();
  tasm.ldab("0+argv"); // assign w/out copy
  tasm.stab("0,x");
  tasm.ldd("1+argv");
  tasm.std("1,x");
  tasm.clr("strtcnt");
  tasm.rts();

  tasm.label("_copyip"); // copy in place
  tasm.dex();
  tasm.dex();
  tasm.ldd("tmp1");
  tasm.std(",x");
  tasm.inx();
  tasm.inx();
  // fallthrough

  // copy argv strdesc to "X"
  // X modified to hold free byte after string
  tasm.label("_copy");
  tasm.sts("tmp2");
  tasm.ldab("0+argv");
  tasm.lds("1+argv");
  tasm.des();
  tasm.label("_nxtchr");
  tasm.pula();
  tasm.staa(",x");
  tasm.inx();
  tasm.decb();
  tasm.bne("_nxtchr");
  tasm.lds("tmp2");
  tasm.clr("strtcnt");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrDel() {
  Assembler tasm;
  tasm.comment("remove a permanent string");
  tasm.comment("then re-link trailing strings");
  tasm.label("strdel");
  tasm.ldd("1,x");
  tasm.subd("strbuf");
  tasm.blo("_rts");
  tasm.ldd("1,x");
  tasm.subd("strend");
  tasm.bhs("_rts");
  tasm.ldd("strend");
  tasm.subd("#2");
  tasm.subb("0,x");
  tasm.sbca("#0");
  tasm.std("strend");
  tasm.ldab("0,x");
  tasm.ldx("1,x");
  tasm.dex();
  tasm.dex();
  tasm.stx("tmp1");
  tasm.abx();
  tasm.inx();
  tasm.inx();
  tasm.sts("tmp2");
  tasm.txs();
  tasm.ldx("tmp1");
  tasm.label("_nxtwrd");
  tasm.pula();
  tasm.pulb();
  tasm.std(",x");
  tasm.inx();
  tasm.inx();
  tasm.cpx("strend");
  tasm.blo("_nxtwrd");
  tasm.lds("tmp2");
  tasm.ldx("tmp1");
  tasm.jmp("strlink"); // should get strfree back if possible.
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdNegX() const {
  Assembler tasm;
  if (undoc) {
    tasm.label("negxi");
    tasm.neg("2,x");
    tasm.ngc("1,x");
    tasm.ngc("0,x");
    tasm.rts();

    tasm.label("negx");
    tasm.neg("4,x");
    tasm.ngc("3,x");
    tasm.ngc("2,x");
    tasm.ngc("1,x");
    tasm.ngc("0,x");
    tasm.rts();
  } else {
    tasm.label("negx");
    tasm.neg("4,x");
    tasm.bcs("_com3");
    tasm.neg("3,x");
    tasm.bcs("_com2");
    tasm.label("negxi");
    tasm.neg("2,x");
    tasm.bcs("_com1");
    tasm.neg("1,x");
    tasm.bcs("_com0");
    tasm.neg("0,x");
    tasm.rts();
    tasm.label("_com3");
    tasm.com("3,x");
    tasm.label("_com2");
    tasm.com("2,x");
    tasm.label("_com1");
    tasm.com("1,x");
    tasm.label("_com0");
    tasm.com("0,x");
    tasm.rts();
  }
  return tasm.source();
}

std::string Library::mdNegTmp2XI() {
  Assembler tasm;
  tasm.label("ntmp2xi");
  tasm.ldd("#0");
  tasm.subd("tmp2");
  tasm.std("1,x");
  tasm.ldab("#0");
  tasm.sbcb("tmp1+1");
  tasm.stab("0,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdNegTmp2XF() {
  Assembler tasm;
  tasm.label("ntmp2xf");
  tasm.ldd("#0");
  tasm.subd("tmp3");
  tasm.std("3,x");
  tasm.ldd("#0");
  tasm.sbcb("tmp2+1");
  tasm.sbca("tmp2");
  tasm.std("1,x");
  tasm.ldab("#0");
  tasm.sbcb("tmp1+1");
  tasm.stab("0,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdNegArgV() const {
  Assembler tasm;
  tasm.label("negargv");
  if (undoc) {
    tasm.neg("4+argv");
    tasm.ngc("3+argv");
    tasm.ngc("2+argv");
    tasm.ngc("1+argv");
    tasm.ngc("0+argv");
    tasm.rts();
  } else {
    tasm.neg("4+argv");
    tasm.bcs("_com3");
    tasm.neg("3+argv");
    tasm.bcs("_com2");
    tasm.neg("2+argv");
    tasm.bcs("_com1");
    tasm.neg("1+argv");
    tasm.bcs("_com0");
    tasm.neg("0+argv");
    tasm.rts();
    tasm.label("_com3");
    tasm.com("3+argv");
    tasm.label("_com2");
    tasm.com("2+argv");
    tasm.label("_com1");
    tasm.com("1+argv");
    tasm.label("_com0");
    tasm.com("0+argv");
    tasm.rts();
  }
  return tasm.source();
}

std::string Library::mdNegTmp() const {
  Assembler tasm;
  tasm.label("negtmp");
  if (undoc) {
    tasm.neg("tmp3+1");
    tasm.ngc("tmp3");
    tasm.ngc("tmp2+1");
    tasm.ngc("tmp2");
    tasm.ngc("tmp1+1");
    tasm.rts();
  } else {
    tasm.neg("tmp3+1");
    tasm.bcs("_com3");
    tasm.neg("tmp3");
    tasm.bcs("_com2");
    tasm.neg("tmp2+1");
    tasm.bcs("_com1");
    tasm.neg("tmp2");
    tasm.bcs("_com0");
    tasm.neg("tmp1+1");
    tasm.rts();
    tasm.label("_com3");
    tasm.com("tmp3");
    tasm.label("_com2");
    tasm.com("tmp2+1");
    tasm.label("_com1");
    tasm.com("tmp2");
    tasm.label("_com0");
    tasm.com("tmp1+1");
    tasm.rts();
  }

  return tasm.source();
}

std::string Library::mdIModByte() {
  Assembler tasm;
  tasm.comment("fast integer modulo operation by three or five");
  tasm.comment("ENTRY:  int in tmp1+1,tmp2,tmp2+1");
  tasm.comment("        ACCB contains modulus (3 or 5)");
  tasm.comment("EXIT:  result in ACCA");
  tasm.label("imodb");
  tasm.pshb();
  tasm.ldaa("tmp1+1");
  tasm.bpl("_ok");
  tasm.deca();
  tasm.label("_ok");
  tasm.adda("tmp2");
  tasm.adca("tmp2+1");
  tasm.adca("#0");
  tasm.adca("#0"); // just in case ACCA was $FF and carry set
  tasm.tab();
  tasm.lsra();
  tasm.lsra();
  tasm.lsra();
  tasm.lsra();
  tasm.andb("#$0F");
  tasm.aba();
  tasm.pulb();
  tasm.label("_dec");
  tasm.sba();
  tasm.bhs("_dec");
  tasm.aba();
  tasm.rts();

  return tasm.source();
}

std::string Library::mdIDivByte() {
  Assembler tasm;
  tasm.comment("fast integer division by three or five");
  tasm.comment("ENTRY+EXIT:  int in tmp1+1,tmp2,tmp2+1");
  tasm.comment("        ACCB contains:");
  tasm.comment("           $CC for div-5");
  tasm.comment("           $AA for div-3");
  tasm.comment("        tmp3,tmp3+1,tmp4 used for storage");
  tasm.label("idivb");
  tasm.stab("tmp4");
  tasm.ldab("tmp1+1"); // save sbyte
  tasm.pshb();         //
  tasm.ldd("tmp2");    // save hbyte
  tasm.psha();         //
  tasm.ldaa("tmp4");   // multiply lbyte by $AAAAAA or $CCCCCC
  tasm.mul();          // and add to result
  tasm.std("tmp3");    //
  tasm.addd("tmp2");   //
  tasm.std("tmp2");    //
  tasm.ldab("tmp1+1"); //
  tasm.adcb("tmp3+1"); //
  tasm.stab("tmp1+1"); //
  tasm.ldd("tmp1+1");  //
  tasm.addd("tmp3");   //
  tasm.std("tmp1+1");  //
  tasm.pulb();         // get hbyte, multiply by $AA or $CC
  tasm.ldaa("tmp4");   // and add to result
  tasm.mul();          //
  tasm.stab("tmp3+1"); //
  tasm.addd("tmp1+1"); //
  tasm.std("tmp1+1");  // (leave tmp3+1, we'll add it next)
  tasm.pulb();         // get sbyte, multiply by $AA or $CC
  tasm.ldaa("tmp4");   // and add
  tasm.mul();          //
  tasm.addb("tmp1+1"); //
  tasm.addb("tmp3+1"); //
  tasm.stab("tmp1+1"); // exit with Z set if nothing left
  tasm.rts();

  return tasm.source();
}

std::string Library::mdIDiv35() {
  Assembler tasm;
  tasm.comment("fast divide by 3 or 5");
  tasm.comment("ENTRY: X in tmp1+1,tmp2,tmp2+1");
  tasm.comment("       ACCD is $CC05 for divide by 5");
  tasm.comment("       ACCD is $AA03 for divide by 3");
  tasm.comment("EXIT:  INT(X/(3 or 5)) in tmp1+1,tmp2,tmp2+1");
  tasm.comment("  tmp3,tmp3+1,tmp4 used for storage");
  tasm.label("idiv35");
  tasm.psha();
  tasm.jsr("imodb");
  tasm.tab();
  tasm.ldaa("tmp2+1");
  tasm.sba();
  tasm.staa("tmp2+1");
  tasm.bcc("_dodiv");
  tasm.ldd("tmp1+1");
  tasm.subd("#1");
  tasm.std("tmp1+1");
  tasm.label("_dodiv");
  tasm.pulb();
  tasm.jmp("idivb");
  return tasm.source();
}

std::string Library::mdIDiv5S() {
  Assembler tasm;
  tasm.comment("fast divide when divisor is '5-smooth'");
  tasm.comment("(i.e. having factors only of 2, 3, 5)");
  tasm.comment("ENTRY: X holds dividend");
  tasm.comment("       ACCB holds divisor");
  tasm.comment("EXIT:  INT(X/ACCB) in X");
  tasm.comment("  tmp1-tmp4 used for storage");
  tasm.label("idiv5s");
  tasm.incomment("div by factors of 2?");
  tasm.bitb("#1");
  tasm.bne("_odd");
  tasm.lsrb();
  tasm.asr(",x");
  tasm.ror("1,x");
  tasm.ror("2,x");
  tasm.bra("idiv5s");

  tasm.label("_odd");
  tasm.cmpb("#1");
  tasm.beq("_rts");

  tasm.stab("tmp1");
  tasm.ldab(",x");
  tasm.stab("tmp1+1");
  tasm.ldd("1,x");
  tasm.std("tmp2");

  tasm.label("_do3");
  tasm.ldab("tmp1");
  tasm.label("_by3");
  tasm.ldaa("#$AB");
  tasm.mul();
  tasm.cmpb("#$55");
  tasm.bhi("_do5");
  tasm.stab("tmp1");
  tasm.ldd("#$AA03");
  tasm.jsr("idiv35");
  tasm.ldab("tmp1");
  tasm.cmpb("#1");
  tasm.beq("_store");
  tasm.bra("_by3");

  tasm.label("_do5");
  tasm.ldab("tmp1");
  tasm.label("_by5");
  tasm.ldaa("#$CD");
  tasm.mul();
  tasm.stab("tmp1");
  tasm.ldd("#$CC05");
  tasm.jsr("idiv35");
  tasm.ldab("tmp1");
  tasm.cmpb("#1");
  tasm.bne("_by5");
  tasm.label("_store");
  tasm.ldab("tmp1+1");
  tasm.stab(",x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.label("_rts");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdStrFlt() {
  Assembler tasm;
  tasm.label("strflt");
  tasm.inc("strtcnt");
  tasm.pshx();
  tasm.tst("tmp1+1"); // tmp1+1 == sbyte
  tasm.bmi("_neg");   // tmp2   == lword
  tasm.ldab("#' '");  // tmp3   == frac
  tasm.bra("_wdigs");
  tasm.label("_neg");
  tasm.jsr("negtmp");
  tasm.ldab("#'-'");
  tasm.label("_wdigs");
  tasm.ldx("tmp3"); // repurpose tmp3 as even/odd save
  tasm.pshx();      // repurpose tmp3+1 as mod 5 result
  tasm.ldx("strfree");
  tasm.stab(",x");
  tasm.clr("tmp1"); // say zero digits on stack
  tasm.label("_nxtwdig");
  tasm.inc("tmp1");   // reserve room for one digit
  tasm.lsr("tmp1+1"); // divide by 2
  tasm.ror("tmp2");
  tasm.ror("tmp2+1");
  tasm.ror("tmp3"); // save remainder (even odd) in tmp3
  tasm.ldab("#5");
  tasm.jsr("imodb");
  tasm.staa("tmp3+1");  // save result mod 5
  tasm.lsl("tmp3");     // restore odd
  tasm.rola();          // construct digit mod 10
  tasm.adda("#'0'");    //
  tasm.psha();          // save to stack
  tasm.ldd("tmp2");     // subtract result mod 5 from word
  tasm.subb("tmp3+1");  //
  tasm.sbca("#0");      //
  tasm.std("tmp2");     //
  tasm.ldab("tmp1+1");  //
  tasm.sbcb("#0");      //
  tasm.stab("tmp1+1");  //
  tasm.ldab("#$CC");    // multiply tmp1+1,tmp2,tmp2+1 by
  tasm.jsr("idivb");    //  1/5 == $CCCCCD
  tasm.bne("_nxtwdig"); // if still have something left...
  tasm.ldd("tmp2");
  tasm.bne("_nxtwdig");
  tasm.ldab("tmp1");
  tasm.label("_nxtc");
  tasm.pula();
  tasm.inx();
  tasm.staa(",x");
  tasm.decb();
  tasm.bne("_nxtc");

  tasm.inx();       // bump ptr
  tasm.inc("tmp1"); // save room for ' ' / '-'
  tasm.pula();      // recover frac
  tasm.pulb();
  tasm.subd("#0");
  tasm.bne("_fdo");
  tasm.jmp("_fdone");
  tasm.label("_fdo");
  tasm.std("tmp2");    // repurpose tmp2 as frac
  tasm.ldab("#'.'");   // 0 in A, '.' in B
  tasm.stab(",x");     // write '.'
  tasm.inc("tmp1");    // record 1 byte written
  tasm.inx();          // bump ptr
  tasm.ldd("#6");      // 0 in A, 4 in B. (almost 5 digits)
  tasm.staa("tmp1+1"); // repurpose tmp1 as out digit (zeroed out)
  tasm.stab("tmp3");   // do a maximum of five digits
  tasm.label("_nxtf");
  tasm.ldd("tmp2");
  tasm.lsl("tmp2+1");
  tasm.rol("tmp2");
  tasm.rol("tmp1+1");
  tasm.lsl("tmp2+1");
  tasm.rol("tmp2");
  tasm.rol("tmp1+1");
  tasm.addd("tmp2");
  tasm.std("tmp2");
  tasm.ldab("tmp1+1");
  tasm.adcb("#0");
  tasm.stab("tmp1+1");
  tasm.lsl("tmp2+1");
  tasm.rol("tmp2");
  tasm.rol("tmp1+1");
  tasm.ldd("tmp1");
  tasm.addb("#'0'");
  tasm.stab(",x");
  tasm.inx();
  tasm.inc("tmp1");
  tasm.clrb();
  tasm.stab("tmp1+1");
  tasm.dec("tmp3");
  tasm.bne("_nxtf");

  tasm.tst("tmp2"); // check to see if we need to round up
  tasm.bmi("_nxtrnd");
  tasm.label("_nxtzero");
  tasm.dex();
  tasm.dec("tmp1");
  tasm.ldaa(",x");
  tasm.cmpa("#'0'");
  tasm.beq("_nxtzero");
  tasm.bra("_zdone");

  tasm.label("_nxtrnd"); // round up
  tasm.dex();
  tasm.dec("tmp1");
  tasm.ldaa(",x");
  tasm.cmpa("#'.'");
  tasm.beq("_dot");
  tasm.inca();
  tasm.cmpa("#'9'");
  tasm.bhi("_nxtrnd");
  tasm.bra("_rdone");

  tasm.label("_dot");
  tasm.ldaa("#'0'"); // pre-emptively store a zero over the '.'
  tasm.staa(",x");

  tasm.ldab("tmp1");
  tasm.label("_ndot");
  tasm.decb();
  tasm.beq("_dzero");
  tasm.dex();
  tasm.ldaa(",x");
  tasm.inca();
  tasm.cmpa("#'9'");
  tasm.bls("_ddone");
  tasm.bra("_ndot");

  tasm.label("_ddone");
  tasm.staa(",x");
  tasm.ldx("strfree");
  tasm.ldab("tmp1");
  tasm.abx();
  tasm.bra("_fdone");

  tasm.label("_dzero");
  tasm.ldaa("#'1'");
  tasm.staa(",x");
  tasm.ldx("strfree");
  tasm.ldab("tmp1");
  tasm.abx();
  tasm.ldaa("#'0'");

  tasm.label("_rdone");
  tasm.staa(",x");
  tasm.label("_zdone");
  tasm.inx();
  tasm.inc("tmp1");

  tasm.label("_fdone"); // leave with count in tmp1
  tasm.ldd("strfree");  // and beginning in D
  tasm.stx("strfree");  // save strfree
  tasm.pulx();          // restore X register
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrVal() {
  Assembler tasm;
  tasm.label("strval");
  tasm.ldab("0,x");
  tasm.ldx("1,x");
  tasm.jsr("strrel");

  tasm.label("inptval");
  tasm.clr("tmp1"); // 0=unsigned
  tasm.bsr("_getsgn");
  tasm.jsr("_getint");
  tasm.tstb();
  tasm.beq("_dosign");
  tasm.ldaa(",x");
  tasm.cmpa("#'.'");
  tasm.bne("_dosign");
  tasm.inx();
  tasm.decb();
  tasm.beq("_dosign");
  tasm.stab("tmp5"); // save strcnt
  tasm.ldd("tmp2");
  tasm.pshb();
  tasm.psha();
  tasm.ldd("tmp1");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("tmp5"); // restore strcnt
  tasm.bsr("_getint");
  tasm.stx("tmp5"); // save X for INPUT
  tasm.ldab("tmp4");
  tasm.ldx("#_tblten");
  tasm.abx();
  tasm.abx();
  tasm.abx();
  tasm.ldab(",x");
  tasm.stab("0+argv");
  tasm.ldd("1,x");
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.sts("tmp4");
  tasm.ldd("tmp4");
  tasm.subd("#10");
  tasm.std("tmp4");
  tasm.lds("tmp4");
  tasm.tsx();
  tasm.ldab("tmp1+1");
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.ldd("#0");
  tasm.std("3,x");
  tasm.stab("tmp4");
  tasm.jsr("divuflt");
  tasm.ldd("3,x");
  tasm.std("tmp3");
  tasm.ldab("#10");
  tasm.tsx();
  tasm.abx();
  tasm.txs();
  tasm.pula();
  tasm.pulb();
  tasm.std("tmp1");
  tasm.pula();
  tasm.pulb();
  tasm.std("tmp2");
  tasm.ldx("tmp5"); // fetch X for INPUT

  tasm.label("_dosign");
  tasm.tst("tmp1");
  tasm.beq("_srts");
  tasm.jmp("negtmp");

  tasm.label("_getsgn");
  tasm.tstb();
  tasm.beq("_srts");
  tasm.ldaa(",x");
  tasm.cmpa("#' '");
  tasm.bne("_trysgn");
  tasm.inx();
  tasm.decb();
  tasm.bra("_getsgn");

  tasm.label("_trysgn");
  tasm.cmpa("#'+'");
  tasm.beq("_prts");
  tasm.cmpa("#'-'");
  tasm.bne("_srts");
  tasm.dec("tmp1");
  tasm.label("_prts");
  tasm.inx();
  tasm.decb();
  tasm.label("_srts");
  tasm.rts();

  tasm.label("_getint"); // from X,B get integer into tmp1+1,tmp2,tmp2+1
  tasm.clra();           // tmp3,tmp3+1 cleared on exit;
  tasm.staa("tmp1+1");   // tmp 4 returned as digit count
  tasm.staa("tmp2");     // tmp 4+1 used as scracth
  tasm.staa("tmp2+1");
  tasm.staa("tmp4");
  tasm.label("_nxtdig");
  tasm.tstb();
  tasm.beq("_crts");
  tasm.ldaa(",x");
  tasm.suba("#'0'");
  tasm.blo("_crts");
  tasm.cmpa("#10");
  tasm.bhs("_crts");
  tasm.inx();
  tasm.decb();         // decrement string count
  tasm.pshb();         // push count
  tasm.psha();         // push digit
  tasm.ldd("tmp2");    // multiply tmp1+1,tmp2,tmp2+1
  tasm.std("tmp3");    // by 10 using tmp3, tmp4+1
  tasm.ldab("tmp1+1"); // as temporary storage
  tasm.stab("tmp4+1"); //
  tasm.bsr("_dbl");    // 10*X = dbl(dbl(dbl(X))+X)
  tasm.bsr("_dbl");    //
  tasm.ldd("tmp3");    //
  tasm.addd("tmp2");   //
  tasm.std("tmp2");    //
  tasm.ldab("tmp4+1"); //
  tasm.adcb("tmp1+1"); //
  tasm.stab("tmp1+1"); //
  tasm.bsr("_dbl");    //
  tasm.pulb();         // restore digit
  tasm.clra();         //  add it to 10*X
  tasm.addd("tmp2");   //
  tasm.std("tmp2");    // tmp1+1,tmp2,tmp2+1
  tasm.ldab("tmp1+1"); //   is now 10*X+D.
  tasm.adcb("#0");     //
  tasm.stab("tmp1+1"); //
  tasm.inc("tmp4");    // increment digit count
  tasm.ldd("tmp1+1");  // check current value
  tasm.subd("#$0CCC"); // < 838656?
  tasm.pulb();         // restore string count
  tasm.blo("_nxtdig"); //  get next dig if ok
  tasm.ldaa("tmp2+1"); //
  tasm.cmpa("#$CC");   // < 838860?
  tasm.blo("_nxtdig"); //  get next dig if ok
                       //  otherwise fallthrough
  tasm.label("_crts");
  tasm.clra();         //  clear fraction
  tasm.staa("tmp3");   //  and return to caller
  tasm.staa("tmp3+1"); //
  tasm.rts();          //

  tasm.label("_dbl");
  tasm.lsl("tmp2+1");
  tasm.rol("tmp2");
  tasm.rol("tmp1+1");
  tasm.rts();

  tasm.label("_tblten");
  tasm.byte("$00,$00,$01");
  tasm.byte("$00,$00,$0A");
  tasm.byte("$00,$00,$64");
  tasm.byte("$00,$03,$E8");
  tasm.byte("$00,$27,$10");
  tasm.byte("$01,$86,$A0");
  tasm.byte("$0F,$42,$40");
  tasm.byte("$98,$96,$80");
  return tasm.source();
}

std::string Library::mdStrEqx() {
  Assembler tasm;
  tasm.comment("equality comparison with string release");
  tasm.comment("ENTRY:  X holds descriptor of LHS");
  tasm.comment("        tmp1+1 and tmp2 are RHS");
  tasm.comment("EXIT:  Z CCR flag set");
  tasm.label("streqx");
  tasm.ldab("0,x");
  tasm.cmpb("tmp1+1");
  tasm.bne("_frts");
  tasm.tstb();
  tasm.beq("_frts");
  tasm.ldx("1,x");
  tasm.jsr("strrel");
  tasm.pshx();
  tasm.ldx("tmp2");
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.sts("tmp3");
  tasm.txs();
  tasm.ldx("tmp2");
  tasm.label("_nxtchr");
  tasm.pula();
  tasm.cmpa(",x");
  tasm.bne("_ne");
  tasm.inx();
  tasm.decb();
  tasm.bne("_nxtchr");
  tasm.lds("tmp3");
  tasm.clra();
  tasm.rts();
  tasm.label("_ne");
  tasm.lds("tmp3");
  tasm.rts();

  tasm.label("_frts");
  tasm.tpa();
  tasm.ldx("1,x");
  tasm.jsr("strrel");
  tasm.ldx("tmp2");
  tasm.jsr("strrel");
  tasm.tap();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrEqs() {
  Assembler tasm;
  tasm.comment("compare string against stack");
  tasm.comment(
      "ENTRY: top of stack is return to caller (ld<ne/eq>_ir1_sr1_ss)");
  tasm.comment("       next two bytes address of string length+payload");
  tasm.comment(
      "EXIT:  we modify those two bytes to point to code beyond payload so "
      "caller can just RTS");
  tasm.comment("       we return correct Z flag for caller");
  tasm.label("streqs");
  tasm.ldx("tmp2");
  tasm.jsr("strrel");
  tasm.sts("tmp3");
  tasm.tsx();
  tasm.ldx("2,x");
  tasm.ldab(",x");
  tasm.cmpb("tmp1+1");
  tasm.bne("_ne");
  tasm.tstb();
  tasm.beq("_eq");
  tasm.tsx();
  tasm.ldx("2,x");
  tasm.inx();
  tasm.txs();
  tasm.ldx("tmp2");
  tasm.label("_nxtchr");
  tasm.pula();
  tasm.cmpa(",x");
  tasm.bne("_ne");
  tasm.inx();
  tasm.decb();
  tasm.bne("_nxtchr");

  tasm.label("_eq");
  tasm.lds("tmp3");
  tasm.bsr("_fudge");
  tasm.clra();
  tasm.rts();

  tasm.label("_ne");
  tasm.lds("tmp3");
  tasm.bsr("_fudge");
  tasm.rts();

  tasm.label("_fudge");
  tasm.tsx();
  tasm.ldd("4,x");
  tasm.ldx("4,x");
  tasm.sec();
  tasm.adcb(",x");
  tasm.adca("#0");
  tasm.tsx();
  tasm.std("4,x");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdStrEqbs() {
  Assembler tasm;
  tasm.comment("compare string against bytecode \"stack\"");
  tasm.comment("ENTRY: tmp1+1 holds length, tmp2 holds compare");
  tasm.comment("EXIT:  we return correct Z flag for caller");
  tasm.label("streqbs");
  tasm.ldx("tmp2");
  tasm.jsr("strrel");
  tasm.jsr("immstr");
  tasm.sts("tmp3");
  tasm.cmpb("tmp1+1");
  tasm.bne("_ne");
  tasm.tstb();
  tasm.beq("_eq");
  tasm.txs();
  tasm.ldx("tmp2");
  tasm.label("_nxtchr");
  tasm.pula();
  tasm.cmpa(",x");
  tasm.bne("_ne");
  tasm.inx();
  tasm.decb();
  tasm.bne("_nxtchr");

  tasm.label("_eq");
  tasm.lds("tmp3");
  tasm.clra();
  tasm.rts();

  tasm.label("_ne");
  tasm.lds("tmp3");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdStrLo() {
  Assembler tasm;
  tasm.comment("compare A$ < B$ with string release");
  tasm.comment("ENTRY:  A$ = 0+argv (len) 1+argv (ptr)");
  tasm.comment("        B$ = tmp1+1 (len) tmp2   (ptr)");
  tasm.comment("EXIT: C flag set if A$ < B$");
  tasm.label("strlo");
  tasm.ldx("1+argv");
  tasm.jsr("strrel");
  tasm.ldx("tmp2");
  tasm.jsr("strrel");
  tasm.ldab("tmp1+1");
  tasm.cmpb("0+argv");
  tasm.bls("_ok");
  tasm.ldab("0+argv");
  tasm.label("_ok");
  tasm.sts("tmp3");
  tasm.lds("1+argv");
  tasm.des();
  tasm.ldx("tmp2");
  tasm.tstb();
  tasm.beq("_tie");
  tasm.dex();
  tasm.label("_nxtchr");
  tasm.inx();
  tasm.pula();
  tasm.cmpa(",x");
  tasm.bne("_done");
  tasm.decb();
  tasm.bne("_nxtchr");
  tasm.label("_tie");
  tasm.ldab("0+argv");
  tasm.cmpb("tmp1+1");
  tasm.label("_done");
  tasm.tpa();
  tasm.lds("tmp3");
  tasm.tap();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrLos() {
  Assembler tasm;
  tasm.label("strlos");
  tasm.tsx(); // ret to ri rs ss
  tasm.ldx("2,x");
  tasm.ldab(",x");
  tasm.stab("tmp1+1");
  tasm.inx();
  tasm.stx("tmp2");
  tasm.abx();
  tasm.stx("tmp3");
  tasm.tsx();
  tasm.ldd("tmp3");
  tasm.std("2,x");
  tasm.bra("strlo");
  return tasm.source();
}

std::string Library::mdStrLosr() {
  Assembler tasm;
  tasm.label("strlosr");
  tasm.tsx();
  tasm.ldx("2,x");
  tasm.ldab(",x");
  tasm.stab("0+argv");
  tasm.inx();
  tasm.stx("1+argv");
  tasm.abx();
  tasm.stx("tmp3");
  tasm.tsx();
  tasm.ldd("tmp3");
  tasm.std("2,x");
  tasm.bra("strlo");
  return tasm.source();
}

std::string Library::mdStrLobs() {
  Assembler tasm;
  tasm.label("strlobs");
  tasm.jsr("immstr");
  tasm.stx("tmp2");
  tasm.stab("tmp1+1");
  tasm.bra("strlo");
  return tasm.source();
}

std::string Library::mdStrLox() {
  Assembler tasm;
  tasm.label("strlox");
  tasm.ldab(",x");
  tasm.stab("tmp1+1");
  tasm.ldx("1,x");
  tasm.stx("tmp2");
  tasm.bra("strlo");
  return tasm.source();
}

std::string Library::mdStrLoxr() {
  Assembler tasm;
  tasm.label("strloxr");
  tasm.ldab(",x");
  tasm.stab("0+argv");
  tasm.ldx("1,x");
  tasm.stx("1+argv");
  tasm.bra("strlo");
  return tasm.source();
}

std::string Library::mdFilename() {
  Assembler tasm;
  tasm.comment("set filename string");
  tasm.comment(" ENTRY: B holds strlen");
  tasm.comment("        3+argv holds addr");
  tasm.comment(" EXIT:  8-byte (padded) string in M_FNAM");
  tasm.comment("        string length in M_FLEN");
  tasm.label("filename");
  tasm.sts("tmp2");
  tasm.ldx("#M_FNAM");
  tasm.cmpb("#8");
  tasm.bls("_ok");
  tasm.ldab("#8");
  tasm.label("_ok");
  tasm.stab("M_FLEN");
  tasm.beq("_donecopy");
  tasm.lds("3+argv");
  tasm.des();
  tasm.label("_copy");
  tasm.pula();
  tasm.staa(",x");
  tasm.inx();
  tasm.decb();
  tasm.bne("_copy");
  tasm.label("_donecopy");
  tasm.lds("tmp2");
  tasm.ldab("M_FLEN");
  tasm.subb("#8");
  tasm.bhs("_done");
  tasm.ldaa("#' '");
  tasm.label("_pad");
  tasm.staa(",x");
  tasm.inx();
  tasm.incb();
  tasm.bne("_pad");
  tasm.label("_done");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetArr() {
  Assembler tasm;
  tasm.comment("get size of an array");
  tasm.comment(" ENTRY: 0+argv: numDims");
  tasm.comment("        1+argv: array descriptor");
  tasm.comment(" EXIT:  X: array beginning");
  tasm.comment("        D: total num bytes");
  tasm.comment("        M_FTYP: element size (3 or 5)");
  tasm.label("getarri");
  tasm.ldab("#3", "Int Array Data");
  tasm.stab("M_FTYP");
  tasm.jsr("_getarrsize");
  tasm.bra("_load");
  tasm.label("getarrf");
  tasm.ldab("#5", "Flt Array Data");
  tasm.stab("M_FTYP");
  tasm.jsr("_getarrsize");
  tasm.lsld();
  tasm.label("_load");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.rts();

  tasm.label("_getarrsize");
  tasm.ldab("0+argv");
  tasm.stab("tmp4");
  tasm.ldx("1+argv");
  tasm.ldd("#1");
  tasm.label("_loop");
  tasm.std("tmp1");
  tasm.inx();
  tasm.inx();
  tasm.ldd(",x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.ldd("tmp3");
  tasm.dec("tmp4");
  tasm.bne("_loop");
  tasm.ldx("1+argv");
  tasm.ldx(",x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdCLoadM() {
  Assembler tasm;
  tasm.comment("CLOADM a file");
  tasm.comment(" ENTRY: ACCD: offset");
  tasm.comment(" EXIT: file contents written to memory");
  tasm.label("cloadm");
  tasm.std("tmp1");
  tasm.jsr("R_SFNAM");
  tasm.ldaa("M_FTYP");
  tasm.cmpa("#2");
  tasm.bne("_fmerror");
  tasm.jsr("R_RSLDR");
  tasm.ldx("tmp1");
  tasm.jmp("R_RCLDM");
  tasm.label("_fmerror");
  tasm.ldab("#FM_ERROR");
  tasm.jmp("error");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdCLoadStar() {
  Assembler tasm;
  tasm.comment("CLOAD* a file");
  tasm.comment(" ENTRY: 0+argv: numDims");
  tasm.comment("        1+argv: array descriptor");
  tasm.comment("        M_FNAM: initialized by filename routine");
  tasm.comment("        M_FLEN: length of FNAM.  Matches any file if 0");
  tasm.comment(" EXIT: file contents written to array");
  tasm.label("cloadstari");
  tasm.jsr("getarri");
  tasm.bra("_load");
  tasm.label("cloadstarf");
  tasm.jsr("getarrf");
  tasm.label("_load");
  tasm.stx("M_CBEG");
  tasm.std("tmp2");
  tasm.ldaa("DP_LNUM");
  tasm.inca();
  tasm.bne("_gotlnum");
  tasm.tab();
  tasm.std("DP_LNUM");
  tasm.label("_gotlnum");
  tasm.ldaa("M_FTYP");
  tasm.psha();
  tasm.jsr("R_SFNAM");
  tasm.pula();
  tasm.bne("_ioerr");
  tasm.cmpa("M_FTYP");
  tasm.bne("_fmerr");
  tasm.jsr("R_RSLDR");
  tasm.ldx("M_LDSZ");
  tasm.cpx("tmp2");
  tasm.blo("_omerr");
  tasm.jmp("R_RBLKS");
  tasm.label("_ioerr");
  tasm.ldab("#IO_ERROR");
  tasm.bra("_error");
  tasm.label("_fmerr");
  tasm.ldab("#FM_ERROR");
  tasm.bra("_error");
  tasm.label("_omerr");
  tasm.ldab("#OM_ERROR");
  tasm.label("_error");
  tasm.jmp("error");
  return tasm.source();
}
std::string Library::mdCSaveStar() {
  Assembler tasm;
  tasm.label("csavestari");
  tasm.jsr("getarri");
  tasm.bra("_save");
  tasm.label("csavestarf");
  tasm.jsr("getarrf");
  tasm.label("_save");
  tasm.stx("M_CBEG");
  tasm.std("M_LDSZ");
  tasm.addd("M_CBEG");
  tasm.std("M_CEND");
  tasm.jsr("R_WFNAM");
  tasm.jmp("R_WBLKS");
  return tasm.source();
}

std::string Library::mdRnd() {
  Assembler tasm;
  tasm.label("rnd");
  tasm.ldab("tmp1+1");
  tasm.bpl("gornd");
  tasm.orab("#1");
  tasm.pshb();
  tasm.ldaa("tmp2");
  tasm.mul();
  tasm.std("rvseed");
  tasm.ldaa("tmp2+1");
  tasm.pulb();
  tasm.mul();
  tasm.addd("rvseed");
  tasm.std("rvseed");

  tasm.label("gornd");
  tasm.ldaa("rvseed");
  tasm.ldab("#-2");
  tasm.mul();
  tasm.std("tmp3");
  tasm.ldaa("rvseed+1");
  tasm.ldab("#-2");
  tasm.mul();
  tasm.addb("#-2");
  tasm.adca("tmp3+1");
  tasm.sbcb("tmp3");
  tasm.sbca("#0");
  tasm.adcb("#0");
  tasm.adca("#0");
  tasm.std("rvseed");
  tasm.rts();

  tasm.label("irnd");
  tasm.bsr("rnd");
  tasm.ldaa("tmp2+1");
  tasm.ldab("rvseed+1");
  tasm.mul(); // CE top
  tasm.staa("tmp3+1");
  tasm.ldaa("tmp2+1");
  tasm.ldab("rvseed");
  tasm.mul(); // CD
  tasm.addb("tmp3+1");
  tasm.adca("#0");
  tasm.std("tmp3");
  tasm.ldaa("tmp2");
  tasm.ldab("rvseed+1");
  tasm.mul(); // BE
  tasm.addd("tmp3");
  tasm.staa("tmp3+1");
  tasm.ldaa("#0");
  tasm.adca("#0");
  tasm.staa("tmp3");
  tasm.ldaa("tmp2");
  tasm.ldab("rvseed");
  tasm.mul(); // BD
  tasm.addd("tmp3");
  tasm.std("tmp3");
  tasm.ldaa("#0");
  tasm.adca("#0");
  tasm.staa("tmp1");
  tasm.ldaa("tmp1+1");
  tasm.beq("_done");
  tasm.ldab("rvseed+1");
  tasm.mul(); // AE
  tasm.addb("tmp3");
  tasm.stab("tmp3");
  tasm.adca("tmp1");
  tasm.staa("tmp1");
  tasm.ldaa("tmp1+1");
  tasm.ldab("rvseed");
  tasm.mul(); // AD
  tasm.addb("tmp1");
  tasm.stab("tmp1");
  tasm.label("_done");
  tasm.ldd("tmp3");
  tasm.addd("#1");
  tasm.bcc("_rts");
  tasm.inc("tmp1");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMul12() {
  Assembler tasm;
  tasm.comment("multiply words in TMP1 and TMP2");
  tasm.comment("result in TMP3");
  tasm.label("mul12");
  tasm.ldaa("tmp1+1");
  tasm.ldab("tmp2+1");
  tasm.mul();
  tasm.std("tmp3");
  tasm.ldaa("tmp1");
  tasm.ldab("tmp2+1");
  tasm.mul();
  tasm.addb("tmp3");
  tasm.stab("tmp3");
  tasm.ldaa("tmp1+1");
  tasm.ldab("tmp2");
  tasm.mul();
  tasm.tba();
  tasm.adda("tmp3");
  tasm.ldab("tmp3+1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMul3F() {
  Assembler tasm;
  tasm.comment("multiply X by 3");
  tasm.comment("result in X");
  tasm.comment("clobbers TMP1+1..TMP3+1");
  tasm.label("mul3f");
  tasm.ldd("3,x");
  tasm.lsld();
  tasm.std("tmp3");
  tasm.ldd("1,x");
  tasm.rolb();
  tasm.rola();
  tasm.std("tmp2");
  tasm.ldab("0,x");
  tasm.rolb();
  tasm.stab("tmp1+1");
  tasm.ldd("3,x");
  tasm.addd("tmp3");
  tasm.std("3,x");
  tasm.ldd("1,x");
  tasm.adcb("tmp2+1");
  tasm.adca("tmp2");
  tasm.std("1,x");
  tasm.ldab("0,x");
  tasm.adcb("tmp1+1");
  tasm.stab("0,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMul3I() {
  Assembler tasm;
  tasm.comment("multiply X by 3");
  tasm.comment("result in X");
  tasm.comment("clobbers TMP1+1");
  tasm.label("mul3i");
  tasm.ldab("0,x");
  tasm.stab("tmp1+1");
  tasm.ldd("1,x");
  tasm.lsld();
  tasm.rol("tmp1+1");
  tasm.addd("1,x");
  tasm.std("1,x");
  tasm.ldab("0,x");
  tasm.adcb("tmp1+1");
  tasm.stab("0,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMulBytF() {
  Assembler tasm;
  tasm.comment("multiply X with ACCB");
  tasm.comment("result in X");
  tasm.comment("clobbers TMP1+1...TMP3+1");
  tasm.label("mulbytf");
  tasm.bsr("mulbyti");
  tasm.ldaa("4,x");
  tasm.ldab("tmp1");
  tasm.mul();
  tasm.std("tmp3");
  tasm.ldaa("3,x");
  tasm.ldab("tmp1");
  tasm.mul();
  tasm.addd("tmp2+1");
  tasm.std("tmp2+1");
  tasm.ldd("tmp1+1");
  tasm.adcb("#0");
  tasm.adca("#0");
  tasm.std("tmp1+1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMulBytI() {
  Assembler tasm;
  tasm.comment("multiply X with ACCB");
  tasm.comment("result in TMP1+1...TMP2+1");
  tasm.comment("clobbers TMP1");
  tasm.label("mulbyti");
  tasm.stab("tmp1");
  tasm.ldaa("2,x");
  tasm.mul();
  tasm.std("tmp2");
  tasm.ldaa("0,x");
  tasm.ldab("tmp1");
  tasm.mul();
  tasm.stab("tmp1+1");
  tasm.ldaa("1,x");
  tasm.ldab("tmp1");
  tasm.mul();
  tasm.addd("tmp1+1");
  tasm.std("tmp1+1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMulFlt() {
  Assembler tasm;
  tasm.label("mulfltx");
  tasm.bsr("mulfltt");
  tasm.ldab("tmp1+1");
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.ldd("tmp3");
  tasm.std("3,x");
  tasm.rts();

  // multiply X with ARGV, result in TMP1+1...TMP3.
  // clobbers tmp4 and tmp4+1
  tasm.label("mulfltt");
  tasm.jsr("mulhlf");
  tasm.clr("tmp4");
  tasm.label("_4_3");
  tasm.ldaa("4+argv");
  tasm.beq("_3_4");
  tasm.ldab("3,x");
  tasm.bsr("_m43");
  tasm.label("_4_1");
  tasm.ldaa("4+argv");
  tasm.ldab("1,x");
  tasm.bsr("_m41");
  tasm.label("_4_2");
  tasm.ldaa("4+argv");
  tasm.ldab("2,x");
  tasm.bsr("_m42");
  tasm.label("_4_0");
  tasm.ldaa("4+argv");
  tasm.ldab("0,x");
  tasm.bsr("_m40");

  tasm.ldab("0,x");
  tasm.bpl("_4_4");
  tasm.ldd("tmp1+1");
  tasm.subb("4+argv");
  tasm.sbca("#0");
  tasm.std("tmp1+1");

  tasm.label("_4_4");
  tasm.ldaa("4+argv");
  tasm.ldab("4,x");
  tasm.beq("_rndup");
  tasm.mul();
  tasm.adca("tmp4");
  tasm.staa("tmp4");
  tasm.bsr("mulflt3");
  tasm.label("_3_4");
  tasm.ldab("4,x");
  tasm.beq("_rndup");
  tasm.ldaa("3+argv");
  tasm.bsr("_m43");
  tasm.label("_1_4");
  tasm.ldab("4,x");
  tasm.ldaa("1+argv");
  tasm.bsr("_m41");
  tasm.label("_2_4");
  tasm.ldab("4,x");
  tasm.ldaa("2+argv");
  tasm.bsr("_m42");
  tasm.label("_0_4");
  tasm.ldab("4,x");
  tasm.ldaa("0+argv");
  tasm.bsr("_m40");

  tasm.ldaa("0+argv");
  tasm.bpl("_rndup");
  tasm.ldd("tmp1+1");
  tasm.subb("4,x");
  tasm.sbca("#0");
  tasm.std("tmp1+1");

  tasm.label("_rndup");
  tasm.ldaa("tmp4");
  tasm.lsla();
  tasm.label("mulflt3");
  tasm.ldd("tmp3");
  tasm.adcb("#0");
  tasm.adca("#0");
  tasm.std("tmp3");
  tasm.ldd("tmp2");
  tasm.adcb("#0");
  tasm.adca("#0");
  tasm.jmp("mulhlf2");
  tasm.label("_m43");
  tasm.mul();
  tasm.addd("tmp3+1");
  tasm.std("tmp3+1");
  tasm.rol("tmp4+1");
  tasm.rts();
  tasm.label("_m41");
  tasm.mul();
  tasm.lsr("tmp4+1");
  tasm.adcb("tmp3");
  tasm.adca("tmp2+1");
  tasm.std("tmp2+1");
  tasm.ldd("tmp1+1");
  tasm.adcb("#0");
  tasm.adca("#0");
  tasm.std("tmp1+1");
  tasm.rts();
  tasm.label("_m42");
  tasm.mul();
  tasm.addd("tmp3");
  tasm.std("tmp3");
  tasm.rol("tmp4+1");
  tasm.rts();
  tasm.label("_m40");
  tasm.mul();
  tasm.lsr("tmp4+1");
  tasm.adcb("tmp2+1");
  tasm.adca("tmp2");
  tasm.bra("mulhlf2");

  return tasm.source();
}

std::string Library::mdMulHlf() {
  Assembler tasm;
  tasm.label("mulhlf");
  tasm.bsr("mulint");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.stab("tmp4+1");
  tasm.label("_3_2");
  tasm.ldaa("3+argv");
  tasm.beq("_2_3");
  tasm.ldab("2,x");
  tasm.bsr("_m32");
  tasm.label("_3_0");
  tasm.ldaa("3+argv");
  tasm.ldab("0,x");
  tasm.bsr("_m30");

  tasm.ldab("0,x");
  tasm.bpl("_3_3");
  tasm.ldab("tmp1+1");
  tasm.subb("3+argv");
  tasm.stab("tmp1+1");

  tasm.label("_3_3");
  tasm.ldaa("3+argv");
  tasm.ldab("3,x");
  tasm.mul();
  tasm.adda("tmp3");
  tasm.std("tmp3");
  tasm.rol("tmp4+1");
  tasm.label("_3_1");
  tasm.ldaa("3+argv");
  tasm.ldab("1,x");
  tasm.bsr("_m31");
  tasm.label("_2_3");
  tasm.ldab("3,x");
  tasm.beq("_rts");
  tasm.ldaa("2+argv");
  tasm.bsr("_m32");
  tasm.label("_0_3");
  tasm.ldab("3,x");
  tasm.ldaa("0+argv");
  tasm.bsr("_m30");

  tasm.ldaa("0+argv");
  tasm.bpl("_1_3");
  tasm.ldab("tmp1+1");
  tasm.subb("3,x");
  tasm.stab("tmp1+1");

  tasm.label("_1_3");
  tasm.ldab("3,x");
  tasm.ldaa("1+argv");
  tasm.clr("tmp4+1");
  tasm.label("_m31");
  tasm.mul();
  tasm.lsr("tmp4+1");
  tasm.adcb("tmp2+1");
  tasm.adca("tmp2");
  tasm.label("mulhlf2");
  tasm.std("tmp2");
  tasm.ldab("tmp1+1");
  tasm.adcb("#0");
  tasm.stab("tmp1+1");
  tasm.rts();
  tasm.label("_m32");
  tasm.mul();
  tasm.addd("tmp2+1");
  tasm.std("tmp2+1");
  tasm.rol("tmp4+1");
  tasm.rts();
  tasm.label("_m30");
  tasm.mul();
  tasm.lsr("tmp4+1");
  tasm.adcb("tmp2");
  tasm.adca("tmp1+1");
  tasm.std("tmp1+1");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMulInt() {
  Assembler tasm;
  tasm.label("mulint");
  tasm.ldaa("2+argv");
  tasm.ldab("2,x");
  tasm.mul();
  tasm.std("tmp2");
  tasm.ldaa("1+argv");
  tasm.ldab("1,x");
  tasm.mul();
  tasm.stab("tmp1+1");
  tasm.ldaa("2+argv");
  tasm.ldab("1,x");
  tasm.mul();
  tasm.addd("tmp1+1");
  tasm.std("tmp1+1");
  tasm.ldaa("1+argv");
  tasm.ldab("2,x");
  tasm.mul();
  tasm.addd("tmp1+1");
  tasm.std("tmp1+1");
  tasm.ldaa("2+argv");
  tasm.ldab("0,x");
  tasm.mul();
  tasm.addb("tmp1+1");
  tasm.stab("tmp1+1");
  tasm.ldaa("0+argv");
  tasm.ldab("2,x");
  tasm.mul();
  tasm.addb("tmp1+1");
  tasm.stab("tmp1+1");
  tasm.rts();

  tasm.label("mulintx");
  tasm.bsr("mulint");
  tasm.ldab("tmp1+1");
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdShlInt() {
  Assembler tasm;
  tasm.comment("multiply X by 2^ACCB");
  tasm.comment("  ENTRY  X contains multiplicand in (0,x 1,x 2,x)");
  tasm.comment("  EXIT   X*2^ACCB in (0,x 1,x 2,x)");
  tasm.comment("         uses tmp1");
  tasm.label("shlint");
  tasm.cmpb("#8");
  tasm.blo("_shlbit");
  tasm.stab("tmp1");
  tasm.ldd("1,x");
  tasm.std("0,x");
  tasm.clr("2,x");
  tasm.ldab("tmp1");
  tasm.subb("#8");
  tasm.bne("shlint");
  tasm.rts();
  tasm.label("_shlbit");
  tasm.lsl("2,x");
  tasm.rol("1,x");
  tasm.rol("0,x");
  tasm.decb();
  tasm.bne("_shlbit");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdShlFlt() {
  Assembler tasm;
  tasm.comment("multiply X by 2^ACCB for positive ACCB");
  tasm.comment("  ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("  EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses tmp1");
  tasm.label("shlflt");
  tasm.cmpb("#8");
  tasm.blo("_shlbit");
  tasm.stab("tmp1");
  tasm.ldd("1,x");
  tasm.std("0,x");
  tasm.ldd("3,x");
  tasm.std("2,x");
  tasm.clr("4,x");
  tasm.ldab("tmp1");
  tasm.subb("#8");
  tasm.bne("shlflt");
  tasm.rts();
  tasm.label("_shlbit");
  tasm.lsl("4,x");
  tasm.rol("3,x");
  tasm.rol("2,x");
  tasm.rol("1,x");
  tasm.rol("0,x");
  tasm.decb();
  tasm.bne("_shlbit");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdShrFlt() {
  Assembler tasm;
  tasm.comment("divide X by 2^ACCB for positive ACCB");
  tasm.comment("  ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("  EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses tmp1");
  tasm.label("shrint");
  tasm.clr("3,x");
  tasm.clr("4,x");
  tasm.label("shrflt");
  tasm.cmpb("#8");
  tasm.blo("_shrbit");
  tasm.stab("tmp1");
  tasm.ldd("2,x");
  tasm.std("3,x");
  tasm.ldd("0,x");
  tasm.std("1,x");
  tasm.clrb();
  tasm.lsla();
  tasm.sbcb("#0");
  tasm.stab("0,x");
  tasm.ldab("tmp1");
  tasm.subb("#8");
  tasm.bne("shrflt");
  tasm.rts();
  tasm.label("_shrbit");
  tasm.asr("0,x");
  tasm.ror("1,x");
  tasm.ror("2,x");
  tasm.ror("3,x");
  tasm.ror("4,x");
  tasm.decb();
  tasm.bne("_shrbit");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdShift() {
  Assembler tasm;

  tasm.comment("multiply X by 2^ACCB for ACCB");
  tasm.comment("  ENTRY  X contains multiplicand in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("  EXIT   X*2^ACCB in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses tmp1");

  tasm.label("shifti");
  tasm.clr("3,x");
  tasm.clr("4,x");
  tasm.label("shift");
  tasm.tstb();
  tasm.beq("_rts");
  tasm.bpl("shlflt");
  tasm.negb();
  tasm.bra("shrflt");
  tasm.label("_rts");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdModFlti() {
  Assembler tasm;
  tasm.comment("modulo X by Y");
  tasm.comment("  ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("                    scratch in  (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("  EXIT   X%Y in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         INT(X/Y) in (7,x 8,x 9,x)");
  tasm.comment("         uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4");
  tasm.label("modflti");
  tasm.ldaa("#8*3"); // set number of shifts
  tasm.jsr("divmod");
  tasm.tst("tmp4");
  tasm.bpl("_rts");
  tasm.jmp("negx");
  tasm.label("_rts");
  tasm.com("9,x");
  tasm.com("8,x");
  tasm.com("7,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdModFlt() {
  Assembler tasm;
  tasm.comment("modulo X by Y");
  tasm.comment("  ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("                    scratch in  (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("  EXIT   X%Y in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         FIX(X/Y) in (7,x 8,x 9,x)");
  tasm.comment("         uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4");
  tasm.label("modflt");
  tasm.ldaa("#8*3"); // set number of shifts
  tasm.jsr("divmod");
  tasm.tst("tmp4");
  tasm.bpl("_rts");
  tasm.jsr("negx");
  tasm.ldd("8,x");
  tasm.addd("#1");
  tasm.std("8,x");
  tasm.ldab("7,x");
  tasm.adcb("#0");
  tasm.stab("7,x");
  tasm.rts();
  tasm.label("_rts");
  tasm.com("9,x");
  tasm.com("8,x");
  tasm.com("7,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdIDivFlt() {
  Assembler tasm;
  tasm.comment("divide X by Y and mask off fraction");
  tasm.comment("  ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("                    scratch in  (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("  EXIT   INT(X/Y) in (0,x 1,x 2,x)");
  tasm.comment("         uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4");
  tasm.label("idivflt");
  tasm.ldaa("#8*3"); // set number of shifts
  tasm.bsr("divmod");
  tasm.tst("tmp4");
  tasm.bmi("_neg");
  tasm.ldd("8,x");
  tasm.comb();
  tasm.coma();
  tasm.std("1,x");
  tasm.ldab("7,x");
  tasm.comb();
  tasm.stab("0,x");
  tasm.rts();

  tasm.label("_neg");
  tasm.ldd("3,x");
  tasm.bne("_copy");
  tasm.ldd("1,x");
  tasm.bne("_copy");
  tasm.ldab(",x");
  tasm.bne("_copy");
  tasm.ldd("8,x");
  tasm.addd("#1");
  tasm.std("1,x");
  tasm.ldab("7,x");
  tasm.adcb("#0");
  tasm.stab("0,x");
  tasm.rts();
  tasm.label("_copy");
  tasm.ldd("8,x");
  tasm.std("1,x");
  tasm.ldab("7,x");
  tasm.stab("0,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdDivFlt() {
  Assembler tasm;
  tasm.comment("divide X by Y");
  tasm.comment("  ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("                    scratch in  (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("  EXIT   X/Y in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4");
  tasm.label("divflt");
  tasm.ldaa("#8*5"); // set number of shifts
  tasm.bsr("divmod");
  tasm.tst("tmp4");
  tasm.bmi("_add1"); // result negative
  tasm.label("_com");
  tasm.ldd("8,x");
  tasm.coma();
  tasm.comb();
  tasm.std("3,x");
  tasm.ldd("6,x");
  tasm.coma();
  tasm.comb();
  tasm.std("1,x");
  tasm.ldab("5,x");
  tasm.comb();
  tasm.stab("0,x");
  tasm.rts();
  tasm.label("_add1");
  tasm.ldd("8,x");
  tasm.addd("#1");
  tasm.std("3,x");
  tasm.ldd("6,x");
  tasm.adcb("#0");
  tasm.adca("#0");
  tasm.std("1,x");
  tasm.ldab("5,x");
  tasm.adcb("#0");
  tasm.stab("0,x");
  tasm.rts();

  tasm.label("divuflt");
  tasm.clr("tmp4");
  tasm.ldab("#8*5");
  tasm.stab("tmp1");
  tasm.bsr("divumod");
  tasm.bra("_com");
  return tasm.source();
}

std::string Library::mdDivMod() {
  Assembler tasm;
  tasm.comment("divide/modulo X by Y with remainder");
  tasm.comment("  ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("         #shifts in ACCA (24 for modulus, 40 for division");
  tasm.comment("  EXIT   for division:");
  tasm.comment("           NOT ABS(X)/ABS(Y) in (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("  EXIT   for modulus:");
  tasm.comment("           NOT INT(ABS(X)/ABS(Y)) in (7,x 8,x 9,x)");
  tasm.comment("           FMOD(X,Y) in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         result sign in tmp4.(0 = pos, -1 = neg).");
  tasm.comment("         uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4");
  tasm.label("divmod");
  tasm.staa("tmp1");
  tasm.clr("tmp4"); // clear output sign
  tasm.tst("0,x");  // dividend positive?
  tasm.bpl("_posX");
  tasm.com("tmp4"); // no, invert output sign
  tasm.jsr("negx");

  tasm.label("_posX");
  tasm.tst("0+argv"); // divisor positive?
  tasm.bpl("divumod");
  tasm.com("tmp4"); // no, invert output sign
  tasm.jsr("negargv");

  tasm.label("divumod");
  tasm.ldd("3,x");
  tasm.std("6,x");
  tasm.ldd("1,x");
  tasm.std("4,x");
  tasm.ldab("0,x");
  tasm.stab("3,x");
  tasm.clra(); // clear C flag
  tasm.clrb(); // instead of ldd #0
  tasm.std("8,x");
  tasm.std("1,x");
  tasm.stab("0,x");

  tasm.label("_nxtdiv");
  tasm.rol("7,x");
  tasm.rol("6,x");
  tasm.rol("5,x");
  tasm.rol("4,x");
  tasm.rol("3,x");
  tasm.rol("2,x");
  tasm.rol("1,x");
  tasm.rol("0,x");
  tasm.bcc("_trialsub");

  tasm.incomment("force subtraction");
  tasm.ldd("3,x");     // if carry out set
  tasm.subd("3+argv"); // then subtraction
  tasm.std("3,x");     // _must_ succeed.
  tasm.ldd("1,x");     //
  tasm.sbcb("2+argv"); // this is needed for
  tasm.sbca("1+argv"); // unsigned division
  tasm.std("1,x");     // by a large number
  tasm.ldab("0,x");    // whose MSB is set
  tasm.sbcb("0+argv"); // (e.g. 1,000,000).
  tasm.stab("0,x");    //
  tasm.clc();          // indicate success
  tasm.bra("_shift");

  tasm.label("_trialsub");
  tasm.ldd("3,x");
  tasm.subd("3+argv");
  tasm.std("tmp3");
  tasm.ldd("1,x");
  tasm.sbcb("2+argv");
  tasm.sbca("1+argv");
  tasm.std("tmp2");
  tasm.ldab("0,x");
  tasm.sbcb("0+argv");
  tasm.stab("tmp1+1");
  tasm.blo("_shift");
  tasm.ldd("tmp3");
  tasm.std("3,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.ldab("tmp1+1");
  tasm.stab("0,x");

  tasm.label("_shift");
  tasm.rol("9,x");
  tasm.rol("8,x");
  tasm.dec("tmp1");
  tasm.bne("_nxtdiv");
  tasm.rol("7,x");
  tasm.rol("6,x");
  tasm.rol("5,x");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdInvFlt() {
  Assembler tasm;
  tasm.comment("X = 1/Y");
  tasm.comment("  ENTRY  Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("  EXIT   1/Y in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         uses argv and tmp1-tmp4 (tmp4+1 unused)");
  tasm.label("invflt");
  tasm.ldd("#0");
  tasm.std("0,x");
  tasm.std("3,x");
  tasm.incb();
  tasm.stab("2,x");
  tasm.jmp("divflt");
  return tasm.source();
}

std::string Library::mdPowIntN() {
  Assembler tasm;
  tasm.comment("Y = X^ACCD for integer X, positive D");
  tasm.comment("  ENTRY  X in 0,x 1,x 2,x");
  tasm.comment("         ACCD contains exponent");
  tasm.comment("  EXIT   X^ACCD in 0,x 1,x 2,x");

  tasm.label("powintn");
  tasm.subd("#0");
  tasm.bne("_nonzero");
  tasm.std("0,x");
  tasm.ldab("#1");
  tasm.stab("2,x");
  tasm.label("_rts");
  tasm.rts();

  tasm.label("_nonzero");
  tasm.lsrd();
  tasm.bcc("_square");

  tasm.subd("#0");
  tasm.beq("_rts");
  tasm.std("tmp1");
  tasm.ldd("1,x");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("0,x");
  tasm.pshb();

  tasm.ldd("tmp1");
  tasm.bsr("_square");

  tasm.pulb();
  tasm.stab("0+argv");
  tasm.pula();
  tasm.pulb();
  tasm.std("1+argv");
  tasm.jmp("mulintx");

  tasm.label("_square");
  tasm.bsr("powintn");
  tasm.jsr("x2arg");
  tasm.jmp("mulintx");

  return tasm.source();
}

std::string Library::mdPowFltN() {
  Assembler tasm;
  tasm.comment("Y = X^ACCD for fixed-point X, positive D");
  tasm.comment("  ENTRY  X in 0,x 1,x 2,x 3,x 4,x");
  tasm.comment("         ACCD contains exponent");
  tasm.comment("  EXIT   X^ACCD in 0,x 1,x 2,x 3,x 4,x");

  tasm.label("powfltn");
  tasm.subd("#0");
  tasm.bne("_nonzero");
  tasm.std("0,x");
  tasm.std("3,x");
  tasm.ldab("#1");
  tasm.stab("2,x");
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_nonzero");
  tasm.lsrd();
  tasm.bcc("_square");
  tasm.subd("#0");
  tasm.beq("_rts");
  tasm.std("tmp1");
  tasm.ldd("3,x");
  tasm.pshb();
  tasm.psha();
  tasm.ldd("1,x");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("0,x");
  tasm.pshb();
  tasm.ldd("tmp1");
  tasm.bsr("_square");
  tasm.pulb();
  tasm.stab("0+argv");
  tasm.pula();
  tasm.pulb();
  tasm.std("1+argv");
  tasm.pula();
  tasm.pulb();
  tasm.std("3+argv");
  tasm.jmp("mulfltx");

  tasm.label("_square");
  tasm.bsr("powfltn");
  tasm.jsr("x2arg");
  tasm.jmp("mulfltx");

  return tasm.source();
}

std::string Library::mdTmp2XI() {
  Assembler tasm;
  tasm.comment("copy integer tmp to [X]");
  tasm.comment("  ENTRY  Y in tmp1+1,tmp2");
  tasm.comment("  EXIT   Y copied to 0,x 1,x 2,x");
  tasm.label("tmp2xi");
  tasm.ldab("tmp1+1");
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdTmp2XF() {
  Assembler tasm;
  tasm.comment("copy fixedpt tmp to [X]");
  tasm.comment("  ENTRY  Y in tmp1+1,tmp2,tmp3");
  tasm.comment("  EXIT   Y copied to 0,x 1,x 2,x 3,x 4,x");
  tasm.label("tmp2xf");
  tasm.ldab("tmp1+1");
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.ldd("tmp3");
  tasm.std("3,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdArg2X() {
  Assembler tasm;
  tasm.comment("copy argv to [X]");
  tasm.comment("  ENTRY  Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("  EXIT   Y copied to 0,x 1,x 2,x 3,x 4,x");
  tasm.label("arg2x");
  tasm.ldab("0+argv");
  tasm.stab("0,x");
  tasm.ldd("1+argv");
  tasm.std("1,x");
  tasm.ldd("3+argv");
  tasm.std("3,x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdX2Arg() {
  Assembler tasm;
  tasm.comment("copy [X] to argv");
  tasm.comment("  ENTRY  Y in 0,x 1,x 2,x 3,x 4,x");
  tasm.comment("  EXIT   Y copied to 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.incomment("copy x to argv");
  tasm.label("x2arg");
  tasm.ldab("0,x");
  tasm.stab("0+argv");
  tasm.ldd("1,x");
  tasm.std("1+argv");
  tasm.ldd("3,x");
  tasm.std("3+argv");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdMSBit() {
  Assembler tasm;
  tasm.comment("ACCA = MSBit(X)");
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("  EXIT   most siginficant bit in ACCA");
  tasm.comment("         0 = sign bit, 39 = LSB. 40 if zero");
  tasm.label("msbit");
  tasm.pshx();
  tasm.clra();

  tasm.label("_nxtbyte");
  tasm.ldab(",x");
  tasm.bne("_dobit");
  tasm.adda("#8");
  tasm.inx();
  tasm.cmpa("#40");
  tasm.blo("_nxtbyte");
  tasm.label("_rts");
  tasm.pulx();
  tasm.rts();

  tasm.label("_dobit"); // find first nonzero bit
  tasm.lslb();
  tasm.bcs("_rts");
  tasm.inca();
  tasm.bra("_dobit");

  return tasm.source();
}

std::string Library::mdSetBit() {
  Assembler tasm;
  tasm.comment("SetBit");
  tasm.comment("  ENTRY  ACCA holds bit to set");
  tasm.comment("  ENTRY  X holds floating point reg");
  tasm.comment("  EXIT   bit set in register");
  tasm.comment("         0 = sign bit, 39 = LSB.");

  tasm.label("setbit");
  tasm.suba("#8");
  tasm.blo("_dobit");
  tasm.inx();
  tasm.bra("setbit");

  tasm.label("_dobit");
  tasm.ldab("#$80");
  tasm.adda("#8");
  tasm.beq("_set");
  tasm.label("_nxtbit");
  tasm.lsrb();
  tasm.deca();
  tasm.bne("_nxtbit");

  tasm.label("_set");
  tasm.orab(",x");
  tasm.stab(",x");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdSqr() {
  Assembler tasm;
  tasm.comment("X = SQR(X)");
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("  EXIT   Y = SQRT(X) in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         Ysq   ( 5,x  6,x  7,x  8,x  9,x)");
  tasm.comment("         Yd    (10,x 11,x 12,x 13,x 14,x)");
  tasm.comment("         bit   (15,x 16,x 17,x 18,x 19,x)");
  tasm.comment("         bitsq (20,x 21,x 22,x 23,x 24,x)");
  tasm.comment("         uses argv for radicand and tmp1-tmp4");
  tasm.label("sqr");

  tasm.jsr("msbit");
  tasm.cmpa("#40");
  tasm.bne("_chkpos");
  tasm.rts(); // return zero if zero

  tasm.label("_chkpos");  // if returned MSB is 0,
  tasm.tsta();            // argument is negative
  tasm.bne("_pos");       // bail out with
  tasm.ldab("#FC_ERROR"); // a function call error
  tasm.jmp("error");

  tasm.label("_pos");
  tasm.staa("tmp1"); // save MSB
  tasm.stx("tmp4");  // save X
  tasm.jsr("x2arg"); // store radicand in argv

  // clear 0,x through 24,x
  tasm.ldab("#12");
  tasm.stab("tmp1+1");
  tasm.ldd("#0");

  tasm.label("_clrx");
  tasm.std(",x");
  tasm.inx();
  tasm.inx();
  tasm.dec("tmp1+1"); // sqrt ( x * 65536 ) = 256 * sqrt ( x )
  tasm.bne("_clrx");
  tasm.std("tmp2");
  tasm.std("tmp3");

  // 01234567 89ABCDEF GHIJKLMN OPQRSTUV WXYZabcd
  //  C D E F  G H I J  K L M N  O P Q R  S T U V
  tasm.incomment("setup bitsq");
  tasm.ldx("tmp4");
  tasm.ldab("#20"); // load X to bitsq
  tasm.abx();
  tasm.ldaa("tmp1"); // restore MSB
  tasm.oraa("#1");   // force to odd bit
  tasm.jsr("setbit");
  tasm.incomment("setup bit");
  tasm.ldx("tmp4"); // load X to bit
  tasm.ldab("#15");
  tasm.abx();
  tasm.ldaa("tmp1"); // restore MSB
  tasm.lsra();       // set sqrt bit
  tasm.adda("#12");
  tasm.jsr("setbit");
  tasm.ldx("tmp4");

  tasm.incomment("tmp = ysq + (yd=2*ysq*bitsq) + bitsq");
  tasm.label("_loop");
  tasm.ldd("23,x");
  tasm.addd("13,x");
  tasm.rol("tmp1");
  tasm.addd("8,x");
  tasm.std("tmp3");
  tasm.ldaa("tmp1");
  tasm.ldab("22,x");
  tasm.adcb("12,x");
  tasm.rora();
  tasm.adcb("7,x");
  tasm.stab("tmp2+1");
  tasm.ldab("21,x");
  tasm.adcb("11,x");
  tasm.rola();
  tasm.adcb("6,x");
  tasm.stab("tmp2");
  tasm.ldab("20,x");
  tasm.adcb("10,x");
  tasm.rora();
  tasm.adcb("5,x");
  tasm.stab("tmp1+1");

  tasm.incomment("see if tmp <= x");
  tasm.subb("0+argv");
  tasm.bhi("_nogood");
  tasm.blo("_good");
  tasm.ldd("tmp2");
  tasm.subd("1+argv");
  tasm.bhi("_nogood");
  tasm.blo("_good");
  tasm.ldd("tmp3");
  tasm.subd("3+argv");
  tasm.bhi("_nogood");

  tasm.label("_good");
  tasm.incomment("ysq = tmp");
  tasm.ldd("tmp3");
  tasm.std("8,x");
  tasm.ldd("tmp2");
  tasm.std("6,x");
  tasm.ldab("tmp1+1");
  tasm.stab("5,x");
  tasm.incomment("y += bit");
  tasm.ldd("3,x");
  tasm.addd("18,x");
  tasm.std("3,x");
  tasm.ldd("1,x");
  tasm.adcb("17,x");
  tasm.adca("16,x");
  tasm.std("1,x");
  tasm.ldab("0,x");
  tasm.adcb("15,x");
  tasm.stab("0,x");
  tasm.incomment("yd = (yd + 2*bitsq)/2");
  tasm.lsr("10,x");
  tasm.ror("11,x");
  tasm.ror("12,x");
  tasm.ldd("13,x");
  tasm.rora();
  tasm.rorb();
  tasm.addd("23,x");
  tasm.std("13,x");
  tasm.ldd("11,x");
  tasm.adcb("22,x");
  tasm.adca("21,x");
  tasm.std("11,x");
  tasm.ldab("10,x");
  tasm.adcb("20,x");
  tasm.stab("10,x");
  tasm.bra("_shift");
  tasm.label("_nogood");
  tasm.incomment("yd = yd/2");
  tasm.lsr("10,x");
  tasm.ror("11,x");
  tasm.ror("12,x");
  tasm.ror("13,x");
  tasm.ror("14,x");
  tasm.label("_shift");
  tasm.incomment("bitsq /= 4");
  tasm.lsr("20,x");
  tasm.ror("21,x");
  tasm.ror("22,x");
  tasm.ror("23,x");
  tasm.ror("24,x");
  tasm.lsr("20,x");
  tasm.ror("21,x");
  tasm.ror("22,x");
  tasm.ror("23,x");
  tasm.ror("24,x");
  tasm.incomment("bit /= 2");
  tasm.lsr("15,x");
  tasm.ror("16,x");
  tasm.ror("17,x");
  tasm.ror("18,x");
  tasm.ror("19,x");
  tasm.incomment("loop while bit exists");
  tasm.bne("_jloop");
  tasm.ldd("17,x");
  tasm.bne("_jloop");
  tasm.ldd("15,x");
  tasm.bne("_jloop");
  tasm.rts();
  tasm.label("_jloop");
  tasm.jmp("_loop");

  return tasm.source();
}

std::string Library::mdRMul315() {
  Assembler tasm;

  tasm.comment("special routine to divide by 5040 or 40320");
  tasm.comment("  (reciprocal-multiply by 315 and shifting)");
  tasm.comment("              1/5040 = 256/315 >> 16");
  tasm.comment("             1/40320 = 128/315 >> 16");
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("         0DD0 or A11A in ACCD");
  tasm.comment("  EXIT   result in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         result ~= X/5040 when D is $0DD0");
  tasm.comment("         result ~= X/40320 when D is $A11A");
  tasm.comment("         uses argv and tmp1-tmp4 (tmp4+1 unused)");
  tasm.label("rmul315"); // 1 /  5040 ~= 13.003174/65536
  tasm.stab("4+argv");   //              ($0D.00D0/$10000)
  tasm.tab();            //
  tasm.anda("#$0f");     // 1 / 40320 ~= 1.625397/65536
  tasm.andb("#$f0");     //              ($01.A01A)
  tasm.std("2+argv");    // Since:
  tasm.ldd("#0");        // ACCA = 16*C + D  (C=$A or $0)
  tasm.std("0+argv");    // ACCB = 16*D + C  (D=$1 or $D)
  tasm.jsr("mulfltx");   // divisor is:  (00)(00)(0D).(C0)(DC)
  tasm.ldd("1,x");       //
  tasm.std("3,x");       // Then perform /65536 by shifting
  tasm.ldab("0,x");      // result "down" by two bytes.
  tasm.stab("2,x");
  tasm.ldd("#0");
  tasm.std("0,x");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdExp() {
  Assembler tasm;

  tasm.label("exp");
  tasm.comment("X = EXP(X)");
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("  EXIT   EXP(X) in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         uses argv and tmp1-tmp4 (tmp4+1 unused)");

  tasm.ldd("#exp_max"); // compare against
  tasm.bsr("dd2argv");  // log(2^23-1)

  tasm.bsr("cmpxa");      // bmi safeguards against
  tasm.bmi("_ok");        // sbcb #0 when ACCB is
  tasm.ble("_ok");        // zero and input carry set
  tasm.ldab("#OV_ERROR"); //
  tasm.jmp("error");      // set error if too big
  tasm.label("_ok");
  tasm.ldd("#exp_min"); // compare against
  tasm.bsr("dd2argv");  // log(2^-16)
  tasm.bsr("cmpxa");
  tasm.bge("_go");
  tasm.ldd("#0"); // too small
  tasm.std("3,x");
  tasm.std("1,x");
  tasm.stab("0,x");
  tasm.rts();

  tasm.label("cmpxa");
  tasm.ldd("3,x");
  tasm.subd("3+argv");
  tasm.ldd("1,x");
  tasm.sbcb("2+argv");
  tasm.sbca("1+argv");
  tasm.ldab("0,x");
  tasm.sbcb("0+argv");
  tasm.rts();

  tasm.label("dd2argv");
  tasm.pshx();
  tasm.pshb();
  tasm.psha();
  tasm.pulx();
  tasm.ldab("0,x");
  tasm.stab("0+argv");
  tasm.ldd("1,x");
  tasm.std("1+argv");
  tasm.ldd("3,x");
  tasm.std("3+argv");
  tasm.pulx();
  tasm.rts();

  tasm.label("_go");
  tasm.ldd("#exp_ln2"); // perform
  tasm.bsr("dd2argv");  // modulo log(2)
  tasm.jsr("modflt");

  tasm.ldab("9,x"); // save int(x/ln(2))
  tasm.pshb();

  // copy x to arg.  should this be a mini routine?
  tasm.ldab("0,x");
  tasm.stab("0+argv");
  tasm.ldd("1,x");
  tasm.std("1+argv");
  tasm.ldd("3,x");
  tasm.std("3+argv");

  tasm.ldd("#8");
  tasm.bsr("_addd");
  tasm.ldd("#56");
  tasm.bsr("_mac");
  tasm.ldd("#336");
  tasm.bsr("_mac");
  tasm.ldd("#1680");
  tasm.bsr("_mac");
  tasm.ldd("#6720");
  tasm.bsr("_mac");
  tasm.ldd("#20160");
  tasm.bsr("_mac");
  tasm.ldd("#40320");
  tasm.bsr("_mac");
  tasm.ldd("#40320");
  tasm.bsr("_mac");

  // divide by 5040
  tasm.ldd("#$A11A");
  tasm.jsr("rmul315");

  tasm.pulb();       // restore quotient
  tasm.jmp("shift"); // and shift by result

  tasm.label("_mac");
  tasm.pshb();
  tasm.psha();
  tasm.jsr("mulfltx");
  tasm.pula();
  tasm.pulb();

  tasm.label("_addd");
  tasm.addd("1,x");
  tasm.std("1,x");
  tasm.ldab("0,x");
  tasm.adcb("#0");
  tasm.stab("0,x");
  tasm.label("_rts");
  tasm.rts();

  tasm.labelByte("exp_max", "$00,$00,$0F,$F1,$3E");
  tasm.labelByte("exp_min", "$FF,$FF,$F4,$E8,$DE");
  tasm.labelByte("exp_ln2", "$00,$00,$00,$B1,$72");

  return tasm.source();
}

std::string Library::mdLog() {
  Assembler tasm;
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("  EXIT   Y=LOG(X) in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses (5,x 6,x 7,x 8,x 9,x) as tmp storage for X");
  tasm.comment("         uses argv and tmp1-tmp4 (tmp4+1 unused)");

  tasm.label("log");
  tasm.ldd("0,x");     // check for high values
  tasm.subd("#$7fff"); //
  tasm.bne("_normal"); // EXP(X) implementation won't reach +8388607
  tasm.ldab("#1");     // so divide by two, take log
  tasm.jsr("shrflt");  // then add ln(2).
  tasm.bsr("_normal");
  tasm.ldd("3,x");
  tasm.addd("#$B172");
  tasm.std("3,x");
  tasm.ldab("2,x");
  tasm.adcb("#0");
  tasm.stab("2,x");
  tasm.rts();

  tasm.label("_normal");
  tasm.jsr("msbit"); // load A with MSB
  tasm.tsta();
  tasm.beq("_fcerror");
  tasm.cmpa("#40");
  tasm.bne("_ok");
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");

  tasm.label("_ok");
  tasm.nega();      // record bit position
  tasm.adda("#40"); // of MSB (0=lsb,40=sign bit)
  tasm.staa("tmp1");
  tasm.ldab("#$DE"); // compute MSB*ln(2)
  tasm.mul();
  tasm.std("8,x");
  tasm.ldaa("tmp1");
  tasm.ldab("#$B1");
  tasm.mul();
  tasm.addb("8,x");
  tasm.adca("#0");
  tasm.std("7,x");

  tasm.ldd("8,x"); // subtract 16*ln(2)
  tasm.subd("#$1720");
  tasm.std("8,x");
  tasm.ldab("7,x");
  tasm.sbcb("#$0B");
  tasm.stab("7,x");
  tasm.ldaa("#0"); // sign extend
  tasm.sbca("#0");
  tasm.tab();
  tasm.std("5,x");

  tasm.label("_newton");
  tasm.pshx();
  tasm.ldab("#5");
  tasm.abx();
  tasm.ldd("exp_max");
  tasm.jsr("dd2argv");
  tasm.jsr("cmpxa");
  tasm.bmi("_go");
  tasm.ble("_go");
  tasm.jsr("arg2x");

  tasm.label("_go");
  tasm.ldab("0,x"); // Z = X
  tasm.stab("5,x");
  tasm.ldd("1,x");
  tasm.std("6,x");
  tasm.ldd("3,x");
  tasm.std("8,x");

  tasm.ldab("#5");
  tasm.abx();
  tasm.jsr("exp");   // Z = EXP(Z)
  tasm.jsr("x2arg"); // argv = Z
  tasm.pulx();
  tasm.ldab("0,x"); // Z = X
  tasm.stab("10,x");
  tasm.ldd("1,x");
  tasm.std("11,x");
  tasm.ldd("3,x");
  tasm.std("13,x");
  tasm.pshx();
  tasm.ldab("#10");
  tasm.abx();
  tasm.jsr("divflt"); // Z = X/Z
  tasm.pulx();
  tasm.ldd("11,x"); // Z -= 1
  tasm.subd("#1");
  tasm.std("11,x");
  tasm.ldab("10,x");
  tasm.sbcb("#0");
  tasm.stab("10,x");
  tasm.bne("_again"); // is result zero?
  tasm.ldd("11,x");
  tasm.bne("_again");
  tasm.ldd("13,x");
  tasm.beq("_done");

  tasm.label("_again");
  tasm.ldd("13,x"); // Y += Z;
  tasm.addd("8,x");
  tasm.std("8,x");
  tasm.ldd("11,x");
  tasm.adcb("7,x");
  tasm.adca("6,x");
  tasm.std("6,x");
  tasm.ldab("10,x");
  tasm.adcb("5,x");
  tasm.stab("5,x");
  tasm.bra("_newton");

  tasm.label("_done");
  tasm.ldab("5,x"); // copy Y
  tasm.stab("0,x");
  tasm.ldd("6,x");
  tasm.std("1,x");
  tasm.ldd("8,x");
  tasm.std("3,x");
  tasm.rts();

  return tasm.source();
}

std::string Library::mdPowFlt() {
  Assembler tasm;
  // X^ARGV, result in X.
  tasm.label("powfltx");
  tasm.ldd("3+argv");
  tasm.pshb();
  tasm.psha();
  tasm.ldd("1+argv");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("0+argv");
  tasm.pshb();
  tasm.jsr("log");
  tasm.pulb();
  tasm.stab("0+argv");
  tasm.pula();
  tasm.pulb();
  tasm.std("1+argv");
  tasm.pula();
  tasm.pulb();
  tasm.std("3+argv");
  tasm.jsr("mulfltx");
  tasm.jmp("exp");
  return tasm.source();
}

std::string Library::mdSin() const {
  Assembler tasm;

  tasm.comment("X = SIN(X)");
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("  EXIT   SIN(X) in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         uses argv and tmp1-tmp4 (tmp4+1 unused)");
  tasm.label("sin");
  tasm.tst("0,x");     // is arg positive?
  tasm.bpl("_sinpos"); //   go if so
  tasm.jsr("negx");    // otherwise
  tasm.bsr("_sinpos"); //   return -sin(-x)
  tasm.jmp("negx");

  // sin of positive x
  tasm.label("_sinpos");
  tasm.ldd("#0"); // compute arg mod 2 pi
  tasm.std("0+argv");
  tasm.ldab("#$6");
  tasm.stab("2+argv"); // although $06.487F is closer to $06.487ED5
  tasm.ldd("#$487F");  // users often use multiples of pi (not 2pi)
  tasm.std("3+argv");  // pi rounds down to $03.243F, so twice that
  tasm.jsr("modflt");  // is $06.487E.

  tasm.jsr("x2arg");
  tasm.stx("tmp1");
  tasm.ldx("#_tbl_pi1"); // if arg < pi
  tasm.bsr("_cmptbl");
  tasm.blo("_q12");    // do quad_12
  tasm.bsr("_subtbl"); // else do -sin(arg-pi)
  tasm.bsr("_q12");
  tasm.jmp("negx");

  tasm.label("_q12");
  tasm.ldx("#_tbl_pi2"); // is arg < pi/2
  tasm.bsr("_cmptbl");
  tasm.blo("_q1");
  tasm.ldx("#_tbl_pi1");
  tasm.bsr("_rsubtbl"); // else do sin(pi-arg)

  tasm.label("_q1"); // if argv < pi/4
  tasm.ldx("#_tbl_pi4");
  tasm.bsr("_cmptbl");
  tasm.blo("_sin");
  tasm.ldx("#_tbl_pi2"); // else do cos(pi/2-arg)
  tasm.bsr("_rsubtbl");
  tasm.jmp("_cos");

  tasm.incomment("compare argv with *x");
  tasm.label("_cmptbl");
  tasm.ldd("2+argv");
  tasm.subd(",x");
  tasm.bne("_rts");
  tasm.ldab("4+argv");
  tasm.subb("2,x");
  tasm.label("_rts");
  tasm.rts();

  tasm.incomment("subtract *x from argv");
  tasm.label("_subtbl");
  tasm.ldd("3+argv");
  tasm.subd("1,x");
  tasm.std("3+argv");
  tasm.ldab("2+argv");
  tasm.sbcb("0,x");
  tasm.stab("2+argv");
  tasm.rts();

  tasm.incomment("subtract *x from argv then negate");
  tasm.label("_rsubtbl");
  tasm.ldd("1,x");
  tasm.subd("3+argv");
  tasm.std("3+argv");
  tasm.ldab("0,x");
  tasm.sbcb("2+argv");
  tasm.stab("2+argv");
  tasm.rts();

  tasm.incomment("sin of angle less than pi/4");
  tasm.label("_sin");
  tasm.ldx("tmp1");
  tasm.jsr("arg2x");
  tasm.ldd("3,x");
  tasm.pshb();
  tasm.psha();
  tasm.jsr("mulfltx");
  tasm.jsr("x2arg");
  tasm.ldd("#42");
  tasm.bsr("_rsubm");
  tasm.ldd("#840");
  tasm.bsr("_rsubm");
  tasm.ldd("#5040");
  tasm.bsr("_rsub");
  tasm.pula();
  tasm.pulb();
  tasm.std("3+argv");
  tasm.jsr("mulfltx");
  tasm.ldd("#$0DD0");
  tasm.jmp("rmul315");

  tasm.incomment("cos of angle less than pi/4");
  tasm.label("_cos");
  tasm.ldx("tmp1");
  tasm.jsr("arg2x");
  tasm.jsr("mulfltx"); // square X
  tasm.jsr("x2arg");   // save in multiplicand
  tasm.ldd("#56");
  tasm.bsr("_rsubm");
  tasm.ldd("#1680");
  tasm.bsr("_rsubm");
  tasm.ldd("#20160");
  tasm.bsr("_rsubm");
  tasm.ldd("#40320");
  tasm.bsr("_rsub");
  tasm.ldd("#$A11A");
  tasm.jmp("rmul315");

  tasm.label("_rsubm");
  tasm.bsr("_rsub");
  tasm.jmp("mulfltx");

  tasm.label("_rsub");
  tasm.neg("4,x");
  if (undoc) {
    tasm.ngc("3,x");
  } else {
    tasm.bcs("_ngc1");
    tasm.neg("3,x");
    tasm.bra("_ngc2");
    tasm.label("_ngc1");
    tasm.com("3,x");
    tasm.label("_ngc2");
  }
  tasm.sbcb("2,x");
  tasm.sbca("1,x");
  tasm.std("1,x");
  if (undoc) {
    tasm.ngc("0,x");
  } else {
    tasm.bcs("_ngc3");
    tasm.neg("0,x");
    tasm.rts();
    tasm.label("_ngc3");
    tasm.com("0,x");
  }
  tasm.rts();

  tasm.labelByte("_tbl_pi1", "$03,$24,$40");
  tasm.labelByte("_tbl_pi2", "$01,$92,$20");
  tasm.labelByte("_tbl_pi4", "$00,$C9,$10");
  return tasm.source();
}

std::string Library::mdCos() {
  Assembler tasm;
  tasm.comment("X = COS(X)");
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("  EXIT   COS(X) in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         uses argv and tmp1-tmp4");
  tasm.label("cos");
  tasm.ldd("3,x");
  tasm.addd("#$9220");
  tasm.std("3,x");
  tasm.ldd("1,x");
  tasm.adcb("#$1");
  tasm.adca("#0");
  tasm.std("1,x");
  tasm.ldab("0,x");
  tasm.adcb("#0");
  tasm.stab("0,x");
  tasm.jmp("sin");
  return tasm.source();
}

std::string Library::mdTan() {
  Assembler tasm;
  tasm.comment("X = TAN(X)");
  tasm.comment("  ENTRY  X in 0,X 1,X 2,X 3,X 4,X");
  tasm.comment("  EXIT   TAN(X) in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses ( 5,x  6,x  7,x  8,x  9,x)");
  tasm.comment("         uses (10,x 11,x 12,x 13,x 14,x)");
  tasm.comment("         uses argv and tmp1-tmp4");
  tasm.label("tan");
  tasm.ldd("3,x");
  tasm.pshb();
  tasm.psha();
  tasm.ldd("1,x");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("0,x");
  tasm.pshb();
  tasm.jsr("sin");
  tasm.pulb();
  tasm.stab("5,x");
  tasm.pula();
  tasm.pulb();
  tasm.std("6,x");
  tasm.pula();
  tasm.pulb();
  tasm.std("8,x");
  tasm.pshx();
  tasm.ldab("#5");
  tasm.abx();
  tasm.jsr("cos");
  tasm.ldab("0,x");
  tasm.stab("0+argv");
  tasm.ldd("1,x");
  tasm.std("1+argv");
  tasm.ldd("3,x");
  tasm.std("3+argv");
  tasm.pulx();
  tasm.jmp("divflt");
  return tasm.source();
}

std::string Library::mdPrAt() {
  Assembler tasm;
  tasm.label("prat");
  tasm.bita("#$FE");
  tasm.bne("_fcerror");
  tasm.anda("#$01");
  tasm.oraa("#$40");
  tasm.std("M_CRSR");
  tasm.rts();
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string Library::mdPrint() {
  Assembler tasm;
  tasm.label("print");
  tasm.label("_loop");
  tasm.ldaa(",x");
  tasm.jsr("R_PUTC");
  tasm.inx();
  tasm.decb();
  tasm.bne("_loop");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdPrTab() {
  Assembler tasm;
  tasm.label("prtab");
  tasm.jsr("R_MKTAB"); // modifies DP_TABW-DP_LWID
  tasm.subb("DP_LPOS");
  tasm.bls("_rts");
  tasm.label("_again");
  tasm.jsr("R_SPACE");
  tasm.decb();
  tasm.bne("_again");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdSet() {
  Assembler tasm;
  tasm.comment("set pixel with existing color");
  tasm.comment("ENTRY: ACCA holds X, ACCB holds Y");
  tasm.label("set");
  tasm.bsr("getxym");
  tasm.ldab(",x");
  tasm.bmi("doset");
  tasm.clrb();

  tasm.label("doset");
  tasm.andb("#$70");
  tasm.ldaa("$82");
  tasm.psha();
  tasm.stab("$82");
  tasm.jsr("R_SETPX");
  tasm.pula();
  tasm.staa("$82");
  tasm.rts();

  tasm.label("getxym");
  tasm.anda("#$1f");
  tasm.andb("#$3f");
  tasm.pshb();
  tasm.tab();
  tasm.jmp("R_MSKPX");
  return tasm.source();
}

std::string Library::mdSetC() {
  Assembler tasm;
  tasm.comment("set pixel with color");
  tasm.comment("ENTRY: X holds byte-to-modify, ACCB holds color");
  tasm.label("setc");

  tasm.decb();
  tasm.bmi("_loadc");
  tasm.lslb();
  tasm.lslb();
  tasm.lslb();
  tasm.lslb();
  tasm.bra("_ok");

  tasm.label("_loadc");
  tasm.ldab(",x");
  tasm.bmi("_ok");
  tasm.clrb();

  tasm.label("_ok");
  tasm.bra("doset");

  return tasm.source();
}

std::string Library::mdPoint() {
  Assembler tasm;
  tasm.comment("get pixel color");
  tasm.comment("ENTRY: ACCA holds X, ACCB holds Y");
  tasm.comment("EXIT: ACCD holds color");
  tasm.label("point");

  tasm.jsr("getxym");
  tasm.ldab(",x");
  tasm.bpl("_text");
  tasm.clra();
  tasm.bitb("M_PMSK");
  tasm.beq("_unset");
  tasm.andb("#$70");
  tasm.lsrb();
  tasm.lsrb();
  tasm.lsrb();
  tasm.lsrb();
  tasm.incb();
  tasm.rts();

  tasm.label("_text");
  tasm.ldd("#-1");
  tasm.rts();

  tasm.label("_unset");
  tasm.tab();
  tasm.rts();

  return tasm.source();
}

std::string Library::mdPeek() {
  Assembler tasm;
  tasm.comment("perform PEEK(X), emulating keypolling");
  tasm.comment("  ENTRY: X holds storage byte");
  tasm.comment("  EXIT:  ACCB holds peeked byte");
  tasm.label("peek");
  tasm.cpx("#M_KBUF");
  tasm.blo("_peek");
  tasm.cpx("#M_IKEY");
  tasm.bhi("_peek");
  tasm.beq("_poll");
  tasm.cpx("#M_KBUF+7");
  tasm.bhi("_peek");
  tasm.label("_poll");
  tasm.jsr("R_KPOLL");
  tasm.beq("_peek");
  tasm.staa("M_IKEY");
  tasm.label("_peek");
  tasm.ldab(",x");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetEq() {
  Assembler tasm;
  tasm.label("geteq");
  tasm.beq("_1");
  tasm.ldd("#0");
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetNe() {
  Assembler tasm;
  tasm.label("getne");
  tasm.bne("_1");
  tasm.ldd("#0");
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetLo() {
  Assembler tasm;
  tasm.label("getlo");
  tasm.blo("_1");
  tasm.ldd("#0");
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetHs() {
  Assembler tasm;
  tasm.label("geths");
  tasm.bhs("_1");
  tasm.ldd("#0");
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetLt() {
  Assembler tasm;
  tasm.label("getlt");
  tasm.blt("_1");
  tasm.ldd("#0");
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdGetGe() {
  Assembler tasm;
  tasm.label("getge");
  tasm.bge("_1");
  tasm.ldd("#0");
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdInput() {
  Assembler tasm;
  tasm.label("inputqqs");
  tasm.jsr("R_QUEST");
  tasm.label("inputqs");
  tasm.jsr("R_QUEST");
  tasm.jsr("R_SPACE");
  tasm.jsr("R_GETLN"); // this will clobber input buffer.  so if
                       // EXEC is called it'll bomb...
  tasm.ldaa("#','");
  tasm.staa(",x");
  tasm.label("_done");
  tasm.stx("inptptr");
  tasm.rts();

  tasm.label("rdinit");
  tasm.ldx("inptptr");
  tasm.ldaa(",x");
  tasm.inx();
  tasm.cmpa("#','");
  tasm.beq("_skpspc");
  tasm.jsr("inputqqs");
  tasm.bra("rdinit");
  tasm.label("_skpspc");
  tasm.ldaa(",x");
  tasm.cmpa("#' '");
  tasm.bne("_done");
  tasm.inx();
  tasm.bra("_skpspc");

  tasm.label("rdredo");
  tasm.ldx("inptptr");
  tasm.bsr("_skpspc");
  tasm.tsta();
  tasm.beq("_rts");
  tasm.cmpa("#','");
  tasm.beq("_rts");
  tasm.ldx("#R_REDO"); // ?REDO
  tasm.ldab("#6");
  tasm.jsr("print");
  tasm.ldx("redoptr");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdPUByte() {
  Assembler tasm;
  tasm.comment("read DATA when records are purely unsigned bytes");
  tasm.comment("EXIT:  int in tmp1+1 and tmp2");
  tasm.label("rpubyte");
  tasm.pshx();
  tasm.ldx("DP_DATA");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldaa(",x");
  tasm.inx();
  tasm.stx("DP_DATA");
  tasm.staa("tmp2+1");
  tasm.ldd("#0");
  tasm.std("tmp1+1");
  tasm.std("tmp3");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdPSByte() {
  Assembler tasm;
  tasm.comment("read DATA when records are purely signed bytes");
  tasm.comment("EXIT:  flt in tmp1+1, tmp2, tmp3");
  tasm.label("rpsbyte");
  tasm.pshx();
  tasm.ldx("DP_DATA");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldaa(",x");
  tasm.inx();
  tasm.stx("DP_DATA");
  tasm.staa("tmp2+1");
  tasm.clrb();
  tasm.stab("tmp3");
  tasm.stab("tmp3+1");
  tasm.lsla();
  tasm.sbcb("#0");
  tasm.tba();
  tasm.std("tmp1+1");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdPUWord() {
  Assembler tasm;
  tasm.comment("read DATA when records are purely unsigned words");
  tasm.comment("EXIT:  flt in tmp1+1, tmp2, tmp3");
  tasm.label("rpuword");
  tasm.pshx();
  tasm.ldx("DP_DATA");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd(",x");
  tasm.inx();
  tasm.inx();
  tasm.stx("DP_DATA");
  tasm.std("tmp2");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.stab("tmp1+1");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdPSWord() {
  Assembler tasm;
  tasm.comment("read DATA when records are purely signed words");
  tasm.comment("EXIT:  flt in tmp1+1, tmp2, tmp3");
  tasm.label("rpsword");
  tasm.pshx();
  tasm.ldx("DP_DATA");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd(",x");
  tasm.inx();
  tasm.inx();
  tasm.stx("DP_DATA");
  tasm.std("tmp2");
  tasm.clrb();
  tasm.stab("tmp3");
  tasm.stab("tmp3+1");
  tasm.lsla();
  tasm.sbcb("#0");
  tasm.stab("tmp1+1");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdPNumbr() {
  Assembler tasm;
  tasm.comment("read DATA when records are pure numbers");
  tasm.comment("EXIT:  flt in tmp1+1, tmp2, tmp3");
  tasm.label("rpnumbr");
  tasm.pshx();
  tasm.ldx("DP_DATA");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldab(",x");
  tasm.stab("tmp1+1");
  tasm.ldd("1,x");
  tasm.std("tmp2");
  tasm.ldd("3,x");
  tasm.std("tmp3");
  tasm.ldab("#5");
  tasm.abx();
  tasm.stx("DP_DATA");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdPStrng() {
  Assembler tasm;
  tasm.comment("read string DATA when records are pure strings");
  tasm.comment("EXIT:  data string descriptor in tmp1+1, tmp2");
  tasm.label("rpstrng");
  tasm.pshx();
  tasm.ldx("DP_DATA");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldab(",x");
  tasm.stab("tmp1+1");
  tasm.inx();
  tasm.stx("tmp2");
  tasm.abx();
  tasm.stx("DP_DATA");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdSUByte() {
  Assembler tasm;
  tasm.comment("read string DATA when records are pure unsigned bytes");
  tasm.comment("ENTRY: X holds destination string descriptor");
  tasm.comment("EXIT:  data table read, and perm string created in X");
  tasm.label("rsubyte");
  tasm.jsr("strdel");
  tasm.jsr("rpubyte");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std("1+argv");
  tasm.ldab("tmp1");
  tasm.stab("0+argv");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string Library::mdRdSSByte() {
  Assembler tasm;
  tasm.comment("read string DATA when records are pure signed bytes");
  tasm.comment("ENTRY: X holds destination string descriptor");
  tasm.comment("EXIT:  data table read, and perm string created in X");
  tasm.label("rssbyte");
  tasm.jsr("strdel");
  tasm.jsr("rpsbyte");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std("1+argv");
  tasm.ldab("tmp1");
  tasm.stab("0+argv");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string Library::mdRdSUWord() {
  Assembler tasm;
  tasm.comment("read string DATA when records are pure unsigned words");
  tasm.comment("ENTRY: X holds destination string descriptor");
  tasm.comment("EXIT:  data table read, and perm string created in X");
  tasm.label("rsuword");
  tasm.jsr("strdel");
  tasm.jsr("rpuword");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std("1+argv");
  tasm.ldab("tmp1");
  tasm.stab("0+argv");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string Library::mdRdSSWord() {
  Assembler tasm;
  tasm.comment("read string DATA when records are pure signed words");
  tasm.comment("ENTRY: X holds destination string descriptor");
  tasm.comment("EXIT:  data table read, and perm string created in X");
  tasm.label("rssword");
  tasm.jsr("strdel");
  tasm.jsr("rpsword");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std("1+argv");
  tasm.ldab("tmp1");
  tasm.stab("0+argv");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string Library::mdRdSNumbr() {
  Assembler tasm;
  tasm.comment("read string DATA when records are pure numbers");
  tasm.comment("ENTRY: X holds destination string descriptor");
  tasm.comment("EXIT:  data table read, and perm string created in X");
  tasm.label("rsnumbr");
  tasm.jsr("strdel");
  tasm.jsr("rpnumbr");
  tasm.jsr("strflt");
  tasm.std("1+argv");
  tasm.ldab("tmp1");
  tasm.stab("0+argv");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string Library::mdRdSStrng() {
  Assembler tasm;
  tasm.comment("read string DATA when records are pure strings");
  tasm.comment("ENTRY: X holds destination string descriptor");
  tasm.comment("EXIT:  data table read, and perm string created in X");
  tasm.label("rsstrng");
  tasm.jsr("strdel");
  tasm.jsr("rpstrng"); // tmp1+1 holds str dec, tmp2 holds loc
  tasm.ldab("tmp1+1");
  tasm.stab("0,X");
  tasm.ldd("tmp2");
  tasm.std("1,X"); // no need to make perm. data strings are static
  tasm.rts();
  return tasm.source();
}

std::string Library::mdRdNStrng() {
  Assembler tasm;
  tasm.comment("read numeric DATA when records are pure strings");
  tasm.comment("EXIT:  flt in tmp1+1, tmp2, tmp3");
  tasm.label("rnstrng");
  tasm.pshx();
  tasm.jsr("rpstrng"); // get string desc in tmp1+1, tmp2.
  tasm.ldx("#tmp1+1"); // strval reads bytecount and address
                       // before clobbering tmp1+1 and tmp2.
  tasm.jsr("strval");  // it also calls strrel but should have no effect
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string Library::mdTo(bool byteCode, bool genLines) {
  Assembler tasm;
  tasm.comment("push for-loop record on stack");
  tasm.comment("ENTRY:  ACCB  contains size of record");
  tasm.comment("        r1    contains stopping variable");
  tasm.comment("              and is always fixedpoint.");
  tasm.comment("        r1+3  must contain zero when both:");
  tasm.comment("              1. loop var is integral.");
  tasm.comment("              2. STEP is missing");
  tasm.label("to");
  tasm.clra();
  tasm.std("tmp3");
  tasm.pulx();
  tasm.stx("tmp1");
  tasm.tsx();
  tasm.clrb();
  tasm.label("_nxtfor");
  tasm.abx();
  tasm.ldd("1,x");
  tasm.subd("letptr");
  tasm.beq("_oldfor");
  tasm.ldab(",x");
  tasm.cmpb("#" + std::to_string(genLines ? 5 : 3));
  tasm.bhi("_nxtfor");
  tasm.sts("tmp2");
  tasm.ldd("tmp2");
  tasm.subd("tmp3"); // #11 or #15; #13 or #17 when generating lines
  tasm.std("tmp2");
  tasm.lds("tmp2");
  tasm.tsx();
  tasm.ldab("tmp3+1");
  tasm.stab("0,x");
  tasm.ldd("letptr");
  tasm.std("1,x");
  tasm.label("_oldfor");
  tasm.ldd(byteCode ? "nxtinst" : "tmp1");
  tasm.std("3,x");
  tasm.ldab("r1"); // reg1 assumed
  tasm.stab("5,x");
  tasm.ldd("r1+1");
  tasm.std("6,x");
  tasm.ldd("r1+3"); // will be zero for pure int.
  tasm.std("8,x");  // frac or sbyte+hbyte of increment
  tasm.ldab("tmp3+1");
  tasm.cmpb("#" + std::to_string(genLines ? 17 : 15));
  tasm.beq("_flt");
  tasm.inca();
  tasm.staa("10,x");
  if (genLines) {
    tasm.ldd("DP_LNUM");
    tasm.std("11,x");
  }
  tasm.bra("_done");
  tasm.label("_flt");
  tasm.ldd("#0");
  tasm.std("10,x");
  tasm.std("13,x");
  tasm.inca();
  tasm.staa("12,x");
  if (genLines) {
    tasm.ldd("DP_LNUM");
    tasm.std("13,x");
  }
  tasm.label("_done");
  tasm.ldx("tmp1");
  tasm.jmp(",x");
  return tasm.source();
}

std::string Library::mdToNative() {
  bool byteCode = false;
  bool genLines = false;
  return mdTo(byteCode, genLines);
}

std::string Library::mdToNativeGenLines() {
  bool byteCode = false;
  bool genLines = true;
  return mdTo(byteCode, genLines);
}

std::string Library::mdToByteCode() {
  bool byteCode = true;
  bool genLines = false;
  return mdTo(byteCode, genLines);
}

std::string Library::mdToByteCodeGenLines() {
  bool byteCode = true;
  bool genLines = true;
  return mdTo(byteCode, genLines);
}

std::string Library::mdByteCode() {
  Assembler tasm;

  tasm.label("noargs");
  tasm.ldx("curinst");
  tasm.inx();
  tasm.stx("nxtinst");
  tasm.rts();

  tasm.label("extend");
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.inx();
  tasm.stx("nxtinst");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.rts();

  tasm.label("getaddr");
  tasm.ldd("curinst");
  tasm.addd("#3");
  tasm.std("nxtinst");
  tasm.ldx("curinst");
  tasm.ldx("1,x");
  tasm.rts();

  tasm.label("getbyte");
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.inx();
  tasm.stx("nxtinst");
  tasm.rts();

  tasm.label("getword");
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldd(",x");
  tasm.inx();
  tasm.inx();
  tasm.stx("nxtinst");
  tasm.rts();

  tasm.label("extbyte");
  tasm.ldd("curinst");
  tasm.addd("#3");
  tasm.std("nxtinst");
  tasm.ldx("curinst");
  tasm.ldab("2,x");
  tasm.pshb();
  tasm.ldab("1,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.pulb();
  tasm.rts();

  tasm.label("extword");
  tasm.ldd("curinst");
  tasm.addd("#4");
  tasm.std("nxtinst");
  tasm.ldx("curinst");
  tasm.ldd("2,x");
  tasm.pshb();
  tasm.ldab("1,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.pulb();
  tasm.rts();

  tasm.label("byteext");
  tasm.ldd("curinst");
  tasm.addd("#3");
  tasm.std("nxtinst");
  tasm.ldx("curinst");
  tasm.ldab("1,x");
  tasm.pshb();
  tasm.ldab("2,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.pulb();
  tasm.rts();

  tasm.label("wordext");
  tasm.ldd("curinst");
  tasm.addd("#4");
  tasm.std("nxtinst");
  tasm.ldx("curinst");
  tasm.ldd("1,x");
  tasm.pshb();
  tasm.ldab("3,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.pulb();
  tasm.rts();

  tasm.label("extdex");
  tasm.ldd("curinst");
  tasm.addd("#3");
  tasm.std("nxtinst");
  tasm.ldx("curinst");
  tasm.ldab("2,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldd(",x");
  tasm.pshb();
  tasm.ldx("curinst");
  tasm.ldab("1,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.pulb();
  tasm.rts();

  tasm.label("dexext");
  tasm.ldd("curinst");
  tasm.addd("#3");
  tasm.std("nxtinst");
  tasm.ldx("curinst");
  tasm.ldab("1,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldd(",x");
  tasm.pshb();
  tasm.ldx("curinst");
  tasm.ldab("2,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldx(",x");
  tasm.pulb();
  tasm.rts();

  tasm.label("eistr");
  tasm.ldx("curinst");
  tasm.inx();
  tasm.pshx();
  tasm.ldab("0,x");
  tasm.ldx("#symtbl");
  tasm.abx();
  tasm.abx();
  tasm.ldd(",x");
  tasm.std("tmp3");
  tasm.pulx();
  tasm.inx();
  tasm.ldab(",x");
  tasm.inx();
  tasm.pshx();
  tasm.abx();
  tasm.stx("nxtinst");
  tasm.pulx();
  tasm.rts();

  tasm.label("immstr");
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.inx();
  tasm.pshx();
  tasm.abx();
  tasm.stx("nxtinst");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

void Library::addDependencies(std::set<std::string> &dependencies) {
  for (auto const &dependency : dependencies) {
    auto &module = modules[dependency];
    if (module.empty()) {
      auto implementation = foundation.find(dependency);
      if (implementation == foundation.end()) {
        fprintf(stderr, "dependency \"%s\" not found in foundation library\n",
                dependency.c_str());
      } else {
        module = implementation->second.instructions;
        addDependencies(implementation->second.dependencies);
      }
    }
  }
}

void Library::assemble(InstructionOp *implementation) {
  for (const auto &entry : queue.queue) {
    std::string callLabel(entry->callLabel());
    if (!callLabel.empty()) {
      auto &val = calls[callLabel];
      if (!val.instructions.empty()) {
        val.callCount++;
      } else {
        val.callCount = 1;
        val.instructions = entry->operate(implementation);
        addDependencies(entry->dependencies);
      }
    }
  }
}
