(* ppc/peepopt.ml *)

open Keiko
open Print

let debug = ref 0

(* Disjoint sets of labels *)

type lab_data = 
    LabDef of labrec 			(* An extant label *)
  | Equiv of codelab			(* A label that's been merged *)

and labrec =
  { y_id: codelab; 			(* Name of the label *)
    y_refct: int ref }			(* Reference count *)

(* |label_tab| -- map labels to their equivalents *)
let label_tab = Hashtbl.create 257

(* |get_label| -- get equivalence cell for a label *)
let get_label x =
  try !(Hashtbl.find label_tab x) with
    Not_found ->
      let y = LabDef { y_id = x; y_refct = ref 0 } in
      Hashtbl.add label_tab x (ref y); y

(* |find_label| -- find data about equivalence class of a label *)
let rec find_label x =
  match get_label x with
      LabDef y -> y
    | Equiv x' -> find_label x'

(* |rename| -- get canonical equivalent of a label *)
let rename x = let y = find_label x in y.y_id

(* |ref_count| -- get reference count cell for a label *)
let ref_count x = let y = find_label x in y.y_refct

(* |same_lab| -- test if two labels are equivalent *)
let same_lab x1 x2 = (rename x1 = rename x2)

(* |equate| -- make two labels equivalent *)
let equate x1 x2 =
  let y1 = find_label x1 and y2 = find_label x2 in
  if y1.y_id = y2.y_id then failwith "equate";
  y2.y_refct := !(y1.y_refct) + !(y2.y_refct);
  Hashtbl.find label_tab y1.y_id := Equiv y2.y_id

(* |do_refs| -- call function on refcount of each label in an instruction *)
let do_refs f =
  function
      JUMP x -> f (ref_count x)
    | JUMPB (b, x) -> f (ref_count x)
    | JUMPC (w, x) -> f (ref_count x)
    | JUMPCZ (w, x) -> f (ref_count x)
    | _ -> ()

(* |rename_labs| -- replace each label by its equivalent *)
let rename_labs =
  function
      LABEL x -> LABEL (rename x)
    | JUMP x -> JUMP (rename x)
    | JUMPB (b, x) -> JUMPB (b, rename x)
    | JUMPC (w, x) -> JUMPC (w, rename x)
    | JUMPCZ (w, x) -> JUMPCZ (w, rename x)
    | i -> i

(* |ruleset| -- simplify and introduce abbreviations *)
let ruleset replace =
  function
      LOCAL n :: LOAD s :: _ ->
	replace 2 [LDL (n, s)]
    | LOCAL n :: STORE s :: _ ->
	replace 2 [STL (n, s)]
    | GLOBAL x :: LOAD s :: _ ->
	replace 2 [LDG (x, s)]
    | GLOBAL x :: STORE s :: _ ->
	replace 2 [STG (x, s)]
    | CONST n :: BINOP PlusA :: LOAD s :: _->
	replace 3 [LDN (n, s)]
    | CONST n :: BINOP PlusA :: STORE s :: _ ->
	replace 3 [STN (n, s)]

    | LOCAL a :: CONST b :: BINOP PlusA :: _ ->
	replace 3 [LOCAL (a+b)]
    | CONST a :: BINOP PlusA :: CONST b :: BINOP PlusA :: _ ->
	replace 4 [CONST (a+b); BINOP PlusA]
     
    | BINOP (Eq|Leq|Geq|Lt|Gt|Neq as w) :: JUMPB (true, lab) :: _ ->
	replace 2 [JUMPC (w, lab)]
    | CONST 0 :: JUMPC (w, lab) :: _ ->
	replace 2 [JUMPCZ (w, lab)]

    | LABEL a :: LABEL b :: _ ->
	equate a b; replace 2 [LABEL a]
    | JUMP a :: LABEL b :: _ when same_lab a b ->
	replace 1 []
    | LABEL a :: _ when !(ref_count a) = 0 ->
	replace 1 []

    | _ -> ()


(* |optstep| -- apply rules at one place in the buffer *)
let optstep rules changed code =
  let ch = ref true in
  let replace n c = 
    changed := true; ch := true;
  if !debug > 0 then
      printf "! $ --> $\n" [fList(fInst) (Util.take n !code); fList(fInst) c];
    List.iter (do_refs decr) (Util.take n !code);
    List.iter (do_refs incr) c; 
    code := c @ Util.drop n !code in
  while !ch do
    ch := false; rules replace !code
  done

(* |rewrite| -- iterate over the code and apply rules *)
let rewrite rules prog =
  let code1 = ref prog and code2 = ref [] in
  let changed = ref true in
  while !changed do
    changed := false;
    while !code1 <> [] do
      optstep rules changed code1;
      if !code1 <> [] then begin
	code2 := rename_labs (List.hd !code1) :: !code2;
	code1 := List.tl !code1
      end
    done;
    code1 := List.rev !code2;
    code2 := []
  done;
  !code1

(* |optimise| -- rewrite list of instructions *)
let optimise prog =
  match Keiko.canon prog with
      SEQ code ->
	List.iter (do_refs incr) code;
	let code2 = rewrite ruleset code in
	Hashtbl.clear label_tab;
	SEQ code2
    | _ -> failwith "optimise"
