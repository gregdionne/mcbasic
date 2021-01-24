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
  tasm.stx("dataptr");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::inherent(InstBegin &inst) {
  inst.dependencies.insert("mdprint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("R_MCXID");
  tasm.cpx("#'h'*256+'C'");
  tasm.bne("_mcbasic");
  tasm.pulx();
  tasm.clrb();
  tasm.pshb();
  tasm.pshb();
  tasm.pshb();
  tasm.jmp(",x");
  tasm.labelText("_reqmsg", "\"?MICROCOLOR BASIC ROM REQUIRED\"");
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
  tasm.equ("OM_ERROR", "12");
  tasm.equ("BS_ERROR", "16");
  tasm.equ("DD_ERROR", "18");
  tasm.label("error");
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

std::string CoreImplementation::regInt_extInt(InstArrayVal1 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayVal1 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayVal1 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayVal2 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayVal2 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayVal2 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayVal3 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayVal3 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayVal3 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayVal4 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayVal4 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayVal4 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayVal5 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayVal5 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayVal5 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayRef1 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayRef1 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayRef1 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayRef2 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayRef2 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayRef2 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayRef3 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayRef3 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayRef3 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayRef4 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayRef4 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayRef4 &inst) {
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

std::string CoreImplementation::regInt_extInt(InstArrayRef5 &inst) {
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

std::string CoreImplementation::regInt_extFlt(InstArrayRef5 &inst) {
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

std::string CoreImplementation::regInt_extStr(InstArrayRef5 &inst) {
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
  tasm.jmp("shrint");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstShift &inst) {
  inst.dependencies.insert("mdshrflt");
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx("#" + inst.arg1->sbyte());
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
  tasm.ldab(inst.arg3->sbyte());
  tasm.addb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldab(inst.arg3->sbyte());
  tasm.ldx(inst.arg3->lword());
  tasm.jmp("strtmp");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_extStr(InstStrCat &inst) {
  inst.dependencies.insert("mdstrtmp");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg3->sbyte());
  tasm.addb(inst.arg2->sbyte());
  tasm.stab(inst.arg1->sbyte());
  tasm.ldab(inst.arg3->sbyte());
  tasm.ldx(inst.arg3->lword());
  tasm.jmp("strtmp");
  return tasm.source();
}

std::string CoreImplementation::regStr_regStr_immStr(InstStrCat &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regStr(InstInkey &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldd("#$0101");
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

std::string CoreImplementation::regInt_regInt(InstNeg &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.neg(inst.arg1->lbyte());
  tasm.ngc(inst.arg1->hbyte());
  tasm.ngc(inst.arg1->sbyte());
  tasm.rts();
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
  Assembler tasm;
  preamble(tasm, inst);
  tasm.neg(inst.arg1->lfrac());
  tasm.ngc(inst.arg1->hfrac());
  tasm.ngc(inst.arg1->lbyte());
  tasm.ngc(inst.arg1->hbyte());
  tasm.ngc(inst.arg1->sbyte());
  tasm.rts();
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
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bpl("_rts");
  tasm.neg(inst.arg1->lfrac());
  tasm.ngc(inst.arg1->hfrac());
  tasm.ngc(inst.arg1->lbyte());
  tasm.ngc(inst.arg1->hbyte());
  tasm.ngc(inst.arg1->sbyte());
  tasm.label("_rts");
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt(InstAbs &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldaa(inst.arg1->sbyte());
  tasm.bpl("_rts");
  tasm.neg(inst.arg1->lbyte());
  tasm.ngc(inst.arg1->hbyte());
  tasm.ngc(inst.arg1->sbyte());
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
  tasm.ldd("#$0101");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regStr_extInt(InstChr &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->lbyte());
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#$0101");
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

std::string CoreImplementation::regInt_regStr_immStr(InstLdEq &inst) {
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

std::string CoreImplementation::regInt_regStr_immStr(InstLdNe &inst) {
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

std::string CoreImplementation::regInt_regStr_regStr(InstLdLo &inst) {
  inst.dependencies.insert("mdstrlo");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg3->sbyte());
  tasm.jsr("strlo");
  tasm.blo("_1");
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_extStr(InstLdLo &inst) {
  inst.dependencies.insert("mdstrlox");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jsr("strlox");
  tasm.blo("_1");
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_immStr(InstLdLo &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_regStr_regStr(InstLdHs &inst) {
  inst.dependencies.insert("mdstrlox");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.ldd(inst.arg3->lword());
  tasm.std("tmp2");
  tasm.ldab(inst.arg3->sbyte());
  tasm.jsr("strlo");
  tasm.bhs("_1");
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_extStr(InstLdHs &inst) {
  inst.dependencies.insert("mdstrlox");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldab(inst.arg2->sbyte());
  tasm.stab("0+argv");
  tasm.ldd(inst.arg2->lword());
  tasm.std("1+argv");
  tasm.jsr("strlox");
  tasm.bhs("_1");
  tasm.ldd("#0");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  tasm.label("_1");
  tasm.ldd("#-1");
  tasm.std(inst.arg1->lword());
  tasm.stab(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_regStr_immStr(InstLdHs &inst) {
  return unimplemented(inst);
}

std::string CoreImplementation::regInt_regInt(InstPeek &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg2->lword());
  tasm.cpx("#M_IKEY");
  tasm.bne("_nostore"); // support PEEK(2) AND PEEK(17023) workflow
  tasm.jsr("R_KPOLL");
  tasm.beq("_nostore");
  tasm.staa("M_IKEY");
  tasm.label("_nostore");
  tasm.ldab(",x");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_extInt(InstPeek &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.ldx(inst.arg2->lword());
  tasm.cpx("#M_IKEY");
  tasm.bne("_nostore"); // support PEEK(2) AND PEEK(17023) workflow
  tasm.jsr("R_KPOLL");
  tasm.beq("_nostore");
  tasm.staa("M_IKEY");
  tasm.label("_nostore");
  tasm.ldab(",x");
  tasm.stab(inst.arg1->lbyte());
  tasm.ldd("#0");
  tasm.std(inst.arg1->sbyte());
  tasm.rts();
  return tasm.source();
}

std::string CoreImplementation::regInt_posWord(InstPeek &inst) {
  Assembler tasm;
  preamble(tasm, inst);
  tasm.std("tmp1");
  tasm.ldx("tmp1");
  tasm.cpx("#M_IKEY");
  tasm.bne("_nostore"); // support PEEK(2) AND PEEK(17023) workflow
  tasm.jsr("R_KPOLL");
  tasm.beq("_nostore");
  tasm.staa("M_IKEY");
  tasm.label("_nostore");
  tasm.ldab(",x");
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
  tasm.jsr("print");
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
  tasm.stx("dataptr");
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
  tasm.sbcb("tmp1");
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
  tasm.sbcb("tmp1");
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
  tasm.sbcb(inst.arg3->hbyte());
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
  tasm.sbcb(inst.arg3->hbyte());
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
  tasm.sbcb(inst.arg3->hbyte());
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
  tasm.sbcb(inst.arg3->hbyte());
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
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#0");
  tasm.std("0+argv");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
  return tasm.source();
}

std::string CoreImplementation::regFlt_regFlt_negByte(InstMul &inst) {
  inst.dependencies.insert("mdmulflt");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldd("#0");
  tasm.std("3+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulfltx");
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
  inst.dependencies.insert("mdmulint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#0");
  tasm.std("0+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulintx");
  return tasm.source();
}

std::string CoreImplementation::regInt_regInt_negByte(InstMul &inst) {
  inst.dependencies.insert("mdmulint");

  Assembler tasm;
  preamble(tasm, inst);
  tasm.stab("2+argv");
  tasm.ldd("#-1");
  tasm.std("0+argv");
  tasm.ldx("#" + inst.arg1->sbyte());
  tasm.jmp("mulintx");
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

void CoreImplementation::preamble(Assembler & /*tasm*/,
                                  Instruction & /*inst*/) {}
