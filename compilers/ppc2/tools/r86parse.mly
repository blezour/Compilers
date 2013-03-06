/* r86parse.mly */

%token<string> IDENT REG INTEGER
%token PLUS LPAR RPAR COMMA COLON NL EQUAL BADTOK EOF

%type<unit> program
%start program

%{
open R86ops
open Print
%}

%%

program : 
    /* EMPTY */			{ () }
  | program NL			{ () }
  | program line NL		{ () } ;

line :
    IDENT COLON			{ emit_lab $1 }
  | IDENT			{ emit_instr $1 [] }
  | IDENT rands			{ emit_instr $1 $2 }
  | IDENT EQUAL rand		{ put "$ = $" [fStr $1; fRand $3] } ;

rands :
    rand			{ [$1] }
  | rand COMMA rands		{ $1::$3 } ;

rand :
    REG				{ Reg (find_reg $1) }
  | const			{ Const $1 }
  | const LPAR REG RPAR		{ Index ($1, find_reg $3) }
  | LPAR REG RPAR		{ Index ("0", find_reg $2) } ;

const :
    IDENT			{ $1 }
  | IDENT PLUS INTEGER		{ $1^"+"^$3 }
  | INTEGER			{ $1 } ;
