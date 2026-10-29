(* ===================================================================== *)
(* Extracted Source: Strict 8b.is Balanced Ternary Algebra               *)
(* Generated via Coq Native Extraction Directive Enclaves                *)
(* ===================================================================== *)

type trit = TMinus | TZero | TPlus

(** Formally verified decidable equality checking *)
let trit_eq t1 t2 =
  match (t1, t2) with
  | TMinus, TMinus -> true
  | TZero, TZero -> true
  | TPlus, TPlus -> true
  | _ -> false

(** Structural negation: Inversion across the 0 structural anchor *)
let trit_opp t =
  match t with
  | TMinus -> TPlus
  | TZero -> TZero
  | TPlus -> TMinus

(** Balanced Ternary Addition mapping: Returns (Carry, Sum) pair *)
let trit_add t1 t2 =
  match (t1, t2) with
  | TZero, x -> (TZero, x)
  | x, TZero -> (TZero, x)
  | TPlus, TPlus -> (TPlus, TMinus)
  | TMinus, TMinus -> (TMinus, TPlus)
  | TPlus, TMinus -> (TZero, TZero)
  | TMinus, TPlus -> (TZero, TZero)

(** Balanced Ternary Multiplication: Branchless state-collapse operator *)
let trit_mul t1 t2 =
  match (t1, t2) with
  | TZero, _ -> TZero
  | _, TZero -> TZero
  | TPlus, x -> x
  | x, TPlus -> x
  | TMinus, TMinus -> TPlus

(** Constitutional Presence Verification Gate: PRINTABLE = HELD ∧ READ *)
let constitutional_gate held read =
  match (held, read) with
  | true, true -> TPlus
  | true, false -> TZero
  | _ -> TMinus
