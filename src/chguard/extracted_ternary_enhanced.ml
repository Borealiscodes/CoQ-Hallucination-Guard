(* AUTOMATICALLY EXTRACTED FROM COQ - ENHANCED ENCLAVE CORE *)
(* PROJECT: Coq-Hallucination-Guard (chguard)               *)
(* SAFETY LAYER: Node Beta Downstream Observer             *)

type rational = { num : Z.t; den : Z.t }

type rationalVector8D = { v_coords : rational list }

type rationalVector80D = { v80_coords : rational list }

type enclaveStatus =
  | VerifiedState of rationalVector80D
  | AllostaticAbort of Z.t

let rat_add r1 r2 =
  { num = Z.add (Z.mul r1.num r2.den) (Z.mul r2.num r1.den);
    den = Z.mul r1.den r2.den }

let rat_mul r1 r2 =
  { num = Z.mul r1.num r2.num;
    den = Z.mul r1.den r2.den }

let rec lift_list_to_half = function
  | [] -> []
  | x :: xs -> { num = x; den = Z.of_int 2 } :: lift_list_to_half xs

let lift_spinor_vector coords_list =
  { v_coords = lift_list_to_half coords_list }

let zero_rat = { num = Z.zero; den = Z.one }

let rec repeat x n =
  if n <= 0 then [] else x :: repeat x (n - 1)

let pad_72_zeros l =
  if List.length l = 8 then l @ (repeat zero_rat 72) else l

let embed_8d_to_80d v =
  { v80_coords = pad_72_zeros v.v_coords }

let rec vec_sub_coords l1 l2 =
  match l1, l2 with
  | r1 :: rs1, r2 :: rs2 ->
    let r_neg = { num = Z.neg r2.num; den = r2.den } in
    rat_add r1 r_neg :: vec_sub_coords rs1 rs2
  | _, _ -> []

let rec sum_sq_rat80 = function
  | [] -> zero_rat
  | r :: rs -> rat_add (rat_mul r r) (sum_sq_rat80 rs)

let manifold_distance_sq v1 v2 =
  sum_sq_rat80 (vec_sub_coords v1.v80_coords v2.v80_coords)

let evaluate_enclave_step origin old_pt new_pt epsilon =
  let d_xz = manifold_distance_sq origin new_pt in
  let d_xy = manifold_distance_sq origin old_pt in
  let d_yz = manifold_distance_sq old_pt new_pt in
  let path_sum = rat_add (rat_add d_xy d_yz) epsilon in
  if Z.leq (Z.mul d_xz.num path_sum.den) (Z.mul path_sum.num d_xz.den) then
    VerifiedState new_pt
  else
    AllostaticAbort (Z.of_int 15)
