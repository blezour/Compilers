(* lab3/kgen.ml *)

open Dict 
open Tree 
open Keiko 
open Print

(* |line_number| -- find line number of variable reference *)
let rec line_number e =
  match e.e_guts with
      Variable x -> x.x_line
    | Sub (a, e) -> line_number a
    | _ -> 999

(* |gen_expr| -- generate code for an expression *)
let rec gen_expr e =
  match e.e_guts with
      Variable _ | Sub _ ->
	SEQ [gen_addr e; LOADW]
    | Number n ->
	CONST n
    | Monop (w, e1) ->
	SEQ [gen_expr e1; MONOP w]
    | Binop (w, e1, e2) ->
	SEQ [gen_expr e1; gen_expr e2; BINOP w]

(* |gen_addr| -- generate code to push address of a variable *)
and gen_addr v =
  match v.e_guts with
      Variable x ->
	let d = x.x_def in
	SEQ [LINE x.x_line; GLOBAL d.d_lab]
    | _ ->
	failwith "gen_addr"

(* |negate| -- map comparison op to its negation *)
let negate = 
  function Eq -> Neq | Neq -> Eq | Lt  -> Geq
    | Leq -> Gt | Gt  -> Leq | Geq -> Lt
    | _ -> failwith "negate"

(* |gen_cond| -- generate code for short-circuit condition *)
let rec gen_cond sense lab e =
  match e.e_guts with
      Number x ->
        let b = (x <> 0) in
	if b = sense then JUMP lab else NOP
    | Binop ((Eq|Neq|Lt|Gt|Leq|Geq) as w, e1, e2) ->
	SEQ [gen_expr e1; gen_expr e2;
	  JUMPC ((if sense then w else negate w), lab)]
    | Monop (Not, e) ->
	gen_cond (not sense) lab e
    | Binop (And, e1, e2) ->
	if sense then begin
	  let lab1 = label () in
	  SEQ [gen_cond false lab1 e1;
	    gen_cond true lab e2; LABEL lab1]
	end
	else begin
	  SEQ [gen_cond false lab e1;
	    gen_cond false lab e2]
	end
    | Binop (Or, e1, e2) ->
	if sense then begin
	  SEQ [gen_cond true lab e1;
	    gen_cond true lab e2]
	end
	else begin
	  let lab1 = label () in
	  SEQ [gen_cond true lab1 e1;
	    gen_cond false lab e2; LABEL lab1]
	end
    | _ ->
	SEQ [gen_expr e; JUMPB (sense, lab)]

(* |gen_stmt| -- generate code for a statement *)
let rec gen_stmt =
  function
      Skip -> NOP
    | Seq ss -> SEQ (List.map gen_stmt ss)
    | Assign (v, e) ->
	SEQ [LINE (line_number v); gen_expr e; gen_addr v; STOREW]
    | Print e ->
	SEQ [gen_expr e; GLOBAL "Lib.Print"; CALL 1]
    | Newline ->
	SEQ [GLOBAL "Lib.Newline"; CALL 0]
    | IfStmt (test, thenpt, elsept) ->
        let lab1 = label () and lab2 = label () in
        SEQ [gen_cond false lab1 test;
	  gen_stmt thenpt; JUMP lab2;
	  LABEL lab1; gen_stmt elsept; LABEL lab2]
    | WhileStmt (test, body) ->
        let lab1 = label () and lab2 = label () in
        SEQ [LABEL lab1; gen_cond false lab2 test;
	  gen_stmt body; JUMP lab1; LABEL lab2]

let gen_decl (Decl (xs, t)) =
  List.iter (fun x ->
      let d = x.x_def in
      let s = 4 in
      printf "GLOVAR $ $\n" [fStr d.d_lab; fNum s]) xs

(* |translate| -- generate code for the whole program *)
let translate (Program (ds, ss)) = 
  printf "PROC MAIN 0 0 0\n" [];
  Keiko.output (gen_stmt ss);
  printf "RETURN\n" [];
  printf "END\n\n" [];
  List.iter gen_decl ds



