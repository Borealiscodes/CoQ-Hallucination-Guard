(**
 * sensory_envelope_wrapper.v — Machine-Checked Coq Formalization of Sensory Regulation Envelope
 * Repository: Borealiscodes/CoQ-Hallucination-Guard (tex/COQwrapped/)
 * Downstream Lineage: Borealiscodes/ndh-game-dev-kit (07-sensory-regulation-envelope)
 * Posture: Pure Systems Math • Zero Clinical Semantics • Diagnostic & Descriptive Only
 *
 * Signed-off-by: Borealis Serenity Hedling <chguard-sentinel@vaked.dev>
 *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Require Import Coq.Bool.Bool.

Open Scope R_scope.

Module SensoryEnvelope.

  Record EnvelopeConfig : Type := mkConfig {
    no_flash        : bool;
    reduced_motion  : bool;
    max_lowpass_hz  : R;
    max_audio_gain  : R;
    allow_haptics   : bool
  }.

  Record AudioParams : Type := mkAudio {
    cutoff_hz : R;
    gain      : R;
    haptic_ms : R
  }.

  Definition clamp_audio (cfg : EnvelopeConfig) (raw : AudioParams) : AudioParams :=
    mkAudio
      (Rmin (Rmax 20 (cutoff_hz raw)) (max_lowpass_hz cfg))
      (Rmin (Rmax 0 (gain raw)) (max_audio_gain cfg))
      (if allow_haptics cfg then Rmax 0 (haptic_ms raw) else 0).

  (** Theorem 1: Clamped audio parameters never exceed the configured low-pass ceiling. *)
  Theorem cutoff_bounded_by_envelope :
    forall (cfg : EnvelopeConfig) (raw : AudioParams),
      20 <= max_lowpass_hz cfg ->
      cutoff_hz (clamp_audio cfg raw) <= max_lowpass_hz cfg.
  Proof.
    intros cfg raw Hmin.
    unfold clamp_audio; simpl.
    apply Rmin_r.
  Qed.

  (** Theorem 2: Clamped gain remains within [0, max_audio_gain] for all non-negative ceilings. *)
  Theorem gain_bounded_and_nonneg :
    forall (cfg : EnvelopeConfig) (raw : AudioParams),
      0 <= max_audio_gain cfg ->
      0 <= gain (clamp_audio cfg raw) /\ gain (clamp_audio cfg raw) <= max_audio_gain cfg.
  Proof.
    intros cfg raw Hmax.
    unfold clamp_audio; simpl.
    split.
    - apply Rmin_glb; [apply Rmax_l | exact Hmax].
    - apply Rmin_r.
  Qed.

  (** Theorem 3: When haptics are opt-in disabled (allow_haptics = false), output vibration is strictly 0. *)
  Theorem opt_in_haptics_isolation :
    forall (cfg : EnvelopeConfig) (raw : AudioParams),
      allow_haptics cfg = false ->
      haptic_ms (clamp_audio cfg raw) = 0.
  Proof.
    intros cfg raw Hopt.
    unfold clamp_audio; simpl.
    rewrite Hopt.
    reflexivity.
  Qed.

End SensoryEnvelope.
