# 🛡️ Coq‑Hallucination‑Guard (chguard)

Coq‑Hallucination‑Guard is a safety‑critical enforcement enclave for Coq and the Ssreflect proof language. It utilizes geometric stability checks, provenance constraints, and deterministic abort logic via `coq-lsp` serialization to prevent syntactic and semantic mimicry in LLM-generated proofs.

---

## 🧠 Syntactic vs. Semantic Mimicry

* **Syntactic Mimicry:** LLMs imitate surface-level token patterns and syntax trees (such as tactic shapes or lemma names) without forming valid proof objects within the Calculus of Inductive Constructions (CIC). Academic grounding for form-versus-structure approximations includes works by Chomsky (1995) and Merrill (2020).
* **Semantic Mimicry:** Models simulate reasoning-shaped text continuation (like fake lemma applications or goal closures) without actual execution on the goal stack, leading to semantic drift. References discussing form versus meaning and symbolic reasoning failures include Bender & Koller (2020), Piantadosi & Hill (2022), Chiang & Cholak (2023), and Wu et al. (2024).

---

## 🛡️ Enforcement Triad

Execution steps pass through three Python enforcement modules before reaching the `coq-lsp` backend:
1. **`geometry.py`:** Detects semantic drift and geometric state collapse using invariants on goal serialization JSON-RPC stream headers.
2. **`provenance.py`:** Enforces humanitarian provenance and non-harm parameters, terminating operations that violate safety boundaries.
3. **`interceptor.py`:** Instantly halts headless `coq-lsp` sessions, purges unbuffered pipeline memory, and logs violations if a breach occurs.

---

## 📁 Repository Scaffolding

```text

coq-hallucination-guard/
│
├── ⚙ _CoqProject                # Coq compilation directives & library mappings
├── 📄 pyproject.toml            # Modern PEP-621 Python tooling metadata
├── 📄 README.md                 # Technical specification & structural usage
├── 🐳 Dockerfile                # Immutable enclave execution container sandbox
│
├── 📦 coq/                      # The Formal Verification Enclave
│   ├── 🟦 BaseTernary.v         # Inductive definitions for balanced ternary data types
│   ├── 🟦 Manifold80D.v         # Soft 80D Riemannian manifold structural framework
│   │
│   └── 🧮 Proofs/
│       ├── CurvatureEvolution.v # Proofs of smoothness across threshold jumps
│       ├── Holonomy.v           # Unitarity and stability metrics for loop transport
│       ├── RuntimeFusion.v      # Verification of branchless lane reduction
│       └── SpectralIntegration.v # Operational bounds via functional calculus
│
├── 📘 docs/                     # Conceptual documentation & high-altitude models
│   └── 📄 bill-nye-tile-explainer.md
│
├── 🐍 src/chguard/              # Python Deterministic Enforcement Layer
│   ├── __init__.py
│   ├── geometry.py              # Parses Coq AST/XML to track goal-state drift
│   ├── provenance.py            # Enforces humanitarian non-harm license rules
│   ├── interceptor.py           # Handles coq-lsp sessions and kills hallucinated tasks
│   └── validator.v              # Coq sandbox workspace script for incoming inputs
│
└── 🔧 tools/                    # Verification pipelines and stabilization scripts
    ├── chguard_watch.py         # Markdown/Notebook execution loop watcher
    ├── lint_docs.py             # Documentation structure linter
    └── run_enclave_attack_test.sh # Shell adversarial breach execution driver
```

---

## 🤝 Acknowledgements

Special gratitude is extended to **Christopher Chenoweth** and **Peter Lodri** of the Trinity Squad for their foundational work on **Ternary Resonance into complex system consolidation**. 

Their breakthrough insights directly govern the project's Constitutional Ontology (`ONTOLOGY.md`). By formalizing the structural alignment between balanced ternary states (`{-1, 0, +1}`) and complex system invariants, their work provides the exact stabilizing mechanics used to map, gate, and consolidate information within our multi-agent geometric layers.

---

## 🚀 Setup, Validation & Stabilization

### 1. Local Environment Setup
Ensure you have Python 3.10+ and a fully operational Coq installation containing the `mathcomp-analysis` library. Clone the workspace, map your local Git configurations to external node protocol specifications, and install the local package dependencies:

```bash
# Configure local identity parameters to align with External Peer Node Beta protocol
git config --local user.name "Downstream Enclave Observer (Node Beta)"
git config --local user.email "chguard-sentinel@vaked.dev"

# Install the Python enforcement components in editable development mode
pip install -e .
```

### 2. Manual Verification Check
To run an independent structural test on an individual Coq verification script:
```bash
chguard-validate path/to/proof.v
```

### 3. Containerized Sandbox Execution (Recommended Isolation)
To run validation checks inside a completely isolated container with zero access to your host machine's root operating system or network lanes:

```bash
# Build the immutable enclave image locally
docker build -t coq-hallucination-guard:latest .

# Run an incoming file check inside the network-disabled container
docker run --rm --network none \
  -v \$(pwd)/src/chguard/validator.v:/home/enclave/workspace/src/chguard/validator.v \
  coq-hallucination-guard:latest src/chguard/validator.v
```

### 4. Activating Document Stabilization (Git Hook)
To protect your repository assets against documentation formatting drift, un-compiled swap artifacts, or structural identity manipulation, deploy the automated Git pre-commit script:

```bash
# Formulate the hook file within the hidden git infrastructure
cat << 'EOF' > .git/hooks/pre-commit
#!/bin/sh
# =====================================================================
# Git Pre-Commit Hook: Automated Enclave Documentation Stabilization
# =====================================================================

echo "[HOOK] Triggering pre-commit validation enclaves..."

# 1. Run the structural documentation linter script
python3 tools/lint_docs.py
if [ \$? -ne 0 ]; then
    echo "\n[HOOK ABORT] Document stabilization checks failed. Commit rejected."
    exit 1
fi

# 2. Prevent accidental tracking of temporary editor swap artifacts
if git diff --cached --name-only | grep -E '\.(bak|tmp|swp)\$'; then
    echo "\n[HOOK ABORT] Detected temporary swap files in the staging area. Commit rejected."
    exit 1
fi

echo "[HOOK SUCCESS] Staging area cleared. Proceeding to cryptographic sign-off."
exit 0
EOF

# Grant absolute system execution permissions to the script file
chmod +x .git/hooks/pre-commit
```

---

## ⭐ Bill Nye Tile Says…

> “Kids!  
> When math gets a proper home, it becomes easier to explore.  
> `chguard` acts like a lock on the door of our big, soft, 80‑dimensional house—making sure the AI doesn't write fake equations on the walls!”
