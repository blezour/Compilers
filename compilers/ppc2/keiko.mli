(* ppc/keiko.mli *)

(* |op| -- type of picoPascal operators *)
type op = Plus | Minus | Times | Div | Mod | Eq 
  | Uminus | Lt | Gt | Leq | Geq | Neq 
  | And | Or | Not | PlusA | Lsl

val fOp : op -> Print.arg

(* |symbol| -- global symbols *)
type symbol = string

val nosym : symbol

val gensym : unit -> symbol

(* |codelab| -- type of code labels *)
type codelab

val nolab : codelab

(* |label| -- generate a code label *)
val label : unit -> codelab

val fLab : codelab -> Print.arg

(* |inst| -- type of intermediate instructions *)
type inst =
    CONST of int 		(* Constant (value) *)
  | GLOBAL of symbol * int	(* Global address (symbol, offset) *)
  | LOCAL of int		(* Local address (offset) *)
  | LOAD of int			(* Load (size) *)
  | STORE of int		(* Store (size) *)
  | FIXCOPY 			(* Copy multiple values (size) *)
  | CALL of int * int 		(* Call procedure (nparams, rsize) *)
  | RESULT of int		(* Procedure result (rsize) *)
  | MONOP of op			(* Perform unary operation (op) *)
  | BINOP of op			(* Perform binary operation (op) *)
  | BOUND of int	  	(* Array bound check (line) *)
  | NCHECK of int		(* Null pointer check (line) *)
  | LABEL of codelab		(* Set code label *)
  | JUMP of codelab		(* Unconditional branch (dest) *)
  | JUMPC of op * codelab	(* Conditional branch (cond, dest) *)
  | JUMPB of bool * codelab	(* Branch on boolean (val, dest) *)

  (* Extra instructions *)
  | LINE of int			(* Line number *)
  | NOP
  | SEQ
  | AFTER			(* Expression with side effect *)
  | TEMP of int			(* Temporary *)

(* |Inst| -- printf format for instructions *)
val fInst : inst -> Print.arg

(* |put| -- output an instruction or source line *)
val put : inst -> unit

(* |do_monop| -- evaluate unary operation *)
val do_monop : op -> int -> int

(* |do_binop| -- evaluate binary operation *)
val do_binop : op -> int -> int -> int

(* |negate| -- find opposite for comparison op *)
val negate : op -> op

(* Operator trees *)

(* |optree| -- type of operator trees *)
type optree = Node of inst * optree list

(* |canon| -- eliminate SEQ, NOP, AFTER nodes *)
val canon : optree -> optree list

(* |print_optree| -- output operator tree on stdout with line breaking *)
val print_optree : optree -> unit
