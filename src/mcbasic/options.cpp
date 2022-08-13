// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "options.hpp"

#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>

static const char *const validOps[] = {"-native",     "-g",
                                       "-list",       "-el",
                                       "-ul",         "-mcode",
                                       "-undoc",      "-v",
                                       "-Wfloat",     "-Wno-float",
                                       "-Wduplicate", "-Wno-duplicate",
                                       "-Wunreached", "-Wno-unreached",
                                       "-Wuninit",    "-Wno-uninit",
                                       "-Wunused",    "-Wno-unused",
                                       "-Wbranch",    "-Wno-branch",
                                       "--"};

static const bool exclusive[] = {
    false, false, false, false, false, false, false, false, true, false,
    true,  false, true,  false, true,  false, true,  false, true, false};

void usage(char *argv[]) {
  fprintf(stderr, "usage: %s ", argv[0]);

  std::size_t nopts = sizeof(validOps) / sizeof(char *);

  if (nopts != 0) {
    fprintf(stderr, "[%s", validOps[0]);
    for (std::size_t i = 1; i < nopts; i++) {
      fprintf(stderr, "%s%s", exclusive[i - 1] ? " | " : "] [", validOps[i]);
    }
    fprintf(stderr, "] ");
  }

  fprintf(stderr, "file1 [file2 [file3...]]\n");
  exit(1);
}

void Options::validate(int argc, char *argv[]) {
  for (int i = 1; i < argc; i++) {
    if (strncmp(argv[i], "-", 1) == 0) {
      bool found = false;

      std::size_t nopts = sizeof(validOps) / sizeof(char *);
      for (std::size_t j = 0; j < nopts; ++j) {
        found |= strcmp(argv[i], validOps[j]) == 0;
      }

      if (!found) {
        fprintf(stderr, "%s:  unrecognized option: \"%s\"\n", argv[0], argv[i]);
        usage(argv);
      }
    }
  }
}

void Options::process(int argc, char *argv[]) {
  argcnt = 1;
  while (argcnt < argc && (strncmp(argv[argcnt], "-", 1) == 0) &&
         (strcmp(argv[argcnt], "--") != 0)) {
    native |= strcmp(argv[argcnt], "-native") == 0;
    g |= strcmp(argv[argcnt], "-g") == 0;
    list |= strcmp(argv[argcnt], "-list") == 0;
    el |= strcmp(argv[argcnt], "-el") == 0;
    ul |= strcmp(argv[argcnt], "-ul") == 0;
    v |= strcmp(argv[argcnt], "-v") == 0;
    mcode |= strcmp(argv[argcnt], "-mcode") == 0;
    undoc |= strcmp(argv[argcnt], "-undoc") == 0;
    Wfloat |= strcmp(argv[argcnt], "-Wfloat") == 0;
    Wfloat &= !(strcmp(argv[argcnt], "-Wno-float") == 0);
    Wduplicate |= strcmp(argv[argcnt], "-Wduplicate") == 0;
    Wduplicate &= !(strcmp(argv[argcnt], "-Wno-duplicate") == 0);
    Wunreached |= strcmp(argv[argcnt], "-Wunreached") == 0;
    Wunreached &= !(strcmp(argv[argcnt], "-Wno-unreached") == 0);
    Wuninit |= strcmp(argv[argcnt], "-Wuninit") == 0;
    Wuninit &= !(strcmp(argv[argcnt], "-Wno-uninit") == 0);
    Wunused |= strcmp(argv[argcnt], "-Wunused") == 0;
    Wunused &= !(strcmp(argv[argcnt], "-Wno-unused") == 0);
    Wbranch |= strcmp(argv[argcnt], "-Wbranch") == 0;
    Wbranch &= !(strcmp(argv[argcnt], "-Wno-branch") == 0);
    argcnt++;
  }

  if (argcnt < argc && (strcmp(argv[argcnt], "--") == 0)) {
    argcnt++;
  }
}

void Options::init(int argc, char *argv[]) {
  validate(argc, argv);
  process(argc, argv);
}
