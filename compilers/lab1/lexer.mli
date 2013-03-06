(* lab1/lexer.mli *)

(* |token| -- scan the next token *)
val token : Lexing.lexbuf -> Parser.token
