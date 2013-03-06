(* lab1/memory.mli *)

(* |store| -- set a memory (named by a string) to a given value *) 
val store : string -> float -> unit

(* |recall| -- retrieve the value from a given memory, or fail *)
val recall : string -> float
