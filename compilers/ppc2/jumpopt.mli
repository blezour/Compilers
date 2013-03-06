(* ppc2/jumpopt.mli *)

(* The jump optimiser looks for multiple labels on the same tree,
   jumps that lead to jumps, and other simple patterns in control flow. *)

(* |optimize| -- clean up a forest *)
val optimize : Keiko.optree list -> Keiko.optree list
