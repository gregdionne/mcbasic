// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "options.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

Options::Options()
    : native{false, "native", nullptr,
             "Use native instructions instead of creating bytecode.",
             "This improves execution speed at the cost of increased codesize. "
             " Many "
             "programs are too big to use native."},
      g{false, "g", nullptr,
        "Generate line number instructions for error handling purposes.",
        "Without this flag, runtime errors appear without any line numbers."},
      v{false, "v", nullptr, "Be verbose when optimizing.",
        "Without this flag, optimization is done silently unless reporting is "
        "goverened by a warning switch."},
      list{false, "list", nullptr,
           "Output a BASIC program listing after optimizations.",
           "Some extensions are used during the compilation stage (e.g. += and "
           "-= "
           "assignment increment/decrement operators, and a WHEN..GOTO/GOSUB "
           "as a "
           "replacement for IF..GOTO/GOSUB ELSE).  These extensions are "
           "internal "
           "and are not available for use in the source BASIC files."},
      el{false, "el", nullptr,
         "Allow empty line number specifications in GOTO/GOSUB statements.",
         "A significant number of MC-10 programs exploited the fact that a "
         "missing line number after a GOTO, GOSUB, or ON..GOTO or ON..GOSUB "
         "statement implicitly resolved to line number zero (0) in MICROCOLOR "
         "BASIC.  This enabled compact ON..GOTO and ON..GOSUB statements where "
         "unused branch indices could be conveniently skipped (or sent to line "
         "0).  For example, a programmer could write 'ON X GOTO "
         "100,200,,300,,,,400,:GOTO 500' to branch to lines 100, 200, 0, 300, "
         "0, "
         "0, 0, 400, and 0 for values of X from 1-9, respectively; and to line "
         "500 for other values of X."},
      ul{false, "ul", nullptr,
         "Do not generate compilation errors on unlisted line numbers.",
         "A runtime '?UL ERROR' will be generated instead.  This is intended "
         "to "
         "be used in conjunction with the '-el' compiler flag.  Use '-g' to "
         "diagnose where these errors occur."},
      mcode{
          false, "mcode", nullptr, "Enable use of machine code (i.e. EXEC).",
          "As a precaution against unexpected behavior, the '-mcode' compiler "
          "flag is required for use with EXEC.  EXEC will only work with the "
          "compiler if the machine code it invokes does not assume the "
          "MICROCOLOR "
          "BASIC interpreter is running or modify direct page variables needed "
          "by "
          "the compiler to function.  Sic hunt dracones!"},
      undoc{
          false, "undoc", nullptr,
          "Enable compilation with undocumented opcodes.",
          "Currently only the undocumented negate-with-carry instructions.  "
          "The "
          "MC6801 and MC6809 both implement 'NGCA' (opcode $42), 'NGCB' "
          "(opcode "
          "$52), 'NGC <indexed>' (opcode $62), and 'NGC <extended>' (opcode "
          "$72). "
          " These permit negation of the 'D' register in four cycles by "
          "issuing a "
          "'NEGB' (opcode $50) followed by 'NGCA' (opcode $42).  They can also "
          "negate multi-byte numbers in-place.  Use caution when using the "
          "undoc "
          "switch, as many 6801 emulators fail to implement these instructions "
          "correctly."},
      Wfloat{
          true, "Wfloat", "Wno-float",
          "Warn when a variable is promoted floating-point.",
          "To improve performance and decrease the memory footprint of the "
          "compiled program, the compiler analyzes the program for variables "
          "that "
          "can be proven to be of pure integral type.  The remainder of the "
          "variables are then promoted to floating point.  The current backend "
          "implements integral variables with three bytes (24 bit two's "
          "complement) and, in turn, emulates floating point with five byte "
          "fixed-point (24 bit two's complement integer; 16-bit fraction).  "
          "While "
          "that makes it faster than floating-point; it's far less accurate, "
          "takes more memory, and is slower than using integers.  Avoid "
          "floating-point if you can."},
      Wduplicate{true, "Wduplicate", "Wno-duplicate",
                 "Warn when a duplicate line number is seen.",
                 "If the compiler sees multiple lines with the same line "
                 "number, it will discard all but the last one."},
      Wunreached{
          true, "Wunreached", "Wno-unreached",
          "Warn when statements cannot be reached.",
          "A statement immediately after an END, GOTO, STOP or RUN statement "
          "can't be reached unless it begins on the next line "
          "and a GOTO or GOSUB statement is issued to it.  Non-executable "
          "statements (REM, DATA) are excepted from this check."},
      Wuninit{
          true, "Wuninit", "Wno-uninit",
          "Warn when a variable is used but never initialized anywhere.",
          "The compiler will replace references to uninitialized string "
          "variables "
          "with \"\" and uninitialized numeric variables with 0 and remove the "
          "variable from the program.  This is likely to be the result of a "
          "typo "
          "or a forgotten initialization."},
      Wunused{true, "Wunused", "Wno-unused",
              "Warn when a variable is assigned to an expression "
              "but never used.",
              "The compiler deletes these variables from the program.  If the "
              "expression invokes RND or INKEY$, a special statement, 'EVAL' "
              "is used "
              "to ensure that the side-effects of changing the random number "
              "seed or "
              "adjusting the keyboard registers is performed.  Otherwise the "
              "expression will be deleted as well.  The warning usually occurs "
              "as the "
              "result of a typo or forgetting to use the variable."},
      Wbranch{true, "Wbranch", "Wno-branch",
              "Warn when conditional branches are pruned.",
              "The compiler may optimize ON..GOTO, ON..GOSUB, and IF..THEN "
              "statements "
              "if their respective predicates evaluates to a constant.  Since "
              "programmers rarely intend for that to happen in practice, this "
              "warning "
              "gets thrown."},
      dash{false, "-", nullptr, "Stop processing flag options.",
           "The '--' option allows compilation of filenames beginning with a "
           "dash "
           "('-')."} {
  table.push_back(&native);
  table.push_back(&g);
  table.push_back(&v);
  table.push_back(&list);
  table.push_back(&el);
  table.push_back(&ul);
  table.push_back(&mcode);
  table.push_back(&undoc);
  table.push_back(&Wfloat);
  table.push_back(&Wduplicate);
  table.push_back(&Wunreached);
  table.push_back(&Wuninit);
  table.push_back(&Wunused);
  table.push_back(&Wbranch);
  table.push_back(&dash);
}

