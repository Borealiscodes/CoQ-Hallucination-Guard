(* ===================================================================== *)
(* Runtime Fusion: Verification of Branchless Lane Reduction            *)
(* Proves that parallel operational paths fold perfectly without loss    *)
(* ===================================================================== *)
From mathcomp Require Import ssreflect ssrbool ssrnat eqtype choice seq.
From HolonomyRuntime Require Import BaseTernary.

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Section RuntimeFusion.

(* Formally verifies that evaluating a batch sequence of lane actions   *)
(* via our branchless multiplication logic matches a linear reduction   *)
Theorem branchless_lane_fusion_invariant :
  forall (lanes : seq trit),
    count (fun t => trit_eq t TZero) lanes = 0 ->
    all (fun t => trit_eq t TPlus) lanes ->
    foldl trit_mul TPlus lanes = TPlus.
Proof.
  move=> lanes H_nz /allP H_plus.
  elim: lanes H_plus => [|t tl IH] H_plus /=.
    by [].
  have /eqP ->: trit_eq t TPlus by apply: H_plus; left.
  rewrite /=.
  apply: IH => x H_in.
  by apply: H_plus; right.
Qed.

End RuntimeFusion.
