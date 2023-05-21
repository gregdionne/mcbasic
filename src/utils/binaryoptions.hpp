// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef UTILS_OPTIONS_HPP
#define UTILS_OPTIONS_HPP

#include "binaryoption.hpp"

#include <vector>

namespace utils {

// Binary options parser for command-line interfaces.
// Intended to be subclassed.  Something like:
//
// #include "binaryoptions.hpp"
//
// class CLIOptions : public utils::BinaryOptions {
// public:
//   CLIOptions();
//   BinaryOption option1;
//   BinaryOption option2;
// };
//
// CLIOptions::CLIOptions()
//     : option1{false, "option1", nullptr, "normally false option",
//               "detailed info for an option that is normally false "
//               "unless you specify '-option1' on the input"},
//       option2{true, "option2", "no-option2", "normally true option",
//               "option2 is 'true' unless -no-option2 is specified"} {
//   addBinaryOption(&option1);
//   addBinaryOption(&option2);
// }
//
// int main(int argc, char *argv[]) {
//   CLIOptions options;
//   auto arguments = options.parse(argc, argv);
//
//   if (options.option1.isEnabled()) {
//     printf("%s was enabled\n", options.option1.c_str());
//   }
//
//   printf("option2's state was %s\n", options.option2.c_str());
//   printf("option2 could be either %s or %s\n", options.option2.onSwitch(),
//          options.option2.offSwitch());
//   return 0;
// }
//
// // > c++ -std=c++14 clioptions.cpp binaryoptions.cpp
// // > ./a.out
// // usage: ./a.out -help
// //        ./a.out -help <option>
// //        ./a.out [-option1] [-option2 | -no-option2]
// //                file1 [file2 [file3...]]
// //
// // > ./a.out -help
// // usage: ./a.out -help
// //        ./a.out -help <option>
// //        ./a.out [-option1] [-option2 | -no-option2]
// //                file1 [file2 [file3...]]
// //
// // OPTIONS
// //
// //  -option1      normally false option
// //
// //  -option2      normally true option
// //                (default) [-no-option2 to disable]
// //
// // > ./a.out -help option2
// //  -option2      normally true option
// //                (default) [-no-option2 to disable]
// //
// //  option2 is 'true' unless -no-option2 is specified

class BinaryOptions {
public:
  std::vector<const char *> parse(int argc, const char *const argv[]);
  const std::vector<BinaryOption *> &getTable() const { return table; }
  void addBinaryOption(BinaryOption *option) { table.push_back(option); }

private:
  BinaryOption *findBinaryOption(const char *arg);
  BinaryOption *findOnSwitch(const char *arg);
  BinaryOption *findOffSwitch(const char *arg);
  void usage(const char *progname) const;
  void helpBinaryOptionSummary(const BinaryOption *option) const;
  void helpBinaryOptionDetails(const BinaryOption *option) const;
  void helpBinaryOptions() const;
  void helpTopic(const char *progname, const char *target) const;
  std::vector<BinaryOption *> table;
  const int nWrap = 65;
};

} // namespace utils

#endif
