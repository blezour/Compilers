(* ppc2/simp.mli *)

(* The simplifier runs over the trees in a forest, looking for algebraic
   simplifications such as constant folding.  It's mostly directed towards
   tidying up addressing calculations. *)

(* |optimize| -- clean up a forest *)
val optimize : Keiko.optree list -> Keiko.optree list
