(* ppc/lexer.mll *)

{
open Print
open Keiko
open Dict
open Parser
open Lexing
open Source

let lineno = ref 1			(* Current line in input file *)

let symtable = 
  Util.make_hash 100
    [ ("array", ARRAY); ("begin", BEGIN);
      ("const", CONST); ("do", DO); ("if", IF ); ("else", ELSE); 
      ("end", END); ("of", OF); 
      ("proc", PROC); ("record", RECORD);
      ("return", RETURN); ("then", THEN); ("to", TO);
      ("type", TYPE); ("var", VAR); ("while", WHILE);
      ("pointer", POINTER); ("nil", NIL);
      ("and", MULOP And); ("div", MULOP Div); ("or", ADDOP Or);
      ("not", NOT); ("mod", MULOP Mod) ]

let lookup s =
  try Hashtbl.find symtable s with
    Not_found -> 
      let x = IDENT (new_ident s) in
      Hashtbl.add symtable s x;
      x

let intern s =
  match lookup s with
      IDENT x -> x
    | _ -> failwith (sprintf "intern $" [fStr s])

(* |strtbl| -- table of string constants from source program *)
let strtbl = ref []

(* |get_string| -- convert a string constant *)
let get_string s =
  let lab = gensym () in
  let n = String.length s in
  let s' = String.create (n-2)
  and i = ref 1 and j = ref 0 in
  while !i <> n-1 do
    let c = s.[!i] in
    s'.[!j] <- c;
    if c = '"' then incr i;
    incr i; incr j
  done;
  strtbl := (lab, String.sub s' 0 !j)::!strtbl;
  STRING (lab, !j)

(* |string_table| -- return contents of string table *)
let string_table () = List.rev !strtbl

let next_line lexbuf =
  incr lineno; Source.note_line !lineno lexbuf
}

rule token = parse
  ['A'-'Z''a'-'z']['A'-'Z''a'-'z''0'-'9''_']*
			{ lookup (lexeme lexbuf) }
| ['0'-'9']+		{ NUMBER (int_of_string (lexeme lexbuf)) }
| '''[^''']'''		{ let s = lexeme lexbuf in CHAR s.[1] }
| "''''"		{ CHAR '\'' }
| '"'([^'"']|'"''"')*'"' { get_string (lexeme lexbuf) }
| ";"			{ SEMI }
| "."			{ DOT }
| ".."			{ DOTDOT }
| "|"			{ VBAR }
| ":"			{ COLON }
| "^"			{ ARROW }
| "("			{ LPAR }
| ")"			{ RPAR }
| ","			{ COMMA }
| "["			{ SUB }
| "]"			{ BUS }
| "="			{ EQUAL }
| "+"			{ ADDOP Plus }
| "-"			{ MINUS }
| "*"			{ MULOP Times }
| "<"			{ RELOP Lt }
| ">"			{ RELOP Gt }
| "<>"			{ RELOP Neq }
| "<="			{ RELOP Leq }
| ">="			{ RELOP Geq }
| ":="			{ ASSIGN }
| [' ''\t']+		{ token lexbuf }
| "(*"			{ comment lexbuf; token lexbuf }
| "\n"			{ next_line lexbuf; token lexbuf }
| _			{ BADTOK }
| eof			{ err_message "unexpected end of file" [] !lineno; 
			  exit 1 }

and comment = parse
  "*)"			{ () }
| "\n"			{ next_line lexbuf; comment lexbuf }
| _			{ comment lexbuf }
| eof			{ err_message "end of file in comment" [] !lineno; 
			  exit 1 }

