// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "coretarget.hpp"
#include "backend/implementation/library.hpp"
#include "utils/strescape.hpp"

#include <algorithm>
#include <cstring>

std::string CoreTarget::generateAssembly(Text &text, InstQueue &queue,
                                         const char *progname,
                                         const char *filename,
                                         const MCBASICCLIOptions &options) {
  return generateHeader(progname, filename, options) +
         generateDirectPage(queue) + generateCode(queue) +
         generateLibrary(queue, options) + generateDataTable(text.dataTable) +
         generateSymbols(text.constTable, text.symbolTable);
}

std::string CoreTarget::generateHeader(const char *progname,
                                       const char *filename,
                                       const MCBASICCLIOptions &options) {
  Assembler tasm;
  std::string comment = std::string("Assembly for ") + filename;
  tasm.comment(comment.c_str());

  comment = "compiled with";

  // trim directory characters from program name
  std::string pname = progname;
  std::size_t backs = pname.rfind("\\"); // dos
  std::size_t slash = pname.rfind("/");  // linux
  pname =
      pname.substr(backs == std::string::npos && slash == std::string::npos ? 0
                   : backs == std::string::npos ? slash + 1
                   : slash == std::string::npos ? backs + 1
                   : backs > slash              ? backs + 1
                                                : slash + 1,
                   std::string::npos);

  // trim any trailing extension (e.g., ".exe")
  pname = pname.substr(0, pname.rfind("."));
  comment += " " + pname;

  // only report switches that affect code generation
  // (skip the verbose, source, list, and warning flags)
  for (const auto &option : options.getTable()) {
    const char *opt = option->c_str();
    if (option->isEnabled() && strcmp(opt, "v") && strcmp(opt, "S") &&
        strcmp(opt, "list") && strncmp(opt, "W", 1)) {
      comment += std::string(" -") + opt;
    }
  }
  tasm.comment(comment);
  tasm.blank();
  return tasm.source();
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
  tasm.block("inptptr", "2");
  tasm.block("redoptr", "2");
  tasm.block("letptr", "2");
  tasm.block("rvseed", "2");

  // leave $93-A2 alone for clean BASIC return
  tasm.org("$a3");
  tasm.block("tmp1", "2");
  tasm.block("tmp2", "2");
  tasm.block("tmp3", "2");
  tasm.block("tmp4", "2");
  tasm.block("tmp5", "2");

  // Some MC-10 programs modify DP_DATA, so we resume at $AF
  tasm.org("$af");
  for (int i = 1; i <= queue.maxRegisterCount; i++) {
    tasm.block("r" + std::to_string(i), "5");
  }
  tasm.label("rend");
  extendDirectPage(tasm);
  tasm.block("argv", "10");
  tasm.blank();
  return generateMicroColorConstants() + tasm.source();
}

