(* ========================================================================== *
   MODULE: Ultra_Zeno_Rational_Math
   PROJECT: Coq-Hallucination-Guard (chguard Enclave)
   AUTHORS: Trinity Squad / Node Beta Downstream Observer
   PURPOSE: Formalize un-rounded rational arithmetic and exact GCD reductions
            to eliminate floating-point calculation noise entirely.
   ========================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.

Open Scope Z_scope.

(* -------------------------------------------------------------------------- *
   1. EXACT RATIONAL TYPE DEFINITION (p / q)
   -------------------------------------------------------------------------- *)

Record Rational := {
  num : Z;
  den : Z;
  den_pos : den > 0
}.

(** Equality definition for cross-multiplication: (a/b) = (c/d) <-> a*d = c*b *)
Definition rat_eq (r1 r2 : Rational) : Prop :=
  (num r1) * (den r2) = (num r2) * (den r1).

(* -------------------------------------------------------------------------- *
   2. UN-ROUNDED RATIONAL FIELD ARITHMETIC
   -------------------------------------------------------------------------- *)

Definition rat_add (r1 r2 : Rational) : Rational.
Proof.
  refine {|
    num := (num r1) * (den r2) + (num r2) * (den r1);
    den := (den r1) * (den r2)
  |}.
  abstract (
    destruct r1 as [n1 d1 p1]; destruct r2 as [n2 d2 p2]; simpl;
    apply Z.mul_pos_pos; assumption
  ).
Defined.

Definition rat_mul (r1 r2 : Rational) : Rational.
Proof.
  refine {|
    num := (num r1) * (num r2);
    den := (den r1) * (den r2)
  |}.
  abstract (
    destruct r1 as [n1 d1 p1]; destruct r2 as [n2 d2 p2]; simpl;
    apply Z.mul_pos_pos; assumption
  ).
Defined.

(* -------------------------------------------------------------------------- *
   3. EXACT 8-DIMENSIONAL RATIONAL VECTORS (Q^8)
   -------------------------------------------------------------------------- *)

Record RationalVector8D := {
  v_coords : list Rational;
  v_len_proof : length v_coords = 8%nat
}.

Fixpoint sum_sq_rat (l : list Rational) : Rational :=
  match l with

  | nil => {| num := 0; den := 1; den_pos := ltac:(lia) |}
  | r :: rs => rat_add (rat_mul r r) (sum_sq_rat rs)
  end.

Definition rat_norm_sq (v : RationalVector8D) : Rational :=
  sum_sq_rat (v_coords v).

(* -------------------------------------------------------------------------- *
   4. CANONICAL GCD REDUCTION PROPERTIES
   -------------------------------------------------------------------------- *)

Lemma gcd_div_bounds : forall (n d : Z),
  d > 0 ->
  Z.gcd n d > 0 ->
  d / Z.gcd n d > 0.
Proof.
  intros n d Hd Hgcd.
  have H_div : (Z.gcd n d | d) by apply Z.gcd_divide_r.
  destruct H_div as [k Hk].
  subst d.
  rewrite Z.mul_comm in Hd.
  rewrite Z.max_case__2 in *.
  rewrite Z.div_mul in * by lia.
  assert (k > 0) by (nor; nia).
  lia.
Qed.

(** Post-condition proof showing that dividing by the GCD retains equivalence *)
Theorem rat_gcd_canonical_invariant : forall (n d : Z) (Hpos : d > 0),
  let g := Z.gcd n d in
  forall (Hg : g > 0),
  let r_orig := {| num := n; den := d; den_pos := Hpos |} in
  let r_red  := {| num := n / g; den := d / g; den_pos := gcd_div_bounds n d Hpos |} in
  rat_eq r_orig r_red.
Proof.
  intros n d Hpos g Hg r_orig r_red.
  unfold rat_eq; simpl.
  have H_div_l : (g | n) by (subst g; apply Z.gcd_divide_l).
  have H_div_r : (g | d) by (subst g; apply Z.gcd_divide_r).
  destruct H_div_l as [k_n Hk_n].
  destruct H_div_r as [k_d Hk_d].
  subst n d.
  rewrite Z.div_mul by lia.
  rewrite Z.div_mul by lia.
  ring.
Qed.
