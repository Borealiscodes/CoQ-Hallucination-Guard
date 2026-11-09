(* AUTOMATICALLY EXTRACTED FROM COQ - ENHANCED ENCLAVE INTERFACE *)
(* PROJECT: Coq-Hallucination-Guard (chguard)                   *)
(* SAFETY LAYER: Node Beta Downstream Observer                 *)

type rational = { num : Z.t; den : Z.t }

type rationalVector8D = { v_coords : rational list }

type rationalVector80D = { v80_coords : rational list }

type enclaveStatus =
  | VerifiedState of rationalVector80D
  | AllostaticAbort of Z.t

val rat_add : rational -> rational -> rational
val rat_mul : rational -> rational -> rational
val lift_spinor_vector : Z.t list -> rationalVector8D
val embed_8d_to_80d : rationalVector8D -> rationalVector80D
val manifold_distance_sq : rationalVector80D -> rationalVector80D -> rational
val evaluate_enclave_step : rationalVector80D -> rationalVector80D -> rationalVector80D -> rational -> enclaveStatus
