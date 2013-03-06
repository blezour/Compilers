(* lab2/kgen.ml *)

open Tree
open Keiko

(* |gen_expr| -- generate code for an expression *)
let rec gen_expr =
  function
      Variable x ->
	SEQ [LINE x.x_line; LDGW x.x_name]
    | Number x ->
	CONST x
    | Monop (w, e1) ->
	SEQ [gen_expr e1; MONOP w]
    | Binop (w, e1, e2) ->
	SEQ [gen_expr e1; gen_expr e2; BINOP w]

(* |negate| -- map comparison operator to its opposite *)
let negate = 
  function Eq -> Neq | Neq -> Eq | Lt  -> Geq
    | Leq -> Gt | Gt -> Leq | Geq -> Lt
    | _ -> failwith "negate"

(* |gen_cond| -- generate code for short-circuit condition *)
let rec gen_cond sense lab e =
  (* Generate code to jump to |lab| if |e| has value |sense| *)
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
	  SEQ [gen_cond false lab e1; 
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
    | Seq stmts -> SEQ (List.map gen_stmt stmts)
    | Assign (v, e) ->
	SEQ [LINE v.x_line; gen_expr e; STGW v.x_name]
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
    | RepeatStmt (body, test) ->
        let lab1 = label () in
        SEQ [LABEL lab1; gen_stmt body; gen_cond true lab1 test]
    | LoopStmt (body) ->
        let lab1 = label () and lab2 = label () in 
        store lab2; SEQ [LABEL lab1; gen_stmt body; JUMP lab1; LABEL lab2]
    | Exit ->
        let lab1 = recall in
        SEQ [JUMP lab1]

(* |translate| -- generate code for the whole program *)
let translate (Program ss) =
  Keiko.output (gen_stmt ss)
