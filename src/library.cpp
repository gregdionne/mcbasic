// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "library.hpp"

#include "assembler.hpp"

void Library::makeFoundation() {
  foundation["mdalloc"] = Lib{0, mdAlloc(), {}};
  foundation["mdref1"] = Lib{0, mdArrayRef1(), {"mdalloc"}};
  foundation["mdref2"] = Lib{0, mdArrayRef2(), {"mdmul12"}};
  foundation["mdref3"] = Lib{0, mdArrayRef3(), {"mdmul12"}};
  foundation["mdref4"] = Lib{0, mdArrayRef4(), {"mdmul12"}};
  foundation["mdref5"] = Lib{0, mdArrayRef5(), {"mdmul12"}};
  foundation["mdrefint"] = Lib{0, mdArrayRefInt(), {}};
  foundation["mdrefflt"] = Lib{0, mdArrayRefFlt(), {}};
  foundation["mddivflt"] = Lib{0, mdDivFlt(), {}};
  foundation["mdmul12"] = Lib{0, mdMul12(), {}};
  foundation["mdmulint"] = Lib{0, mdMulInt(), {}};
  foundation["mdmulhlf"] = Lib{0, mdMulHlf(), {"mdmulint"}};
  foundation["mdmulflt"] = Lib{0, mdMulFlt(), {"mdmulhlf"}};
  foundation["mdstrflt"] = Lib{0, mdStrFlt(), {"mddivflt"}};
  foundation["mdstrprm"] = Lib{0, mdStrPrm(), {"mdstrdel"}};
  foundation["mdstrrel"] = Lib{0, mdStrRel(), {}};
  foundation["mdstrtmp"] = Lib{0, mdStrTmp(), {}};
  foundation["mdstrdel"] = Lib{0, mdStrDel(), {"mdalloc"}};
  foundation["mdstrval"] = Lib{0, mdStrVal(), {}};
  foundation["mdstreqs"] = Lib{0, mdStrEqs(), {}};
  foundation["mdstreqbs"] = Lib{0, mdStrEqbs(), {}};
  foundation["mdstreqx"] = Lib{0, mdStrEqx(), {}};
  foundation["mdstrlo"] = Lib{0, mdStrLo(), {}};
  foundation["mdstrlos"] = Lib{0, mdStrLos(), {"mdstrlo"}};
  foundation["mdstrlobs"] = Lib{0, mdStrLobs(), {"mdstrlo"}};
  foundation["mdstrlox"] = Lib{0, mdStrLox(), {"mdstrlo"}};
  foundation["mdrnd"] = Lib{0, mdRnd(), {}};
  foundation["mdprat"] = Lib{0, mdPrAt(), {}};
  foundation["mdprint"] = Lib{0, mdPrint(), {}};
  foundation["mdprtab"] = Lib{0, mdPrTab(), {}};
  foundation["mdset"] = Lib{0, mdSet(), {}};
  foundation["mdsetc"] = Lib{0, mdSetC(), {"mdset"}};
  foundation["mdpoint"] = Lib{0, mdPoint(), {"mdset"}};
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
  foundation["mdrsubyte"] = Lib{0, mdRdSUByte(), {"mdrpubyte"}};
  foundation["mdrssbyte"] = Lib{0, mdRdSSByte(), {"mdrpsbyte"}};
  foundation["mdrsuword"] = Lib{0, mdRdSUWord(), {"mdrpuword"}};
  foundation["mdrssword"] = Lib{0, mdRdSSWord(), {"mdrpsword"}};
  foundation["mdrsnumbr"] = Lib{0, mdRdSNumbr(), {"mdrpnumbr"}};
  foundation["mdrsstrng"] = Lib{0, mdRdSStrng(), {"mdrpstrng"}};
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
  tasm.subd("2,x");
  tasm.bhi("_err");
  tasm.ldd("0+argv");
  tasm.std("tmp1");
  tasm.lsld();
  tasm.rts();
  tasm.label("_err");
  tasm.ldab("#BS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string Library::mdArrayRef2() {
  Assembler tasm;
  tasm.comment("get offset from 2D descriptor X and argv.");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref2");
  tasm.ldd("2,x");
  tasm.std("tmp1");
  tasm.subd("0+argv");
  tasm.bls("_err");
  tasm.ldd("2+argv");
  tasm.std("tmp2");
  tasm.subd("4,x");
  tasm.bhs("_err");
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
  tasm.comment("get offset from 3D descriptor X and argv.");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref3");
  tasm.ldd("4,x");
  tasm.std("tmp1");
  tasm.subd("2+argv");
  tasm.bls("_err");
  tasm.ldd("4+argv");
  tasm.std("tmp2");
  tasm.subd("6,x");
  tasm.bhs("_err");
  tasm.jsr("mul12");
  tasm.addd("2+argv");
  tasm.std("tmp2");

  tasm.ldd("2,x");
  tasm.std("tmp1");
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
  tasm.ldd("6,x");
  tasm.std("tmp1");
  tasm.subd("4+argv");
  tasm.bls("_err");
  tasm.ldd("6+argv");
  tasm.std("tmp2");
  tasm.subd("8,x");
  tasm.bhs("_err");
  tasm.jsr("mul12");
  tasm.addd("4+argv");
  tasm.std("tmp2");

  tasm.ldd("4,x");
  tasm.std("tmp1");
  tasm.subd("2+argv");
  tasm.bls("_err");
  tasm.ldd("4+argv");
  tasm.std("tmp2");
  tasm.subd("6,x");
  tasm.bhs("_err");
  tasm.jsr("mul12");
  tasm.addd("2+argv");
  tasm.std("tmp2");

  tasm.ldd("2,x");
  tasm.std("tmp1");
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
  tasm.comment("get offset from 4D descriptor X and argv.");
  tasm.comment("return word offset in D and byte offset in tmp1");
  tasm.label("ref5");

  tasm.ldd("8,x");
  tasm.std("tmp1");
  tasm.subd("6+argv");
  tasm.bls("_err");
  tasm.ldd("8+argv");
  tasm.std("tmp2");
  tasm.subd("10,x");
  tasm.bhs("_err");
  tasm.jsr("mul12");
  tasm.addd("6+argv");
  tasm.std("tmp2");

  tasm.ldd("6,x");
  tasm.std("tmp1");
  tasm.subd("4+argv");
  tasm.bls("_err");
  tasm.ldd("6+argv");
  tasm.std("tmp2");
  tasm.subd("8,x");
  tasm.bhs("_err");
  tasm.jsr("mul12");
  tasm.addd("4+argv");
  tasm.std("tmp2");

  tasm.ldd("4,x");
  tasm.std("tmp1");
  tasm.subd("2+argv");
  tasm.bls("_err");
  tasm.ldd("4+argv");
  tasm.std("tmp2");
  tasm.subd("6,x");
  tasm.bhs("_err");
  tasm.jsr("mul12");
  tasm.addd("2+argv");
  tasm.std("tmp2");

  tasm.ldd("2,x");
  tasm.std("tmp1");
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
  tasm.addd("0,x");
  tasm.std("tmp1");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrRel() {
  Assembler tasm;
  tasm.comment("release a temporary string");
  tasm.comment("ENTRY: X holds string start");
  tasm.comment("EXIT:  X holds new end of string space");
  tasm.label("strrel");
  tasm.cpx("strend");
  tasm.bls("_rts");
  tasm.cpx("strstop");
  tasm.bhs("_rts");
  tasm.stx("strfree");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string Library::mdStrTmp() {
  Assembler tasm;
  tasm.comment("make a temporary clone of a string");
  tasm.comment("ENTRY: X holds string start");
  tasm.comment("       B holds string length");
  tasm.comment("EXIT:  D holds new string pointer");
  tasm.label("strtmp");
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
  tasm.ldx("tmp1");
  tasm.std("1,x");
  tasm.ldab("0+argv");
  tasm.stab("0,x");
  tasm.rts();

  // single-char
  tasm.label("_char");
  tasm.ldaa("#1");
  tasm.ldx("1+argv");
  tasm.ldab(",x");
  // fallthrough
  tasm.label("_null");
  tasm.ldaa("#1");
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

std::string Library::mdStrFlt() {
  Assembler tasm;
  tasm.label("strflt");
  tasm.pshx();
  tasm.tst("tmp1+1"); // tmp1+1 == sbyte
  tasm.bmi("_neg");   // tmp2   == lword
  tasm.ldab("' '");   // tmp3   == frac
  tasm.bra("_wdigs");
  tasm.label("_neg");
  tasm.neg("tmp3+1");
  tasm.ngc("tmp3");
  tasm.ngc("tmp2+1");
  tasm.ngc("tmp2");
  tasm.ngc("tmp1+1");
  tasm.ldab("'-'");
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
  tasm.ldaa("tmp1+1");
  tasm.adda("tmp2");
  tasm.adca("tmp2+1");
  tasm.adca("#0");
  tasm.adca("#0"); // just in case a was FF and CC set
  tasm.tab();
  tasm.lsra();
  tasm.lsra();
  tasm.lsra();
  tasm.lsra();
  tasm.andb("#$0F");
  tasm.aba();
  tasm.label("_dec");
  tasm.suba("#5");
  tasm.bhs("_dec");
  tasm.adda("#5");
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
  tasm.pshb();          // save sbyte
  tasm.ldd("tmp2");     // save hbyte
  tasm.psha();          //
  tasm.ldaa("#$CC");    // multiply lbyte by $CCCCC and add to result
  tasm.mul();           //
  tasm.std("tmp3");     //
  tasm.addd("tmp2");    //
  tasm.std("tmp2");     //
  tasm.ldab("tmp1+1");  //
  tasm.adcb("tmp3+1");  //
  tasm.stab("tmp1+1");  //
  tasm.ldd("tmp1+1");   //
  tasm.addd("tmp3");    //
  tasm.std("tmp1+1");   //
  tasm.pulb();          // get hbyte, multiply by $CC and add
  tasm.ldaa("#$CC");    //
  tasm.mul();           //
  tasm.stab("tmp3+1");  //
  tasm.addd("tmp1+1");  //
  tasm.std("tmp1+1");   //  (leave tmp3+1, we'll add it next)
  tasm.pulb();          // get sbyte, multiply by $CC and add
  tasm.ldaa("#$CC");    //
  tasm.mul();           //
  tasm.addb("tmp1+1");  //
  tasm.addb("tmp3+1");  //
  tasm.stab("tmp1+1");  //
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
  tasm.jsr("divufl");
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
  tasm.beq("_rts");
  tasm.neg("tmp3+1");
  tasm.ngc("tmp3");
  tasm.ngc("tmp2+1");
  tasm.ngc("tmp2");
  tasm.ngc("tmp1+1");
  tasm.label("_rts");
  tasm.rts();

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

  tasm.label("_getint"); // from X,B get integer into tmp1+1,tmp2,tmp2+2
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
  tasm.decb();
  tasm.pshb();      // push count
  tasm.psha();      // push result
  tasm.ldd("tmp2"); // tmp1+1 -> tmp4+1
  tasm.std("tmp3"); // tmp2   -> tmp3
  tasm.ldab("tmp1+1");
  tasm.stab("tmp4+1");
  tasm.bsr("_dbl");
  tasm.bsr("_dbl");
  tasm.ldd("tmp3");
  tasm.addd("tmp2");
  tasm.std("tmp2");
  tasm.ldab("tmp4+1");
  tasm.adcb("tmp1+1");
  tasm.stab("tmp1+1");
  tasm.bsr("_dbl");
  tasm.pulb(); // restore result
  tasm.clra(); //
  tasm.addd("tmp2");
  tasm.std("tmp2");
  tasm.ldab("tmp1+1");
  tasm.adcb("#0");
  tasm.stab("tmp1+1");
  tasm.pulb();       // restore string count
  tasm.ldaa("tmp4"); // increment digit count
  tasm.inca();
  tasm.staa("tmp4");
  tasm.cmpa("#6");
  tasm.blo("_nxtdig");
  tasm.label("_crts");
  tasm.clra();
  tasm.staa("tmp3");
  tasm.staa("tmp3+1");
  tasm.rts();

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
  tasm.byte("$00,$86,$80");
  tasm.byte("$0F,$42,$40");
  return tasm.source();
}

std::string Library::mdStrEqx() {
  Assembler tasm;
  tasm.label("streqx");
  tasm.ldab("0,x");
  tasm.cmpb("tmp1+1");
  tasm.bne("_rts");
  tasm.tstb();
  tasm.beq("_rts");
  tasm.sts("tmp3");
  tasm.ldx("1,x");
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
  tasm.label("_rts");
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
  tasm.label("strlo"); // entry argv0 holds len, lhs
  tasm.stab("tmp1+1"); //      tmp1+1 holds len, rhs
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
  tasm.ldab("tmp1+1");
  tasm.bra("strlo");
  return tasm.source();
}

std::string Library::mdStrLobs() {
  Assembler tasm;
  tasm.label("strlobs");
  tasm.jsr("immstr");
  tasm.stx("tmp2");
  tasm.bra("strlo");
  return tasm.source();
}

std::string Library::mdStrLox() {
  Assembler tasm;
  tasm.label("strlox");
  tasm.ldab(",x");
  tasm.ldx("1,x");
  tasm.stx("tmp2");
  tasm.bra("strlo");
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

std::string Library::mdMulFlt() {
  Assembler tasm;
  tasm.label("mulfltx");
  tasm.bsr("mulflt");
  tasm.ldab("tmp1+1");
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.ldd("tmp3");
  tasm.std("3,x");
  tasm.rts();

  tasm.label("mulflt");
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
  tasm.lslb();
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
  tasm.addb("tmp2");
  tasm.adca("tmp1+1");
  tasm.std("tmp1+1");
  tasm.ldaa("1+argv");
  tasm.ldab("2,x");
  tasm.mul();
  tasm.addb("tmp2");
  tasm.adca("tmp1+1");
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

std::string Library::mdDivFlt() {
  Assembler tasm;
  tasm.comment("divide X by Y");
  tasm.comment("  ENTRY  X contains dividend in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("                    scratch in  (5,x 6,x 7,x 8,x 9,x)");
  tasm.comment("         Y in 0+argv, 1+argv, 2+argv, 3+argv, 4+argv");
  tasm.comment("  EXIT   X/Y in (0,x 1,x 2,x 3,x 4,x)");
  tasm.comment("         uses tmp1,tmp1+1,tmp2,tmp2+1,tmp3,tmp3+1,tmp4");
  tasm.label("divflt");
  tasm.clr("tmp4");
  tasm.tst("0,x");
  tasm.bpl("_posX");
  tasm.com("tmp4");
  tasm.neg("4,x");
  tasm.ngc("3,x");
  tasm.ngc("2,x");
  tasm.ngc("1,x");
  tasm.ngc("0,x");

  tasm.label("_posX");
  tasm.tst("0+argv");
  tasm.bpl("_posA");
  tasm.com("tmp4");
  tasm.neg("4+argv");
  tasm.ngc("3+argv");
  tasm.ngc("2+argv");
  tasm.ngc("1+argv");
  tasm.ngc("0+argv");

  tasm.label("divufl");
  tasm.label("_posA");
  tasm.ldd("3,x");
  tasm.std("6,x");
  tasm.ldd("1,x");
  tasm.std("4,x");
  tasm.ldab("0,x");
  tasm.stab("3,x");
  tasm.ldd("#0");
  tasm.std("8,x");
  tasm.std("1,x");
  tasm.stab("0,x");
  tasm.ldaa("#41");
  tasm.staa("tmp1");

  tasm.label("_nxtdiv");
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
  tasm.rol("7,x");
  tasm.rol("6,x");
  tasm.rol("5,x");
  tasm.rol("4,x");
  tasm.rol("3,x");
  tasm.rol("2,x");
  tasm.rol("1,x");
  tasm.rol("0,x");
  tasm.dec("tmp1");
  tasm.bne("_nxtdiv");
  tasm.tst("tmp4");
  tasm.bne("_add1");
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
  tasm.cmpa("','");
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
  tasm.ldx("dataptr");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldaa(",x");
  tasm.inx();
  tasm.stx("dataptr");
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
  tasm.ldx("dataptr");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldaa(",x");
  tasm.inx();
  tasm.stx("dataptr");
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
  tasm.ldx("dataptr");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd(",x");
  tasm.inx();
  tasm.inx();
  tasm.stx("dataptr");
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
  tasm.ldx("dataptr");
  tasm.cpx("#enddata");
  tasm.blo("_ok");
  tasm.ldab("#OD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd(",x");
  tasm.inx();
  tasm.inx();
  tasm.stx("dataptr");
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
  tasm.ldx("dataptr");
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
  tasm.stx("dataptr");
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
  tasm.ldx("dataptr");
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
  tasm.stx("dataptr");
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
  tasm.jsr("strrel");
  tasm.jsr("rnubyte");
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
  tasm.jsr("strrel");
  tasm.jsr("rnsbyte");
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
  tasm.jsr("strrel");
  tasm.jsr("rnuword");
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
  tasm.jsr("strrel");
  tasm.jsr("rnsword");
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
  tasm.jsr("strrel");
  tasm.jsr("rnnumbr");
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
  tasm.jsr("strrel");
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
  tasm.comment("read numerc DATA when records are pure strings");
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
  tasm.comment("        r1    contains stopping variable and is always float.");
  tasm.comment("        r1+3  must contain zero if an integer.");
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
  tasm.ldx("#symstart");
  tasm.abx();
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
  tasm.ldx("#symstart");
  tasm.abx();
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
  tasm.ldx("#symstart");
  tasm.abx();
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
  tasm.ldx("#symstart");
  tasm.abx();
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
  tasm.ldx("#symstart");
  tasm.abx();
  tasm.pulb();
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
  for (auto &entry : queue.queue) {
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
