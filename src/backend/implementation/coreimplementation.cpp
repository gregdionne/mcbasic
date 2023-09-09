// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "coreimplementation.hpp"

std::string CoreImplementation::unimplemented(Instruction &inst) {
  return "\t!unimplemented " + inst.arg1->dataTypeStr() + inst.arg1->modeStr() +
         " " + inst.arg2->dataTypeStr() + inst.arg2->modeStr() + " " +
         inst.arg3->dataTypeStr() + inst.arg3->modeStr() + "\n";
}

std::string CoreImplementation::immLin(InstLabel &inst) {
  Assembler tasm;

  if (inst.generateLines) {
    preamble(tasm, inst);
    tasm.stx("DP_LNUM");
    tasm.rts();
  }

  return tasm.source();
}

std::string CoreImplementation::inherent(InstComment &inst) {
  Assembler tasm;
  tasm.comment(inst.comment);
  return tasm.source();
}

std::string CoreImplementation::inherent(InstClear &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.ldx("#bss");
  tasm.bra("_start");
  tasm.label("_again");
  tasm.staa(",x");
  tasm.inx();
  tasm.label("_start");
  tasm.cpx("#bes");
  tasm.bne("_again");
  tasm.stx("strbuf");
  tasm.stx("strend");
  tasm.inx();
  tasm.inx();
  tasm.stx("strfree");
  tasm.ldx("#$8FFF");
  tasm.stx("strstop");
  tasm.ldx("#startdata");
  tasm.stx("DP_DATA");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::inherent(InstBegin &inst) {
  inst.dependencies.insert("mdprint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("R_MCXID");
  tasm.cpx("#'h'*256+'C'");
  tasm.beq("_ok");
  tasm.ldx("R_MCXBT");
  tasm.cpx("#'1'*256+'0'");
  tasm.bne("_mcbasic");
  tasm.label("_ok");
  tasm.clrb();
  tasm.ldx("#charpage");
  tasm.label("_again");
  tasm.stab(",x");
  tasm.inx();
  tasm.incb();
  tasm.bne("_again");
  tasm.pulx();
  tasm.pshb();
  tasm.pshb();
  tasm.pshb();
  tasm.stab("strtcnt");
  tasm.jmp(",x");
  tasm.labelText("_reqmsg", "\"?UNSUPPORTED ROM\"");
  tasm.label("_mcbasic");
  tasm.ldx("#_reqmsg");
  tasm.ldab("#30");
  tasm.jsr("print");
  tasm.pulx();
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::inherent(InstEnd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.pulx();
  tasm.pula();
  tasm.pula();
  tasm.pula();
  tasm.jsr("R_RESET");
  tasm.jmp("R_DMODE");
  tasm.equ("NF_ERROR", "0");
  tasm.equ("RG_ERROR", "4");
  tasm.equ("OD_ERROR", "6");
  tasm.equ("FC_ERROR", "8");
  tasm.equ("OV_ERROR", "10");
  tasm.equ("OM_ERROR", "12");
  tasm.equ("BS_ERROR", "16");
  tasm.equ("DD_ERROR", "18");
  tasm.equ("D0_ERROR", "20");
  tasm.equ("LS_ERROR", "28");
  tasm.equ("IO_ERROR", "34");
  tasm.equ("FM_ERROR", "36");
  tasm.label("error");
  tasm.jmp("R_ERROR");
  return tasm.source();
}

std::string CoreImplementation::inherent(InstLPrintOn &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab("#-2");
  tasm.stab("DP_DEVN");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::inherent(InstLPrintOff &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clr("DP_DEVN");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::posByte(InstError &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp("R_ERROR");
  return tasm.source();
}

std::string CoreImplementation::inherent(InstStop &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#R_BKMSG-1");
  tasm.jmp("R_BREAK");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstArrayDim1 &inst) {
  inst.dependencies.insert("mdalloc");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.lsld();
  tasm.addd("2,x");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt(InstArrayDim1 &inst) {
  inst.dependencies.insert("mdalloc");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.lsld();
  tasm.lsld();
  tasm.addd("2,x");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr(InstArrayDim1 &inst) {
  inst.dependencies.insert("mdalloc");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.lsld();
  tasm.addd("2,x");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstArrayDim2 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt(InstArrayDim2 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr(InstArrayDim2 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstArrayDim3 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt(InstArrayDim3 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr(InstArrayDim3 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstArrayDim4 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r4+1");
  tasm.addd("#1");
  tasm.std("8,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt(InstArrayDim4 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r4+1");
  tasm.addd("#1");
  tasm.std("8,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr(InstArrayDim4 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r4+1");
  tasm.addd("#1");
  tasm.std("8,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstArrayDim5 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r4+1");
  tasm.addd("#1");
  tasm.std("8,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r5+1");
  tasm.addd("#1");
  tasm.std("10,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt(InstArrayDim5 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r4+1");
  tasm.addd("#1");
  tasm.std("8,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r5+1");
  tasm.addd("#1");
  tasm.std("10,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr(InstArrayDim5 &inst) {
  inst.dependencies.insert("mdalloc");
  inst.dependencies.insert("mdmul12");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(",x");
  tasm.beq("_ok");
  tasm.ldab("#DD_ERROR");
  tasm.jmp("error");
  tasm.label("_ok");
  tasm.ldd("strbuf");
  tasm.std(",x");
  tasm.ldd("r1+1");
  tasm.addd("#1");
  tasm.std("2,x");
  tasm.std("tmp1");
  tasm.ldd("r2+1");
  tasm.addd("#1");
  tasm.std("4,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r3+1");
  tasm.addd("#1");
  tasm.std("6,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r4+1");
  tasm.addd("#1");
  tasm.std("8,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp1");
  tasm.ldd("r5+1");
  tasm.addd("#1");
  tasm.std("10,x");
  tasm.std("tmp2");
  tasm.jsr("mul12");
  tasm.std("tmp3");
  tasm.lsld();
  tasm.addd("tmp3");
  tasm.jmp("alloc");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayVal1 &inst) {
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayVal1 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayVal1 &inst) {
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd("#55");
  tasm.jsr("ref1");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayVal1 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("0+argv");
  tasm.ldd("#55");
  tasm.jsr("ref1");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayVal1 &inst) {
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayVal1 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayVal2 &inst) {
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayVal2 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayVal2 &inst) {
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref2");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayVal2 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.jsr("ref2");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayVal2 &inst) {
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayVal2 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayVal3 &inst) {
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayVal3 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayVal3 &inst) {
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref3");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayVal3 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref3");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayVal3 &inst) {
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayVal3 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayVal4 &inst) {
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref4");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayVal4 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref4");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayVal4 &inst) {
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref4");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayVal4 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref4");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayVal4 &inst) {
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref4");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayVal4 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref4");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayVal5 &inst) {
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword() + "+20");
  tasm.std("8+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayVal5 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("8+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayVal5 &inst) {
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword() + "+20");
  tasm.std("8+argv");
  tasm.jsr("ref5");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayVal5 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("8+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref5");
  tasm.jsr("refflt");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.ldd("3,x");
  tasm.std(inst.result->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayVal5 &inst) {
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword() + "+20");
  tasm.std("8+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayVal5 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("8+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.result->sbyte());
  tasm.ldd("1,x");
  tasm.std(inst.result->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayRef1 &inst) {
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayRef1 &inst) {
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd("#55");
  tasm.jsr("ref1");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayRef1 &inst) {
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayRef2 &inst) {
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayRef2 &inst) {
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref2");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayRef2 &inst) {
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayRef3 &inst) {
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayRef3 &inst) {
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref3");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayRef3 &inst) {
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayRef4 &inst) {
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref4");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayRef4 &inst) {
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref4");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayRef4 &inst) {
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref4");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstArrayRef5 &inst) {
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword() + "+20");
  tasm.std("8+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstArrayRef5 &inst) {
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword() + "+20");
  tasm.std("8+argv");
  tasm.jsr("ref5");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_regInt(InstArrayRef5 &inst) {
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword() + "+20");
  tasm.std("8+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayRef1 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayRef1 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("0+argv");
  tasm.ldd("#55");
  tasm.jsr("ref1");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayRef1 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref1");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("0+argv");
  tasm.ldd("#33");
  tasm.jsr("ref1");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayRef2 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayRef2 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.jsr("ref2");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayRef2 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref2");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.jsr("ref2");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayRef3 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayRef3 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref3");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayRef3 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref3");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.jsr("ref3");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayRef4 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayRef4 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref4");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayRef4 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref4");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("6+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.jsr("ref4");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstArrayRef5 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("8+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstArrayRef5 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("8+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref5");
  tasm.jsr("refflt");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexInt(InstArrayRef5 &inst) {
  inst.dependencies.insert("mdgetlw");
  inst.dependencies.insert("mdref5");
  inst.dependencies.insert("mdrefint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("getlw");
  tasm.std("8+argv");
  tasm.ldd(inst.arg1->lword());
  tasm.std("0+argv");
  tasm.ldd(inst.arg1->lword() + "+5");
  tasm.std("2+argv");
  tasm.ldd(inst.arg1->lword() + "+10");
  tasm.std("4+argv");
  tasm.ldd(inst.arg1->lword() + "+15");
  tasm.std("6+argv");
  tasm.jsr("ref5");
  tasm.jsr("refint");
  tasm.std("letptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::inherent(InstCLoadM &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcloadm");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clrb();
  tasm.jsr("filename");
  tasm.ldd("#0");
  tasm.jmp("cloadm");
  return tasm.source();
}

std::string CoreImplementation::regStr(InstCLoadM &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcloadm");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("3+argv");
  tasm.ldab(inst.arg1->sbyte());
  tasm.jsr("filename");
  tasm.ldd("#0");
  tasm.jmp("cloadm");
  return tasm.source();
}

std::string CoreImplementation::regStr_regInt(InstCLoadM &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcloadm");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->lword());
  tasm.std("3+argv");
  tasm.ldab(inst.arg1->sbyte());
  tasm.jsr("filename");
  tasm.ldab(inst.arg2->sbyte());
  tasm.asrb();
  tasm.adcb("#0");
  tasm.bne("_fcerror");
  tasm.ldd(inst.arg2->lword());
  tasm.jmp("cloadm");
  tasm.label("_fcerror");
  tasm.ldab("FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::extInt_posByte(InstCLoadStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcloadstar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.clrb();
  tasm.jsr("filename");
  tasm.jmp("cloadstari");
  return tasm.source();
}

std::string CoreImplementation::extFlt_posByte(InstCLoadStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcloadstar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.clrb();
  tasm.jsr("filename");
  tasm.jmp("cloadstarf");
  return tasm.source();
}

std::string CoreImplementation::extInt_posByte_regStr(InstCLoadStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcloadstar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("3+argv");
  tasm.ldab(inst.arg3->sbyte());
  tasm.jsr("filename");
  tasm.jmp("cloadstari");
  return tasm.source();
}

std::string CoreImplementation::extFlt_posByte_regStr(InstCLoadStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcloadstar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("3+argv");
  tasm.ldab(inst.arg3->sbyte());
  tasm.jsr("filename");
  tasm.jmp("cloadstarf");
  return tasm.source();
}
std::string CoreImplementation::extInt_posByte(InstCSaveStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcsavestar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.clrb();
  tasm.jsr("filename");
  tasm.jmp("csavestari");
  return tasm.source();
}

std::string CoreImplementation::extFlt_posByte(InstCSaveStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcsavestar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.clrb();
  tasm.jsr("filename");
  tasm.jmp("csavestarf");
  return tasm.source();
}

std::string CoreImplementation::extInt_posByte_regStr(InstCSaveStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcsavestar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("3+argv");
  tasm.ldab(inst.arg3->sbyte());
  tasm.jsr("filename");
  tasm.jmp("csavestari");
  return tasm.source();
}

std::string CoreImplementation::extFlt_posByte_regStr(InstCSaveStar &inst) {
  inst.dependencies.insert("mdfilename");
  inst.dependencies.insert("mdcsavestar");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("0+argv");
  tasm.stx("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("3+argv");
  tasm.ldab(inst.arg3->sbyte());
  tasm.jsr("filename");
  tasm.jmp("csavestarf");
  return tasm.source();
}

std::string CoreImplementation::regInt_immLbl(InstJmpIfEqual &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immLbl(InstJmpIfNotEqual &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::immLbl(InstGoTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immLbl(InstJsrIfEqual &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immLbl(InstJsrIfNotEqual &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::immLbl(InstGoSub &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regFlt_regFlt_regInt(InstShift &inst) {
  inst.dependencies.insert("mdshift");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->lbyte());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("shift");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extInt(InstShift &inst) {
  inst.dependencies.insert("mdshift");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->lbyte());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("shift");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regInt(InstShift &inst) {
  inst.dependencies.insert("mdshift");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->lbyte());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("shifti");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extInt(InstShift &inst) {
  inst.dependencies.insert("mdshift");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->lbyte());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("shifti");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstShift &inst) {
  inst.dependencies.insert("mdshlint");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("shlint");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posByte(InstShift &inst) {
  inst.dependencies.insert("mdshlflt");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("shlflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_negByte(InstShift &inst) {
  inst.dependencies.insert("mdshrflt");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.negb();
  tasm.jmp("shrint");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstShift &inst) {
  inst.dependencies.insert("mdshrflt");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.negb();
  tasm.jmp("shrflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_posByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldab("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_immStr(InstLd &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regStr_extStr(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_posByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_negByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_posWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_negWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldab("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_regFlt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_regInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_posByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_negByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_posWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_negWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_regInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extStr_immStr(InstLd &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::extStr_regStr(InstLd &inst) {
  inst.dependencies.insert("mdstrprm");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string CoreImplementation::dexInt_extInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab("0+argv");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::dexFlt_extInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab("0+argv");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::dexFlt_extFlt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.std(inst.arg1->fract());
  tasm.ldd("1+argv");
  tasm.std(inst.arg1->lword());
  tasm.ldab("0+argv");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::dexStr_extStr(InstLd &inst) {
  inst.dependencies.insert("mdstrprm");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldx("tmp1");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string CoreImplementation::indFlt_posByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_negByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_posWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_negWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldab("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_regFlt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_regInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_posByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_negByte(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_posWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_negWord(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_regInt(InstLd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indStr_immStr(InstLd &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::indStr_regStr(InstLd &inst) {
  inst.dependencies.insert("mdstrprm");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jmp("strprm");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr(InstStrInit &inst) {
  inst.dependencies.insert("mdstrtmp");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldx(inst.arg2->lword()); // get source
  tasm.jsr("strtmp");           // copy to strfree and bump strfree
  tasm.std(inst.arg1->lword()); // store old strfree to result descr.
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_extStr(InstStrInit &inst) {
  inst.dependencies.insert("mdstrtmp");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldx(inst.arg2->lword()); // get source
  tasm.jsr("strtmp");           // copy to strfree and bump strfree
  tasm.std(inst.arg1->lword()); // store old strfree to result descr.
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_immStr(InstStrInit &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regStr_regStr_regStr(InstStrCat &inst) {
  inst.dependencies.insert("mdstrtmp");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg3->lword());
  tasm.jsr("strrel");
  tasm.ldx(inst.arg2->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.abx();
  tasm.stx("strfree");
  tasm.addb(inst.arg3->sbyte());
  tasm.bcs("_lserror");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldab(inst.arg3->sbyte());
  tasm.ldx(inst.arg3->lword());
  tasm.jmp("strcat");
  tasm.label("_lserror");
  tasm.ldab("#LS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_extStr(InstStrCat &inst) {
  inst.dependencies.insert("mdstrtmp");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("tmp1");
  tasm.ldx(inst.arg2->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.abx();
  tasm.stx("strfree");
  tasm.ldx("tmp1");
  tasm.addb(inst.arg3->sbyte());
  tasm.bcs("_lserror");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldab(inst.arg3->sbyte());
  tasm.ldx(inst.arg3->lword());
  tasm.jmp("strcat");
  tasm.label("_lserror");
  tasm.ldab("#LS_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_immStr(InstStrCat &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regStr(InstInkey &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#$0100+(charpage>>8)");
  tasm.std(inst.arg1->sbyte());
  tasm.ldaa("M_IKEY");
  tasm.bne("_gotkey");
  tasm.jsr("R_KEYIN");
  tasm.label("_gotkey");
  tasm.clr("M_IKEY");
  tasm.staa(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.staa(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extStr(InstInkey &inst) {
  inst.dependencies.insert("mdstrdel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshx();
  tasm.jsr("strdel");
  tasm.pulx();
  tasm.clr("strtcnt");
  tasm.ldd("#$0100+(charpage>>8)");
  tasm.std(inst.arg1->sbyte());
  tasm.ldaa("M_IKEY");
  tasm.bne("_gotkey");
  tasm.jsr("R_KEYIN");
  tasm.label("_gotkey");
  tasm.clr("M_IKEY");
  tasm.staa(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.staa(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indStr(InstInkey &inst) {
  inst.dependencies.insert("mdstrdel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.jsr("strdel");
  tasm.ldx("letptr");
  tasm.clr("strtcnt");
  tasm.ldd("#$0100+(charpage>>8)");
  tasm.std(inst.arg1->sbyte());
  tasm.ldaa("M_IKEY");
  tasm.bne("_gotkey");
  tasm.jsr("R_KEYIN");
  tasm.label("_gotkey");
  tasm.clr("M_IKEY");
  tasm.staa(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.staa(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt(InstMem &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.sts("tmp1");
  tasm.ldd("tmp1");
  tasm.subd("strfree");
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt(InstPos &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("M_CRSR");
  tasm.anda("#1");
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt(InstTimer &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("DP_TIMR");
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt(InstOne &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#0");                // 3
  tasm.std(inst.arg1->fract());  // 5
  tasm.std(inst.arg1->sbyte());  // 4
  tasm.ldab("#1");               // 2
  tasm.stab(inst.arg1->lbyte()); // 4
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt(InstOne &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#1");
  tasm.staa(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt(InstOne &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std(inst.arg1->sbyte());
  tasm.ldab("#1");
  tasm.stab(inst.arg1->lbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt(InstOne &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#1");
  tasm.staa(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt(InstTrue &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#0");                // 3
  tasm.std(inst.arg1->fract());  // 5
  tasm.ldd("#-1");               // 3
  tasm.std(inst.arg1->lword());  // 5
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt(InstTrue &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#-1");               // 3
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.std(inst.arg1->lword());  // 5
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt(InstTrue &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt(InstTrue &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt(InstClr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#0");                // 3
  tasm.std(inst.arg1->fract());  // 5
  tasm.std(inst.arg1->lword());  // 5
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt(InstClr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#0");                // 3
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.std(inst.arg1->lword());  // 5
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt(InstClr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt(InstClr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.inc(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->hbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.inc(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->hbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.inc(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->hbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.inc(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->hbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.inc(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->hbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.inc(inst.arg1->lbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->hbyte());
  tasm.bne("_rts");
  tasm.inc(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.addd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstInc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.addd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstDec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt(InstNeg &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.jmp("negx");
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt(InstNeg &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.jmp("negxi");
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt(InstNeg &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp("negx");
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt(InstNeg &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp("negxi");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstNeg &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("negxi");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstNeg &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstNeg &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("negx");
  return tasm.source();
}
std::string CoreImplementation::regFlt_extFlt(InstNeg &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstCom &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.com(inst.arg1->lbyte());
  tasm.com(inst.arg1->hbyte());
  tasm.com(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstCom &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.comb();
  tasm.coma();
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.comb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstSgn &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.bmi("_neg");
  tasm.bne("_pos");
  tasm.ldd(inst.arg2->lword());
  tasm.bne("_pos");
  tasm.ldd("#0");
  tasm.stab(inst.arg1->lbyte());
  tasm.bra("_done");
  tasm.label("_pos");
  tasm.ldd("#1");
  tasm.stab(inst.arg1->lbyte());
  tasm.clrb();
  tasm.bra("_done");
  tasm.label("_neg");
  tasm.ldd("#-1");
  tasm.stab(inst.arg1->lbyte());
  tasm.label("_done");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt(InstSgn &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.bmi("_neg");
  tasm.bne("_pos");
  tasm.ldd(inst.arg2->lword());
  tasm.bne("_pos");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_pos");
  tasm.ldd("#0");
  tasm.stab(inst.arg1->lbyte());
  tasm.bra("_done");
  tasm.label("_pos");
  tasm.ldd("#1");
  tasm.stab(inst.arg1->lbyte());
  tasm.clrb();
  tasm.bra("_done");
  tasm.label("_neg");
  tasm.ldd("#-1");
  tasm.stab(inst.arg1->lbyte());
  tasm.label("_done");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstSgn &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.bmi("_neg");
  tasm.bne("_pos");
  tasm.ldd(inst.arg2->lword());
  tasm.bne("_pos");
  tasm.ldd("#0");
  tasm.stab(inst.arg1->lbyte());
  tasm.bra("_done");
  tasm.label("_pos");
  tasm.ldd("#1");
  tasm.stab(inst.arg1->lbyte());
  tasm.clrb();
  tasm.bra("_done");
  tasm.label("_neg");
  tasm.ldd("#-1");
  tasm.stab(inst.arg1->lbyte());
  tasm.label("_done");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt(InstSgn &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.bmi("_neg");
  tasm.bne("_pos");
  tasm.ldd(inst.arg2->lword());
  tasm.bne("_pos");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_pos");
  tasm.ldd("#0");
  tasm.stab(inst.arg1->lbyte());
  tasm.bra("_done");
  tasm.label("_pos");
  tasm.ldd("#1");
  tasm.stab(inst.arg1->lbyte());
  tasm.clrb();
  tasm.bra("_done");
  tasm.label("_neg");
  tasm.ldd("#-1");
  tasm.stab(inst.arg1->lbyte());
  tasm.label("_done");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstAbs &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bpl("_rts");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("negx");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstAbs &inst) {
  inst.dependencies.insert("mdnegx");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bpl("_rts");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("negxi");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstAbs &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->sbyte());
  tasm.bpl("_copy");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_copy");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstAbs &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->sbyte());
  tasm.bpl("_copy");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_copy");
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstFract &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstFract &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstFract &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstFract &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstDbl &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.lsl("4,x");
  tasm.rol("3,x");
  tasm.rol("2,x");
  tasm.rol("1,x");
  tasm.rol("0,x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstDbl &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.rol("2,x");
  tasm.rol("1,x");
  tasm.rol("0,x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstDbl &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.lsld();
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.rolb();
  tasm.rola();
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.rolb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstDbl &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.lsld();
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.rolb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstSq &inst) {
  inst.dependencies.insert("mdx2arg");
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jsr("x2arg");
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstSq &inst) {
  inst.dependencies.insert("mdx2arg");
  inst.dependencies.insert("mdmulint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jsr("x2arg");
  tasm.jmp("mulintx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstSq &inst) {
  inst.dependencies.insert("mdx2arg");
  inst.dependencies.insert("mdmulflt");
  inst.dependencies.insert("mdtmp2xf");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("x2arg");
  tasm.jsr("mulfltt");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("tmp2xf");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstSq &inst) {
  inst.dependencies.insert("mdx2arg");
  inst.dependencies.insert("mdmulint");
  inst.dependencies.insert("mdtmp2xi");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("x2arg");
  tasm.jsr("mulint");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("tmp2xi");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstOr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.orab(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstOr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.orab(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstOr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.orab(inst.arg2->lbyte());
  tasm.oraa(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstOr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.orab(inst.arg2->lbyte());
  tasm.oraa(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstOr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->lword());
  tasm.orab(inst.arg2->lbyte());
  tasm.oraa(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.orab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstOr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->lword());
  tasm.orab(inst.arg2->lbyte());
  tasm.oraa(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.orab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstAnd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.andb(inst.arg2->lbyte());
  tasm.clra();
  tasm.std(inst.arg1->lword());
  tasm.staa(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstAnd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.andb(inst.arg2->lbyte());
  tasm.stab(inst.arg2->lbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstAnd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.andb(inst.arg2->lbyte());
  tasm.anda(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.clr(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstAnd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.andb(inst.arg2->lbyte());
  tasm.anda(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstAnd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->lword());
  tasm.andb(inst.arg2->lbyte());
  tasm.anda(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.andb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstAnd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->lword());
  tasm.andb(inst.arg2->lbyte());
  tasm.anda(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.andb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte(InstIRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.staa("tmp1+1");
  tasm.std("tmp2");
  tasm.jsr("irnd");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord(InstIRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clr("tmp1+1");
  tasm.std("tmp2");
  tasm.jsr("irnd");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posByte(InstRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.staa("tmp1+1");
  tasm.std("tmp2");

  tasm.jsr("rnd");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negByte(InstRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.staa("tmp1+1");
  tasm.std("tmp2");
  tasm.jsr("rnd");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posWord(InstRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clr("tmp1+1");
  tasm.std("tmp2");

  tasm.jsr("rnd");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negWord(InstRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp2");
  tasm.ldab("#-1");
  tasm.stab("tmp1+1");

  tasm.jsr("rnd");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.bmi("_neg");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.beq("_flt");
  tasm.jsr("irnd");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.rts();

  tasm.label("_neg");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.label("_flt");
  tasm.jsr("rnd");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extInt(InstRnd &inst) {
  inst.dependencies.insert("mdrnd");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.bmi("_neg");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.beq("_flt");
  tasm.jsr("irnd");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.rts();

  tasm.label("_neg");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.label("_flt");
  tasm.jsr("rnd");
  tasm.std(inst.arg1->fract());
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstInv &inst) {
  inst.dependencies.insert("mdinvflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("invflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstInv &inst) {
  inst.dependencies.insert("mdinvflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg2->fract());
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("invflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstHlf &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.asr("0,x");
  tasm.ror("1,x");
  tasm.ror("2,x");
  tasm.ror("3,x");
  tasm.ror("4,x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstHlf &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.asr(inst.arg1->sbyte());
  tasm.ror(inst.arg1->hbyte());
  tasm.ror(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.rora();
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstHlf &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.asrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.rora();
  tasm.rorb();
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.rora();
  tasm.rorb();
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extInt(InstHlf &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.asrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.rora();
  tasm.rorb();
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.rora();
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstSqr &inst) {
  inst.dependencies.insert("mdsqr");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("sqr");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstSqr &inst) {
  inst.dependencies.insert("mdsqr");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("sqr");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstExp &inst) {
  inst.dependencies.insert("mdexp");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("exp");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstExp &inst) {
  inst.dependencies.insert("mdexp");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("exp");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstLog &inst) {
  inst.dependencies.insert("mdlog");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("log");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstLog &inst) {
  inst.dependencies.insert("mdlog");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("log");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstSin &inst) {
  inst.dependencies.insert("mdsin");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("sin");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstSin &inst) {
  inst.dependencies.insert("mdsin");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("sin");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstCos &inst) {
  inst.dependencies.insert("mdcos");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("cos");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstCos &inst) {
  inst.dependencies.insert("mdcos");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("cos");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt(InstTan &inst) {
  inst.dependencies.insert("mdtan");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("tan");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstTan &inst) {
  inst.dependencies.insert("mdtan");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("tan");
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr(InstAsc &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.beq("_fc_error");
  tasm.ldx(inst.arg2->lword());
  tasm.ldab(",x");
  tasm.jsr("strrel");
  tasm.label("_null");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr(InstAsc &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.beq("_fc_error");
  tasm.ldx(inst.arg2->lword());
  tasm.ldab(",x");
  tasm.label("_null");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr(InstLen &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.ldx(inst.arg2->lword());
  tasm.jsr("strrel");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr(InstLen &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_regInt(InstChr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#$0100+(charpage>>8)");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_extInt(InstChr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#$0100+(charpage>>8)");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_regInt(InstStr &inst) {
  inst.dependencies.insert("mdstrflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte()); // store length
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_regFlt(InstStr &inst) {
  inst.dependencies.insert("mdstrflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->fract());
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte()); // store length
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_extInt(InstStr &inst) {
  inst.dependencies.insert("mdstrflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd("#0");
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte()); // store length
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_extFlt(InstStr &inst) {
  inst.dependencies.insert("mdstrflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->fract());
  tasm.std("tmp3");
  tasm.jsr("strflt");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.stab(inst.arg1->sbyte()); // store length
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regStr(InstVal &inst) {
  inst.dependencies.insert("mdstrval");
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg2->sbyte());
  tasm.jsr("strval");
  tasm.ldx(inst.arg2->lword());
  tasm.jsr("strrel");
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldd("tmp3");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extStr(InstVal &inst) {
  inst.dependencies.insert("mdstrval");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("strval");
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldd("tmp3");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_regInt(InstLeft &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->sbyte());
  tasm.beq("_ok");
  tasm.bmi("_fc_error");
  tasm.bne("_rts");
  tasm.label("_ok");
  tasm.ldab(inst.arg3->lbyte());
  tasm.beq("_zero");
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_extInt(InstLeft &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->sbyte());
  tasm.beq("_ok");
  tasm.bmi("_fc_error");
  tasm.bne("_rts");
  tasm.label("_ok");
  tasm.ldab(inst.arg3->lbyte());
  tasm.beq("_zero");
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_posByte(InstLeft &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.tstb();
  tasm.beq("_zero");
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_regInt(InstMid &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->sbyte());
  tasm.beq("_ok");
  tasm.bmi("_fc_error");
  tasm.bne("_zero");
  tasm.label("_ok");
  tasm.ldab(inst.arg3->lbyte());
  tasm.beq("_fc_error");
  tasm.ldab(inst.arg1->sbyte());
  tasm.incb();
  tasm.subb(inst.arg3->lbyte());
  tasm.bls("_zero");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg3->lword());
  tasm.subd("#1");
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_extInt(InstMid &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->sbyte());
  tasm.beq("_ok");
  tasm.bmi("_fc_error");
  tasm.bne("_zero");
  tasm.label("_ok");
  tasm.ldab(inst.arg3->lbyte());
  tasm.beq("_fc_error");
  tasm.ldab(inst.arg1->sbyte());
  tasm.incb();
  tasm.subb(inst.arg3->lbyte());
  tasm.bls("_zero");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg3->lword());
  tasm.subd("#1");
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_posByte(InstMid &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.tstb();
  tasm.beq("_fc_error");
  tasm.ldaa(inst.arg1->sbyte());
  tasm.inca();
  tasm.sba();
  tasm.bls("_zero");
  tasm.staa(inst.arg1->sbyte());
  tasm.clra();
  tasm.addd(inst.arg1->lword());
  tasm.subd("#1");
  tasm.std(inst.arg1->lword());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_regInt(InstMidT &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("5+" + inst.arg1->sbyte());
  tasm.beq("_ok");
  tasm.bmi("_fc_error");
  tasm.bne("_zero");
  tasm.label("_ok");
  tasm.ldab("5+" + inst.arg1->lbyte());
  tasm.beq("_fc_error");
  tasm.ldab(inst.arg1->sbyte());
  tasm.subb("5+" + inst.arg1->lbyte());
  tasm.blo("_zero");
  tasm.incb();
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("5+" + inst.arg1->lword());
  tasm.subd("#1");
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->lbyte());
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_extInt(InstMidT &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("5+" + inst.arg1->sbyte());
  tasm.beq("_ok");
  tasm.bmi("_fc_error");
  tasm.bne("_zero");
  tasm.label("_ok");
  tasm.ldab("5+" + inst.arg1->lbyte());
  tasm.beq("_fc_error");
  tasm.ldab(inst.arg1->sbyte());
  tasm.subb("5+" + inst.arg1->lbyte());
  tasm.blo("_zero");
  tasm.incb();
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("5+" + inst.arg1->lword());
  tasm.subd("#1");
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->lbyte());
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_posByte(InstMidT &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd("5+" + inst.arg1->sbyte());
  tasm.beq("_ok");
  tasm.bmi("_fc_error");
  tasm.bne("_zero");
  tasm.label("_ok");
  tasm.ldab("5+" + inst.arg1->lbyte());
  tasm.beq("_fc_error");
  tasm.ldab(inst.arg1->sbyte());
  tasm.subb("5+" + inst.arg1->lbyte());
  tasm.blo("_zero");
  tasm.incb();
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("5+" + inst.arg1->lword());
  tasm.subd("#1");
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  tasm.label("_fc_error");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_regInt(InstRight &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->sbyte());
  tasm.bne("_rts");
  tasm.ldab(inst.arg1->sbyte());
  tasm.subb(inst.arg3->lbyte());
  tasm.bls("_rts");
  tasm.clra();
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->lbyte());
  tasm.beq("_zero");
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_extInt(InstRight &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->sbyte());
  tasm.bne("_rts");
  tasm.ldab(inst.arg1->sbyte());
  tasm.subb(inst.arg3->lbyte());
  tasm.bls("_rts");
  tasm.clra();
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->lbyte());
  tasm.beq("_zero");
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_posByte(InstRight &inst) {
  inst.dependencies.insert("mdstrrel");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.tstb();
  tasm.beq("_zero");
  tasm.stab("tmp1");
  tasm.ldab(inst.arg1->sbyte());
  tasm.subb("tmp1");
  tasm.bls("_rts");
  tasm.clra();
  tasm.addd(inst.arg1->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1");
  tasm.cmpb(inst.arg1->sbyte());
  tasm.bhs("_rts");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_zero");
  tasm.pshx();
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("strrel");
  tasm.pulx();
  tasm.ldd("#$0100");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.incb();
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regFlt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extFlt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb("#-1");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regInt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extInt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regFlt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extFlt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.incb();
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negByte(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negWord(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb("#-1");
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexFlt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg3->fract());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexFlt(InstLdEq &inst) {
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg1->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_regStr(InstLdEq &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldx("#" + inst.arg3->sbyte());
  tasm.jsr("streqx");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_extStr(InstLdEq &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.jsr("streqx");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexStr(InstLdEq &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgeteq");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp3");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldx("tmp3");
  tasm.jsr("streqx");
  tasm.jsr("geteq");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_immStr(InstLdEq &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_extStr_immStr(InstLdEq &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_regInt_posByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.incb();
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regFlt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extFlt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb("#-1");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regInt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extInt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regFlt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extFlt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.incb();
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negByte(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.cmpb(inst.arg2->lbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->sbyte());
  tasm.subd("#-1");
  tasm.bne("_done");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negWord(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.bne("_done");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.cmpb("#-1");
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexFlt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.bne("_done");
  tasm.ldd(inst.arg3->fract());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.bne("_done");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexFlt(InstLdNe &inst) {
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.bne("_done");
  tasm.ldd(inst.arg1->lword());
  tasm.subd(inst.arg3->lword());
  tasm.bne("_done");
  tasm.ldab(inst.arg1->sbyte());
  tasm.cmpb(inst.arg3->sbyte());
  tasm.label("_done");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_regStr(InstLdNe &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldx("#" + inst.arg3->sbyte());
  tasm.jsr("streqx");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_extStr(InstLdNe &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.jsr("streqx");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexStr(InstLdNe &inst) {
  inst.dependencies.insert("mdstreqx");
  inst.dependencies.insert("mdgetne");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp3");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldx("tmp3");
  tasm.jsr("streqx");
  tasm.jsr("getne");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_immStr(InstLdNe &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_extStr_immStr(InstLdNe &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_regInt_posByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negByte(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negWord(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg1->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg1->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subb(inst.arg3->lword());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_regInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.clrb();
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_regFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_extInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_extInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_extInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subb(inst.arg3->lword());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_extInt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_extFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.clrb();
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_extFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_extFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_extFlt(InstLdLt &inst) {
  inst.dependencies.insert("mdgetlt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getlt");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_regStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrlo");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("tmp1+1");
  tasm.jsr("strlo");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_extStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrlox");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jsr("strlox");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_immStr(InstLdLt &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_extStr_regStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrlo");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("tmp1+1");
  tasm.jsr("strlo");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexStr(InstLdLt &inst) {
  inst.dependencies.insert("mdstrlox");
  inst.dependencies.insert("mdgetlo");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldx("tmp1");
  tasm.jsr("strlox");
  tasm.jsr("getlo");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_immStr(InstLdLt &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immStr_regStr(InstLdLt &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immStr_extStr(InstLdLt &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_regInt_posByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negByte(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_posWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_negWord(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg1->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extFlt_dexFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.ldd(inst.arg1->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subb(inst.arg3->lword());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_regInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.clrb();
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_regFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_extInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_extInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_extInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subb(inst.arg3->lword());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_extInt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_extFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.clrb();
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_extFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_extFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_extFlt(InstLdGe &inst) {
  inst.dependencies.insert("mdgetge");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.pulb();
  tasm.sbcb(inst.arg3->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.jsr("getge");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_regStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrlo");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("tmp1+1");
  tasm.jsr("strlo");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_extStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrlox");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jsr("strlox");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_immStr(InstLdGe &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_extStr_regStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrlo");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("tmp1+1");
  tasm.jsr("strlo");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_dexStr(InstLdGe &inst) {
  inst.dependencies.insert("mdstrlox");
  inst.dependencies.insert("mdgeths");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldx("tmp1");
  tasm.jsr("strlox");
  tasm.jsr("geths");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extStr_immStr(InstLdGe &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immStr_regStr(InstLdGe &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immStr_extStr(InstLdGe &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_regInt(InstPeek &inst) {
  inst.dependencies.insert("mdpeek");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg2->lword());
  tasm.jsr("peek");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstPeek &inst) {
  inst.dependencies.insert("mdpeek");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg2->lword());
  tasm.jsr("peek");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord(InstPeek &inst) {
  inst.dependencies.insert("mdpeek");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldx("tmp1");
  tasm.jsr("peek");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte(InstPeek &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldx("tmp1");
  tasm.ldab(",x");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstPeekWord &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg2->lword());
  tasm.ldd(",x");
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstPeekWord &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg2->lword());
  tasm.ldd(",x");
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord(InstPeekWord &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldx("tmp1");
  tasm.ldd(",x");
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte(InstPeekWord &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#0");
  tasm.abx();
  tasm.ldd(",x");
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::posByte_regInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx("tmp1");
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::posByte_extInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx("tmp1");
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::posWord_regInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx("tmp1");
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::posWord_extInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx("tmp1");
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg1->lword());
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx(inst.arg1->lword());
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx(inst.arg1->lword());
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_posByte(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg1->lword());
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_regInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx(inst.arg1->lword());
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::dexInt_extInt(InstPoke &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->lbyte());
  tasm.ldx("tmp1");
  tasm.ldx(inst.arg1->lword());
  tasm.stab(",x");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_posByte(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.clra();
  tasm.staa(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_negByte(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldaa("#-1");
  tasm.staa(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_posWord(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.clr(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_negWord(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldaa("#-1");
  tasm.staa(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_regInt(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_posByte(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.clra();
  tasm.staa(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.clrb();
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_negByte(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldaa("#-1");
  tasm.staa(inst.arg1->sbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_posWord(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_negWord(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldaa("#-1");
  tasm.staa(inst.arg1->sbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_regInt(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_regFlt(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::dexInt_extInt(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("letptr");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::dexFlt_extInt(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("letptr");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("letptr");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::dexFlt_extFlt(InstFor &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("letptr");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("letptr");
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt(InstForOne &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd("#1");                // 3
  tasm.staa(inst.arg1->sbyte()); // 4
  tasm.std(inst.arg1->lword());  // 5
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt(InstForOne &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd("#0");                // 3
  tasm.std(inst.arg1->fract());  // 5
  tasm.std(inst.arg1->sbyte());  // 4
  tasm.ldab("#1");               // 2
  tasm.stab(inst.arg1->lbyte()); // 4
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt(InstForTrue &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd("#-1");               // 3
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.std(inst.arg1->lword());  // 5
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt(InstForTrue &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd("#0");                // 3
  tasm.std(inst.arg1->fract());  // 5
  tasm.ldd("#-1");               // 3
  tasm.std(inst.arg1->lword());  // 5
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt(InstForClr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd("#0");                // 3
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.std(inst.arg1->lword());  // 5
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt(InstForClr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stx("letptr");
  tasm.ldd("#0");                // 3
  tasm.std(inst.arg1->fract());  // 5
  tasm.std(inst.arg1->lword());  // 5
  tasm.stab(inst.arg1->sbyte()); // 4
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::ptrInt_posByte(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrInt_negByte(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrInt_posWord(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrInt_negWord(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrInt_regInt(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrInt_extInt(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_posByte(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_negByte(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_posWord(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_negWord(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_regInt(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_extInt(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_regFlt(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_extFlt(InstTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrInt_regInt(InstStep &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_regInt(InstStep &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::ptrFlt_regFlt(InstStep &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::extInt(InstNextVar &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::extFlt(InstNextVar &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::inherent(InstNext &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immLbls(InstOnGoTo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_immLbls(InstOnGoSub &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::inherent(InstReturn &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::immStr(InstPr &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::inherent(InstPrComma &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr("R_MKTAB");
  tasm.beq("_screen");
  tasm.ldab("DP_LPOS");
  tasm.cmpb("DP_LTAB");
  tasm.blo("_nxttab");
  tasm.jmp("R_ENTER");
  tasm.label("_screen");
  tasm.ldab("DP_LPOS");
  tasm.label("_nxttab");
  tasm.subb("DP_TABW");
  tasm.bhs("_nxttab");
  tasm.label("_nxtspc");
  tasm.jsr("R_SPACE");
  tasm.incb();
  tasm.beq("_nxtspc");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr(InstPr &inst) {
  inst.dependencies.insert("mdstrrel");
  inst.dependencies.insert("mdprint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg1->sbyte());
  tasm.beq("_rts");
  tasm.ldx(inst.arg1->lword());
  tasm.jsr("print");
  tasm.ldx(inst.arg1->lword());
  tasm.jmp("strrel");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extStr(InstPr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  inst.dependencies.insert("mdprint");

  tasm.ldab(inst.arg1->sbyte());
  tasm.beq("_rts");
  tasm.ldx(inst.arg1->lword());
  tasm.jmp("print");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::posByte(InstPrAt &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#$40");
  tasm.std("M_CRSR");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::posWord(InstPrAt &inst) {
  inst.dependencies.insert("mdprat");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp("prat");
  return tasm.source();
}

std::string CoreImplementation::regInt(InstPrAt &inst) {
  inst.dependencies.insert("mdprat");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_fcerror");
  tasm.ldd(inst.arg1->lword());
  tasm.jmp("prat");
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::extInt(InstPrAt &inst) {
  inst.dependencies.insert("mdprat");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bne("_fcerror");
  tasm.ldd(inst.arg1->lword());
  tasm.jmp("prat");
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::regInt(InstPrTab &inst) {
  inst.dependencies.insert("mdprtab");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg1->lbyte());
  tasm.jmp("prtab");
  return tasm.source();
}

std::string CoreImplementation::extInt(InstPrTab &inst) {
  inst.dependencies.insert("mdprtab");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg1->lbyte());
  tasm.jmp("prtab");
  return tasm.source();
}

std::string CoreImplementation::posByte(InstPrTab &inst) {
  inst.dependencies.insert("mdprtab");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp("prtab");
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte(InstSet &inst) {
  inst.dependencies.insert("mdset");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->lbyte());
  tasm.jmp("set");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstSet &inst) {
  inst.dependencies.insert("mdset");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->lbyte());
  tasm.ldab(inst.arg1->lbyte());
  tasm.jmp("set");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstSet &inst) {
  inst.dependencies.insert("mdset");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->lbyte());
  tasm.ldab(inst.arg1->lbyte());
  tasm.jmp("set");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstSetC &inst) {
  inst.dependencies.insert("mdsetc");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.pshb();
  tasm.ldaa(inst.arg2->lbyte());
  tasm.ldab(inst.arg1->lbyte());
  tasm.jsr("getxym");
  tasm.pulb();
  tasm.jmp("setc");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstSetC &inst) {
  inst.dependencies.insert("mdsetc");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->lbyte());
  tasm.ldab(inst.arg1->lbyte());
  tasm.jsr("getxym");
  tasm.ldab(inst.arg3->lbyte());
  tasm.jmp("setc");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstSetC &inst) {
  inst.dependencies.insert("mdsetc");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->lbyte());
  tasm.pshb();
  tasm.ldaa(inst.arg2->lbyte());
  tasm.ldab(inst.arg1->lbyte());
  tasm.jsr("getxym");
  tasm.pulb();
  tasm.jmp("setc");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstPoint &inst) {
  inst.dependencies.insert("mdpoint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg3->lbyte());
  tasm.ldab(inst.arg2->lbyte());
  tasm.jsr("point");
  tasm.stab(inst.arg1->lbyte());
  tasm.tab();
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstPoint &inst) {
  inst.dependencies.insert("mdpoint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg3->lbyte());
  tasm.ldab(inst.arg2->lbyte());
  tasm.jsr("point");
  tasm.stab(inst.arg1->lbyte());
  tasm.tab();
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstPoint &inst) {
  inst.dependencies.insert("mdpoint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.tba();
  tasm.ldab(inst.arg2->lbyte());
  tasm.jsr("point");
  tasm.stab(inst.arg1->lbyte());
  tasm.tab();
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte(InstReset &inst) {
  inst.dependencies.insert("mdset");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.tba();
  tasm.ldab(inst.arg1->lbyte());
  tasm.jsr("getxym");
  tasm.jmp("R_CLRPX");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstReset &inst) {
  inst.dependencies.insert("mdset");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->lbyte());
  tasm.ldab(inst.arg1->lbyte());
  tasm.jsr("getxym");
  tasm.jmp("R_CLRPX");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstReset &inst) {
  inst.dependencies.insert("mdset");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg2->lbyte());
  tasm.ldab(inst.arg1->lbyte());
  tasm.jsr("getxym");
  tasm.jmp("R_CLRPX");
  return tasm.source();
}

std::string CoreImplementation::inherent(InstCls &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp("R_CLS");
  return tasm.source();
}

std::string CoreImplementation::posByte(InstClsN &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp("R_CLSN");
  return tasm.source();
}

std::string CoreImplementation::regInt(InstClsN &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->sbyte());
  tasm.bne("_fcerror");
  tasm.ldab(inst.arg1->lbyte());
  tasm.jmp("R_CLSN");
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::extInt(InstClsN &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->sbyte());
  tasm.bne("_fcerror");
  tasm.ldab(inst.arg1->lbyte());
  tasm.jmp("R_CLSN");
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::posByte(InstExec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.std("tmp1");
  tasm.ldx("tmp1");
  tasm.jmp(",x");
  return tasm.source();
}

std::string CoreImplementation::posWord(InstExec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldx("tmp1");
  tasm.jmp(",x");
  return tasm.source();
}

std::string CoreImplementation::regInt(InstExec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.tst(inst.arg1->sbyte());
  tasm.bne("_fcerror");
  tasm.ldd(inst.arg1->lword());
  tasm.std("tmp1");
  tasm.ldx("tmp1");
  tasm.jmp(",x");
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::extInt(InstExec &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg1->sbyte());
  tasm.bne("_fcerror");
  tasm.ldab(inst.arg1->lbyte());
  tasm.jmp("R_CLSN");
  tasm.label("_fcerror");
  tasm.ldab("#FC_ERROR");
  tasm.jmp("error");
  return tasm.source();
}

std::string CoreImplementation::inherent(InstInputBuf &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::extFlt(InstReadBuf &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::indFlt(InstReadBuf &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::extStr(InstReadBuf &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::indStr(InstReadBuf &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::inherent(InstIgnoreExtra &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("inptptr");
  tasm.ldaa(",x");
  tasm.beq("_rts");
  tasm.ldx("#R_EXTRA");
  tasm.ldab("#15");
  tasm.jmp("print");
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt(InstRead &inst) {
  std::string callLabel = inst.pureByte && inst.pureUnsigned   ? "rpubyte"
                          : inst.pureByte                      ? "rpsbyte"
                          : inst.pureWord && inst.pureUnsigned ? "rpuword"
                          : inst.pureWord                      ? "rpsword"
                          : inst.pureNumeric                   ? "rpnumbr"
                                                               : "rnstrng";

  inst.dependencies.insert("md" + callLabel);

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.jsr(callLabel);
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt(InstRead &inst) {
  std::string callLabel = inst.pureByte && inst.pureUnsigned   ? "rpubyte"
                          : inst.pureByte                      ? "rpsbyte"
                          : inst.pureWord && inst.pureUnsigned ? "rpuword"
                          : inst.pureWord                      ? "rpsword"
                          : inst.pureNumeric                   ? "rpnumbr"
                                                               : "rnstrng";

  inst.dependencies.insert("md" + callLabel);

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.jsr(callLabel);
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldd("tmp3");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indStr(InstRead &inst) {
  std::string callLabel = inst.pureByte && inst.pureUnsigned   ? "rsubyte"
                          : inst.pureByte                      ? "rssbyte"
                          : inst.pureWord && inst.pureUnsigned ? "rsuword"
                          : inst.pureWord                      ? "rssword"
                          : inst.pureNumeric                   ? "rsnumbr"
                                                               : "rsstrng";

  inst.dependencies.insert("md" + callLabel);

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.jmp(callLabel);
  return tasm.source();
}

std::string CoreImplementation::extInt(InstRead &inst) {
  std::string callLabel = inst.pureByte && inst.pureUnsigned   ? "rpubyte"
                          : inst.pureByte                      ? "rpsbyte"
                          : inst.pureWord && inst.pureUnsigned ? "rpuword"
                          : inst.pureWord                      ? "rpsword"
                          : inst.pureNumeric                   ? "rpnumbr"
                                                               : "rnstrng";
  inst.dependencies.insert("md" + callLabel);

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr(callLabel);
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt(InstRead &inst) {
  std::string callLabel = inst.pureByte && inst.pureUnsigned   ? "rpubyte"
                          : inst.pureByte                      ? "rpsbyte"
                          : inst.pureWord && inst.pureUnsigned ? "rpuword"
                          : inst.pureWord                      ? "rpsword"
                          : inst.pureNumeric                   ? "rpnumbr"
                                                               : "rnstrng";

  inst.dependencies.insert("md" + callLabel);

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jsr(callLabel);
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldd("tmp3");
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extStr(InstRead &inst) {
  std::string callLabel = inst.pureByte && inst.pureUnsigned   ? "rsubyte"
                          : inst.pureByte                      ? "rssbyte"
                          : inst.pureWord && inst.pureUnsigned ? "rsuword"
                          : inst.pureWord                      ? "rssword"
                          : inst.pureNumeric                   ? "rsnumbr"
                                                               : "rsstrng";

  inst.dependencies.insert("md" + callLabel);

  Assembler tasm;
  preamble(tasm, inst);
  tasm.jmp(callLabel);
  return tasm.source();
}

std::string CoreImplementation::inherent(InstRestore &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#startdata");
  tasm.stx("DP_DATA");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstSound &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg1->lbyte());
  tasm.ldab(inst.arg2->lbyte());
  tasm.jmp("R_SOUND");
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_regFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->fract());
  tasm.addd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.adcb(inst.arg3->lbyte());
  tasm.adca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_regInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_regInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_regFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.addd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.adcb(inst.arg3->lbyte());
  tasm.adca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_regInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_regInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.addd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.adcb(inst.arg3->lbyte());
  tasm.adca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.addd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.adcb(inst.arg3->lbyte());
  tasm.adca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negByte(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negWord(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posByte_extFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.adcb(inst.arg3->hbyte());
  tasm.adca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negByte_extFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.adcb(inst.arg3->hbyte());
  tasm.adca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posWord_extFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg3->hbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negWord_extFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg3->hbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_extInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.adcb(inst.arg3->hbyte());
  tasm.adca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_extInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.adcb(inst.arg3->hbyte());
  tasm.adca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_extInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.adcb(inst.arg3->hbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_extInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.adcb(inst.arg3->hbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_dexFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.addd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg1->lword());
  tasm.adcb(inst.arg3->lbyte());
  tasm.adca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_dexInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extInt_dexFlt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstAdd &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.addd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.adcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_regFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_regInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_regInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_regFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_regInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_regInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->lword());
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.sbcb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#0");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negByte(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subb("tmp1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negWord(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posByte_extFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negByte_extFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posWord_extFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negWord_extFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_extInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_extInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subb(inst.arg3->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg3->hbyte());
  tasm.sbca(inst.arg3->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_extInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_extInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_dexFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd(inst.arg2->fract());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg1->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_dexInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extInt_dexFlt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldd("#0");
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg1->lword());
  tasm.sbcb(inst.arg3->lbyte());
  tasm.sbca(inst.arg3->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_dexInt(InstSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldd(inst.arg2->lword());
  tasm.ldx("tmp1");
  tasm.subd(inst.arg3->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg1->sbyte());
  tasm.sbcb(inst.arg3->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_regFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg3->fract());
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_regInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indFlt_indFlt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_regInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldd(inst.arg3->lword());
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.clra();
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.ldaa("#-1");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::indInt_indInt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("letptr");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_regFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_regInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extFlt_extFlt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_regInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->lword());
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::extInt_extInt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg2->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lword());
  tasm.sbca(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->lword());
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg3->lword());
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#-1");
  tasm.sbcb(inst.arg2->hbyte());
  tasm.sbca(inst.arg2->sbyte());
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd("#0");
  tasm.subd(inst.arg2->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd("tmp1");
  tasm.sbcb(inst.arg2->lbyte());
  tasm.sbca(inst.arg2->hbyte());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negByte(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa("#-1");
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_posWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#0");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt_negWord(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.subd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab("#-1");
  tasm.sbcb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posByte_extFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab(inst.arg3->lbyte());
  tasm.sbcb("tmp1");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd(inst.arg3->sbyte());
  tasm.sbcb("#0");
  tasm.sbca("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negByte_extFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldab(inst.arg3->lbyte());
  tasm.sbcb("tmp1");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd(inst.arg3->sbyte());
  tasm.sbcb("#-1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_posWord_extFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_negWord_extFlt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg3->fract());
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg3->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posByte_extInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldab(inst.arg3->lbyte());
  tasm.subb("tmp1");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd(inst.arg3->sbyte());
  tasm.sbcb("#0");
  tasm.sbca("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negByte_extInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("tmp1");
  tasm.ldab(inst.arg3->lbyte());
  tasm.subb("tmp1");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd(inst.arg3->sbyte());
  tasm.sbcb("#-1");
  tasm.sbca("#-1");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord_extInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg3->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb("#0");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_negWord_extInt(InstRSub &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldd(inst.arg3->lword());
  tasm.subd("tmp1");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg3->sbyte());
  tasm.sbcb("#-1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regFlt(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extFlt(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regInt(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extInt(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posByte(InstMul &inst) {
  inst.dependencies.insert("mdmulbytf");
  inst.dependencies.insert("mdtmp2xf");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jsr("mulbytf");
  tasm.jmp("tmp2xf");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstMul &inst) {
  inst.dependencies.insert("mdmulbytf");
  inst.dependencies.insert("mdntmp2xf");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.negb();
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jsr("mulbytf");
  tasm.jmp("ntmp2xf");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posWord(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.stab("0+argv");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negWord(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#255");
  tasm.stab("0+argv");
  tasm.tab();
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regFlt(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extFlt(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstMul &inst) {
  inst.dependencies.insert("mdmulint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulintx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstMul &inst) {
  inst.dependencies.insert("mdmulint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulintx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstMul &inst) {
  inst.dependencies.insert("mdmulbyti");
  inst.dependencies.insert("mdtmp2xi");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jsr("mulbyti");
  tasm.jmp("tmp2xi");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstMul &inst) {
  inst.dependencies.insert("mdmulbyti");
  inst.dependencies.insert("mdntmp2xi");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.negb();
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jsr("mulbyti");
  tasm.jmp("ntmp2xi");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstMul &inst) {
  inst.dependencies.insert("mdmulint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.clrb();
  tasm.stab("0+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulintx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstMul &inst) {
  inst.dependencies.insert("mdmulint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldab("#-1");
  tasm.stab("0+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulintx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt(InstMul3 &inst) {
  inst.dependencies.insert("mdmul3f");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mul3f");
  return tasm.source();
}

std::string CoreImplementation::regFlt_extFlt(InstMul3 &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd(inst.arg2->fract());
  tasm.lsld();
  tasm.std("tmp3");
  tasm.ldd(inst.arg2->lword());
  tasm.rolb();
  tasm.rola();
  tasm.std("tmp2");
  tasm.ldab(inst.arg2->sbyte());
  tasm.rolb();
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->fract());
  tasm.addd("tmp3");
  tasm.std(inst.arg1->fract());
  tasm.ldd(inst.arg2->lword());
  tasm.adcb("tmp2+1");
  tasm.adca("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstMul3 &inst) {
  inst.dependencies.insert("mdmul3i");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mul3i");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstMul3 &inst) {

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.lsld();
  tasm.rol("tmp1+1");
  tasm.addd(inst.arg2->lword());
  tasm.std(inst.arg1->lword());
  tasm.ldab(inst.arg2->sbyte());
  tasm.adcb("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regFlt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extFlt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regInt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extInt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posByte(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#0");
  tasm.std("0+argv");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posWord(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.stab("0+argv");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negWord(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#255");
  tasm.stab("0+argv");
  tasm.tab();
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regFlt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extFlt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regInt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extInt(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_posByte(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#0");
  tasm.std("0+argv");
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_negByte(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_posWord(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.stab("0+argv");
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_negWord(InstDiv &inst) {
  inst.dependencies.insert("mddivflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#255");
  tasm.stab("0+argv");
  tasm.tab();
  tasm.std("3+argv");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("divflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regFlt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extFlt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_regInt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_extInt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posByte(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#0");
  tasm.std("0+argv");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negByte(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_posWord(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.stab("0+argv");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regFlt_negWord(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#255");
  tasm.stab("0+argv");
  tasm.tab();
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regFlt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extFlt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_regInt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_extInt(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#0");
  tasm.std("0+argv");
  tasm.std("3+argv");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.stab("0+argv");
  tasm.std("3+argv");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negWord(InstIDiv &inst) {
  inst.dependencies.insert("mddivflti");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#255");
  tasm.stab("0+argv");
  tasm.tab();
  tasm.std("3+argv");
  tasm.std(inst.arg1->sbyte() + "+3");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idivflt");
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstIDiv3 &inst) {
  inst.dependencies.insert("mdidiv35");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldd("#$AA03");
  tasm.jsr("idiv35");
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstIDiv3 &inst) {
  inst.dependencies.insert("mdidiv35");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldd("#$AA03");
  tasm.jsr("idiv35");
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstIDiv5 &inst) {
  inst.dependencies.insert("mdidiv35");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldd("#$CC05");
  tasm.jsr("idiv35");
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstIDiv5 &inst) {
  inst.dependencies.insert("mdidiv35");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("tmp1+1");
  tasm.ldd(inst.arg2->lword());
  tasm.std("tmp2");
  tasm.ldd("#$CC05");
  tasm.jsr("idiv35");
  tasm.ldd("tmp2");
  tasm.std(inst.arg1->lword());
  tasm.ldab("tmp1+1");
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstIDiv5S &inst) {
  inst.dependencies.insert("mdidiv5s");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("idiv5s");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regFlt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extFlt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_regInt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_extInt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posByte(InstPow &inst) {
  inst.dependencies.insert("mdpowfltn");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltn");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_posWord(InstPow &inst) {
  inst.dependencies.insert("mdpowfltn");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltn");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negWord(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldd("#255");
  tasm.stab("0+argv");
  tasm.tab();
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regFlt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extFlt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->fract());
  tasm.std("3+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_regInt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_extInt(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("1+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posByte(InstPow &inst) {
  inst.dependencies.insert("mdpowintn");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.clra();
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powintn");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_negByte(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_posWord(InstPow &inst) {
  inst.dependencies.insert("mdpowintn");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powintn");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regInt_negWord(InstPow &inst) {
  inst.dependencies.insert("mdpowflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("1+argv");
  tasm.ldab("#-1");
  tasm.stab("0+argv");
  tasm.ldd("#0");
  tasm.std(inst.arg1->fract());
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("powfltx");
  return tasm.source();
}

void CoreImplementation::preamble(Assembler & /*tasm*/,
                                  Instruction & /*inst*/) {}
