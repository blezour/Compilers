(* nclex.mll *)

{
open Ncparse 
open String 
open Lexing

let line_no = ref 1
}

rule token =
  parse
      "<"['A'-'Z''a'-'z']+	{ let s = lexeme lexbuf in
				  OPEN (sub s 1 (length s - 1)) }
    | [^'<''>''('')'',''@'' ''\n']+  
				{ WORD (lexeme lexbuf) }
    | "(*"[^'\n']*"*)"		{ WORD (lexeme lexbuf) }
    | " "			{ SPACE }
    | ">"			{ CLOSE }
    | "("			{ LPAREN }
    | ")"			{ RPAREN }
    | ","			{ COMMA }
    | "@"			{ ATSIGN }
    | "\n"			{ incr line_no; CHAR "\n" }
    | _				{ CHAR (lexeme lexbuf) }
    | eof			{ EOF }

