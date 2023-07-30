// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_ASSEMBLER_ASSEMBLER_HPP
#define BACKEND_ASSEMBLER_ASSEMBLER_HPP

#include <string>

// Provide a convenient interface for 6801 assembly
// - right now these simply write a string to an internal buffer
//   intended to be output to an .asm file suitable for tasm6801
// - eventually the internals can be converted to something more
//   structured that can obviate the need for external assmebly.

class Assembler {
public:
  void comment(std::string const &comment);
  void incomment(std::string const &comment);

  // directives
  void org(std::string const &address);
  void module(std::string const &name);
  void labelByte(std::string const &name, std::string const &data);
  void labelText(std::string const &name, std::string const &data);
  void byte(std::string const &data);
  void word(std::string const &data);
  void text(std::string const &data);
  void end();
  void label(std::string const &name, std::string const &comment = "");
  void equ(std::string const &name, std::string const &num,
           std::string const &comment = "");
  void block(std::string const &name, std::string const &numBytes,
             std::string const &comment = "");

  // inherent instructions
  void aba(std::string const &comment = "");
  void abx(std::string const &comment = "");
  void asra(std::string const &comment = "");
  void asrb(std::string const &comment = "");
  void clc(std::string const &comment = "");
  void clra(std::string const &comment = "");
  void clrb(std::string const &comment = "");
  void coma(std::string const &comment = "");
  void comb(std::string const &comment = "");
  void deca(std::string const &comment = "");
  void decb(std::string const &comment = "");
  void des(std::string const &comment = "");
  void dex(std::string const &comment = "");
  void inca(std::string const &comment = "");
  void incb(std::string const &comment = "");
  void ins(std::string const &comment = "");
  void inx(std::string const &comment = "");
  void lsla(std::string const &comment = "");
  void lslb(std::string const &comment = "");
  void lsld(std::string const &comment = "");
  void lsra(std::string const &comment = "");
  void lsrb(std::string const &comment = "");
  void lsrd(std::string const &comment = "");
  void mul(std::string const &comment = "");
  void nega(std::string const &comment = "");
  void negb(std::string const &comment = "");
  void psha(std::string const &comment = "");
  void pshb(std::string const &comment = "");
  void pshx(std::string const &comment = "");
  void pula(std::string const &comment = "");
  void pulb(std::string const &comment = "");
  void pulx(std::string const &comment = "");
  void rola(std::string const &comment = "");
  void rolb(std::string const &comment = "");
  void rora(std::string const &comment = "");
  void rorb(std::string const &comment = "");
  void rts(std::string const &comment = "");
  void sba(std::string const &comment = "");
  void sec(std::string const &comment = "");
  void tab(std::string const &comment = "");
  void tap(std::string const &comment = "");
  void tba(std::string const &comment = "");
  void tpa(std::string const &comment = "");
  void tsta(std::string const &comment = "");
  void tstb(std::string const &comment = "");
  void tsx(std::string const &comment = "");
  void txs(std::string const &comment = "");

  // instructions with an &operand
  void adca(std::string const &operand, std::string const &comment = "");
  void adcb(std::string const &operand, std::string const &comment = "");
  void adda(std::string const &operand, std::string const &comment = "");
  void addb(std::string const &operand, std::string const &comment = "");
  void addd(std::string const &operand, std::string const &comment = "");
  void anda(std::string const &operand, std::string const &comment = "");
  void andb(std::string const &operand, std::string const &comment = "");
  void asr(std::string const &operand, std::string const &comment = "");
  void bcc(std::string const &operand, std::string const &comment = "");
  void bcs(std::string const &operand, std::string const &comment = "");
  void beq(std::string const &operand, std::string const &comment = "");
  void bge(std::string const &operand, std::string const &comment = "");
  void bhi(std::string const &operand, std::string const &comment = "");
  void bhs(std::string const &operand, std::string const &comment = "");
  void bita(std::string const &operand, std::string const &comment = "");
  void bitb(std::string const &operand, std::string const &comment = "");
  void ble(std::string const &operand, std::string const &comment = "");
  void blo(std::string const &operand, std::string const &comment = "");
  void bls(std::string const &operand, std::string const &comment = "");
  void blt(std::string const &operand, std::string const &comment = "");
  void bmi(std::string const &operand, std::string const &comment = "");
  void bne(std::string const &operand, std::string const &comment = "");
  void bpl(std::string const &operand, std::string const &comment = "");
  void bra(std::string const &operand, std::string const &comment = "");
  void bsr(std::string const &operand, std::string const &comment = "");
  void clr(std::string const &operand, std::string const &comment = "");
  void cmpa(std::string const &operand, std::string const &comment = "");
  void cmpb(std::string const &operand, std::string const &comment = "");
  void com(std::string const &operand, std::string const &comment = "");
  void cpx(std::string const &operand, std::string const &comment = "");
  void dec(std::string const &operand, std::string const &comment = "");
  void eora(std::string const &operand, std::string const &comment = "");
  void eorb(std::string const &operand, std::string const &comment = "");
  void inc(std::string const &operand, std::string const &comment = "");
  void jmp(std::string const &operand, std::string const &comment = "");
  void jsr(std::string const &operand, std::string const &comment = "");
  void ldaa(std::string const &operand, std::string const &comment = "");
  void ldab(std::string const &operand, std::string const &comment = "");
  void ldd(std::string const &operand, std::string const &comment = "");
  void lds(std::string const &operand, std::string const &comment = "");
  void ldx(std::string const &operand, std::string const &comment = "");
  void lsl(std::string const &operand, std::string const &comment = "");
  void lsr(std::string const &operand, std::string const &comment = "");
  void neg(std::string const &operand, std::string const &comment = "");
  void ngc(std::string const &operand, std::string const &comment = "");
  void oraa(std::string const &operand, std::string const &comment = "");
  void orab(std::string const &operand, std::string const &comment = "");
  void rol(std::string const &operand, std::string const &comment = "");
  void ror(std::string const &operand, std::string const &comment = "");
  void sbca(std::string const &operand, std::string const &comment = "");
  void sbcb(std::string const &operand, std::string const &comment = "");
  void staa(std::string const &operand, std::string const &comment = "");
  void stab(std::string const &operand, std::string const &comment = "");
  void std(std::string const &operand, std::string const &comment = "");
  void sts(std::string const &operand, std::string const &comment = "");
  void stx(std::string const &operand, std::string const &comment = "");
  void suba(std::string const &operand, std::string const &comment = "");
  void subb(std::string const &operand, std::string const &comment = "");
  void subd(std::string const &operand, std::string const &comment = "");
  void tst(std::string const &operand, std::string const &comment = "");

  // emit a blank line
  void blank();

  // fetch the assembly buffer
  std::string source();

  // clear the assembly
  void clear();

private:
  void inherent(std::string const &opcode, std::string const &comment);
  void singlearg(std::string const &opcode, std::string const &operand,
                 std::string const &comment);
  std::string buffer;
};
#endif
