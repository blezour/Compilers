(* lab4/tree.ml *)

open Dict

(* |name| -- type for applied occurrences with annotations *)
type name = 
  { x_name: ident; 		(* Name of the reference *)
    x_line: int; 		(* Line number *)
    mutable x_def: def }        (* Definition in scope *)

type expr = 
    Number of int
  | Variable of name
  | Monop of Keiko.op * expr
  | Binop of Keiko.op * expr * expr
  | Call of name * expr list

type stmt =
    Skip
  | Seq of stmt list
  | Assign of name * expr
  | Return of expr
  | IfStmt of expr * stmt * stmt
  | WhileStmt of expr * stmt
  | Print of expr
  | Newline

type block = Block of ident list * proc list * stmt

and proc = Proc of name * ident list * block

type program = Program of block

let dummy = 
  { d_tag = "*dummy*"; d_kind = VarDef; d_level = 0;
    d_lab = "*nolab*"; d_off = 0 }

let makeName x ln = 
  { x_name = x; x_line = ln; x_def = dummy }


(* Pretty printer *)

open Print

let fTail f xs =
  let g prf = List.iter (fun x -> prf " $" [f x]) xs in fExt g

let fList f =
  function
      [] -> fStr "()"
    | x::xs -> fMeta "($$)" [f x; fTail(f) xs]

let fName x = fStr x.x_name

let rec fExpr =
  function
      Number n ->
	fMeta "(NUMBER $)" [fNum n]
    | Variable x -> 
	fMeta "(VARIABLE $)" [fName x]
    | Monop (w, e1) -> 
	fMeta "($ $)" [fStr (Keiko.op_name w); fExpr e1]
    | Binop (w, e1, e2) -> 
	fMeta "($ $ $)" [fStr (Keiko.op_name w); fExpr e1; fExpr e2]
    | Call (x, es) ->
	fMeta "(CALL $$)" [fName x; fTail(fExpr) es]

let rec fStmt = 
  function
      Skip -> 
	fStr "(SKIP)"
    | Seq ss -> 
	fMeta "(SEQ$)" [fTail(fStmt) ss]
    | Assign (x, e) -> 
	fMeta "(ASSIGN $ $)" [fName x; fExpr e]
    | Return e ->
	fMeta "(RETURN $)" [fExpr e]
    | Print e -> 
	fMeta "(PRINT $)" [fExpr e]
    | Newline -> 
	fStr "(NEWLINE)"
    | IfStmt (e, s1, s2) ->
	fMeta "(IF $ $ $)" [fExpr e; fStmt s1; fStmt s2]
    | WhileStmt (e, s) -> 
	fMeta "(WHILE $ $)" [fExpr e; fStmt s]

let rec fBlock (Block (vs, ps, body)) =
  fMeta "(BLOCK $$ $)" [fList(fStr) vs; fTail(fProc) ps; fStmt body]

and fProc (Proc (x, fps, body)) =
  fMeta "(PROC $ $ $)" [fName x; fList(fStr) fps; fBlock body]

let print_tree fp (Program b) =
  fgrindf fp "(PROGRAM $)" [fBlock b]
