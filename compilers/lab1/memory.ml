(* lab1/memory.ml *)

(* |store| -- set a memory (named by a string) to a given value *)
let table = ref [];;
let store x v = (table := (x,v):: !table);;

(* |recall| -- retrieve the value from a given memory, or fail *)
let recall varname = List.assoc varname !table;;
