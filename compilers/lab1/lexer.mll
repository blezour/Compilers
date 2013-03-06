(* lab1/lexer.mll *)

{
open Parser 
open Lexing
}

rule token = 
  parse
      ['A'-'Z''a'-'z']['A'-'Z''a'-'z''0'-'9''_']*
			{ IDENT (lexeme lexbuf) }
    | ['0'-'9']+("."['0'-'9']+)?
			{ NUMBER (float_of_string (lexeme lexbuf)) }
    | "("		{ OPEN }
    | ")"		{ CLOSE }
    | "="		{ EQUAL }
    | "+"		{ PLUS }
    | "-"		{ MINUS }
    | "*"		{ TIMES }
    | "/"		{ DIVIDE }
    | [' ''\t']+	{ token lexbuf }
    | "\n"		{ token lexbuf }
    | _			{ BADTOK }
    | eof		{ EOF }

