(* lab4/check.ml *)

open Tree 
open Dict 
open Print 

(* |err_line| -- line number for error messages *)
let err_line = ref 1

(* |Semantic_error| -- exception raised if error detected *)
exception Semantic_error of string * Print.arg list * int

(* |sem_error| -- issue error message by raising exception *)
let sem_error fmt args = 
  raise (Semantic_error (fmt, args, !err_line))

(* |lookup_def| -- find definition of a name, give error is none *)
let lookup_def env x =
  err_line := x.x_line;
  try let d = lookup x.x_name env in x.x_def <- d; d with 
    Not_found -> sem_error "$ is not declared" [fStr x.x_name]

(* |add_def| -- add definition to env, give error if already declared *)
let add_def d env =
  try define d env with 
    Exit -> sem_error "$ is already declared" [fStr d.d_tag]

(* |check_expr| -- check and annotate an expression *)
let rec check_expr env =
  function
      Number n -> ()
    | Variable x -> 
	let d = lookup_def env x  in
	begin
	  match d.d_kind with
	      VarDef -> ()
	    | ProcDef _ ->
		sem_error "$ is not a variable" [fStr x.x_name]
	end
    | Monop (w, e1) -> 
	check_expr env e1
    | Binop (w, e1, e2) -> 
	check_expr env e1;
	check_expr env e2
    | Call (p, args) ->
	let d = lookup_def env p in
	begin
	  match d.d_kind with
	      VarDef ->
		sem_error "$ is not a procedure" [fStr p.x_name]
	    | ProcDef nargs ->
		if List.length args <> nargs then
		  sem_error "procedure $ needs $ arguments" 
		    [fStr p.x_name; fNum nargs];
	end;
	List.iter (check_expr env) args

(* |check_stmt| -- check and annotate a statement *)
let rec check_stmt inproc env =
  function
      Skip -> ()
    | Seq ss ->
	List.iter (check_stmt inproc env) ss
    | Assign (x, e) ->
	let d = lookup_def env x in
	begin
	  match d.d_kind with
	      VarDef -> check_expr env e
	    | ProcDef n -> sem_error "$ is not a variable" [fStr x.x_name]
	end
    | Return e ->
	if not inproc then
	  sem_error "return statement only allowed in procedure" [];
	check_expr env e
    | IfStmt (test, thenpt, elsept) ->
	check_expr env test;
	check_stmt inproc env thenpt;
	check_stmt inproc env elsept
    | WhileStmt (test, body) ->
	check_expr env test;
	check_stmt inproc env body
    | Print e ->
	check_expr env e
    | Newline ->
	()

(* |serialize| -- number a list, starting from 0 *)
let serialize xs = 
  let rec count i =
    function
	[] -> []
      | x :: xs -> (i, x) :: count (i+1) xs in
  count 0 xs

(*
Frame layout

	arg n
	...
bp+16:	arg 1
bp+12:	static link
bp+8:   current cp
bp+4:   return addr
bp:	dynamic link
bp-4:   local 1
	...
	local m
*)

let arg_base = 16
let loc_base = 0

(* |declare_arg| -- declare a formal parameter *)
let declare_arg lev env (i, x) =
  let d = { d_tag = x; d_kind = VarDef; d_level = lev; 
		d_lab = ""; d_off = arg_base + 4*i } in
  add_def d env

(* |declare_arg| -- declare a local variable *)
let declare_local lev env (i, x) =
  let d = { d_tag = x; d_kind = VarDef; d_level = lev; 
		d_lab = ""; d_off = loc_base - 4*(i+1) } in
  add_def d env

(* |declare_global| -- declare a global variable *)
let declare_global env x =
  let d = { d_tag = x; d_kind = VarDef; d_level = 0; 
		d_lab = sprintf "_$" [fStr x]; d_off = 0 } in
  add_def d env

(* |declare_proc| -- declare a procedure *)
let declare_proc lev env (Proc (p, formals, body)) =
  let lab = sprintf "$_$" [fStr p.x_name; fNum (label ())] in
  let d = { d_tag = p.x_name; 
		d_kind = ProcDef (List.length formals); d_level = lev;
	    	d_lab = lab; d_off = 0 } in
  p.x_def <- d; add_def d env

(* |check_proc| -- check a procedure body *)
let rec check_proc lev env (Proc (p, formals, Block (vars, procs, body))) =
  err_line := p.x_line;
  let env' = 
    List.fold_left (declare_arg lev) (new_block env) (serialize formals) in
  let env'' = 
    List.fold_left (declare_local lev) env' (serialize vars) in
  let env''' = 
    List.fold_left (declare_proc (lev+1)) env'' procs in
  List.iter (check_proc (lev+1) env''') procs;
  check_stmt true env''' body

(* |annotate| -- check and annotate a program *)
let annotate (Program (Block (vars, procs, body))) =
  let env = List.fold_left declare_global empty vars in
  let env' = List.fold_left (declare_proc 1) env procs in
  List.iter (check_proc 1 env') procs;
  check_stmt false env' body