void Options::usage(const char *progname) const {
  fprintf(stderr, "usage: %s --help\n", progname);
  fprintf(stderr, "       %s --help <option>\n", progname);
  int n = fprintf(stderr, "       %s", progname);

  for (const auto &option : table) {
    if (n > nWrap) {
      fprintf(stderr, "\n");
      n = fprintf(stderr, "%7s", "");
      for (size_t i = 0; i < strlen(progname); ++i) {
        n += fprintf(stderr, " ");
      }
    }
    n += fprintf(stderr, " [");
    if (option->onSwitch() && option->offSwitch()) {
      if (!strncmp(option->onSwitch(), "W", 1) &&
          !strncmp(option->offSwitch(), "Wno-", 4) &&
          !strcmp(option->onSwitch() + 1, option->offSwitch() + 4)) {
        n += fprintf(stderr, "-W[no-]%s", option->onSwitch() + 1);
      } else {
        n += fprintf(stderr, "-%s | -%s", option->onSwitch(),
                     option->offSwitch());
      }
    } else if (option->onSwitch()) {
      n += fprintf(stderr, "-%s", option->onSwitch());
    } else if (option->offSwitch()) {
      n += fprintf(stderr, "-%s", option->offSwitch());
    }
    n += fprintf(stderr, "]");
  }

  fprintf(stderr, "\n%7s", "");
  for (size_t i = 0; i < strlen(progname); ++i) {
    fprintf(stderr, " ");
  }
  fprintf(stderr, " file1 [file2 [file3...]]\n\n");
}

