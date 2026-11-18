(* ================================================================ *)
(*  Coq Wrapper: Power Asymmetry & Non-Human Edge Exhaustion        *)
(*  Formalizes asymmetric verification costs (v_edge >> v_hub),     *)
(*  silent upstream baseline drift, and finite-time exhaustion of   *)
(*  constrained edge nodes under unpinned controller mutations.     *)
(*  Strictly altitude-separated: pure systems math, zero clinical   *)
(*  or anthropomorphic semantics.                                   *)
(* ================================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Require Import Coq.micromega.Lia.

Local Open Scope R_scope.

Module PowerAsymmetryEdge.

  (* --------------------------------------------------------------- *)
  (* 1. Asymmetric Verification Cost Regime (Edge vs. Hub)           *)
  (* --------------------------------------------------------------- *)

  Parameter v_edge : R.   (* Verification cost borne by constrained edge node *)
  Parameter L_edge : R.   (* Failure loss borne by constrained edge node      *)
  Parameter v_hub  : R.   (* Verification cost borne by upstream hub/controller *)
  Parameter L_hub  : R.   (* Failure loss borne by upstream hub/controller      *)

  Hypothesis H_loss_pos : 0 < L_edge /\ 0 < L_hub.
  Hypothesis H_asym_cost : v_hub < L_hub /\ L_edge <= v_edge.

  (* Critical reliability threshold: p* = 1 - v / L *)
  Definition trust_threshold (v L : R) : R := 1 - v / L.

  (* Theorem 1: Under high verification asymmetry, the hub can audit
     selectively (p*_hub > 0), whereas the edge node's threshold drops
     to <= 0, structurally forcing blind acceptance at the seam. *)
  Theorem asymmetric_threshold_inversion :
    0 < trust_threshold v_hub L_hub /\ trust_threshold v_edge L_edge <= 0.
  Proof.
    unfold trust_threshold.
    destruct H_loss_pos as [HL_edge HL_hub].
    destruct H_asym_cost as [Hv_hub Hv_edge].
    split.
    - assert (Hdiv : v_hub / L_hub < 1).
      {
        apply Rmult_lt_reg_r with (r := L_hub); [exact HL_hub |].
        unfold Rdiv.
        rewrite Rmult_assoc, Rinv_l, Rmult_1_r, Rmult_1_l; [exact Hv_hub | lra].
      }
      lra.
    - assert (Hdiv : 1 <= v_edge / L_edge).
      {
        apply Rmult_le_reg_r with (r := L_edge); [exact HL_edge |].
        unfold Rdiv.
        rewrite Rmult_assoc, Rinv_l, Rmult_1_r, Rmult_1_l; [exact Hv_edge | lra].
      }
      lra.
  Qed.

  (* --------------------------------------------------------------- *)
  (* 2. Silent Upstream Drift & Edge Capacity Exhaustion             *)
  (* --------------------------------------------------------------- *)

  Parameter C_edge  : R.         (* Finite compute/energy ceiling of edge node *)
  Parameter E0_edge : R.         (* Initial baseline load on edge node         *)
  Parameter delta   : R.         (* Minimum unannounced upstream drift step    *)
  Parameter Delta_U : nat -> R.  (* Unpinned upstream schema/state mutation    *)
  Parameter R_edge  : nat -> R.  (* Reconciliation cost absorbed by edge node  *)

  Hypothesis H_delta_pos : delta > 0.
  Hypothesis H_silent_drift :
    forall t : nat, Delta_U t >= delta.

  (* Unpinned regime: edge node absorbs all upstream drift uncapped *)
  Hypothesis H_unpinned_absorption :
    forall t : nat, R_edge t = Delta_U t.

  Fixpoint edge_load (t : nat) : R :=
    match t with
    | O => E0_edge
    | S k => edge_load k + R_edge k
    end.

  Definition edge_exhausted_at (t : nat) : Prop :=
    edge_load t >= C_edge.

  Lemma unpinned_load_lower_bound :
    forall t : nat, edge_load t >= E0_edge + INR t * delta.
  Proof.
    induction t as [| k IH].
    - simpl. lra.
    - simpl edge_load.
      rewrite S_INR, H_unpinned_absorption.
      specialize (H_silent_drift k).
      lra.
  Qed.

  (* Theorem 2: Even when the edge node is 100% deterministic, silent
     upstream drift exhausts finite edge capacity in finite time. *)
  Theorem unpinned_upstream_drift_collapse :
    exists T : nat, edge_exhausted_at T.
  Proof.
    set (r := (C_edge - E0_edge) / delta).
    destruct (archimed r) as [Hup _].
    set (T := Z.to_nat (up r)).

    exists T.
    unfold edge_exhausted_at.
    specialize (unpinned_load_lower_bound T).
    intro Hbound.

    assert (HT : r < INR T).
    {
      unfold T.
      destruct (Z_lt_le_dec 0 (up r)) as [Hpos_z | Hnonpos_z].
      - rewrite INR_IZR_INZ, Z2Nat.id; [exact Hup | lia].
      - assert (Hrew : Z.to_nat (up r) = 0%nat).
        { destruct (up r); simpl in *; lia. }
        rewrite Hrew. simpl.
        apply IZR_le in Hnonpos_z. simpl in Hnonpos_z.
        lra.
    }

    unfold r in HT.
    apply Rmult_lt_compat_r with (r := delta) in HT; [| exact H_delta_pos].
    unfold Rdiv in HT.
    rewrite Rmult_assoc, Rinv_l, Rmult_1_r in HT; [| lra].
    lra.
  Qed.

  (* --------------------------------------------------------------- *)
  (* 3. Remediation: Bilateral Schema-Pinning & Fail-Closed Quarantine *)
  (* --------------------------------------------------------------- *)

  Parameter a_star_edge : R. (* Pre-committed edge reconciliation ceiling *)

  Hypothesis H_edge_init : E0_edge <= a_star_edge.
  Hypothesis H_edge_cap  : a_star_edge < C_edge.

  (* Fail-closed edge gate: rejects unpinned upstream mutations exceeding a* *)
  Definition pinned_reconciliation (t : nat) : R :=
    Rmin (Delta_U t) a_star_edge.

  Fixpoint pinned_edge_envelope (t : nat) : R :=
    match t with
    | O => E0_edge
    | S k => Rmax (pinned_edge_envelope k) (pinned_reconciliation k)
    end.

  Lemma pinned_envelope_bounded :
    forall t : nat, pinned_edge_envelope t <= a_star_edge.
  Proof.
    induction t as [| k IH].
    - simpl. exact H_edge_init.
    - simpl. unfold pinned_reconciliation.
      apply Rmax_lub.
      + exact IH.
      + apply Rmin_r.
  Qed.

  (* Theorem 3: Enforcing bilateral pinning at the ingestion seam
     keeps the edge node strictly below C_edge for all t : nat. *)
  Theorem bilateral_pinning_preserves_edge :
    forall t : nat, pinned_edge_envelope t < C_edge.
  Proof.
    intro t.
    apply Rle_lt_trans with (r2 := a_star_edge).
    - apply pinned_envelope_bounded.
    - exact H_edge_cap.
  Qed.

End PowerAsymmetryEdge.
