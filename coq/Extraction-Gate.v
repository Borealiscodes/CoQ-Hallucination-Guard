(* ========================================================================== *
   MODULE: Extraction Gate
   PROJECT: Coq-Hallucination-Guard (chguard Enclave)
   AUTHORS: Trinity Squad / Node Beta Downstream Observer
   PURPOSE: Configure and execute the formal compiler extraction pipeline.
            Extracts the verified scale-invariant ternary codecs, 
            Z3 modular parity checks, and hardware refinement mappings 
            into pure, zero-overhead native OCaml source modules.
   ========================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.extraction.Extraction.

(* Load the entire verified catalog to prepare the kernel context *)
Require Import Ultra_Zeno_Rational_Math.
Require Import Base243_Bijection.
Require Import Base243_Ternary_Parity.
Require Import RuntimeFusion.
Require Import SpectralIntegration.
Require Import Manifold_Deterministic_Abort.

Open Scope Z_scope.

(* -------------------------------------------------------------------------- *
   1. TARGET SUBSTRATE COMPILER TUNING (NATIVE INTEGER INTEROP)
   -------------------------------------------------------------------------- *)

(** Map Coq's arbitrary-precision inductive Z type straight onto OCaml's 
    native 64-bit integer type (`int64`) to match CPU register boundaries. *)
Extract Inductive Z => "int64" [ "0L" "" ]
  "(fun fO fP fN n -> if n = 0L then fO () else if n > 0L then fP n else fN (Int64.neg n))".

Extract Constant Z.add => "Int64.add".
Extract Constant Z.sub => "Int64.sub".
Extract Constant Z.mul => "Int64.mul".
Extract Constant Z.div => "Int64.div".
Extract Constant Z.modulo => "Int64.rem".
Extract Constant Z.eqb => "(fun a b -> a = b)".
Extract Constant Z.leb => "(fun a b -> a <= b)".
Extract Constant Z.ltb => "(fun a b -> a < b)".
Extract Constant Z.gcd => 
  "(fun a b ->
     let rec gcd_loop x y = if y = 0L then Int64.abs x else gcd_loop y (Int64.rem x y) in
     gcd_loop a b)".

(* -------------------------------------------------------------------------- *
   2. REFINEMENT EXTRACTION INVARIANT COMMANDS
   -------------------------------------------------------------------------- *)

Extraction Inline shift_t unshift_t shift_trit.

(* Extract the standalone code modules to generate the binary blueprints *)
Extraction "chguard_enclave.ml"
  pack_list
  unpack_list
  satisfies_z3_parity
  sum_shifted_trits
  deserialize_trits_to_bytes
  runtime_fusion_equivalence_invariant
  sum_dirichlet_energy
  signed_laplacian_positive_semidefinite
  audit_ledger_epoch
  unconditional_epochal_guillotine.
