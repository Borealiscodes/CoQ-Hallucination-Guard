/* ========================================================================== *
   MODULE: chguard_ffi.c
   PROJECT: Coq-Hallucination-Guard (chguard Enclave Substrate)
   PURPOSE: C-ABI Foreign Function Interface (FFI) Wrapper.
            Binds register-aligned native C signatures directly to the 
            extracted, linear-time OCaml proof execution kernels.
   ========================================================================== */

#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>
#include <stdint.h>

/* Initialize the embedded OCaml runtime state within the host processor */
void chguard_enclave_init(void) {
    char *argv[] = { "chguard_enclave", NULL };
    caml_startup(argv);
}

/**
 * C-ABI Gate: pack_list
 * Maps a flat array of C int64_t values into the extracted OCaml list tracker.
 */
int64_t c_pack_list(const int64_t *trits, size_t len) {
    static const value *closure = NULL;
    if (closure == NULL) {
        closure = caml_named_value("pack_list");
    }

    CAMLparam0();
    CAMLlocal2(ml_list, ml_val);

    ml_list = Val_int(0); /* Initialize empty list equivalent to nil */
    for (size_t i = len; i > 0; i--) {
        ml_val = caml_copy_int64(trits[i - 1]);
        value new_cell = caml_alloc(2, 0);
        Field(new_cell, 0) = ml_val;
        Field(new_cell, 1) = ml_list;
        ml_list = new_cell;
    }

    value res = caml_callback(*closure, ml_list);
    CAMLreturnT(int64_t, Int64_val(res));
}

/**
 * C-ABI Gate: audit_ledger_epoch
 * Directly evaluates the allostatic collapse threshold over flat registers.
 */
int32_t c_audit_ledger_epoch(int64_t accumulated_drift, int64_t max_ceiling) {
    static const value *closure = NULL;
    if (closure == NULL) {
        closure = caml_named_value("audit_ledger_epoch");
    }

    CAMLparam0();
    value v_drift = caml_copy_int64(accumulated_drift);
    value v_ceil = caml_copy_int64(max_ceiling);

    /* OCaml variant block evaluation */
    value res = caml_callback2(*closure, v_drift, v_ceil);
    
    /* Tag 0 = CryptographicallyValidEpoch, Tag 1 = AllostaticCollapseGuillotine (0x0F) */
    if (Tag_val(res) == 1) {
        CAMLreturnT(int32_t, 0x0F); 
    }
    CAMLreturnT(int32_t, 0x00); /* Validation Success */
}
