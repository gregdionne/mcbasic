// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_FWDDECLSTATEMENT_HPP
#define AST_FWDDECLSTATEMENT_HPP

// forward declarations for visitors

class Statement; // TOKEN
class For;       // $80,$A2,$A5 (for/to/step)
class Go;        // $81,$82     (goto/gosub)
class Rem;       // $83
class If;        // $84,$A3     (if/then)
class Data;      // $85
class Print;     // $86,$9A     (print,lprint)
class On;        // $87
class Input;     // $88
class End;       // $89
class Next;      // $8A
class Dim;       // $8B
class Read;      // $8C
class Let;       // $8D
class Run;       // $8E
class Restore;   // $8F
class Return;    // $90
class Stop;      // $91
class Poke;      // $92
class Clear;     // $95
class CLoadM;    // $97
class CLoadStar; // $97
class CSaveStar; // $98
class Set;       // $9B
class Reset;     // $9C
class Cls;       // $9D
class Sound;     // $9E
class Exec;      // $9F

// extensions
class When;
class Accum;
class Decum;
class Necum;
class Eval;
class Error;

#endif
