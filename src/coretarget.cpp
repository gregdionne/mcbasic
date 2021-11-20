// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "coretarget.hpp"
#include "fixedpoint.hpp"
#include "library.hpp"

std::string CoreTarget::generateAssembly(DataTable &dataTable,
                                         ConstTable &constTable,
                                         SymbolTable &symbolTable,
                                         InstQueue &queue, Options &options) {
  return generateDirectPage(queue) + generateCode(queue) +
         generateLibrary(queue, options) + generateDataTable(dataTable) +
         generateSymbols(constTable, symbolTable);
}

std::string CoreTarget::generateDirectPage(InstQueue &queue) {
  Assembler tasm;
  tasm.comment("direct page registers");
  tasm.org("$80");
  tasm.block("strtcnt", "1");
  tasm.block("strbuf", "2");
  tasm.block("strend", "2");
  tasm.block("strfree", "2");
  tasm.block("strstop", "2");
  tasm.block("dataptr", "2");
  tasm.block("inptptr", "2");
  tasm.block("redoptr", "2");
  tasm.block("letptr", "2");

  tasm.org("$a3"); // we want to leave $93-4 alone
  for (int i = 1; i <= queue.maxRegisterCount; i++) {
    tasm.block("r" + std::to_string(i), "5");
  }
  tasm.label("rend");
  tasm.block("rvseed", "2");
  extendDirectPage(tasm);
  tasm.block("tmp1", "2");
  tasm.block("tmp2", "2");
  tasm.block("tmp3", "2");
  tasm.block("tmp4", "2");
  tasm.block("tmp5", "2");
  tasm.block("argv", "10");
  tasm.blank();
  return generateMicroColorConstants() + tasm.source();
}

std::string CoreTarget::generateMicroColorConstants() {
  Assembler tasm;

  tasm.comment("Equates for MC-10 MICROCOLOR BASIC 1.0");
  tasm.comment("");

  tasm.comment("Direct page equates");
  tasm.equ("DP_LNUM", "$E2", "current line in BASIC");
  tasm.equ("DP_TABW", "$E4", "current tab width on console");
  tasm.equ("DP_LPOS", "$E6", "current line position on console");
  tasm.equ("DP_LWID", "$E7", "current line width of console");
  tasm.comment("");

  tasm.comment("Memory equates");
  tasm.equ("M_KBUF", "$4231", "keystrobe buffer (8 bytes)");
  tasm.equ("M_PMSK", "$423C", "pixel mask for SET, RESET and POINT");
  tasm.equ("M_IKEY", "$427F", "key code for INKEY$");
  tasm.equ("M_CRSR", "$4280", "cursor location");
  tasm.equ("M_LBUF", "$42B2", "line input buffer (130 chars)");
  tasm.equ("M_MSTR", "$4334", "buffer for small string moves");
  tasm.equ("M_CODE", "$4346", "start of program space");
  tasm.comment("");

  tasm.comment("ROM equates");
  tasm.equ("R_BKMSG", "$E1C1", "'BREAK' string location");
  tasm.equ("R_ERROR", "$E238", "generate error and restore direct mode");
  tasm.equ("R_BREAK", "$E266", "generate break and restore direct mode");
  tasm.equ("R_RESET", "$E3EE", "setup stack and disable CONT");
  tasm.equ("R_SPACE", "$E7B9", "emit \" \" to console");
  tasm.equ("R_QUEST", "$E7BC", "emit \"?\" to console");
  tasm.equ("R_REDO", "$E7C1", "emit \"?REDO\" to console");
  tasm.equ("R_EXTRA", "$E8AB", "emit \"?EXTRA IGNORED\" to console");
  tasm.equ("R_DMODE", "$F7AA", "display OK prompt and restore direct mode");
  tasm.equ("R_KPOLL", "$F879", "if key is down, do KEYIN, else set Z CCR flag");
  tasm.equ("R_KEYIN", "$F883",
           "poll key for key-down transition set Z otherwise");
  tasm.equ("R_PUTC", "$F9C9", "write ACCA to console");
  tasm.equ("R_MKTAB", "$FA7B", "setup tabs for console");
  tasm.equ("R_GETLN", "$FAA4",
           "get line, returning with X pointing to M_BUF-1");
  tasm.equ("R_SETPX", "$FB44", "write pixel character to X");
  tasm.equ("R_CLRPX", "$FB59", "clear pixel character in X");
  tasm.equ("R_MSKPX", "$FB7C",
           "get pixel screen location X and mask in R_PMSK");
  tasm.equ("R_CLSN", "$FBC4", "clear screen with color code in ACCB");
  tasm.equ("R_CLS", "$FBD4", "clear screen with space character");
  tasm.equ("R_SOUND", "$FFAB",
           "play sound with pitch in ACCA and duration in ACCB");
  tasm.equ("R_MCXID", "$FFDA", "ID location for MCX BASIC");
  tasm.blank();

  tasm.comment("Equate(s) for MCBASIC constants");
  tasm.equ("charpage", "$0100", "single-character string page.");
  tasm.blank();
  return tasm.source();
}

