(* lab3/dict.ml *)

(* Environments are implemented using a library module that 
   represents mappings by balanced binary trees. *)

type ident = string

type ptype = 
    Integer 
  | Boolean 
  | Array of int * ptype
  | Void

(* |def| -- definitions in environment *)
type def = 
  { d_tag: ident; 		(* Name *)
    d_type: ptype;		(* Type *)
    d_lab: string }		(* Global label *)

module IdMap = Map.Make(struct type t = ident  let compare = compare end)

let type_size v =  match v with
    Integer -> 4
  | Boolean -> 1
  | Array(x, y) -> x * (type_size y);; 

let is_array v = match v with
    Integer -> false
  | Boolean -> false
  | Array(x,y) -> true

let base_type v = match v with
    Integer -> raise Exit;
  | Boolean -> raise Exit;
  | Array(x,y) -> y;;

type environment = Env of def IdMap.t

let can f x = try f x; true with Not_found -> false

(* |define| -- add a definition *)
let define d (Env e) = 
  if can (IdMap.find d.d_tag) e then raise Exit;
  Env (IdMap.add d.d_tag d e)

(* |lookup| -- find definition of an identifier *)
let lookup x (Env e) = IdMap.find x e

(* |init_env| -- empty environment *)
let init_env = Env IdMap.empty
