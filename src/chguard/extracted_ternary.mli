(* ===================================================================== *)
(* Extracted Interface: Strict 8b.is Balanced Ternary Algebra            *)
(* Generated via Coq Native Extraction Directive Enclaves                *)
(* ===================================================================== *)

type trit = TMinus | TZero | TPlus

val trit_eq : trit -> trit -> bool
val trit_opp : trit -> trit
val trit_add : trit -> trit -> trit * trit
val trit_mul : trit -> trit -> trit
val constitutional_gate : bool -> bool -> trit
