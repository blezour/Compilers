(* lab2/memory.ml *)

(* |store| -- put a new label for exit commands to jump to on the top of the stack *)
let exitlabelstack = ref [];;
let store l = (exitlabelstack:= l :: !exitlabelstack);;

(* |recall| -- pop the top label from the stack *)
let recall = 
  let exitlabelstacktop = List.hd !exitlabelstack in
exitlabelstack := List.tl !exitlabelstack; exitlabelstacktop;; 

