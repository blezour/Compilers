(* ppc2/regs.ml *)

open Risc86
open Print

(* |pool| -- list of allocatable registers *)
let pool = [R_0; R_1; R_2; R_3; R_4; R_5]

(* |safe| -- list of callee-save registers *)
let safe = [R_3; R_4; R_5]

(* |regmap| -- hash table giving refcount for each resister *)
let regmap = Util.make_hash 20 (List.map (fun r -> (r, ref 0)) pool)

(* |is_free| -- test if register is free *)
let is_free r =
  try !(Hashtbl.find regmap r) = 0 with Not_found -> false

(* |refcount| -- apply function to refcount cell *)
let refcount f r =
  try f (Hashtbl.find regmap r) with Not_found -> ()

(* |find_first| -- find first element of list passing a test *)
let rec find_first p =
  function
      [] -> raise Not_found
    | x::xs -> if p x then x else find_first p xs

(* |alloc| -- allocate register from specified set *)
let alloc set =
  try 
    let r = find_first is_free set in
    refcount incr r; r
  with Not_found ->
    failwith "Sorry, I ran out of registers"

(* |alloc_reg| -- allocate any register *)
let alloc_reg () = alloc pool

(* |get_reg| -- replace R_any by specific register *)
let get_reg r =
  if r = R_any then alloc_reg () else r

(* |release_reg| -- release a register *)
let release_reg r =
  refcount decr r

(* |dump_regs| -- dump register state *)
let dump_regs () =
  printf "!R" [];
  List.iter 
    (fun r -> printf " $=$" [fReg r; fNum !(Hashtbl.find regmap r)])
    pool;
  printf "\n" []

(* |temp| -- data for temp variable *)
type temp =
  { t_id : int;				(* Name *)
    t_refct : int ref;			(* Number of references *)
    mutable t_reg : reg }		(* Allocated register *)

let ntemps = ref 0
let temptab = Hashtbl.create 129

(* |new_temp| -- create a temp variable *)
let new_temp c =
  incr ntemps; 
  let n = !ntemps in
  Hashtbl.add temptab n { t_id = n; t_refct = ref c; t_reg = R_none };
  n

(* |temp| -- get data for a temp variable *)
let temp n = Hashtbl.find temptab n

(* |inc_temp| -- increment refcount of a temp variable *)
let inc_temp n =
  let t = temp n in incr t.t_refct

(* |def_temp| -- specify register for a temp variable *)
let def_temp n r =
  let t = temp n in 
  t.t_reg <- r;
  decr t.t_refct;
  Hashtbl.find regmap r := !(t.t_refct)

(* |use_temp| -- find register for a temp variable *)
let use_temp n =
  let t = temp n in 
  decr t.t_refct; t.t_reg

(* |spill_temps| -- move temp variables to callee-save registers *)
let spill_temps () =
  Hashtbl.iter (fun n t ->
      if !(t.t_refct) > 0 && t.t_reg <> R_none
	  && not (List.mem t.t_reg safe) then begin
	let r = alloc safe in
	Hashtbl.find regmap r := !(Hashtbl.find regmap t.t_reg);
	Hashtbl.find regmap t.t_reg := 0;
	emit "mov" [RegVal r; RegVal t.t_reg];
	t.t_reg <- r
      end)
    temptab

let init () = 
  ntemps := 0;
  Hashtbl.clear temptab;
  let zero x = x := 0 in List.iter (refcount zero) pool
