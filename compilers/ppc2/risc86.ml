(* ppc2/risc86.ml *)

open Keiko
open Print

(* |reg| -- type of Risc86 registers *)
type reg =
    R_0 | R_1 | R_2 | R_3 | R_4 | R_5 | R_bp | R_sp | R_any | R_none

let reg_name =
  function
      R_0 -> "%0" | R_1 -> "%1" | R_2 -> "%2" | R_3 -> "%3"
    | R_4 -> "%4" | R_5 -> "%5" | R_bp -> "%bp" | R_sp -> "%sp"
    | R_any -> "*ANYREG*" | R_none -> "*NOREG*"

(* |fReg| -- format register for printing *)
let fReg r = fStr (reg_name r)

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
let fRand =
  function
      Const v -> fNum v
    | RegVal reg -> fReg reg
    | Offset (off, reg) -> 
	if off = 0 then fMeta "($)" [fReg reg] else
	  fMeta "$($)" [fNum off; fReg reg]
    | Index (lab, off, reg) ->
	if off = 0 then fMeta "$($)" [fStr lab; fReg reg] else
	  fMeta "$+$($)" [fStr lab; fNum off; fReg reg]
    | Global (lab, off) ->
	if off = 0 then fStr lab else fMeta "$+$" [fStr lab; fNum off]
    | Label lab -> fMeta ".L$" [fLab lab]
    | Symbol sym -> fStr sym
    | NoVal -> fStr "*NoVal*"

(* |reg_of| -- extract register (or R_none) from operand *)
let reg_of = 
  function
      RegVal reg -> reg
    | Offset (off, reg) -> reg
    | Index (lab, off, reg) -> reg
    | _ -> failwith "reg_of"

(* |emit| -- emit an assembly language instruction *)
let emit inst rands =
  if rands = [] then
    printf "\t$\n" [fStr inst]
  else
    printf "\t$ $\n" [fStr inst; fList(fRand) rands]

let emit_lab lab =
  printf ".L$:\n" [fLab lab]

(* |seg| -- type of assembler segments *)
type seg = Text | Data | Unknown

(* |current_seg| -- current output segment *)
let current_seg = ref Unknown

(* |segment| -- emit segment directive if needed *)
let segment s =
  if !current_seg <> s then begin
    let seg_name = 
      match s with 
	Text -> ".text" | Data -> ".data" | Unknown -> "*unknown*" in
    printf "\t$\n" [fStr seg_name];
    current_seg := s
  end

(* |preamble| -- emit start of assembler file *)
let preamble () =
  printf "! picoPascal compiler output\n" [];
  printf "\t.global _pmain\n\n" []

(* |postamble| -- finish the assembler file *)
let postamble () =
  printf "! End\n" []

(* |start_proc| -- emit start of procedure *)
let start_proc lab fsize =
  segment Text;
  printf "$:\n" [fStr lab];
  printf "\tprolog\n" [];
  if fsize > 0 then
    printf "\tsub %sp, %sp, $\n" [fNum fsize]

(* |end_proc| -- emit end of procedure *)
let end_proc () =
  printf "\tepilog\n" [];
  printf "\tret\n\n" []

(* |emit_string| -- output a string constant *)
let emit_string lab s =
  segment Data;
  printf "$:" [fStr lab];
  let n = String.length s in
  for k = 0 to n-1 do
    let c = int_of_char s.[k] in
    if k mod 10 = 0 then 
      printf "\n\t.byte $" [fNum c]
    else
      printf ", $" [fNum c]
  done;
  printf "\n\t.byte 0\n" []

(* |emit_export| -- export a label *)
let emit_export lab =
  printf "\t.global $\n" [fStr lab]

(* |emit_global| -- output a global variable *)
let emit_global lab n =
  printf "\t.common $, $, 4\n" [fStr lab; fNum n]
