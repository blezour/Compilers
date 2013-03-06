(* ppc/mach.ml *)

(* |metrics| -- target representation of data object *)
type metrics = 
  { r_size: int; 		(* Size of object *)
    r_align: int }		(* Address must be multiple of this *)

let int_rep = { r_size = 4; r_align = 4 }
let char_rep = { r_size = 1; r_align = 1 }
let bool_rep = { r_size = 1; r_align = 1 }
let void_rep = { r_size = 0; r_align = 1 }
let addr_rep = { r_size = 4; r_align = 4 }
let proc_rep = { r_size = 8; r_align = 4 }
let param_rep = { r_size = 4; r_align = 4 }
let max_align = 4

(* 
Frame layout:

	arg n
	...
24	arg 1
	----------------
20	static link
16	return address
12	saved ebx
 8	saved esi
 4	saved edi
bp:	dynamic link
	----------------
	local 1
	...
	local m
*)

let param_base = 24
let local_base = 0
let stat_link = 20
