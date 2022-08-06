// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "writer.hpp"

#include <cmath>   //fabs
#include <cstdio>  //f...
#include <cstdlib> //perror
#include <cstring> //strlen

void Writer::init() {
  opts.init(argc, argv);
  argcnt = opts.argcnt;
}

void Writer::close() { fclose(fp); }

bool Writer::openNext() {
  if (argcnt < argc) {
    static char outname[BUFSIZ];
    strncpy(outname, argv[argcnt], BUFSIZ);
    outname[BUFSIZ - 1] = '\0';
    char *ext = strrchr(outname, '.');
    if (!ext) {
      strcat(outname, ".asm");
    } else {
      strcpy(ext, ".asm");
    }

    fp = fopen(outname, "w");
    if (!fp) {
      fprintf(stderr, "%s: ", argv[0]);
      perror(argv[argcnt]);
      exit(1);
    }
    filecnt = argcnt;
    argcnt++;
    return true;
  }
  argcnt = 0;
  return false;
}

void Writer::writeHeader() {
  fprintf(fp, "; Assembly for %s\n", argv[filecnt]);
  fprintf(fp, "; compiled with");

  for (int i = 0; i < opts.argcnt; i++) {
    fprintf(fp, " %s", argv[i]);
  }

  fprintf(fp, "\n\n");
}

void Writer::writeString(const std::string &ops) {
  fprintf(fp, "%s", ops.c_str());
}
