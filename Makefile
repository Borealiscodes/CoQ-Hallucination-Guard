# ========================================================================== #
# BUILD BENCHMARK: Coq to Shared Object (.so) Infrastructure Makefile        #
# PROJECT: Coq-Hallucination-Guard (chguard Enclave)                         #
# ========================================================================== #

CC = gcc
OCAMLOPT = ocamlopt
CFLAGS = -O3 -fPIC -Wall -Wextra -I$(shell $(OCAMLOPT) -where)
OCAMLFLAGS = -output-obj -runtime-variant _pic

all: libchguard_enclave.so

# 1. Compile the verified Coq specifications down to raw text artifacts
coq_compile:
	coqc -Q . Chguard Ultra_Zeno_Rational_Math.v
	coqc -Q . Chguard Base243_Bijection.v
	coqc -Q . Chguard Base243_Ternary_Parity.v
	coqc -Q . Chguard RuntimeFusion.v
	coqc -Q . Chguard SpectralIntegration.v
	coqc -Q . Chguard Manifold_Deterministic_Abort.v
	coqc -Q . Chguard Extraction.v

# 2. Compile OCaml and C layers into a single, unified position-independent shared object
libchguard_enclave.so: chguard_enclave.ml src/chguard_ffi.c
	$(OCAMLOPT) $(OCAMLFLAGS) -o src/chguard_enclave_obj.o chguard_enclave.ml
	$(CC) -shared $(CFLAGS) -o libchguard_enclave.so src/chguard_ffi.c src/chguard_enclave_obj.o

clean:
	rm -rf *.cmi *.cmx *.o *.vxs *.vo *.glob src/*.o *.so
