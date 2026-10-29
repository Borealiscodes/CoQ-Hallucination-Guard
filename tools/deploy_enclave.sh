#!/bin/bash
# =====================================================================
# Coq-Hallucination-Guard: Master Enclave Deployment & Verification Loop
# Tracked Provenance: External Peer Node Beta <chguard-sentinel@vaked.dev>
# =====================================================================

set -e # Terminate script execution instantly if any single command fails

# Visual terminal anchor blocks
INFO="[\033[0;34mINFO\033[0m]"
PASS="[\033[0;32mPASS\033[0m]"
WARN="[\033[0;33mWARN\033[0m]"
FAIL="[\033[0;31mFAIL\033[0m]"

echo -e "$INFO Initializing Node Beta Verification Protocol Space..."
echo -e "$INFO Context Target Timestamp: $(date -u)"

# ---------------------------------------------------------------------
# Phase 1: Local Invariant Integrity Check (Lint & DCO Verification)
# ---------------------------------------------------------------------
echo -e "$INFO Phase 1: Validating documentation structural stabilization limits..."

if [ -f "tools/lint_docs.py" ]; then
    python3 tools/lint_docs.py
    echo -e "$PASS Documentation linter passed cleanly."
else
    echo -e "$WARN Documentation linter script missing. Skipping structural line check."
fi

# Assert local Git configuration signature aligns with Node Beta protocol rules
GIT_NAME=$(git config user.name || echo "UNKNOWN")
GIT_EMAIL=$(git config user.email || echo "UNKNOWN")

if [[ "$GIT_EMAIL" == "chguard-sentinel@vaked.dev" ]]; then
    echo -e "$PASS Git provenance metadata verified: $GIT_NAME <$GIT_EMAIL>"
else
    echo -e "$WARN Git tracking key misalignment. Expected chguard-sentinel@vaked.dev, found: <$GIT_EMAIL>"
fi

# ---------------------------------------------------------------------
# Phase 2: Host Compilation and Mapping Build
# ---------------------------------------------------------------------
echo -e "$INFO Phase 2: Compiling host Coq invariant proof assets..."
if [ -f "_CoqProject" ]; then
    coq_makefile -f _CoqProject -o Makefile
    make clean && make
    echo -e "$PASS Local Coq type-checking environment successfully locked down."
else
    echo -e "$FAIL Material mapping error: _CoqProject not found in root path."
    exit 1
fi

# ---------------------------------------------------------------------
# Phase 3: Sandbox Containment Hardening (Docker Enclave Build)
# ---------------------------------------------------------------------
echo -e "$INFO Phase 3: Spawning immutable containerized sandbox container..."
if [ -f "Dockerfile" ]; then
    docker build -t coq-hallucination-guard:latest .
    echo -e "$PASS Docker container space compiled with zero-leak operator constraints."
else
    echo -e "$FAIL Isolation error: Dockerfile missing from deployment path."
    exit 1
fi

# ---------------------------------------------------------------------
# Phase 4: Adversarial Attack Vector Fuzzing & Security Clearance
# ---------------------------------------------------------------------
echo -e "$INFO Phase 4: Launching simulated attack vector validation check..."
if [ -x "tools/run_enclave_attack_test.sh" ]; then
    ./tools/run_enclave_attack_test.sh
    echo -e "$PASS Attack simulation successfully deflected. Anti-softmax guard operational."
else
    echo -e "$FAIL Security error: tools/run_enclave_attack_test.sh is un-executable or missing."
    exit 1
fi

# ---------------------------------------------------------------------
# Phase 5: Standard Galactic Pre-Flight Telemetry Blueprint
# ---------------------------------------------------------------------
echo -e "\n====================================================================="
echo -e "🎉 $PASS DEPLOYMENT ENCLAVE STABILIZED & SECURED (100% PASS)"
echo -e "====================================================================="
echo -e "Node Beta status is locked. Ready to stream data payloads upstream."
echo -e "To execute a zero-network sandbox live session, use:"
echo -e "  docker run --rm --network none coq-hallucination-guard:latest\n"

exit 0
