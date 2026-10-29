#!/usr/bin/env python3
import os
import re
import sys

def lint_markdown_file(file_path: str) -> bool:
    """
    Enforces strict structural and metadata stability rules on markdown files.
    Returns False immediately if formatting drift or identity corruption is found.
    """
    if not os.path.exists(file_path):
        print(f"[LINT ERROR] Target file missing: {file_path}", file=sys.stderr)
        return False

    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Rule 1: Ensure the Document Title possesses clean, un-mimicked formatting
    if not content.startswith("# "):
        print(f"[LINT FAILURE] {file_path} must begin with a H1 header standard.", file=sys.stderr)
        return False

    # Rule 2: Verify that System Provenance and Lineage data structures are untouched
    required_anchors = [
        r"Core Ternary Resonance Invariants",
        r"Enclave Enforcement Architecture",
        r"External Peer Node Beta"
    ]
    for anchor in required_anchors:
        if not re.search(anchor, content):
            print(f"[LINT FAILURE] {file_path} is missing critical Lineage/Provenance Anchor: '{anchor}'", file=sys.stderr)
            return False

    # Rule 3: Check for empty sections or unresolved template tokens
    if "TODO" in content or "FIXME" in content:
        print(f"[LINT FAILURE] {file_path} contains unresolved compilation placeholders (TODO/FIXME).", file=sys.stderr)
        return False

    print(f"[LINT SUCCESS] Structural consistency verified: {file_path}")
    return True

if __name__ == "__main__":
    # Target documentation files directly within the local workspace
    target_docs = ["README.md", "docs/bill-nye-tile-explainer.md"]
    success = True
    for doc in target_docs:
        if os.path.exists(doc):
            if not lint_markdown_file(doc):
                success = False
                
    if not success:
        sys.exit(1)
