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

open Parsing;;
# 3 "parser.mly"
 
open Keiko
open Tree
# 39 "parser.ml"
let yytransl_const = [|
  263 (* SEMI *);
  264 (* DOT *);
  265 (* COLON *);
  266 (* LPAR *);
  267 (* RPAR *);
  268 (* COMMA *);
  269 (* MINUS *);
  270 (* VBAR *);
  271 (* ASSIGN *);
    0 (* EOF *);
  272 (* BADTOK *);
  273 (* BEGIN *);
  274 (* DO *);
  275 (* ELSE *);
  276 (* END *);
  277 (* IF *);
  278 (* THEN *);
  279 (* WHILE *);
  280 (* REPEAT *);
  281 (* UNTIL *);
  282 (* LOOP *);
  283 (* PRINT *);
  284 (* NEWLINE *);
  285 (* EXIT *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* MONOP *);
  259 (* MULOP *);
  260 (* ADDOP *);
  261 (* RELOP *);
  262 (* NUMBER *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\003\000\003\000\004\000\004\000\004\000\004\000\
\004\000\004\000\004\000\004\000\004\000\004\000\006\000\006\000\
\007\000\007\000\007\000\008\000\008\000\009\000\009\000\009\000\
\009\000\009\000\005\000\000\000"

let yylen = "\002\000\
\004\000\001\000\001\000\003\000\000\000\003\000\002\000\001\000\
\005\000\007\000\005\000\004\000\003\000\001\000\001\000\003\000\
\001\000\003\000\003\000\001\000\003\000\001\000\001\000\002\000\
\002\000\003\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\028\000\027\000\000\000\000\000\000\000\
\000\000\000\000\008\000\014\000\000\000\002\000\000\000\000\000\
\000\000\023\000\000\000\000\000\022\000\000\000\000\000\000\000\
\020\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\024\000\000\000\025\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\013\000\001\000\004\000\000\000\026\000\000\000\
\000\000\000\000\000\000\021\000\000\000\000\000\000\000\009\000\
\011\000\000\000\010\000"

let yydgoto = "\002\000\
\004\000\013\000\014\000\015\000\021\000\022\000\023\000\024\000\
\025\000"

let yysindex = "\020\000\
\000\255\000\000\018\255\000\000\000\000\128\255\128\255\018\255\
\018\255\128\255\000\000\000\000\028\255\000\000\049\255\043\255\
\128\255\000\000\128\255\128\255\000\000\008\255\003\255\059\255\
\000\000\005\255\048\255\057\255\082\255\081\255\018\255\128\255\
\000\000\004\255\000\000\128\255\018\255\128\255\128\255\128\255\
\018\255\128\255\000\000\000\000\000\000\082\255\000\000\003\255\
\017\255\059\255\059\255\000\000\071\255\082\255\018\255\000\000\
\000\000\078\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\063\255\000\000\000\000\000\000\000\000\015\255\
\063\255\000\000\000\000\000\000\000\000\000\000\112\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\007\255\046\255\
\000\000\000\000\000\000\000\000\092\255\000\000\094\255\000\000\
\000\000\000\000\000\000\000\000\065\255\000\000\000\000\000\000\
\063\255\000\000\000\000\000\000\000\000\101\255\000\000\085\255\
\000\000\056\255\075\255\000\000\000\000\108\255\063\255\000\000\
\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\250\255\071\000\000\000\253\255\001\000\070\000\016\000\
\240\255"

let yytablesize = 141
let yytable = "\016\000\
\033\000\027\000\028\000\035\000\016\000\016\000\038\000\026\000\
\036\000\036\000\029\000\015\000\036\000\015\000\047\000\039\000\
\003\000\015\000\005\000\034\000\001\000\005\000\041\000\052\000\
\015\000\015\000\015\000\016\000\015\000\037\000\049\000\015\000\
\046\000\016\000\053\000\055\000\056\000\016\000\006\000\005\000\
\007\000\008\000\054\000\009\000\010\000\011\000\012\000\030\000\
\058\000\017\000\017\000\016\000\017\000\050\000\051\000\031\000\
\017\000\032\000\017\000\018\000\018\000\040\000\018\000\017\000\
\017\000\017\000\018\000\017\000\018\000\005\000\017\000\005\000\
\042\000\018\000\018\000\018\000\043\000\018\000\019\000\019\000\
\018\000\019\000\005\000\005\000\005\000\019\000\036\000\019\000\
\044\000\016\000\057\000\016\000\019\000\019\000\019\000\016\000\
\019\000\059\000\007\000\019\000\005\000\045\000\016\000\016\000\
\016\000\048\000\016\000\006\000\000\000\016\000\007\000\007\000\
\005\000\005\000\012\000\000\000\007\000\000\000\005\000\006\000\
\006\000\000\000\000\000\000\000\000\000\006\000\012\000\012\000\
\005\000\017\000\003\000\003\000\012\000\018\000\000\000\000\000\
\003\000\019\000\000\000\000\000\020\000"

let yycheck = "\003\000\
\017\000\008\000\009\000\020\000\008\000\009\000\004\001\007\000\
\005\001\005\001\010\000\005\001\005\001\007\001\011\001\013\001\
\017\001\011\001\001\001\019\000\001\000\007\001\018\001\040\000\
\018\001\019\001\020\001\031\000\022\001\022\001\037\000\025\001\
\032\000\037\000\041\000\019\001\020\001\041\000\021\001\025\001\
\023\001\024\001\042\000\026\001\027\001\028\001\029\001\020\001\
\055\000\004\001\005\001\055\000\007\001\038\000\039\000\007\001\
\011\001\015\001\013\001\004\001\005\001\003\001\007\001\018\001\
\019\001\020\001\011\001\022\001\013\001\007\001\025\001\007\001\
\025\001\018\001\019\001\020\001\020\001\022\001\004\001\005\001\
\025\001\007\001\020\001\019\001\020\001\011\001\005\001\013\001\
\008\001\005\001\020\001\007\001\018\001\019\001\020\001\011\001\
\022\001\020\001\007\001\025\001\007\001\031\000\018\001\019\001\
\020\001\036\000\022\001\007\001\255\255\025\001\019\001\020\001\
\019\001\020\001\007\001\255\255\025\001\255\255\025\001\019\001\
\020\001\255\255\255\255\255\255\255\255\025\001\019\001\020\001\
\001\001\002\001\019\001\020\001\025\001\006\001\255\255\255\255\
\025\001\010\001\255\255\255\255\013\001"

let yynames_const = "\
  SEMI\000\
  DOT\000\
  COLON\000\
  LPAR\000\
  RPAR\000\
  COMMA\000\
  MINUS\000\
  VBAR\000\
  ASSIGN\000\
  EOF\000\
  BADTOK\000\
  BEGIN\000\
  DO\000\
  ELSE\000\
  END\000\
  IF\000\
  THEN\000\
  WHILE\000\
  REPEAT\000\
  UNTIL\000\
  LOOP\000\
  PRINT\000\
  NEWLINE\000\
  EXIT\000\
  "

let yynames_block = "\
  IDENT\000\
  MONOP\000\
  MULOP\000\
  ADDOP\000\
  RELOP\000\
  NUMBER\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'stmts) in
    Obj.repr(
# 24 "parser.mly"
                          ( Program _2 )
# 210 "parser.ml"
               : Tree.program))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 27 "parser.mly"
                 ( seq _1 )
# 217 "parser.ml"
               : 'stmts))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 30 "parser.mly"
            ( [_1] )
# 224 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 31 "parser.mly"
                          ( _1 :: _3 )
# 232 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 34 "parser.mly"
                   ( Skip )
# 238 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'name) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 35 "parser.mly"
                       ( Assign (_1, _3) )
# 246 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 36 "parser.mly"
                  ( Print _2 )
# 253 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 37 "parser.mly"
               ( Newline )
# 259 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 38 "parser.mly"
                            ( IfStmt (_2, _4, Skip) )
# 267 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'stmts) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 39 "parser.mly"
                                        ( IfStmt (_2, _4, _6) )
# 276 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 40 "parser.mly"
                             ( WhileStmt (_2, _4) )
# 284 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'stmts) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 41 "parser.mly"
                                        ( RepeatStmt (_2, _4) )
# 292 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 42 "parser.mly"
                                        ( LoopStmt (_2) )
# 299 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 43 "parser.mly"
                                        ( Exit )
# 305 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 46 "parser.mly"
              ( _1 )
# 312 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 47 "parser.mly"
                        ( Binop (_2, _1, _3) )
# 321 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 50 "parser.mly"
            ( _1 )
# 328 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 51 "parser.mly"
                        ( Binop (_2, _1, _3) )
# 337 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 52 "parser.mly"
                        ( Binop (Minus, _1, _3) )
# 345 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 55 "parser.mly"
              ( _1 )
# 352 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 56 "parser.mly"
                        ( Binop (_2, _1, _3) )
# 361 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'name) in
    Obj.repr(
# 59 "parser.mly"
            ( Variable _1 )
# 368 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 60 "parser.mly"
              ( Number _1 )
# 375 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 61 "parser.mly"
                   ( Monop (_1, _2) )
# 383 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 62 "parser.mly"
                   ( Monop (Uminus, _2) )
# 390 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 63 "parser.mly"
                     ( _2 )
# 397 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Tree.ident) in
    Obj.repr(
# 66 "parser.mly"
             ( make_name _1 !Lexer.lineno )
# 404 "parser.ml"
               : 'name))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Tree.program)
