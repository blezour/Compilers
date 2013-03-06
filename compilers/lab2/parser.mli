type token =
  | IDENT of (Tree.ident)
  | MONOP of (Keiko.op)
  | MULOP of (Keiko.op)
  | ADDOP of (Keiko.op)
  | RELOP of (Keiko.op)
  | NUMBER of (int)
  | SEMI
  | DOT
  | COLON
  | LPAR
  | RPAR
  | COMMA
  | MINUS
  | VBAR
  | ASSIGN
  | EOF
  | BADTOK
  | BEGIN
  | DO
  | ELSE
  | END
  | IF
  | THEN
  | WHILE
  | REPEAT
  | UNTIL
  | LOOP
  | PRINT
  | NEWLINE
  | EXIT

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Tree.program
