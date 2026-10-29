# =====================================================================
# Coq-Hallucination-Guard: Immutable Container Enclave Sandbox
# =====================================================================
FROM ocaml/opam:debian-12-ocaml-4.14 AS builder

USER opam
WORKDIR /home/opam

# Initialize opam package repository and switch settings
RUN opam init --disabled-sandbox -y && \
    opam switch create coq-enclave 4.14.1 && \
    eval $(opam env --switch=coq-enclave)

# Pin and compile explicit versions of Coq and MathComp dependencies
RUN opam repo add coq-released https://inria.fr && \
    opam update && \
    opam install -y \
    coq.8.18.0 \
    coq-mathcomp-ssreflect.2.1.0 \
    coq-mathcomp-algebra.2.1.0 \
    coq-mathcomp-analysis.1.0.0 \
    coq-lsp.0.1.8

# --- Execution Runtime Environment ---
FROM python:3.11-slim-bookworm

# Establish critical system runtime paths
ENV PATH="/home/enclave/.opam/coq-enclave/bin:${PATH}"
ENV HOME="/home/enclave"

# Install fundamental system runtime utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Instantiate a non-privileged, isolated system runtime user
RUN useradd -m -s /bin/bash enclave
USER enclave
WORKDIR /home/enclave/workspace

# Port operational binary binaries over from the compilation layer
COPY --from=builder --chown=enclave:enclave /home/opam/.opam /home/enclave/.opam

# Copy local repository code assets into the container workspace
COPY --chown=enclave:enclave . /home/enclave/workspace

# Install the Python enforcement framework and freeze runtime states
RUN pip install --no-cache-dir --user -e . && \
    coq_makefile -f _CoqProject -o Makefile && \
    make

# Establish global environment parameters adhering to Bounded Non-Harm Enclaves
ENTRYPOINT ["python3", "-m", "chguard.interceptor"]
CMD ["src/chguard/validator.v"]
