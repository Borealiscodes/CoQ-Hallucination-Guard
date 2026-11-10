(* ========================================================================== *
   MODULE: Tactics
   PROJECT: Coq-Hallucination-Guard (chguard Enclave)
   AUTHORS: Trinity Squad / Node Beta Downstream Observer
   PURPOSE: Enhanced high-efficiency Ltac automation routines for linear 
            list induction and thermodynamic dissipation monotonicity.
   ========================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.

Open Scope Z_scope.

(** 
  Tactic: chguard_crush
  Constructively clears structural conditions, automatically inverts 
  recursive list Forall boundaries, and handles modular arithmetic.
*)
Ltac chguard_crush :=
  intros;
  simpl in *;
  
  (* 1. Invert recursive Forall bounds declarations sequentially *)
  repeat match goal with

    | [ H : Forall _ nil |- _ ] => clear H
    | [ H : Forall _ (_ :: _) |- _ ] => inversion H; clear H; subst
    | [ H : _ /\ _ |- _ ] => destruct H
  end;
  
  (* 2. Clear trivial equalities and leverage lia over integer rings *)
  try easy;
  try ring;
  try lia.

(** 
  Tactic: verify_dissipation_step
  Automates the thermodynamic dissipation step check: F(s_{t+1}) <= F(s_t).
  Inverts the step transition relation and forces linear boundary reduction.
*)
Ltac verify_dissipation_step :=
  chguard_crush;
  match goal with

  | [ H : ?F_next <= ?F_curr |- ?F_next - 1 < ?F_curr ] => lia
  | _ => idtac
  end.

