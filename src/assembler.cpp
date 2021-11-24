// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "assembler.hpp"
#include "strescape.hpp"

std::string Assembler::source() { return buffer; }

void Assembler::clear() { buffer = ""; }

void Assembler::blank() { buffer += '\n'; }

void Assembler::module(std::string const &name) {
  buffer += "\t.module\t" + name + '\n';
}

void Assembler::org(std::string const &address) {
  buffer += "\t.org\t" + address + '\n';
}

void Assembler::end() { buffer += "\t.end\n"; }

void Assembler::labelByte(std::string const &name, std::string const &data) {
  buffer += name + "\t.byte\t" + data + '\n';
}

void Assembler::labelText(std::string const &name, std::string const &data) {
  buffer += name + "\t.text\t" + data + '\n';
}

void Assembler::byte(std::string const &data) {
  buffer += "\t.byte\t" + data + '\n';
}

void Assembler::word(std::string const &data) {
  buffer += "\t.word\t" + data + '\n';
}

void Assembler::text(std::string const &data) {
  buffer += "\t.text\t" + data + '\n';
}

void Assembler::incomment(std::string const &comment) {
  buffer += "\t; " + comment + "\n";
}

void Assembler::comment(std::string const &comment) {
  buffer += "; " + comment + "\n";
}

void Assembler::label(std::string const &name, std::string const &comment) {
  std::string out = name;
  if (!comment.empty()) {
    out += "\t\t\t; " + comment;
  }
  out += "\n";
  buffer += out;
}

void Assembler::equ(std::string const &name, std::string const &numBytes,
                    std::string const &comment) {
  std::string out = name + "\t.equ\t" + numBytes;
  if (!comment.empty()) {
    out += "\t; " + comment;
  }
  out += '\n';
  buffer += out;
}

void Assembler::block(std::string const &name, std::string const &numBytes,
                      std::string const &comment) {
  std::string out = name + "\t.block\t" + numBytes;
  if (!comment.empty()) {
    out += "\t; " + comment;
  }
  out += '\n';
  buffer += out;
}

void Assembler::inherent(std::string const &opcode,
                         std::string const &comment) {
  std::string op = '\t' + opcode;
  if (!comment.empty()) {
    op += "\t\t; " + comment;
  }
  op += '\n';
  buffer += op;
}

void Assembler::singlearg(std::string const &opcode, std::string const &operand,
                          std::string const &comment) {
  std::string op = '\t' + opcode;
  op += '\t' + operand;
  if (!comment.empty()) {
    op += '\t' + comment;
  }
  op += '\n';
  buffer += op;
}