std::string CoreTarget::generateLibrary(InstQueue &queue, Options &options) {
  Library library(queue, options.undoc);
  library.assemble(makeDispatcher().get());

  std::string ops = generateLibraryCatalog(library);

  for (auto &entry : library.modules) {
    Assembler tasm;
    tasm.module(entry.first);
    ops += tasm.source() + entry.second + '\n';
  }

  for (auto &entry : library.calls) {
    Assembler tasm;
    tasm.label(entry.first,
               "numCalls = " + std::to_string(entry.second.callCount));
    tasm.module("mod" + entry.first);
    ops += tasm.source();
    ops += entry.second.instructions;
    ops += '\n';
  }

  return ops;
}

std::string CoreTarget::generateLibraryCatalog(Library & /*library*/) {
  return "";
}
std::string CoreTarget::generateSymbolCatalog(ConstTable & /*constTable*/,
                                              SymbolTable & /*symbolTable*/) {
  return "";
}

std::string CoreTarget::generateDataTable(DataTable &dataTable) {
  Assembler tasm;
  tasm.comment("data table");
  tasm.label("startdata");
  if (!dataTable.pureNumeric) {
    for (auto &i : dataTable.data) {
      tasm.text(std::to_string(i.size()) + ", " + '"' + strescape(i) + '"');
    }
  } else if (dataTable.pureByte) {
    std::string args;
    for (std::size_t i = 0; i < dataTable.data.size(); ++i) {

      args += dataTable.data[i];

      if (i % 6 == 5 || i + 1 == dataTable.data.size()) {
        tasm.byte(args);
        args = "";
      } else {
        args += ", ";
      }
    }
  } else if (dataTable.pureWord) {
    std::string args;
    for (std::size_t i = 0; i < dataTable.data.size(); ++i) {
      args += dataTable.data[i];

      if (i % 4 == 3 || i + 1 == dataTable.data.size()) {
        tasm.word(args);
        args = "";
      } else {
        args += ", ";
      }
    }
  } else if (!dataTable.data.empty()) {
    for (auto &i : dataTable.data) {
      try {
        char buf[1024];
        FixedPoint entry(std::stod(i));
        sprintf(buf, "$%02x, $%02x, $%02x, $%02x, $%02x ; %s",
                0x0ff & (entry.wholenum >> 16), 0x0ff & (entry.wholenum >> 8),
                0x0ff & (entry.wholenum), 0x0ff & (entry.fraction >> 8),
                0x0ff & (entry.fraction), i.c_str());
        tasm.byte(buf);
      } catch (...) {
        tasm.text("!BAD DATA FORMAT");
      }
    }
  }
  tasm.label("enddata");
  tasm.blank();
  return tasm.source();
}

std::string CoreTarget::generateSymbols(ConstTable &constTable,
                                        SymbolTable &symbolTable) {

  std::string catalog = generateSymbolCatalog(constTable, symbolTable);

  Assembler tasm;
  tasm.blank();

  // Go through all constants and extract large ones...
  // TODO move this code to constTable
  bool hasLargeInts = false;
  for (auto &entry : constTable.ints) {
    hasLargeInts |=
        ((entry & 0xff0000) != 0) && ((entry & 0xff0000) != 0xff0000);
  }

  if (hasLargeInts) {
    tasm.comment("large integer constants");
    for (auto &entry : constTable.ints) {
      if (((entry & 0xff0000) != 0) && ((entry & 0xff0000) != 0xff0000)) {
        char buf[1024];
        sprintf(buf, "$%02x, $%02x, $%02x", 0x0ff & (entry >> 16),
                0x0ff & (entry >> 8), 0x0ff & (entry));
        tasm.labelByte(FixedPoint(entry).label(), buf);
      }
    }
    tasm.blank();
  }

  if (!constTable.flts.empty()) {
    tasm.comment("fixed-point constants");
    for (auto &entry : constTable.flts) {
      char buf[1024];
      sprintf(buf, "$%02x, $%02x, $%02x, $%02x, $%02x",
              0x0ff & (entry.wholenum >> 16), 0x0ff & (entry.wholenum >> 8),
              0x0ff & (entry.wholenum), 0x0ff & (entry.fraction >> 8),
              0x0ff & (entry.fraction));
      tasm.labelByte(entry.label(), buf);
    }
    tasm.blank();
  }

  tasm.comment("block started by symbol");
  tasm.label("bss");
  tasm.blank();

  tasm.comment("Numeric Variables");
  for (const auto &symbol : symbolTable.numVarTable) {
    tasm.block((symbol.isFloat ? "FLTVAR_" : "INTVAR_") + symbol.name,
               symbol.isFloat ? "5" : "3");
  }

  tasm.comment("String Variables");
  for (const auto &symbol : symbolTable.strVarTable) {
    tasm.block("STRVAR_" + symbol.name, "3");
  }

  tasm.comment("Numeric Arrays");
  for (const auto &symbol : symbolTable.numArrTable) {
    tasm.block((symbol.isFloat ? "FLTARR_" : "INTARR_") + symbol.name,
               std::to_string(2 + 2 * symbol.numDims),
               "dims=" + std::to_string(symbol.numDims));
  }

  tasm.comment("String Arrays");
  for (const auto &symbol : symbolTable.strArrTable) {
    tasm.block("STRARR_" + symbol.name, std::to_string(2 + 2 * symbol.numDims),
               "dims=" + std::to_string(symbol.numDims));
  }

  tasm.blank();
  tasm.comment("block ended by symbol");
  tasm.label("bes");
  tasm.end();

  return catalog + tasm.source();
}
