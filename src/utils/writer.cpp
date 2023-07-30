// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "writer.hpp"

#include <cmath>   //fabs
#include <cstdio>  //f...
#include <cstdlib> //perror
#include <cstring> //strlen

void Writer::close() { fclose(fp); }

void Writer::open() {
  static char outname[BUFSIZ];
  strncpy(outname, filename, BUFSIZ);
  outname[BUFSIZ - 1] = '\0';
  char *ext = strrchr(outname, '.');
  if (!ext) {
    strcat(outname, ".asm");
  } else {
    strcpy(ext, ".asm");
  }

  fp = fopen(outname, "w");
  if (!fp) {
    fprintf(stderr, "%s: ", progname);
    perror(filename);
    exit(1);
  }
}

void Writer::writeHeader() {
  fprintf(fp, "; Assembly for %s\n", filename);
  fprintf(fp, "; compiled with");

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
  fprintf(fp, " %s", pname.c_str());

  // only report switches that affect code generation
  // (skip the verbose, list, and warning flags)
  for (const auto &option : options.getTable()) {
    const char *opt = option->c_str();
    if (option->isEnabled() && strcmp(opt, "v") && strcmp(opt, "list") &&
        strncmp(opt, "W", 1)) {
      fprintf(fp, " -%s", opt);
    }
  }

  fprintf(fp, "\n\n");
}

void Writer::writeString(const std::string &ops) {
  fprintf(fp, "%s", ops.c_str());
}

void Writer::write(const std::string &ops) {
  open();
  writeHeader();
  writeString(ops);
  close();
}