void Assembler::aba(std::string const &comment) { inherent("aba", comment); }
void Assembler::abx(std::string const &comment) { inherent("abx", comment); }
void Assembler::asra(std::string const &comment) { inherent("asra", comment); }
void Assembler::asrb(std::string const &comment) { inherent("asrb", comment); }
void Assembler::clc(std::string const &comment) { inherent("clc", comment); }
void Assembler::clra(std::string const &comment) { inherent("clra", comment); }
void Assembler::clrb(std::string const &comment) { inherent("clrb", comment); }
void Assembler::coma(std::string const &comment) { inherent("coma", comment); }
void Assembler::comb(std::string const &comment) { inherent("comb", comment); }
void Assembler::deca(std::string const &comment) { inherent("deca", comment); }
void Assembler::decb(std::string const &comment) { inherent("decb", comment); }
void Assembler::des(std::string const &comment) { inherent("des", comment); }
void Assembler::dex(std::string const &comment) { inherent("dex", comment); }
void Assembler::inca(std::string const &comment) { inherent("inca", comment); }
void Assembler::incb(std::string const &comment) { inherent("incb", comment); }
void Assembler::ins(std::string const &comment) { inherent("ins", comment); }
void Assembler::inx(std::string const &comment) { inherent("inx", comment); }
void Assembler::lsla(std::string const &comment) { inherent("lsla", comment); }
void Assembler::lslb(std::string const &comment) { inherent("lslb", comment); }
void Assembler::lsld(std::string const &comment) { inherent("lsld", comment); }
void Assembler::lsra(std::string const &comment) { inherent("lsra", comment); }
void Assembler::lsrb(std::string const &comment) { inherent("lsrb", comment); }
void Assembler::lsrd(std::string const &comment) { inherent("lsrd", comment); }
void Assembler::mul(std::string const &comment) { inherent("mul", comment); }
void Assembler::nega(std::string const &comment) { inherent("nega", comment); }
void Assembler::negb(std::string const &comment) { inherent("negb", comment); }
void Assembler::psha(std::string const &comment) { inherent("psha", comment); }
void Assembler::pshb(std::string const &comment) { inherent("pshb", comment); }
void Assembler::pshx(std::string const &comment) { inherent("pshx", comment); }
void Assembler::pula(std::string const &comment) { inherent("pula", comment); }
void Assembler::pulb(std::string const &comment) { inherent("pulb", comment); }
void Assembler::pulx(std::string const &comment) { inherent("pulx", comment); }
void Assembler::rola(std::string const &comment) { inherent("rola", comment); }
void Assembler::rolb(std::string const &comment) { inherent("rolb", comment); }
void Assembler::rora(std::string const &comment) { inherent("rora", comment); }
void Assembler::rorb(std::string const &comment) { inherent("rorb", comment); }
void Assembler::rts(std::string const &comment) { inherent("rts", comment); }
void Assembler::sba(std::string const &comment) { inherent("sba", comment); }
void Assembler::sec(std::string const &comment) { inherent("sec", comment); }
void Assembler::tab(std::string const &comment) { inherent("tab", comment); }
void Assembler::tap(std::string const &comment) { inherent("tap", comment); }
void Assembler::tba(std::string const &comment) { inherent("tba", comment); }
void Assembler::tpa(std::string const &comment) { inherent("tpa", comment); }
void Assembler::tsta(std::string const &comment) { inherent("tsta", comment); }
void Assembler::tstb(std::string const &comment) { inherent("tstb", comment); }
void Assembler::tsx(std::string const &comment) { inherent("tsx", comment); }
void Assembler::txs(std::string const &comment) { inherent("txs", comment); }

