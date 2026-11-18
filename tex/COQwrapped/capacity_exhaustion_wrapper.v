(* ================================================================ *)
(*  Coq Wrapper: Capacity Exhaustion Cascade                       *)
(*  This module formalizes the bounded-capacity collapse invariant *)
(*  described in the Sustainable Presence Framework monograph.     *)
(*  It is altitude-separated: pure math, no psychological semantics. *)
(* ================================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Require Import Coq.micromega.Lia.

Local Open Scope R_scope.

Module CapacityCollapse.

  (* --------------------------------------------------------------- *)
  (* Parameters                                                      *)
  (* --------------------------------------------------------------- *)

  Parameter C : R.        (* Maximum structural capacity ceiling *)
  Parameter m : R.        (* Margin / buffer term                *)
  Parameter E0 : R.       (* Initial energy level                *)
  Parameter p : R.        (* Positive drift coefficient          *)
  Parameter delta : R.    (* Minimum step-size of demand drift   *)

  Hypothesis p_pos : p > 0.
  Hypothesis delta_pos : delta > 0.

  (* --------------------------------------------------------------- *)
  (* Demand and adaptation functions                                 *)
  (* --------------------------------------------------------------- *)

  (* D_t: incoming demand at time t *)
  Parameter D : nat -> R.

  (* A_t: adaptation weight applied by the host *)
  Parameter A : nat -> R.

  (* Each incoming demand exceeds baseline by at least delta *)
  Hypothesis demand_step :
    forall t : nat, D t >= delta.

  (* Uncapped continuous adaptation policy: A_t = D_t *)
  Hypothesis adaptation_policy :
    forall t : nat, A t = D t.

  (* --------------------------------------------------------------- *)
  (* Energy trajectory definition                                    *)
  (* --------------------------------------------------------------- *)

  (* Y_{t+1} = Y_t + p * A_t *)
  Fixpoint energy (t : nat) : R :=
    match t with
    | O => E0
    | S k => energy k + p * A k
    end.

  (* Linear lower bound driven by uncapped adaptation policy *)
  Lemma energy_lower_bound :
    forall t : nat, energy t >= E0 + INR t * (p * delta).
  Proof.
    induction t as [| k IH].
    - simpl. lra.
    - simpl energy.
      rewrite S_INR.
      rewrite adaptation_policy.
      specialize (demand_step k).
      assert (Hstep : p * D k >= p * delta).
      { nra. }
      lra.
  Qed.

  (* --------------------------------------------------------------- *)
  (* Collapse condition: energy crosses capacity ceiling C + m       *)
  (* --------------------------------------------------------------- *)

  Definition collapses_at (t : nat) : Prop :=
    energy t >= C + m.

  (* --------------------------------------------------------------- *)
  (* Main theorem: collapse occurs in finite time                    *)
  (* --------------------------------------------------------------- *)

  Theorem finite_time_collapse :
    exists T : nat, collapses_at T.
  Proof.
    assert (Hpos : p * delta > 0).
    { apply Rmult_gt_0_compat; assumption. }

    (* Constructive witness via Coq's Archimedean property *)
    set (r := (C + m - E0) / (p * delta)).
    destruct (archimed r) as [Hup _].
    set (T := Z.to_nat (up r)).

    exists T.
    unfold collapses_at.
    specialize (energy_lower_bound T).
    intro Hbound.

    (* Relate INR T to IZR (up r) > r *)
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

    (* Multiply r < INR T by (p * delta) > 0 to clear division *)
    unfold r in HT.
    apply Rmult_lt_compat_r with (r := p * delta) in HT; [| exact Hpos].
    unfold Rdiv in HT.
    rewrite Rmult_assoc, Rinv_l, Rmult_1_r in HT; [| lra].
    lra.
  Qed.

End CapacityCollapse.
