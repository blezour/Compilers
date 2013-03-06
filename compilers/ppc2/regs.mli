(* ppc2/regs.mli *)

open Risc86

val init : unit -> unit

(* alloc_reg -- allocate any register *)
val alloc_reg : unit -> reg

(* get_reg -- use specified register or allocate one *)
val get_reg : reg -> reg

(* release_reg -- decrement reference count of register *)
val release_reg : reg -> unit

val dump_regs : unit -> unit


(* Temps *)

val new_temp : int -> int

val inc_temp : int -> unit

val use_temp : int -> reg

val def_temp : int -> reg -> unit

val spill_temps : unit -> unit

