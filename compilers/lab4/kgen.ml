(* lab4/kgen.ml *)

open Tree 
open Dict 
open Keiko 
open Print 

let level = ref 0

let slink = 12

let gen_addr d =
  if d.d_level = 0 then
    GLOBAL d.d_lab
  else
    failwith "local variables not implemented yet"

(* |gen_expr| -- generate code for an expression *)
let rec gen_expr =
  function
      Variable x ->
	let d = x.x_def in
	begin
	  match d.d_kind with
	      VarDef ->
		SEQ [LINE x.x_line; gen_addr d; LOADW]
	    | ProcDef nargs -> 
		failwith "no procedure values"
	end
    | Number x ->
	CONST x
    | Monop (w, e1) ->
	SEQ [gen_expr e1; MONOP w]
    | Binop (w, e1, e2) ->
	SEQ [gen_expr e1; gen_expr e2; BINOP w]
    | Call (p, args) ->
        SEQ [LINE p.x_line;
	  failwith "no procedure call"]

(* |negate| -- map comparison op to its negation *)
let negate = 
  function Eq -> Neq | Neq -> Eq | Lt  -> Geq
    | Leq -> Gt | Gt  -> Leq | Geq -> Lt
    | _ -> failwith "negate"

(* |gen_cond| -- generate code for short-circuit condition *)
let rec gen_cond sense lab e =
  match e with
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
    | e ->
	SEQ [gen_expr e; JUMPB (sense, lab)]

(* |gen_stmt| -- generate code for a statement *)
let rec gen_stmt =
  function
      Skip -> NOP
    | Seq ss ->
	SEQ (List.map gen_stmt ss)
    | Assign (v, e) ->
	let d = v.x_def in
	begin
	  match d.d_kind with
	      VarDef ->
		SEQ [gen_expr e; gen_addr d; STOREW]
	   | _ -> failwith "assign"
	end
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
    | Return e ->
	failwith "no return statement"

(* |gen_proc| -- generate code for a procedure *)
let rec gen_proc (Proc (p, formals, Block (vars, procs, body))) =
  let d = p.x_def in
  level := d.d_level;
  printf "PROC $ $ 0 0\n" [fStr d.d_lab; fNum (4 * List.length vars)];
  Keiko.output (gen_stmt body);
  printf "ERROR E_RETURN 0\n" [];
  printf "END\n\n" [];
  List.iter gen_proc procs

(* |translate| -- generate code for the whole program *)
let translate (Program (Block (vars, procs, body))) =
  level := 0;
  printf "PROC MAIN 0 0 0\n" [];
  Keiko.output (gen_stmt body);
  printf "RETURN\n" [];
  printf "END\n\n" [];
  List.iter gen_proc procs;
  List.iter (function x -> printf "GLOVAR _$ 4\n" [fStr x]) vars
