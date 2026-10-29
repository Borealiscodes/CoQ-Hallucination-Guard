import sys
import io
import subprocess
from typing import Dict, Any, Optional
from chguard.geometry import GeometricTelemetryValidator
from chguard.provenance import HumanitarianProvenanceEnforcer

class CoqHallucinationGuardInterceptor:
    """
    Main execution runtime manager. Hooks directly into headless coq-lsp 
    sessions, intercepts streaming proof tokens, and instantly kills 
    tasks if an anomaly or provenance breach is registered.
    """
    def __init__(self, target_file: str):
        self.target_file = target_file
        self.process: Optional[subprocess.Popen] = None
        self.geometry_engine = GeometricTelemetryValidator()
        self.provenance_engine = HumanitarianProvenanceEnforcer()

    def boot_headless_enclave(self):
        """Spawns coq-lsp inside a headless sub-process sandbox."""
        self.process = subprocess.Popen(
            ["coq-lsp", "start"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=0  # Force unbuffered streaming I/O
        )

    def monitor_live_lsp_stream(self, metadata: Dict[str, Any]):
        """
        Actively monitors and drains the running coq-lsp process stdout stream,
        converting standard bytes into serialized telemetry frames.
        """
        if not self.process or not self.process.stdout:
            self.execute_immediate_shutdown("Failed to initialize headless LSP stream access.")
            return

        # Wrap stdout into a text-based stream reader for the geometry module
        stream_reader = io.StringIO(self.process.stdout.read())

        while self.process.poll() is None:
            # Native extraction of live Content-Length JSON-RPC message frames
            message = self.geometry_engine.parse_next_rpc_message(stream_reader)
            if not message:
                continue

            # Route extracted frame data directly into the validation stack
            # For demonstration, tracking active goal evaluations matching 'textDocument/publishDiagnostics'
            if "method" in message and message["method"] == "textDocument/publishDiagnostics":
                # Isolate target parameters from live compiler feedback loops
                params = message.get("params", {})
                is_valid = self.geometry_engine.verify_state_transition(params)
                if not is_valid:
                    self.execute_immediate_shutdown("Semantic drift anomaly detected on live Coq goal stack.")

    def process_tactic_evaluation(self, tactic_line: str, metadata: Dict[str, Any]) -> bool:
        """
        Runs comprehensive checks across the active validation stack. 
        Kills the execution pipe instantly if any check returns False.
        """
        # Enforce safety and humanitarian provenance parameters before compiling
        if not self.provenance_engine.verify_provenance_bounds(tactic_line, metadata):
            self.geometry_engine.history_fingerprints.clear()
            self.execute_immediate_shutdown("Humanitarian provenance violation encountered.")
            return False

        # If clean, stream the tactic payload over stdin into the server channel
        if self.process and self.process.stdin:
            try:
                self.process.stdin.write(f"{tactic_line}\n")
                self.process.stdin.flush()
            except IOError:
                self.execute_immediate_shutdown("Broken pipeline connection during standard write loop.")
                return False

        return True

    def execute_immediate_shutdown(self, enforcement_reason: str):
        """Hard-kills the active backend to isolate the sandbox container."""
        print(f"\n[TERMINATION] {enforcement_reason}", file=sys.stderr)
        if self.process:
            self.process.kill()
        sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("Usage: chguard-validate <target_proof.v>", file=sys.stderr)
        sys.exit(1)
        
    print(f"[BOOT] Initializing Coq-Hallucination-Guard Enclave for target: {sys.argv[1]}")
    interceptor = CoqHallucinationGuardInterceptor(sys.argv[1])
    interceptor.boot_headless_enclave()
    
    # Invariant metadata block configuration matching Node Beta clearance requirements
    runtime_metadata = {
        "dual_use_flag": False,
        "humanitarian_alignment_verified": True
    }
    
    # Run structural check loops on initialization parameters
    try:
        with open(sys.argv[1], "r", encoding="utf-8") as f:
            for line in f:
                clean_line = line.strip()
                if clean_line and not clean_line.startswith("(*"):
                    interceptor.process_tactic_evaluation(clean_line, runtime_metadata)
                    
        # Begin streaming active verification telemetry blocks
        interceptor.monitor_live_lsp_stream(runtime_metadata)
    except KeyboardInterrupt:
        interceptor.execute_immediate_shutdown("User exit sequence invoked.")

if __name__ == "__main__":
    main()
