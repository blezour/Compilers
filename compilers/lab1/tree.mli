(* lab1/tree.mli *)

(* Abstract syntax *)

type expr =
    Number of float		(* Constant (value) *)
  | Variable of string		(* Variable (name) *)
  | Binop of op * expr * expr	(* Binary operator *)

and op = Plus | Minus | Times | Divide
