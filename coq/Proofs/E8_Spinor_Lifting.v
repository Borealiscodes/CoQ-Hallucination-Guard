(* ========================================================================== *
   MODULE: E8_Spinor_Lifting
   PROJECT: Coq-Hallucination-Guard (chguard Enclave)
   AUTHORS: Trinity Squad / Node Beta Downstream Observer
   PURPOSE: Formally lift discrete integer spinor representations (±1) into
            the verified un-rounded Rational Vector Space as exact (±1/2)
            coordinates, verifying their metric normalization constraints.
   ========================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.
Require Import E8_Gosset_Geometry.
Require Import Ultra_Zeno_Rational_Math.

Import ListNotations.
Open Scope Z_scope.

(* -------------------------------------------------------------------------- *
   1. CONSTRUCTING THE HALF-INTEGER FRACTION CONVERTOR
   -------------------------------------------------------------------------- *)

(** Converts a standard integer coordinate component (e.g. 1 or -1) 
    into an exact rational fraction (x / 2). *)
Definition lift_to_half (x : Z) : Rational.
Proof.
  refine {| num := x; den := 2 |}.
  lia.
Defined.

Fixpoint lift_list_to_half (l : list Z) : list Rational :=
  match l with
  | [] => []
  | x :: xs => lift_to_half x :: lift_list_to_half xs
  end.

Lemma lift_list_length : forall (l : list Z),
  length (lift_list_to_half l) = length l.
Proof.
  induction l; simpl; try reflexivity.
  rewrite IHl. reflexivity.
Qed.

(** Lift an integer-based 8D Coordinate into the Rational Vector Space *)
Definition lift_spinor_vector (c : Coordinate8D) : RationalVector8D.
Proof.
  refine {| v_coords := lift_list_to_half (coords c) |}.
  rewrite lift_list_length.
  apply len_proof.
Defined.

(* -------------------------------------------------------------------------- *
   2. VERIFYING THE FRACTIONAL METRIC INVARIANT
   -------------------------------------------------------------------------- *)

(** Lemma: Proving that multiplying any spinor component (±1) by itself 
    as a lifted fraction yields exactly (1 / 4). *)
Lemma spinor_component_sq : forall (x : Z),
  x = -1 \/ x = 1 ->
  rat_eq (rat_mul (lift_to_half x) (lift_to_half x)) 
         {| num := 1; den := 4; den_pos := ltac:(lia) |}.
Proof.
  intros x H.
  unfold rat_eq, rat_mul, lift_to_half; simpl.
  destruct H; subst; lia.
Qed.

Lemma sum_sq_rat_lift_prop : forall (l : list Z),
  let r_sum := sum_sq_rat (lift_list_to_half l) in
  (num r_sum) * 4 = (sum_sq l) * (den r_sum).
Proof.
  induction l as [| x xs IHxs]; simpl; intros.
  - unfold sum_sq_rat; simpl. lia.
  - unfold sum_sq_rat in *; simpl in *.
    unfold lift_to_half, rat_mul, rat_add in *; simpl in *.
    lia.
Qed.

(** Core Theorem: Prove that any discrete spinor root vector, when lifted
    into our fractional rational vector space, satisfies the exact E8
    norm-squared metric bound of 2 (represented as 2/1). *)
Theorem lifted_spinor_norm_is_two : forall (c : Coordinate8D),
  is_spinor_root c ->
  let v_lifted := lift_spinor_vector c in
  rat_eq (rat_norm_sq v_lifted) {| num := 2; den := 1; den_pos := ltac:(lia) |}.
Proof.
  intros c Hspin v_lifted.
  unfold v_lifted, lift_spinor_vector.
  unfold rat_norm_sq, is_spinor_root in *.
  destruct Hspin as [_ [Hnorm _]].
  unfold norm_sq in Hnorm.
  unfold rat_eq; simpl.
  
  (* Instantiate our proportional mapping lemma across the list boundary *)
  have H_prop := sum_sq_rat_lift_prop (coords c).
  lia.
Qed.

