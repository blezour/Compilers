(* ppc2/risc86.mli *)

open Keiko

(* |reg| -- type of Risc86 registers *)
type reg =
    R_0 | R_1 | R_2 | R_3 | R_4 | R_5 | R_bp | R_sp | R_any | R_none

(* |fReg| -- format register for printing *)
val fReg : reg -> Print.arg

(* |operand| -- type of operands for assembly instructions *)
type operand =			    (* VALUE		RISC86 SYNTAX *)
    Const of int 		    (* val		val	      *)
  | RegVal of reg		    (* [reg]		reg	      *)
  | Offset of int * reg		    (* val+[reg]        val(reg)      *)
  | Index of symbol * int * reg	    (* lab+val+[reg]	lab+val(reg)  *)
  | Global of symbol * int	    (* lab+val		lab+val       *)
  | Label of codelab		    (* lab		lab           *)
  | Symbol of symbol		    (* lab		lab	      *)
  | NoVal

(* |fRand| -- format operand for printing *)
val fRand : operand -> Print.arg

(* |reg_of| -- extract register (or R_none) from operand *)
val reg_of : operand -> reg

(* |emit| -- emit an assembly language instruction *)
val emit : string -> operand list -> unit

val emit_lab : Keiko.codelab -> unit

(* |preamble| -- emit first part of assembly language output *)
val preamble : unit -> unit

(* |postamble| -- emit last part of assembly language output *)
val postamble : unit -> unit

(* |start_proc| -- emit beginning of procedure *)
val start_proc : Keiko.symbol -> int -> unit

(* |end_proc| -- emit end of procedure *)
val end_proc : unit -> unit

(* |emit_string| -- emit assembler code for string constant *)
val emit_string : Keiko.symbol -> string -> unit

(* |emit_global| -- emit assembler code to define global variable *)
val emit_global : Keiko.symbol -> int -> unit
