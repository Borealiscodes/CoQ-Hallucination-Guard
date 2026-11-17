(* ================================================================ *)
(* Coq Wrapper: Disciplined vs. Post-Hoc Attribution Drift (SPF)    *)
(* Formalizes geometric decay under prior-fixed likelihood bounds   *)
(* vs. non-updating odds under post-hoc excuse selection.           *)
(* ================================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.

Module AttributionDrift.

Parameter omega0 : R.
Hypothesis H_omega0 : omega0 > 0.

Fixpoint odds (ratio : nat -> R) (t : nat) : R :=
  match t with
  | O => omega0
  | S k => odds ratio k * ratio k
  end.

(* Part 1: Disciplined prior-fixed bound (0 <= ratio t <= rho) *)
Theorem disciplined_geometric_decay :
  forall (ratio : nat -> R) (rho : R),
    0 <= rho ->
    (forall t : nat, 0 <= ratio t /\ ratio t <= rho) ->
    forall t : nat, 0 <= odds ratio t /\ odds ratio t <= (rho ^ t) * omega0.
Proof.
  intros ratio rho Hrho Hbound t.
  induction t as [| k [IH_nonneg IH_upper]].
  - simpl. lra.
  - simpl.
    destruct (Hbound k) as [Hr_nonneg Hr_upper].
    split.
    + apply Rmult_le_pos; assumption.
    + assert (Hstep : odds ratio k * ratio k <= ((rho ^ k) * omega0) * rho).
      { apply Rmult_le_compat; assumption. }
      lra.
Qed.

(* Part 2: Post-hoc excuse inflation (ratio t >= 1) never reduces odds *)
Theorem post_hoc_excuse_stagnation :
  forall (ratio : nat -> R),
    (forall t : nat, 1 <= ratio t) ->
    forall t : nat, omega0 <= odds ratio t.
Proof.
  intros ratio Hge1 t.
  induction t as [| k IH].
  - simpl. lra.
  - simpl.
    specialize (Hge1 k).
    assert (Hpos : 0 < odds ratio k) by lra.
    nra.
Qed.

End AttributionDrift.