void Assembler::adca(std::string const &operand, std::string const &comment) {
  singlearg("adca", operand, comment);
}
void Assembler::adcb(std::string const &operand, std::string const &comment) {
  singlearg("adcb", operand, comment);
}
void Assembler::adda(std::string const &operand, std::string const &comment) {
  singlearg("adda", operand, comment);
}
void Assembler::addb(std::string const &operand, std::string const &comment) {
  singlearg("addb", operand, comment);
}
void Assembler::addd(std::string const &operand, std::string const &comment) {
  singlearg("addd", operand, comment);
}
void Assembler::anda(std::string const &operand, std::string const &comment) {
  singlearg("anda", operand, comment);
}
void Assembler::andb(std::string const &operand, std::string const &comment) {
  singlearg("andb", operand, comment);
}
void Assembler::asr(std::string const &operand, std::string const &comment) {
  singlearg("asr", operand, comment);
}
void Assembler::bcc(std::string const &operand, std::string const &comment) {
  singlearg("bcc", operand, comment);
}
void Assembler::bcs(std::string const &operand, std::string const &comment) {
  singlearg("bcs", operand, comment);
}
void Assembler::beq(std::string const &operand, std::string const &comment) {
  singlearg("beq", operand, comment);
}
void Assembler::bge(std::string const &operand, std::string const &comment) {
  singlearg("bge", operand, comment);
}
void Assembler::bhi(std::string const &operand, std::string const &comment) {
  singlearg("bhi", operand, comment);
}
void Assembler::bhs(std::string const &operand, std::string const &comment) {
  singlearg("bhs", operand, comment);
}
void Assembler::bita(std::string const &operand, std::string const &comment) {
  singlearg("bita", operand, comment);
}
void Assembler::bitb(std::string const &operand, std::string const &comment) {
  singlearg("bitb", operand, comment);
}
void Assembler::ble(std::string const &operand, std::string const &comment) {
  singlearg("ble", operand, comment);
}
void Assembler::blo(std::string const &operand, std::string const &comment) {
  singlearg("blo", operand, comment);
}
void Assembler::bls(std::string const &operand, std::string const &comment) {
  singlearg("bls", operand, comment);
}
void Assembler::blt(std::string const &operand, std::string const &comment) {
  singlearg("blt", operand, comment);
}
void Assembler::bmi(std::string const &operand, std::string const &comment) {
  singlearg("bmi", operand, comment);
}
void Assembler::bne(std::string const &operand, std::string const &comment) {
  singlearg("bne", operand, comment);
}
void Assembler::bpl(std::string const &operand, std::string const &comment) {
  singlearg("bpl", operand, comment);
}
void Assembler::bra(std::string const &operand, std::string const &comment) {
  singlearg("bra", operand, comment);
}
void Assembler::bsr(std::string const &operand, std::string const &comment) {
  singlearg("bsr", operand, comment);
}
void Assembler::clr(std::string const &operand, std::string const &comment) {
  singlearg("clr", operand, comment);
}
void Assembler::cmpa(std::string const &operand, std::string const &comment) {
  singlearg("cmpa", operand, comment);
}
void Assembler::cmpb(std::string const &operand, std::string const &comment) {
  singlearg("cmpb", operand, comment);
}
void Assembler::com(std::string const &operand, std::string const &comment) {
  singlearg("com", operand, comment);
}
void Assembler::cpx(std::string const &operand, std::string const &comment) {
  singlearg("cpx", operand, comment);
}
void Assembler::dec(std::string const &operand, std::string const &comment) {
  singlearg("dec", operand, comment);
}
void Assembler::eora(std::string const &operand, std::string const &comment) {
  singlearg("eora", operand, comment);
}
void Assembler::eorb(std::string const &operand, std::string const &comment) {
  singlearg("eorb", operand, comment);
}
void Assembler::inc(std::string const &operand, std::string const &comment) {
  singlearg("inc", operand, comment);
}
void Assembler::jmp(std::string const &operand, std::string const &comment) {
  singlearg("jmp", operand, comment);
}
void Assembler::jsr(std::string const &operand, std::string const &comment) {
  singlearg("jsr", operand, comment);
}
void Assembler::ldaa(std::string const &operand, std::string const &comment) {
  singlearg("ldaa", operand, comment);
}
void Assembler::ldab(std::string const &operand, std::string const &comment) {
  singlearg("ldab", operand, comment);
}
void Assembler::ldd(std::string const &operand, std::string const &comment) {
  singlearg("ldd", operand, comment);
}
void Assembler::lds(std::string const &operand, std::string const &comment) {
  singlearg("lds", operand, comment);
}
void Assembler::ldx(std::string const &operand, std::string const &comment) {
  singlearg("ldx", operand, comment);
}
void Assembler::lsl(std::string const &operand, std::string const &comment) {
  singlearg("lsl", operand, comment);
}
void Assembler::lsr(std::string const &operand, std::string const &comment) {
  singlearg("lsr", operand, comment);
}
void Assembler::neg(std::string const &operand, std::string const &comment) {
  singlearg("neg", operand, comment);
}
void Assembler::ngc(std::string const &operand, std::string const &comment) {
  singlearg("ngc", operand, comment);
}
void Assembler::oraa(std::string const &operand, std::string const &comment) {
  singlearg("oraa", operand, comment);
}
void Assembler::orab(std::string const &operand, std::string const &comment) {
  singlearg("orab", operand, comment);
}
void Assembler::rol(std::string const &operand, std::string const &comment) {
  singlearg("rol", operand, comment);
}
void Assembler::ror(std::string const &operand, std::string const &comment) {
  singlearg("ror", operand, comment);
}
void Assembler::sbca(std::string const &operand, std::string const &comment) {
  singlearg("sbca", operand, comment);
}
void Assembler::sbcb(std::string const &operand, std::string const &comment) {
  singlearg("sbcb", operand, comment);
}
void Assembler::staa(std::string const &operand, std::string const &comment) {
  singlearg("staa", operand, comment);
}
void Assembler::stab(std::string const &operand, std::string const &comment) {
  singlearg("stab", operand, comment);
}
void Assembler::std(std::string const &operand, std::string const &comment) {
  singlearg("std", operand, comment);
}
void Assembler::sts(std::string const &operand, std::string const &comment) {
  singlearg("sts", operand, comment);
}
void Assembler::stx(std::string const &operand, std::string const &comment) {
  singlearg("stx", operand, comment);
}
void Assembler::suba(std::string const &operand, std::string const &comment) {
  singlearg("suba", operand, comment);
}
void Assembler::subb(std::string const &operand, std::string const &comment) {
  singlearg("subb", operand, comment);
}
void Assembler::subd(std::string const &operand, std::string const &comment) {
  singlearg("subd", operand, comment);
}
void Assembler::tst(std::string const &operand, std::string const &comment) {
  singlearg("tst", operand, comment);
}
