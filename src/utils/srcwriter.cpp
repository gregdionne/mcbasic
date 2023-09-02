// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "srcwriter.hpp"

#include <cstdio>  //f...
#include <cstdlib> //perror
#include <cstring> //strlen

void SrcWriter::init() {
  strncpy(outname, filename, BUFSIZ);
  outname[BUFSIZ - 1] = '\0';
  char *ext = strrchr(outname, '.');
  if (!ext) {
    strcat(outname, ".asm");
  } else {
    strcpy(ext, ".asm");
  }
}

void SrcWriter::open() {
  fp = fopen(outname, "w");
  if (!fp) {
    fprintf(stderr, "%s: ", progname);
    perror(filename);
    exit(1);
  }
}

void SrcWriter::writeString(const std::string &ops) {
  fprintf(fp, "%s", ops.c_str());
}

void SrcWriter::write(const std::string &ops) {
  if (options.S.isEnabled()) {
    open();
    writeString(ops);
    close();
  }
}

void SrcWriter::close() { fclose(fp); }
