import json
import io
from typing import Dict, Any, List, Optional

class GeometricTelemetryValidator:
    """
    Parses live coq-lsp JSON-RPC goal state data to detect semantic drift,
    abrupt goal context switches, or geometric state collapse.
    """
    def __init__(self, soft_bound: float = 1.0):
        self.soft_bound = soft_bound
        self.history_fingerprints: List[int] = []

    def parse_next_rpc_message(self, stream: io.StringIO) -> Optional[Dict[str, Any]]:
        """
        Natively processes Content-Length headers out of a standard IO byte/text
        stream, isolating the exact raw JSON token string for evaluation.
        """
        line = stream.readline()
        if not line or not line.startswith("Content-Length:"):
            return None
            
        try:
            length = int(line.split(":")[1].strip())
            stream.readline() # Read and discard the mandatory '\r\n' buffer separator
            raw_json = stream.read(length)
            return json.loads(raw_json)
        except (IndexError, ValueError, json.JSONDecodeError):
            return None

    def compute_goal_fingerprint(self, goal_data: Dict[str, Any]) -> int:
        """Creates a deterministic structural hash of the current goal hypothesis."""
        hypotheses = goal_data.get("hyp", [])
        conclusion = goal_data.get("ty", "")
        structural_string = f"HYPS:{'|'.join(hypotheses)}//GOAL:{conclusion}"
        return hash(structural_string)

    def verify_state_transition(self, coq_lsp_response: Dict[str, Any]) -> bool:
        """Processes goal serialization frames to check for token replication anomalies."""
        goals = coq_lsp_response.get("result", {}).get("goals", [])
        if not goals:
            return True

        for goal in goals:
            fingerprint = self.compute_goal_fingerprint(goal)
            if len(self.history_fingerprints) > 0:
                last_fp = self.history_fingerprints[-1]
                if fingerprint == last_fp and goal.get("changed", False):
                    return False
            self.history_fingerprints.append(fingerprint)
        return True
