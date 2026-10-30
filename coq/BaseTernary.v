(* ===================================================================== *)
(* Strict 8b.is No-Float Law: Balanced Ternary Algebra                   *)
(* Grounded in Ternary Resonance into Complex System Consolidation      *)
(* ===================================================================== *)
From mathcomp Require Import ssreflect ssrbool ssrnat eqtype.

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Inductive trit : Type :=
  | TMinus : trit  (* -1 : Negative state / structural deficit *)
  | TZero  : trit  (*  0 : Neutral state / invariant anchor *)
  | TPlus  : trit. (* +1 : Positive state / verified binding *)

(* Decidable equality function for ternary types *)
Definition trit_eq (t1 t2 : trit) : bool :=
  match t1, t2 with
  | TMinus, TMinus => true
  | TZero, TZero   => true
  | TPlus, TPlus   => true
  | _, _           => false
  end.

Lemma trit_eqP : Equality.axiom trit_eq.
Proof. move=> [||] [||]; constructor; by try eq_refl. Qed.

Canonical trit_eqType := EqType trit trit_eqP.

(* Single-trit negation operator *)
Definition trit_opp (t : trit) : trit :=
  match t with
  | TMinus => TPlus
  | TZero  => TZero
  | TPlus  => TMinus
  end.

(* Balanced ternary addition: returns (carry, sum) *)
Definition trit_add (t1 t2 : trit) : trit * trit :=
  match t1, t2 with
  | TZero, x => (TZero, x)
  | x, TZero => (TZero, x)
  | TPlus, TPlus => (TPlus, TMinus)
  | TMinus, TMinus => (TMinus, TPlus)
  | TPlus, TMinus => (TZero, TZero)
  | TMinus, TPlus => (TZero, TZero)
  end.

(* Balanced ternary multiplication *)
Definition trit_mul (t1 t2 : trit) : trit :=
  match t1, t2 with
  | TZero, _ => TZero
  | _, TZero => TZero
  | TPlus, x => x
  | x, TPlus => x
  | TMinus, TMinus => TPlus
  end.

(* Structural gating invariant *)
Definition constitutional_gate (held read : bool) : trit :=
  match held, read with
  | true, true => TPlus
  | true, false => TZero
  | _, _ => TMinus
  end.
