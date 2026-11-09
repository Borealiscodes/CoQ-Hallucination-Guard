(* ========================================================================== *
   MODULE: Extraction_Enhanced
   PROJECT: Coq-Hallucination-Guard (chguard Enclave)
   AUTHORS: Trinity Squad / Node Beta Downstream Observer
   PURPOSE: Extract newly verified rational math fields, 80D embeddings, 
            and deterministic abort logic into high-efficiency OCaml code.
            Maps Coq types directly to OCaml native Zarith for speed.
   ========================================================================== *)

Require Import Coq.Extraction.
Require Import Coq.ZArith.ZArith.

Require Import Ultra_Zeno_Rational_Math.
Require Import Manifold_80D_Embedding.
Require Import Manifold_80D_Metric_Tensor.
Require Import Manifold_Deterministic_Abort.

(* -------------------------------------------------------------------------- *
   1. NATIVE OCAML TYPE MAPPINGS FOR HARDWARE REGISTERS
   -------------------------------------------------------------------------- *)

(* Map Coq's inductive Z type straight to OCaml's optimized Zarith integer library *)
Extract Inductive Z => "Z.t" [ "Z.zero" "(\<_ -> Z.succ Z.zero)" ] 
  "___" (* Custom match expression for efficiency *).
Extract Constant Z.add => "Z.add".
Extract Constant Z.sub => "Z.sub".
Extract Constant Z.mul => "Z.mul".
Extract Constant Z.gcd => "Z.gcd".
Extract Constant Z.div => "Z.div".
Extract Constant Z.leb => "Z.leq".

(* Map standard list structures directly to native OCaml arrays or lists *)
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive bool => "bool" [ "true" "false" ].

(* -------------------------------------------------------------------------- *
   2. EXTRACTION TARGET DIRECTIVES
   -------------------------------------------------------------------------- *)

Unset Extraction Optimize.
Set Extraction AccessControls.

Extraction Language OCaml.

(* Extract everything necessary to assemble the live Python/Zig gateway *)
Extraction "src/chguard/extracted_ternary_enhanced.ml"
  rat_add
  rat_mul
  lift_spinor_vector
  embed_8d_to_80d
  manifold_distance_sq
  evaluate_enclave_step.
