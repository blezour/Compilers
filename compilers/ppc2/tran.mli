(* ppc2/tran.mli *)

(* The function |translate| takes the body of a procedure (represented
   as a list of optrees) and generates machine code as a sequence of calls
   to the interface provided by the Risc86 module. *)

(* |translate| -- generate code for a procedure body *)
val translate : Keiko.symbol -> int -> Keiko.optree list -> unit