std::string CoreTarget::generateMicroColorConstants() {
  Assembler tasm;

  tasm.comment("Equates for MC-10 MICROCOLOR BASIC 1.0");
  tasm.comment("");

  tasm.comment("Direct page equates");
  tasm.equ("DP_TIMR", "$09", "value of MC6801/6803 counter");
  tasm.equ("DP_DATA", "$AD", "pointer to where READ gets next value");
  tasm.equ("DP_LNUM", "$E2", "current line in BASIC");
  tasm.equ("DP_TABW", "$E4", "current tab width on console");
  tasm.equ("DP_LTAB", "$E5", "current last tab column");
  tasm.equ("DP_LPOS", "$E6", "current line position on console");
  tasm.equ("DP_LWID", "$E7", "current line width of console");
  tasm.equ("DP_DEVN", "$E8", "current device number");
  tasm.comment("");

  tasm.comment("Memory equates");
  tasm.equ("M_KBUF", "$4231", "keystrobe buffer (8 bytes)");
  tasm.equ("M_PMSK", "$423C", "pixel mask for SET, RESET and POINT");
  tasm.equ("M_FLEN", "$4256", "filename len");
  tasm.equ("M_FNAM", "$4257", "filename (8 bytes)");
  tasm.equ("M_FTYP", "$4267", "cassette filetype");
  tasm.equ("M_LDSZ", "$426C", "load addr / array size");
  tasm.equ("M_CBEG", "$426F", "cassette beginning address");
  tasm.equ("M_CEND", "$4271", "address after cassette ending");
  tasm.equ("M_IKEY", "$427F", "key code for INKEY$");
  tasm.equ("M_CRSR", "$4280", "cursor location");
  tasm.equ("M_LBUF", "$42B2", "line input buffer (130 chars)");
  tasm.equ("M_MSTR", "$4334", "buffer for small string moves");
  tasm.equ("M_CODE", "$4346", "start of program space");
  tasm.comment("");

  tasm.comment("ROM equates");
  tasm.equ("R_MCXBT", "$E047", "MCX BASIC 3.x target ('10' for an MC-10)");
  tasm.equ("R_BKMSG", "$E1C1", "'BREAK' string location");
  tasm.equ("R_ERROR", "$E238", "generate error and restore direct mode");
  tasm.equ("R_BREAK", "$E266", "generate break and restore direct mode");
  tasm.equ("R_RESET", "$E3EE", "setup stack and disable CONT");
  tasm.equ("R_ENTER", "$E766", "emit carriage return to console");
  tasm.equ("R_SPACE", "$E7B9", "emit \" \" to console");
  tasm.equ("R_QUEST", "$E7BC", "emit \"?\" to console");
  tasm.equ("R_REDO", "$E7C1", "emit \"?REDO\" to console");
  tasm.equ("R_EXTRA", "$E8AB", "emit \"?EXTRA IGNORED\" to console");
  tasm.equ("R_DMODE", "$F7AA", "display OK prompt and restore direct mode");
  tasm.equ("R_KPOLL", "$F879", "if key is down, do KEYIN, else set Z CCR flag");
  tasm.equ("R_KEYIN", "$F883",
           "poll key for key-down transition set Z otherwise");
  tasm.equ("R_PUTC", "$F9C6", "write ACCA to console");
  tasm.equ("R_MKTAB", "$FA7B", "setup tabs for console");
  tasm.equ("R_GETLN", "$FAA4",
           "get line, returning with X pointing to M_BUF-1");
  tasm.equ("R_SETPX", "$FB44", "write pixel character to X");
  tasm.equ("R_CLRPX", "$FB59", "clear pixel character in X");
  tasm.equ("R_MSKPX", "$FB7C",
           "get pixel screen location X and mask in R_PMSK");
  tasm.equ("R_CLSN", "$FBC4", "clear screen with color code in ACCB");
  tasm.equ("R_CLS", "$FBD4", "clear screen with space character");
  tasm.equ("R_WBLKS", "$FC5D", "write blocks M_CBEG up to before M_CEND");
  tasm.equ("R_WFNAM", "$FC8E", "write filename block + silence + post-leader");
  tasm.equ("R_RBLKS", "$FDC5", "read data blocks into M_CBEG");
  tasm.equ("R_RCLDM", "$FE1B", "read machine language blocks offset by X");
  tasm.equ("R_SFNAM", "$FE37", "search for filename");
  tasm.equ("R_SOUND", "$FFAB",
           "play sound with pitch in ACCA and duration in ACCB");
  tasm.equ("R_MCXID", "$FFDA", "ID location for MCX BASIC");
  tasm.equ("R_RSLDR", "$FF4E", "read leader preceding data blocks");
  tasm.blank();

  tasm.comment("Equate(s) for MCBASIC constants");
  tasm.equ("charpage", "$1B00", "single-character string page.");
  tasm.blank();
  return tasm.source();
}

std::string CoreTarget::generateLibrary(InstQueue &queue,
                                        const MCBASICCLIOptions &options) {
  Library library(queue, options.undoc.isEnabled());
  library.assemble(makeDispatcher().get());

  std::string ops = generateLibraryCatalog(library);

  for (const auto &entry : library.getModules()) {
    Assembler tasm;
    tasm.module(entry.first);
    ops += tasm.source() + entry.second + '\n';
  }

  for (const auto &entry : library.getCalls()) {
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
  auto data = dataTable.getData();
  if (!dataTable.isPureNumeric()) {
    for (auto &i : data) {
      tasm.text(std::to_string(i.size()) + ", " + '"' + strEscapeTASM(i) + '"');
    }
  } else if (dataTable.isPureByte()) {
    std::string args;
    for (std::size_t i = 0; i < data.size(); ++i) {

      args += data[i];

      if (i % 6 == 5 || i + 1 == data.size()) {
        tasm.byte(args);
        args = "";
      } else {
        args += ", ";
      }
    }
  } else if (dataTable.isPureWord()) {
    std::string args;
    for (std::size_t i = 0; i < data.size(); ++i) {
      args += data[i];

      if (i % 4 == 3 || i + 1 == data.size()) {
        tasm.word(args);
        args = "";
      } else {
        args += ", ";
      }
    }
  } else if (!data.empty()) {
    for (auto &i : data) {
      try {
        char buf[1024];
        FixedPoint entry(std::stod(i));
        snprintf(buf, 1024, "$%02x, $%02x, $%02x, $%02x, $%02x ; %s",
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
        snprintf(buf, 1024, "$%02x, $%02x, $%02x", 0x0ff & (entry >> 16),
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
      snprintf(buf, 1024, "$%02x, $%02x, $%02x, $%02x, $%02x",
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
               std::to_string(2 + 2 * std::max(symbol.numDims, 1)),
               "dims=" + std::to_string(symbol.numDims));
  }

  tasm.comment("String Arrays");
  for (const auto &symbol : symbolTable.strArrTable) {
    tasm.block("STRARR_" + symbol.name,
               std::to_string(2 + 2 * std::max(symbol.numDims, 1)),
               "dims=" + std::to_string(symbol.numDims));
  }

  tasm.blank();
  tasm.comment("block ended by symbol");
  tasm.label("bes");
  tasm.end();

  return catalog + tasm.source();
}
