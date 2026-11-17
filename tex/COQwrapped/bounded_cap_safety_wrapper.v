(* ================================================================ *)
(* Coq Wrapper: Bounded-Cap Safety Invariant (Corollary 2 / SPF)    *)
(* Proves that pre-committed capacity caps a* < C prevent collapse  *)
(* for all time steps t : nat. Pure math, altitude-separated.       *)
(* ================================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.

Module BoundedCapSafety.

Parameter C : R.       (* Maximum structural capacity ceiling *)
Parameter E0 : R.      (* Initial precedent / baseline level *)
Parameter a_star : R.  (* Pre-committed adaptation ceiling *)
Parameter D : nat -> R. (* Incoming demand sequence *)

Hypothesis H_init : E0 <= a_star.
Hypothesis H_cap  : a_star < C.

(* Capped adaptation policy: A_t = min(D_t, a*) *)
Definition A (t : nat) : R := Rmin (D t) a_star.

(* Precedent trajectory: E_{t+1} = max(E_t, A_t) *)
Fixpoint precedent (t : nat) : R :=
  match t with
  | O => E0
  | S k => Rmax (precedent k) (A k)
  end.

(* Inductive invariant: precedent never exceeds a* *)
Lemma precedent_bounded_by_cap :
  forall t : nat, precedent t <= a_star.
Proof.
  induction t as [| k IH].
  - simpl. exact H_init.
  - simpl. unfold A.
    apply Rmax_lub.
    + exact IH.
    + apply Rmin_r.
Qed.

(* Main safety theorem: system never reaches capacity ceiling C *)
Theorem never_collapses :
  forall t : nat, precedent t < C.
Proof.
  intro t.
  apply Rle_lt_trans with (r2 := a_star).
  - apply precedent_bounded_by_cap.
  - exact H_cap.
Qed.

End BoundedCapSafety.
