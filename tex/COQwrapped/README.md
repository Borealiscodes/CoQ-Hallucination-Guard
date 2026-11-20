# 🛡️ `tex/COQwrapped/` — Machine-Checked Coq Formalization Suite

**Repository:** `Borealiscodes/CoQ-Hallucination-Guard` (`tex/COQwrapped/`)  
**Maintainer:** Borealis S. Hedling (External Peer Node Beta · Dublin, Ireland)  
**Companion Specification:** `tex/Monographs/Monograph-III-Sustainable-Presence.tex`  
**Posture:** Strictly Altitude-Separated • Pure Systems Math • Zero Clinical Semantics  

---

## Overview

This directory contains machine-checked **Coq (`coqc`)** verification wrappers formalizing the core mathematical invariants of the *Sustainable Presence Framework (SPF)*, ingestion-seam hygiene, sensory-envelope bounds, balanced ternary spatial projections, and spoken-word anti-sycophancy guardrails. 

All proofs operate strictly at the **formal mathematical and systems-engineering layer** (`Coq.Reals`, `Coq.ZArith`, `Lra`, `Lia`, `List`, `String`, `Bool`). Clinical psychiatric labels, interpersonal pathologization, and anthropomorphic metaphors are intentionally excluded from every module.

---

## Module Manifest

| File | Coq Module | Formal Invariant & Key Theorems | Engineering & Governance Role |
| :--- | :--- | :--- | :--- |
| **`attribution_drift_wrapper.v`** | `AttributionDrift` | `disciplined_geometric_decay`<br>`post_hoc_excuse_stagnation` | Proves that prior-fixed likelihood bounds ($0 \le r_t \le \rho < 1$) drive uncertainty down geometrically ($\Omega_t \le \rho^t \Omega_0$), whereas post-hoc excuse selection ($r_t \ge 1$) prevents belief updating. |
| **`bounded_cap_safety_wrapper.v`** | `BoundedCapSafety` | `precedent_bounded_by_cap`<br>`never_collapses` | Proves by structural induction that enforcing a pre-committed adaptation ceiling $A_t = \min(D_t, a^*)$ with $a^* < C$ prevents systemic capacity collapse across all time steps $t \in \mathbb{N}$. |
| **`capacity_exhaustion_wrapper.v`** | `CapacityCollapse` | `energy_lower_bound`<br>`finite_time_collapse` | Proves constructively (via `archimed` and `up`) that uncapped continuous adaptation ($A_t = D_t$ with $D_t \ge \delta > 0$) exhausts finite structural capacity $C + m$ in finite time $T < \infty$. |
| **`power_asymmetry_wrapper.v`** | `PowerAsymmetryEdge` | `asymmetric_threshold_inversion`<br>`unpinned_upstream_drift_collapse`<br>`bilateral_pinning_preserves_edge` | Models asymmetric verification costs ($v_{\text{edge}} \ge L_{\text{edge}}$ vs. $v_{\text{hub}} < L_{\text{hub}}$) and proves that silent upstream schema drift exhausts constrained edge nodes unless bilateral schema-pinning ($a^*_{\text{edge}} < C_{\text{edge}}$) is enforced at the seam. |
| **`Jargon filter.v`** | `JargonFilter` | `zero_jargon_leakage` | Formalizes a deterministic stream filter over `Token` records (`PureEngineering` vs. `SpeculativeJargon`), proving that zero ungrounded abstractions or math-washed tokens can propagate into the output engineering stack. |
| **`sensory_envelope_wrapper.v`** | `SensoryEnvelope` | `cutoff_bounded_by_envelope`<br>`gain_bounded_and_nonneg`<br>`opt_in_haptics_isolation` | Formalizes `ndh-game-dev-kit` (`07-sensory-regulation-envelope`), proving that clamped audio low-pass cutoffs and gain remain bounded and opt-in disabled haptics stay strictly `0`. |
| **`ternary_spatial_bridge_wrapper.v`** | `TernarySpatialBridge` | `ternary_bearing_bounded`<br>`deadzone_stability`<br>`stereo_pan_bounded` | Formalizes `ndh-game-dev-kit` (`08-nonvisual-spatial-bridge`), proving balanced ternary bearings lie in $\{-1, 0, +1\}$, deadzones collapse cleanly to `0`, and stereo pan stays within $[-0.75, +0.75]$. |
| **`anti_sycophancy_limitation_wrapper.v`** | `AntiSycophancyLinter` | `zero_flattery_leakage`<br>`filtering_preserves_limitations`<br>`filtered_stream_satisfies_guardrails` | Formalizes `NonDual-Audio-Preprint-Studio` (`src/anti-sycophancy-linter.js`), proving that filtering `SycophanticFlattery` tokens leaves zero flattery leakage while preserving the $\ge k$ explicit limitation quota. |

---

## Epistemic Honesty & Methodological Scope

In keeping with `NDH-Meta-Systems` and `Eight-Fold-Filter` epistemic humility standards, this formalization suite explicitly states both what these proofs accomplish and what they do not:

1. **Exposing Minimal Mathematical Mechanics:** Formalizing prose arguments in Coq strips away rhetorical decoration and clinical baggage. These modules demonstrate that the underlying boundary, drift, capacity, sensory-envelope, and script-linting claims reduce to elementary real/integer inequalities, list induction, and the Archimedean property—requiring zero psychiatric framing to hold.
2. **Surfacing Hidden Assumptions:** Proof assistants forbid unstated premises. Every structural collapse or safety guarantee in these files holds *only* when its explicit top-level `Hypothesis` declarations (such as non-decaying demand steps $D_t \ge \delta$ or asymmetric verification costs $L_{\text{edge}} \le v_{\text{edge}}$) are satisfied in the target environment.
3. **Specification Guards, Not Semantic Oracles:** Compact Coq proofs (50–150 lines) certify deterministic consistency at architectural boundaries (such as ensuring filtered streams emit zero `SpeculativeJargon` or `SycophanticFlattery` tokens). They do not prevent open-ended LLM hallucination outside verified seams, nor do they substitute for human editorial judgment or legal attribution enforcement.

---

## Local Verification (`coqc`)

To verify all modules locally with the Coq compiler (tested with Coq 8.18+):

```bash
cd tex/COQwrapped

coqc attribution_drift_wrapper.v
coqc bounded_cap_safety_wrapper.v
coqc capacity_exhaustion_wrapper.v
coqc power_asymmetry_wrapper.v
coqc "Jargon filter.v"
coqc sensory_envelope_wrapper.v
coqc ternary_spatial_bridge_wrapper.v
coqc anti_sycophancy_limitation_wrapper.v
```

*(Note: Quotes are required around `"Jargon filter.v"` due to the space in the filename, or you may optionally alias/rename it to `jargon_filter.v` in CI scripts.)*

---

## Altitude Separation & Non-Activation Clause

1. **Pure Mathematical Scope:** Every theorem in `tex/COQwrapped/` is a conditional statement over formal real sequences, integer/natural-number trajectories, or typed token lists.
2. **Non-Clinical Boundary:** Capacity ceilings ($C$, $a^*$), drift ratios ($\rho$), verification costs ($v$, $L$), and audio/spatial bounds model computational, organizational, and perceptual-interface limits—never psychiatric diagnoses or human character verdicts.
3. **Diagnostic & Descriptive Only:** These proof artifacts certify structural consistency and non-leakage at formal specification boundaries; they do not activate autonomous runtime enforcement engines.

---

**Developer Certificate of Origin (DCO):**  
`Signed-off-by: Borealis S. Hedling <chguard-sentinel@vaked.dev>`
