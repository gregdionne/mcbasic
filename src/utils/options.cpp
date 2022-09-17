// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "options.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

namespace utils {

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

    fprintf(stderr, " %s\n", std::string(text, n).c_str());

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

} // namespace utils
