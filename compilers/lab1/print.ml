(* common/print.ml *)

type arg = 
    Str of string 		(* String *)
  | Chr of char 		(* Character *)
  | Ext of ((string -> arg list -> unit) -> unit)  (* Extension *)

(* |do_print| -- the guts of printf and friends *)
let rec do_print out_fun fmt args =
  let j = ref 0 in
  for i = 0 to String.length fmt - 1 do
    let c = fmt.[i] in
    if c <> '$' then
      out_fun c
    else begin
      begin try
	match List.nth args !j with
	    Str s -> 
	      for k = 0 to String.length s - 1 do out_fun s.[k] done
	  | Chr c -> 
	      out_fun c
	  | Ext f -> 
	      f (do_print out_fun)
      with Invalid_argument _ -> 
	for i = 0 to 2 do out_fun '*' done
      end;
      incr j
    end
  done

let fNum n = Str (string_of_int n)
let fFlo x = Str (string_of_float x)
let fStr s = Str s
let fChr c = Chr c
let fBool b = Str (if b then "true" else "false")
let fExt f = Ext f

let fFix (n, w) =
  let digits = string_of_int n in
  let w0 = String.length digits in
  let padding = if w0 >= w then "" else String.make (w-w0) ' ' in
  Str (padding ^ digits)

(* |fMeta| -- insert output of recursive call to printf *)
let fMeta fmt args = Ext (function prf -> prf fmt args)

(* |fList| -- format a comma-separated list *)
let fList cvt xs = 
  let f prf =
    if xs <> [] then begin
      prf "$" [cvt (List.hd xs)];
      List.iter (function y -> prf ", $" [cvt y]) (List.tl xs)
    end in
  Ext f

(* |fprintf| -- print to a file *)
let fprintf fp fmt args = do_print (output_char fp) fmt args

(* |printf| -- print on standard output *)
let printf fmt args = fprintf stdout fmt args; flush stdout

(* |sprintf| -- print to a string *)
let sprintf fmt args =
  let buf = String.create 256 and n = ref 0 in
  let store c = buf.[!n] <- c; incr n in
  do_print store fmt args;
  String.sub buf 0 !n

open Format

let rec do_grind fmt args =
  let n = String.length fmt in
  let i, j = ref 0, ref 0 in
  while !i < n do
    begin match fmt.[!i] with
	'$' ->
	  begin try 
	    match List.nth args !j with
	      | Chr c -> print_char c
	      | Str s -> print_string s
	      | Ext f -> f do_grind
	  with Invalid_argument _ -> 
	    print_string "***"
	  end;
	  incr j
      | ' ' -> print_space ()
      | '_' -> print_char ' '
      | '(' -> open_hvbox 2; print_char '('
      | ')' -> print_char ')'; close_box ()
      | c -> print_char c
    end;
    incr i
  done

(* |fgrindf| -- pretty-printer *)
let rec fgrindf fp fmt args =
  set_formatter_out_channel fp;
  do_grind fmt args;
  print_newline ()
