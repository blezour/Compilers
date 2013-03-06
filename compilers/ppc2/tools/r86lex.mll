(* r86lex.mll *)

{
open R86parse
open Lexing

let lnum = ref 1
}

rule token = parse
    ['A'-'Z''a'-'z''_''$''.']['A'-'Z''a'-'z''0'-'9''_''$''.']*
			{ IDENT (lexeme lexbuf) }
  | '-'?['0'-'9']+	{ INTEGER (lexeme lexbuf) }
  | '%'['a'-'z''0'-'9']+ { REG (lexeme lexbuf) }
  | '('			{ LPAR }
  | ')'			{ RPAR }
  | ','			{ COMMA }
  | ':'			{ COLON }
  | '='			{ EQUAL }
  | '+'			{ PLUS }
  | [' ''\t']+		{ token lexbuf }
  | '!'[^'\n']*		{ token lexbuf }
  | '\n'		{ incr lnum; NL }
  | '"'([^'"']|'\\''"')*'"'
			{ STRING (lexeme lexbuf) }
  | _			{ BADTOK }
  | eof			{ EOF }
