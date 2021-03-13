// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "options.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <cstddef>

static const char *const validOps[] = {"-Wfloat", "-Wno-float", "-g", "-list",
                                       "-native", "-undoc",     "--"};
static const bool exclusive[] = {true, false, false, false, false, false};

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
    Wfloat |= strcmp(argv[argcnt], "-Wfloat") == 0;
    Wfloat &= !(strcmp(argv[argcnt], "-Wno-float") == 0);
    undoc |= strcmp(argv[argcnt], "-undoc") == 0;
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
