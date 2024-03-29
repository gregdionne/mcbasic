// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "bytecodeimplementation.hpp"

#include "backend/assembler/assembler.hpp"

std::string ByteCodeImplementation::inherent(InstBegin &inst) {
  inst.dependencies.insert("mdbcode");
  return CoreImplementation::inherent(inst);
}

std::string ByteCodeImplementation::regInt_immLbl(InstJmpIfEqual &inst) {
  Assembler tasm;
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_rts");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_rts");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regFlt_immLbl(InstJmpIfEqual &inst) {
  Assembler tasm;
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_rts");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_rts");
  tasm.ldd(inst.arg1->fract());
  tasm.bne("_rts");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immLbl(InstJmpIfNotEqual &inst) {
  Assembler tasm;
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_go");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.beq("_rts");
  tasm.label("_go");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regFlt_immLbl(InstJmpIfNotEqual &inst) {
  Assembler tasm;
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_go");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_go");
  tasm.ldd(inst.arg1->fract());
  tasm.beq("_rts");
  tasm.label("_go");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::immLbl(InstGoTo & /*inst*/) {
  Assembler tasm;
  tasm.jsr("getaddr");
  tasm.stx("nxtinst");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immLbl(InstJsrIfEqual &inst) {
  Assembler tasm;
  tasm.pulx();
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_rts");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_rts");
  tasm.ldd("nxtinst");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("#3");
  tasm.pshb();
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::regFlt_immLbl(InstJsrIfEqual &inst) {
  Assembler tasm;
  tasm.pulx();
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_rts");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_rts");
  tasm.ldd(inst.arg1->fract());
  tasm.bne("_rts");
  tasm.ldd("nxtinst");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("#3");
  tasm.pshb();
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immLbl(InstJsrIfNotEqual &inst) {
  Assembler tasm;
  tasm.pulx();
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_go");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.beq("_rts");
  tasm.label("_go");
  tasm.ldd("nxtinst");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("#3");
  tasm.pshb();
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::regFlt_immLbl(InstJsrIfNotEqual &inst) {
  Assembler tasm;
  tasm.pulx();
  tasm.jsr("getaddr");
  tasm.ldd(inst.arg1->lword());
  tasm.bne("_go");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_go");
  tasm.ldd(inst.arg1->lword());
  tasm.beq("_rts");
  tasm.label("_go");
  tasm.ldd("nxtinst");
  tasm.pshb();
  tasm.psha();
  tasm.ldab("#3");
  tasm.pshb();
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::immLbl(InstGoSub &inst) {
  Assembler tasm;
  tasm.pulx();
  tasm.jsr("getaddr");
  tasm.ldd("nxtinst");
  tasm.pshb();
  tasm.psha();
  if (inst.generateLines) {
    tasm.ldd("DP_LNUM");
    tasm.pshb();
    tasm.psha();
    tasm.ldab("#5");
  } else {
    tasm.ldab("#3");
  }
  tasm.pshb();
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::regStr_immStr(InstLd &inst) {
  Assembler tasm;
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.stab(inst.arg1->sbyte());
  tasm.inx();
  tasm.stx(inst.arg1->lword());
  tasm.abx();
  tasm.stx("nxtinst");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::extStr_immStr(InstLd &inst) {
  Assembler tasm;
  inst.dependencies.insert("mdstrdel");
  tasm.jsr("extend");
  tasm.pshx();        // let go of whatever x points to
  tasm.jsr("strdel"); // let go of whatever x points to
  tasm.pulx();
  tasm.stx("tmp1"); // holds dest
  tasm.ldx("nxtinst");
  tasm.ldab("0,x"); // get sbyte
  tasm.inx();
  tasm.stx("tmp2");
  tasm.abx();
  tasm.stx("nxtinst");
  tasm.ldx("tmp1"); // retrieve dest
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::indStr_immStr(InstLd &inst) {
  Assembler tasm;
  inst.dependencies.insert("mdstrdel");
  tasm.ldx("letptr");
  tasm.pshx();        // let go of whatever x points to
  tasm.jsr("strdel"); // let go of whatever x points to
  tasm.pulx();
  tasm.stx("tmp1"); // holds dest
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.inx();
  tasm.stx("tmp2");
  tasm.abx();
  tasm.stx("nxtinst");
  tasm.ldx("tmp1");
  tasm.stab("0,x");
  tasm.ldd("tmp2");
  tasm.std("1,x");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regStr_immStr(InstStrInit &inst) {
  inst.dependencies.insert("mdstrtmp");

  Assembler tasm;
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.stab(inst.arg1->sbyte());
  tasm.inx();
  tasm.pshx();
  tasm.abx();
  tasm.stx("nxtinst");
  tasm.pulx();
  tasm.jsr("strtmp");
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regStr_regStr_immStr(InstStrCat &inst) {
  inst.dependencies.insert("mdstrtmp");

  Assembler tasm;
  tasm.ldx(inst.arg2->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.abx();
  tasm.stx("strfree");
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.addb(inst.arg2->sbyte());
  tasm.bcs("_lserror");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldab(",x");
  tasm.inx();
  tasm.pshx();
  tasm.abx();
  tasm.stx("nxtinst");
  tasm.pulx();
  tasm.jmp("strcat");
  tasm.label("_lserror");
  tasm.ldab("#LS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_regStr_immStr(InstLdEq &inst) {
  inst.dependencies.insert("mdstreqbs");
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.jsr("streqbs");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_extStr_immStr(InstLdEq &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  tasm.jsr("eistr");
  tasm.stab("tmp1+1");
  tasm.stx("tmp2");
  tasm.ldx("tmp3");
  tasm.jsr("streqx");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_regStr_immStr(InstLdNe &inst) {
  inst.dependencies.insert("mdstreqbs");
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.jsr("streqbs");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_extStr_immStr(InstLdNe &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  tasm.jsr("eistr");
  tasm.stab("tmp1+1");
  tasm.stx("tmp2");
  tasm.ldx("tmp3");
  tasm.jsr("streqx");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_regStr_immStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrlobs");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jsr("strlobs");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_extStr_immStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrloxr");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  tasm.jsr("eistr");
  tasm.stab("tmp1+1");
  tasm.stx("tmp2");
  tasm.ldx("tmp3");
  tasm.jsr("strloxr");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immStr_regStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrlo");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  tasm.jsr("immstr");
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldx(inst.arg3->lword());
  tasm.stx("tmp2");
  tasm.jsr("strlo");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immStr_extStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrlox");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  tasm.jsr("eistr");
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldx("tmp3");
  tasm.jsr("strlox");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_regStr_immStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrlobs");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jsr("strlobs");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_extStr_immStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrloxr");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  tasm.jsr("eistr");
  tasm.stab("tmp1+1");
  tasm.stx("tmp2");
  tasm.ldx("tmp3");
  tasm.jsr("strloxr");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immStr_regStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrlo");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  tasm.jsr("immstr");
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldx(inst.arg3->lword());
  tasm.stx("tmp2");
  tasm.jsr("strlo");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immStr_extStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrlox");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  tasm.jsr("eistr");
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldx("tmp3");
  tasm.jsr("strlox");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_posByte(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("getbyte");
  tasm.stab("r1+2");
  tasm.ldd("#0");
  tasm.std("r1");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_negByte(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("getbyte");
  tasm.stab("r1+2");
  tasm.ldd("#-1");
  tasm.std("r1");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_posWord(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("getword");
  tasm.std("r1+1");
  tasm.ldd("#0");
  tasm.stab("r1");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_negWord(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("getword");
  tasm.std("r1+1");
  tasm.ldab("#-1");
  tasm.stab("r1");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_regInt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;

  tasm.jsr("noargs");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_extInt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("extend");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("r1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("r1+1");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_regFlt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_extFlt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("extend");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("r1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("r1+1");
  tasm.ldd(inst.arg2->fract());
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#13" : "#11");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_posByte(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("getbyte");
  tasm.stab("r1+2");
  tasm.ldd("#0");
  tasm.std("r1");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_negByte(InstTo &inst) {
  Assembler tasm;
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");
  tasm.jsr("getbyte");
  tasm.stab("r1+2");
  tasm.ldd("#-1");
  tasm.std("r1");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_posWord(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("getword");
  tasm.std("r1+1");
  tasm.ldd("#0");
  tasm.stab("r1");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_negWord(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("getword");
  tasm.std("r1+1");
  tasm.ldab("#-1");
  tasm.stab("r1");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_regInt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_extInt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("extend");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("r1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("r1+1");
  tasm.ldd("#0");
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_regFlt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_extFlt(InstTo &inst) {
  inst.dependencies.insert(inst.generateLines ? "mdtobcgl" : "mdtobc");

  Assembler tasm;
  tasm.jsr("extend");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("r1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("r1+1");
  tasm.ldd(inst.arg2->fract());
  tasm.std("r1+3");
  tasm.ldab(inst.generateLines ? "#17" : "#15");
  tasm.jmp("to");
  return tasm.source();
}

std::string ByteCodeImplementation::ptrInt_regInt(InstStep &inst) {
  int varsize = 3;
  int offset = 2 + 1 + 2 + 2 + varsize;

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.tsx();

  tasm.ldd(std::to_string(offset) + ",x"); // check if nonzero
  tasm.beq("_zero");
  tasm.ldab(inst.arg2->sbyte());
  tasm.bpl("_nonzero");

  tasm.ldd(std::to_string(offset - 2) + ",x");
  tasm.addd("#1");
  tasm.std(std::to_string(offset - 2) + ",x");
  tasm.ldab(std::to_string(offset - 3) + ",x");
  tasm.adcb("#0");
  tasm.stab(std::to_string(offset - 3) + ",x");

  tasm.label("_zero");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_nonzero");
  tasm.stab(std::to_string(offset) + ",x");

  tasm.ldd(inst.arg2->lword());
  tasm.std(std::to_string(offset + 1) + ",x");

  tasm.ldd("nxtinst");
  tasm.std("5,x");

  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_regInt(InstStep &inst) {
  int varsize = 5;
  int offset = 2 + 1 + 2 + 2 + varsize;

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.tsx();

  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(std::to_string(offset) + ",x");

  tasm.ldd(inst.arg2->lword());
  tasm.std(std::to_string(offset + 1) + ",x");

  tasm.ldd(inst.arg2->fract());
  tasm.std(std::to_string(offset + 3) + ",x");

  tasm.ldd("nxtinst");
  tasm.std("5,x");

  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::ptrFlt_regFlt(InstStep &inst) {
  int varsize = 5;
  int offset = 2 + 1 + 2 + 2 + varsize;

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.tsx();

  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(std::to_string(offset) + ",x");

  tasm.ldd(inst.arg2->lword());
  tasm.std(std::to_string(offset + 1) + ",x");

  tasm.ldd(inst.arg2->fract());
  tasm.std(std::to_string(offset + 3) + ",x");

  tasm.ldd("nxtinst");
  tasm.std("5,x");

  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::extInt(InstNextVar &inst) {
  Assembler tasm;
  tasm.jsr("extend");
  tasm.stx("letptr");
  tasm.pulx();
  tasm.tsx();
  tasm.clrb();
  tasm.label("_nxtvar");
  tasm.abx();
  tasm.ldd("1,x");
  tasm.subd("letptr");
  tasm.beq("_ok");
  tasm.ldab(",x");
  tasm.cmpb(inst.generateLines ? "#5" : "#3");
  tasm.bhi("_nxtvar");
  tasm.label("_ok");
  tasm.txs();
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::extFlt(InstNextVar &inst) {
  Assembler tasm;
  tasm.jsr("extend");
  tasm.stx("letptr");
  tasm.pulx();
  tasm.tsx();
  tasm.clrb();
  tasm.label("_nxtvar");
  tasm.abx();
  tasm.ldd("1,x");
  tasm.subd("letptr");
  tasm.beq("_ok");
  tasm.ldab(",x");
  tasm.cmpb(inst.generateLines ? "#5" : "#3");
  tasm.bhi("_nxtvar");
  tasm.label("_ok");
  tasm.txs();
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::inherent(InstNext &inst) {
  Assembler tasm;
  tasm.jsr("noargs");
  tasm.pulx();
  tasm.tsx();
  tasm.ldab(",x");
  tasm.cmpb(inst.generateLines ? "#5" : "#3");
  tasm.bhi("_ok");
  tasm.ldab("#NF_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.cmpb(inst.generateLines ? "#13" : "#11");
  tasm.bne("_flt");
  //   0,x (byte) rec length
  //   1,x (word) index variable pointer
  //   3,x (word) loop destination
  //   5,x (trip) "to" limit
  //   8,x (trip) step amount
  // [11,x (word) line number of destination]
  tasm.ldab("8,x");  // save sign byte of step in r1
  tasm.stab("r1");   //
  tasm.ldd("9,x");   // get lower word
  tasm.ldx("1,x");   // get pointer to index variable
  tasm.addd("1,x");  // add to lower word of index variable
  tasm.std("r1+1");  // save in r1
  tasm.std("1,x");   // ...and index variable
  tasm.ldab("r1");   // get saved sign byte of step
  tasm.adcb(",x");   // add with sign byte of index variable
  tasm.stab("r1");   // save in r1
  tasm.stab(",x");   // ...and in index variable
  tasm.tsx();        // point back to stack
  tasm.tst("8,x");   // check sign byte of step
  tasm.bpl("_iopp"); // go if positive
  tasm.ldd("r1+1");  // compare against "to" limit
  tasm.subd("6,x");  //
  tasm.ldab("r1");   //
  tasm.sbcb("5,x");  //
  tasm.blt("_done"); // bail if past limit
  if (inst.generateLines) {
    tasm.ldd("11,x");    // transfer destination line number
    tasm.std("DP_LNUM"); // when using "-g" compiler flag
  }
  tasm.ldx("3,x"); // go to destination
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");
  tasm.label("_iopp");
  tasm.ldd("6,x");   // compare against "to" limit
  tasm.subd("r1+1"); //
  tasm.ldab("5,x");  //
  tasm.sbcb("r1");   //
  tasm.blt("_done"); // bail if past limit
  if (inst.generateLines) {
    tasm.ldd("11,x");    // transfer destination line number
    tasm.std("DP_LNUM"); // when using "-g" compiler flag
  }
  tasm.ldx("3,x"); // go to destination
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");

  tasm.label("_done");
  tasm.ldab("0,x");     // get record length
  tasm.abx();           // add offset to stack
  tasm.txs();           //
  tasm.jmp("mainloop"); // return

  tasm.label("_flt");
  //   0,x (byte) rec length
  //   1,x (word) index variable pointer
  //   3,x (word) loop destination
  //   5,x (pent) "to" limit
  //  10,x (pent) step amount
  // [15,x (word) line number of destination]
  tasm.ldab("10,x"); // save sign byte of "step" in r1
  tasm.stab("r1");   //
  tasm.ldd("11,x");  // save lower word in r1
  tasm.std("r1+1");  //
  tasm.ldd("13,x");  // load fraction word
  tasm.ldx("1,x");   // get pointer to index variable
  tasm.addd("3,x");  // add to fraction word
  tasm.std("r1+3");  // store in r1
  tasm.std("3,x");   // ... and index variable
  tasm.ldd("1,x");   // add lower words
  tasm.adcb("r1+2"); //
  tasm.adca("r1+1"); //
  tasm.std("r1+1");  // store in r1
  tasm.std("1,x");   // ... and index variable
  tasm.ldab("r1");   // add sign bytes
  tasm.adcb(",x");   //
  tasm.stab("r1");   // store in r1
  tasm.stab(",x");   // ... and index variable
  tasm.tsx();
  tasm.tst("10,x");  // check sign byte of "step"
  tasm.bpl("_fopp"); // go if positive
  tasm.ldd("r1+3");  // compare against "to" limit
  tasm.subd("8,x");  //
  tasm.ldd("r1+1");  //
  tasm.sbcb("7,x");  //
  tasm.sbca("6,x");  //
  tasm.ldab("r1");   //
  tasm.sbcb("5,x");  //
  tasm.blt("_done"); // bail if past the limit
  if (inst.generateLines) {
    tasm.ldd("15,x");    // transfer destination line number
    tasm.std("DP_LNUM"); // when using "-g" debug flag
  }
  tasm.ldx("3,x"); // go to loop destination
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");

  tasm.label("_fopp");
  tasm.ldd("8,x");   // compare against "to" limit
  tasm.subd("r1+3"); //
  tasm.ldd("6,x");   //
  tasm.sbcb("r1+2"); //
  tasm.sbca("r1+1"); //
  tasm.ldab("5,x");  //
  tasm.sbcb("r1");   //
  tasm.blt("_done"); // bail if past limit
  if (inst.generateLines) {
    tasm.ldd("15,x");    // transfer destination line number
    tasm.std("DP_LNUM"); // when using "-g" debug flag
  }
  tasm.ldx("3,x"); // go to loop destination
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immLbls(InstOnGoTo &inst) {
  Assembler tasm;
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldd(inst.arg1->sbyte());
  tasm.bne("_fail");
  tasm.ldab(inst.arg1->lbyte());
  tasm.decb();
  tasm.cmpb("0,x");
  tasm.bhs("_fail");
  tasm.abx();
  tasm.abx();
  tasm.ldx("1,x");
  tasm.stx("nxtinst");
  tasm.rts();
  tasm.label("_fail");
  tasm.ldab(",x");
  tasm.abx();
  tasm.abx();
  tasm.inx();
  tasm.stx("nxtinst");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::regInt_immLbls(InstOnGoSub &inst) {
  Assembler tasm;
  tasm.pulx();
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldd(inst.arg1->sbyte());
  tasm.bne("_fail");
  tasm.ldab(inst.arg1->lbyte());
  tasm.decb();
  tasm.cmpb("0,x");
  tasm.bhs("_fail");
  tasm.stx("tmp1");
  tasm.stab("tmp2");
  tasm.ldab(",x");
  tasm.abx();
  tasm.abx();
  tasm.inx();
  tasm.pshx();
  if (inst.generateLines) {
    tasm.ldx("DP_LNUM");
    tasm.pshx();
  }
  tasm.ldaa(inst.generateLines ? "#5" : "#3");
  tasm.psha();
  tasm.ldx("tmp1");
  tasm.ldab("tmp2");
  tasm.abx();
  tasm.abx();
  tasm.ldx("1,x");
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");
  tasm.label("_fail");
  tasm.ldab(",x");
  tasm.abx();
  tasm.abx();
  tasm.inx();
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::inherent(InstReturn &inst) {
  Assembler tasm;
  tasm.pulx();
  tasm.tsx();
  tasm.clrb();
  tasm.label("_nxt");
  tasm.abx();
  tasm.ldab(",x");
  tasm.bne("_ok");
  tasm.ldab("#RG_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.cmpb(inst.generateLines ? "#5" : "#3");
  tasm.bne("_nxt");
  if (inst.generateLines) {
    tasm.ldd("1,x");
    tasm.std("DP_LNUM");
    tasm.ldab("#3");
    tasm.abx();
  } else {
    tasm.inx();
  }
  tasm.txs();
  tasm.pulx();
  tasm.stx("nxtinst");
  tasm.jmp("mainloop");
  return tasm.source();
}

std::string ByteCodeImplementation::immStr(InstPr &inst) {
  inst.dependencies.insert("mdstrrel");
  inst.dependencies.insert("mdprint");

  Assembler tasm;
  tasm.ldx("curinst");
  tasm.inx();
  tasm.ldab(",x");
  tasm.beq("_null");
  tasm.inx();
  tasm.jsr("print");
  tasm.stx("nxtinst");
  tasm.rts();
  tasm.label("_null");
  tasm.inx();
  tasm.stx("nxtinst");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::inherent(InstInputBuf & /*inst*/) {
  Assembler tasm;
  tasm.jsr("noargs");
  tasm.ldx("curinst");
  tasm.stx("redoptr");
  tasm.jmp("inputqs"); // '? '
  return tasm.source();
}

std::string ByteCodeImplementation::extFlt(InstReadBuf &inst) {
  inst.dependencies.insert("mdstrval");
  inst.dependencies.insert("mdinput");

  Assembler tasm;
  tasm.jsr("extend");
  tasm.stx("letptr");
  tasm.jsr("rdinit"); // if \0 ?? else skip spaces
  tasm.ldab("#128");  // bufsiz?
  tasm.jsr("inptval");
  tasm.stx("inptptr");
  tasm.ldaa(",x");
  tasm.ldx("letptr");
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldd("tmp3");
  tasm.std(inst.arg1->fract());
  tasm.jsr("rdredo"); // if Z set, return, else X is ?redo pointer
  tasm.beq("_rts");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::indFlt(InstReadBuf &inst) {
  inst.dependencies.insert("mdstrval");
  inst.dependencies.insert("mdinput");

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.jsr("rdinit"); // if \0 ?? else skip spaces
  tasm.ldab("#128");  // bufsiz?
  tasm.jsr("inptval");
  tasm.stx("inptptr");
  tasm.ldaa(",x");
  tasm.ldx("letptr");
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldd("tmp3");
  tasm.std(inst.arg1->fract());
  tasm.jsr("rdredo"); // if Z set, return, else X is ?redo pointer
  tasm.beq("_rts");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string ByteCodeImplementation::extStr(InstReadBuf &inst) {
  inst.dependencies.insert("mdinput");
  inst.dependencies.insert("mdstrprm");

  Assembler tasm;
  tasm.jsr("extend");
  tasm.stx("letptr");
  tasm.jsr("rdinit");
  tasm.ldaa("#','");
  tasm.staa("tmp1");
  tasm.ldaa(",x");
  tasm.beq("_null");
  tasm.cmpa("#'\"'");
  tasm.bne("_unquoted");
  tasm.staa("tmp1");
  tasm.inx();
  tasm.label("_unquoted");
  tasm.stx("tmp3");
  tasm.clrb();
  tasm.label("_nxtchr");
  tasm.incb();
  tasm.inx();
  tasm.ldaa(",x");
  tasm.beq("_done");
  tasm.cmpa("tmp1");
  tasm.bne("_nxtchr");
  tasm.label("_done");
  tasm.stx("inptptr");

  tasm.stab("0+argv");
  tasm.ldd("tmp3");
  tasm.std("1+argv");
  tasm.ldx("letptr");
  tasm.jsr("strprm");

  tasm.label("_rdredo");
  tasm.jsr("rdredo"); // if Z set, return, else X is ?redo ptr
  tasm.beq("_rts");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();

  tasm.label("_null");
  tasm.ldx("letptr");
  tasm.jsr("strdel");
  tasm.ldd("#$0100");
  tasm.ldx("letptr");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.bra("_rdredo");
  return tasm.source();
}

std::string ByteCodeImplementation::indStr(InstReadBuf &inst) {
  inst.dependencies.insert("mdinput");
  inst.dependencies.insert("mdstrprm");

  Assembler tasm;
  tasm.jsr("noargs");
  tasm.jsr("rdinit");
  tasm.ldaa("#','");
  tasm.staa("tmp1");
  tasm.ldaa(",x");
  tasm.beq("_null");
  tasm.cmpa("#'\"'");
  tasm.bne("_unquoted");
  tasm.staa("tmp1");
  tasm.inx();
  tasm.label("_unquoted");
  tasm.stx("tmp3");
  tasm.clrb();
  tasm.label("_nxtchr");
  tasm.incb();
  tasm.inx();
  tasm.ldaa(",x");
  tasm.beq("_done");
  tasm.cmpa("tmp1");
  tasm.bne("_nxtchr");
  tasm.label("_done");
  tasm.stx("inptptr");

  tasm.stab("0+argv");
  tasm.ldd("tmp3");
  tasm.std("1+argv");
  tasm.ldx("letptr");
  tasm.jsr("strprm");

  tasm.label("_rdredo");
  tasm.jsr("rdredo"); // if Z set, return, else X is ?redo ptr
  tasm.beq("_rts");
  tasm.stx("nxtinst");
  tasm.label("_rts");
  tasm.rts();

  tasm.label("_null");
  tasm.ldx("letptr");
  tasm.jsr("strdel");
  tasm.ldd("#$0100");
  tasm.ldx("letptr");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.bra("_rdredo");
  return tasm.source();
}

bool ByteCodeImplementation::isGetAddr(Instruction &inst) {
  return inst.arg1->isImmLin();
}

bool ByteCodeImplementation::isExtend(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isExtended() && arg2->isInherent() && arg3->isInherent();
  bool in2 = arg1->isExtended() && arg2->isRegister() && arg3->isInherent();
  bool in3 = arg1->isExtended() && arg2->isRegister() && arg3->isExtended();
  bool in4 = arg1->isExtended() && arg2->isIndirect() && arg3->isInherent();
  bool in5 = arg1->isExtended() && arg2->isExtended() && arg3->isInherent();
  bool in6 = arg1->isExtended() && arg2->isExtended() && arg3->isRegister();
  bool in7 = arg1->isRegister() && arg2->isExtended() && arg3->isInherent();
  bool in8 = arg1->isRegister() && arg2->isExtended() && arg3->isRegister();
  bool in9 = arg1->isRegister() && arg2->isRegister() && arg3->isExtended();
  bool in10 = arg1->isIndirect() && arg2->isExtended() && arg3->isInherent();

  return in1 || in2 || in3 || in4 || in5 || in6 || in7 || in8 || in9 || in10;
}

bool ByteCodeImplementation::isGetByte(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isByte() && !arg2->isExtended() && !arg3->isExtended();
  bool in2 = !arg1->isExtended() && arg2->isByte() && !arg3->isExtended();
  bool in3 = !arg1->isExtended() && !arg2->isExtended() && arg3->isByte();

  return in1 || in2 || in3;
}

bool ByteCodeImplementation::isGetWord(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isWord() && !arg2->isExtended() && !arg3->isExtended();
  bool in2 = !arg1->isExtended() && arg2->isWord() && !arg3->isExtended();
  bool in3 = !arg1->isExtended() && !arg2->isExtended() && arg3->isWord();

  return in1 || in2 || in3;
}

bool ByteCodeImplementation::isByteExt(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isByte() && arg2->isExtended() && arg3->isInherent();
  bool in2 = arg1->isRegister() && arg2->isByte() && arg3->isExtended();
  bool in3 = arg1->isExtended() && arg2->isByte() && arg3->isExtended();
  bool in4 = arg1->isIndirect() && arg2->isByte() && arg3->isExtended();
  return in1 || in2 || in3 || in4;
}

bool ByteCodeImplementation::isWordExt(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isWord() && arg2->isExtended() && arg3->isInherent();
  bool in2 = arg1->isRegister() && arg2->isWord() && arg3->isExtended();
  bool in3 = arg1->isExtended() && arg2->isWord() && arg3->isExtended();
  bool in4 = arg1->isIndirect() && arg2->isWord() && arg3->isExtended();
  return in1 || in2 || in3 || in4;
}

bool ByteCodeImplementation::isExtByte(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isExtended() && arg2->isByte() && arg3->isInherent();
  bool in2 = arg1->isExtended() && arg2->isByte() && arg3->isRegister();
  bool in3 = arg1->isRegister() && arg2->isExtended() && arg3->isByte();
  bool in4 = arg1->isExtended() && arg2->isExtended() && arg3->isByte();
  bool in5 = arg1->isIndirect() && arg2->isExtended() && arg3->isByte();
  return in1 || in2 || in3 || in4 || in5;
}

bool ByteCodeImplementation::isExtWord(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isExtended() && arg2->isWord() && arg3->isInherent();
  bool in2 = arg1->isRegister() && arg2->isExtended() && arg3->isWord();
  bool in3 = arg1->isExtended() && arg2->isExtended() && arg3->isWord();
  bool in4 = arg1->isIndirect() && arg2->isExtended() && arg3->isWord();
  return in1 || in2 || in3 || in4;
}

bool ByteCodeImplementation::isExtDex(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isExtended() && arg2->isDoubleEx() && arg3->isInherent();
  bool in2 = arg1->isRegister() && arg2->isExtended() && arg3->isDoubleEx();
  bool in3 = arg1->isExtended() && arg2->isExtended() && arg3->isDoubleEx();
  bool in4 = arg1->isIndirect() && arg2->isExtended() && arg3->isDoubleEx();
  return in1 || in2 || in3 || in4;
}

bool ByteCodeImplementation::isDexExt(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  bool in1 = arg1->isDoubleEx() && arg2->isExtended() && arg3->isInherent();
  bool in2 = arg1->isRegister() && arg2->isDoubleEx() && arg3->isExtended();
  bool in3 = arg1->isExtended() && arg2->isDoubleEx() && arg3->isExtended();
  bool in4 = arg1->isIndirect() && arg2->isDoubleEx() && arg3->isExtended();
  return in1 || in2 || in3 || in4;
}

bool ByteCodeImplementation::isNoArgs(Instruction &inst) {
  auto &arg1 = inst.arg1;
  auto &arg2 = inst.arg2;
  auto &arg3 = inst.arg3;

  return !arg1->isImmediate() && !arg2->isImmediate() && !arg3->isImmediate() &&
         !arg1->isExtended() && !arg2->isExtended() && !arg3->isExtended();
}

void ByteCodeImplementation::preamble(Assembler &tasm, Instruction &inst) {
  std::string addr;
  addr = isGetAddr(inst)   ? "getaddr"
         : isExtend(inst)  ? "extend"
         : isGetByte(inst) ? "getbyte"
         : isGetWord(inst) ? "getword"
         : isByteExt(inst) ? "byteext"
         : isWordExt(inst) ? "wordext"
         : isExtByte(inst) ? "extbyte"
         : isExtWord(inst) ? "extword"
         : isExtDex(inst)  ? "extdex"
         : isDexExt(inst)  ? "dexext"
         : isNoArgs(inst)  ? "noargs"
                           : "!unknown";
  tasm.jsr(addr);
}
