# 🛡️ Coq‑Hallucination‑Guard (chguard)

Coq‑Hallucination‑Guard is a safety‑critical enforcement enclave for Coq and the Ssreflect proof language.
It utilizes geometric stability checks, provenance constraints, and deterministic abort logic via coq-lsp serialization to prevent syntactic and semantic mimicry in LLM-generated proofs.

🏗️ UNDER CONSTRUCTION NOTE

⚠️ ATTENTION: ARCHITECTURAL BASELINE IN PROGRESS
This repository is currently under active construction. The foundational structural blueprint and directory layout are locked down below. We are populating this codebase one artifact at a time, in strict dependency order, to maintain 100% formal alignment between the Coq type-checker and the Python enforcement enclave. Do not inject unstructured files.

🧠 Syntactic vs. Semantic Mimicry

• Syntactic Mimicry: LLMs imitate surface-level token patterns and syntax trees (such as tactic shapes or lemma names) without forming valid proof objects within the Calculus of Inductive Constructions (CIC). Academic grounding for form-versus-structure approximations includes works by Chomsky (1995) and Merrill (2020).
• Semantic Mimicry: Models simulate reasoning-shaped text continuation (like fake lemma applications or goal closures) without actual execution on the goal stack, leading to semantic drift. References discussing form versus meaning and symbolic reasoning failures include Bender & Koller (2020), Piantadosi & Hill (2022), Chiang & Cholak (2023), and Wu et al. (2024).

🛡️ Enforcement Triad

Execution steps pass through three Python enforcement modules before reaching the coq-lsp backend:
1. geometry.py: Detects semantic drift and geometric state collapse using invariants on goal serialization JSON.
2. provenance.py: Enforces humanitarian provenance and non-harm parameters, terminating operations that violate safety boundaries.
3. interceptor.py: Instantly halts headless coq-lsp sessions, purges memory, and logs violations if a breach occurs.

📁 Repository Scaffolding

text
coq-hallucination-guard/
│
├── ⚙ _CoqProject                # Coq compilation directives & library mappings
├── 📦 coq/                      # The Formal Verification Enclave
│   ├── 🟦 BaseTernary.v         # Inductive definitions for balanced ternary data types
│   ├── 🟦 Manifold80D.v        # Soft 80D Riemannian manifold structural framework
│   │
│   └── 🧮 Proofs/
│       ├── CurvatureEvolution.v # Proofs of smoothness across threshold jumps
│       ├── Holonomy.v          # Unitarity and stability metrics for loop transport
│       ├── RuntimeFusion.v     # Verification of branchless lane reduction
│       └── SpectralIntegration.v # Operational bounds via functional calculus
│
├── 🐍 src/chguard/              # Python Deterministic Enforcement Layer
│   ├── __init__.py
│   ├── geometry.py             # Parses Coq AST/XML to track goal-state drift
│   ├── provenance.py           # Enforces humanitarian non-harm license rules
│   ├── interceptor.py          # Handles coq-lsp sessions and kills hallucinated tasks
│   └── validator.v             # Coq sandbox workspace script for incoming inputs
│
├── 🔧 tools/
│   └── chguard_watch.py        # Markdown/Notebook execution loop watcher
│
├── 📄 pyproject.toml            # Modern PEP-621 Python tooling metadata
└── 📄 README.md                 # Technical specification & structural usage
Use code with caution.

🤝 Acknowledgements

Special gratitude is extended to Christopher Chenoweth and Peter Lodri of the Trinity Squad for their foundational work on Ternary Resonance into complex system consolidation.
Their breakthrough insights directly govern the project's Constitutional Ontology (ONTOLOGY.md). By formalizing the structural alignment between balanced ternary states ({-1, 0, +1}) and complex system invariants, their work provides the exact stabilizing mechanics used to map, gate, and consolidate information within our multi-agent geometric layers.

Setup and Validation

Requires Python 3.10+ and coq-lsp:
bash
pip install -e .
chguard-validate path/to/proof.v
Use code with caution.

⭐ Bill Nye Tile Says…

“Kids!
When math gets a proper home, it becomes easier to explore.
chguard acts like a lock on the door of our big, soft, 80‑dimensional house—making sure the AI doesn't write fake equations on the walls!”