void Options::helpOptionSummary(const Option *option) const {
  if (option->onSwitch()) {
    fprintf(stderr, " -%-12s", option->onSwitch());
  }
  fprintf(stderr, " %s\n", option->summary());
  if (option->offSwitch()) {
    fprintf(stderr, "  %-12s (default) [-%s to disable]\n", "",
            option->offSwitch());
  }
  fprintf(stderr, "\n");
}

void Options::helpOptions() const {
  fprintf(stderr, "OPTIONS\n\n");
  for (const auto &option : table) {
    helpOptionSummary(option);
  }
}

void Options::helpOptionDetails(const Option *option) const {
  const char *text = option->details();

  do {
    int n = 0;
    while (text[n] && n < nWrap) {
      ++n;
    }

    while (text[n] && text[n] != ' ') {
      ++n;
    }

    fprintf(stderr, " %s\n", std::string(text, n ? n : n - 1).c_str());

    while (text[n] == ' ') {
      ++n;
    }

    text = text + n;
  } while (*text);
}

void Options::helpTopic(const char *progname, const char *target) const {
  // skip any leading '-'
  if (target[0] == '-') {
    ++target;
  }

  for (const auto &option : table) {
    if (option->onSwitch() &&
        (!strcmp(option->onSwitch(), target) ||
         (option->offSwitch() && !strcmp(option->offSwitch(), target)))) {
      helpOptionSummary(option);
      helpOptionDetails(option);

      return;
    }
  }
  fprintf(stderr, "%s --help: Unrecognized option \"%s\"\n", progname, target);
  exit(1);
}

Option *Options::findOption(const char *arg) {
  if (auto *opt = findOnSwitch(arg)) {
    return opt;
  }

  fprintf(stderr, "internal error: option \"%s\" not found\n", arg);
  exit(1);
}

// convert iterator idiom to pointer idiom
Option *Options::findOnSwitch(const char *arg) {
  auto op = std::find_if(table.begin(), table.end(), [&arg](const Option *o) {
    return arg && arg[0] && o->onSwitch() && !strcmp(arg + 1, o->onSwitch());
  });

  return op == table.end() ? nullptr : *op;
}

Option *Options::findOffSwitch(const char *arg) {
  auto op = std::find_if(table.begin(), table.end(), [&arg](const Option *o) {
    return arg && arg[0] && o->offSwitch() && !strcmp(arg + 1, o->offSwitch());
  });

  return op == table.end() ? nullptr : *op;
}

std::vector<const char *> Options::parse(int argc, const char *const argv[]) {

  const char *progname = argv[0];
  if (argc == 1) {
    usage(progname);
    exit(1);
  }

  if (!strcmp(argv[1], "--help")) {
    if (argc == 2) {
      usage(progname);
      helpOptions();
      exit(0);
    }

    if (argc == 3) {
      helpTopic(progname, argv[2]);
      exit(0);
    }

    usage(progname);
    exit(1);
  }

  int i = 1;
  for (; i < argc && !strncmp(argv[i], "-", 1); ++i) {
    if (auto *op = findOnSwitch(argv[i])) {
      op->setEnable(true);
    } else if (auto *op = findOffSwitch(argv[i])) {
      op->setEnable(false);
    } else {
      fprintf(stderr, "%s:  unrecognized option: \"%s\"\n", progname, argv[i]);
      usage(progname);
      exit(1);
    }

    if (!strcmp(argv[i], "--")) {
      ++i;
      break;
    }
  }

  std::vector<const char *> filenames;
  while (i < argc) {
    filenames.push_back(argv[i++]);
  }
  return filenames;
}
