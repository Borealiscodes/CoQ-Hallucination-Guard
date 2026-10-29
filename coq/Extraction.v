(* ===================================================================== *)
(* OCaml Functional Extraction Directives                                *)
(* Project: Coq-Hallucination-Guard (chguard) \times Node Beta Enclave   *)
(* ===================================================================== *)
From HolonomyRuntime Require Import BaseTernary.
Require Import Extraction.

Set Implicit Arguments.
Unset Strict Implicit.

(* Direct Coq to optimize out proof-only metadata during extraction *)
Extraction Language OCaml.

(* Custom constructor mapping to produce standard, optimal idiomatic OCaml layouts *)
Extract Inductive trit => "trit" [ "TMinus" "TZero" "TPlus" ].
Extract Inlined Definition trit_eq => "(fun t1 t2 -> t1 = t2)".
Extract Inlined Definition trit_opp => "(fun t -> match t with TMinus -> TPlus | TZero -> TZero | TPlus -> TMinus)".

(* Extract the structural modules directly into the local building layout path *)
Extraction "src/chguard/extracted_ternary.ml" trit BaseTernary.trit_add BaseTernary.trit_mul BaseTernary.constitutional_gate.
