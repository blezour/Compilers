(* lab3/tree.ml *)

open Dict

(* |name| -- type for applied occurrences with annotations *)
type name = 
  { x_name: ident; 		(* Name of the reference *)
    x_line: int; 		(* Line number *)
    mutable x_def: def }        (* Definition in scope *)


(* Abstract syntax *)

type program = Program of decl list * stmt

and decl = Decl of name list * ptype

and stmt = 
    Skip 
  | Seq of stmt list
  | Assign of expr * expr
  | Print of expr
  | Newline
  | IfStmt of expr * stmt * stmt
  | WhileStmt of expr * stmt

and expr = 
  { e_guts: expr_guts;
    mutable e_type: ptype }

and expr_guts =
    Number of int 
  | Variable of name
  | Sub of expr * expr
  | Monop of Keiko.op * expr 
  | Binop of Keiko.op * expr * expr

let dummy = { d_tag = "*dummy*"; d_type = Void; d_lab = "*nolab*" }

let makeName x ln = 
  { x_name = x; x_line = ln; x_def = dummy }

let makeExpr e =
  { e_guts = e; e_type = Void }


(* Pretty printer *)

open Print

let fTail f xs =
  let g prf = List.iter (fun x -> prf " $" [f x]) xs in fExt g

let fList f =
  function
      [] -> fStr "()"
    | x::xs -> fMeta "($$)" [f x; fTail(f) xs]

let fName x = fStr x.x_name

let rec fType =
  function
      Integer -> fStr "INTEGER"
    | Boolean -> fStr "BOOLEAN"
    | Void -> fStr "VOID"
    | Array (n, t) -> fMeta "(ARRAY $ $)" [fNum n; fType t]

let fDecl (Decl (xs, t)) =
  fMeta "(DECL $ $)" [fList(fName) xs; fType t]

let rec fExpr e =
  match e.e_guts with
      Number n ->
	fMeta "(NUMBER $)" [fNum n]
    | Variable x -> 
	fMeta "(VARIABLE $)" [fName x]
    | Sub (e1, e2) ->
	fMeta "(SUB $ $)" [fExpr e1; fExpr e2]
    | Monop (w, e1) -> 
	fMeta "($ $)" [fStr (Keiko.op_name w); fExpr e1]
    | Binop (w, e1, e2) -> 
	fMeta "($ $ $)" [fStr (Keiko.op_name w); fExpr e1; fExpr e2]

let rec fStmt = 
  function
      Skip -> 
	fStr "(SKIP)"
    | Seq ss -> 
	fMeta "(SEQ$)" [fTail(fStmt) ss]
    | Assign (e1, e2) -> 
	fMeta "(ASSIGN $ $)" [fExpr e1; fExpr e2]
    | Print e -> 
	fMeta "(PRINT $)" [fExpr e]
    | Newline -> 
	fStr "(NEWLINE)"
    | IfStmt (e, s1, s2) ->
	fMeta "(IF $ $ $)" [fExpr e; fStmt s1; fStmt s2]
    | WhileStmt (e, s) -> 
	fMeta "(WHILE $ $)" [fExpr e; fStmt s]

let fProg (Program (ds, s)) = 
  fMeta "(PROGRAM $ $)" [fList(fDecl) ds; fStmt s]

let print_tree fp t = fgrindf fp "$" [fProg t]
