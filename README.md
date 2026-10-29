 # 🛡️ Coq‑Hallucination‑Guard (chguard)

Coq‑Hallucination‑Guard is a safety‑critical enforcement enclave for Coq and the Ssreflect proof language. It integrates geometric stability invariants, provenance constraints, and deterministic abort logic through coq-lsp serialization to prevent syntactic and semantic mimicry in LLM‑generated proofs.

The system ensures that every incoming proof object is evaluated against a hallucination‑resistant geometric manifold, preventing Flyxion‑style metric collapse, curvature explosions, drift cascades, and spectral instability.

---

🧠 Syntactic vs. Semantic Mimicry

Syntactic Mimicry
LLMs imitate surface‑level token patterns (tactic shapes, lemma names, proof scripts) without producing valid CIC proof objects.  
Relevant academic grounding includes Chomsky (1995), Merrill (2020).

Semantic Mimicry
Models simulate reasoning‑shaped text continuation (fake lemma applications, fabricated goal closures) without executing on the actual goal stack.  
Key references include Bender & Koller (2020), Piantadosi & Hill (2022), Chiang & Cholak (2023), Wu et al. (2024).

Coq‑Hallucination‑Guard prevents both failure modes by enforcing geometric invariants on the serialized goal state.

---

🛡️ Enforcement Triad

All incoming Coq proof attempts pass through three Python enforcement modules before reaching the coq-lsp backend:

1. geometry.py  
   Detects semantic drift, metric collapse, and curvature instability using FSFE‑aligned invariants on the JSON‑RPC goal stream.

2. provenance.py  
   Enforces humanitarian provenance, non‑harm constraints, and Node Beta lineage rules.  
   Any violation triggers immediate termination.

3. interceptor.py  
   Halts headless coq-lsp sessions, purges unbuffered pipeline memory, and logs violations.

This triad ensures that no hallucinated proof object can enter the Coq kernel.

---

📁 Repository Scaffolding

`text
<pre> 
    
coq-hallucination-guard/
│
├── ⚙ _CoqProject                # Coq compilation directives & library mappings
├── 📄 pyproject.toml            # Modern PEP-621 Python tooling metadata
├── 📄 README.md                 # Technical specification & structural usage
├── 🐳 Dockerfile                # Immutable enclave execution container sandbox
│
├── 📦 coq/                      # The Formal Verification Enclave
│   ├── 🟦 BaseTernary.v         # Inductive definitions for balanced ternary data types
│   ├── 🟦 Manifold80D.v         # FSFE-aligned 80D Soft Riemannian Manifold with A6/A7/A8 invariants:
│   │                               - triangle inequality enforcement
│   │                               - slack-dimension soft geometry
│   │                               - collapse-surface stability
│   │                               - holonomy compatibility
│   │                               - curvature monotonicity
│   │                               - spectral integration bounds
│   ├── 🟦 Extraction.v          # OCaml code extraction compilation directives
│   │
│   └── 🧮 Proofs/
│       ├── CurvatureEvolution.v # Smoothness across threshold jumps
│       ├── Holonomy.v           # Unitarity and stability metrics for loop transport
│       ├── RuntimeFusion.v      # Verification of branchless lane reduction
│       └── SpectralIntegration.v # Operational bounds via functional calculus
│
├── 📘 docs/                     # Conceptual documentation & high-altitude models
│   ├── 📄 bill-nye-tile-explainer.md
│   └── 📄 AppendixNodeBetaConsolidated_Framework.tex
│
├── 🖺 tex/                      # Mathematical manuscripts and LaTeX assets
│   └── 📄 AppendixAntiSoftmaxAlignment_Framework.tex
│
├── 🐍 src/chguard/              # Python & Machine-Speed Functional Target Layer
│   ├── init.py
│   ├── geometry.py              # Parses Coq AST/XML to track goal-state drift
│   ├── provenance.py            # Enforces humanitarian non-harm license rules
│   ├── interceptor.py           # Handles coq-lsp sessions and kills hallucinated tasks
│   ├── validator.v              # Coq sandbox workspace script for incoming inputs
│   ├── extracted_ternary.ml     # Materialized verified OCaml functional core
│   └── extracted_ternary.mli    # Materialized verified OCaml module interface
│
└── 🔧 tools/                    # Verification pipelines and stabilization scripts
    ├── chguard_watch.py         # Markdown/Notebook execution loop watcher
    ├── lint_docs.py             # Documentation structure linter
    ├── runenclaveattack_test.sh # Shell adversarial breach execution driver
    └── deploy_enclave.sh        # Master enclave pipeline and deployment orchestrator
`

</pre>
---

🤝 Acknowledgements

Special gratitude to Christopher Chenoweth and Peter Lodri of the Trinity Squad for foundational work on Ternary Resonance and complex system consolidation. Their structural ontology (ONTOLOGY.md) governs the balanced ternary invariants ({-1, 0, +1}) used throughout the geometric layers.

---

🚀 Setup, Validation & Stabilization

1. Local Environment Setup

`bash
git config --local user.name "Downstream Enclave Observer (Node Beta)"
git config --local user.email "chguard-sentinel@vaked.dev"

pip install -e .
`

2. Manual Verification & Code Extraction

`bash
coqmakefile -f CoqProject -o Makefile && make clean && make
`

3. Full Enclave Pipeline

`bash
chmod +x tools/deploy_enclave.sh
./tools/deploy_enclave.sh
`

4. Containerized Sandbox Execution

`bash
docker build -t coq-hallucination-guard:latest .

docker run --rm --network none \
  -v $(pwd)/src/chguard/validator.v:/home/enclave/workspace/src/chguard/validator.v \
  coq-hallucination-guard:latest src/chguard/validator.v
`

5. Git Pre‑Commit Stabilization Hook

`bash
cat << 'EOF' > .git/hooks/pre-commit

!/bin/sh
python3 tools/lint_docs.py || { echo "[HOOK ABORT] Documentation failed."; exit 1; }
if git diff --cached --name-only | grep -E '\.(bak|tmp|swp)$'; then
    echo "[HOOK ABORT] Swap files detected."; exit 1;
fi
echo "[HOOK SUCCESS] Proceeding to cryptographic sign-off."
EOF

chmod +x .git/hooks/pre-commit
`

---

⭐ Bill Nye Tile Says…

> “Kids!  
> When math gets a proper home, it becomes easier to explore.  
> chguard acts like a lock on the door of our big, soft, 80‑dimensional house—making sure the AI doesn't write fake equations on the walls!”

---

