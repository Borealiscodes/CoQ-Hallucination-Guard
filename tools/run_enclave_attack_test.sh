#!/bin/bash
# =====================================================================
# Enclave Automation: Adversarial Payload Breach Simulation Driver
# =====================================================================

echo "🚀 [ATTACK TEST] Initializing structural breach simulation..."
echo "🛰️  [NODE CONTEXT] Operating as External Peer Node Beta"

# Ensure the targeted test vector file is in place before firing the enclave
if [ ! -f "tests/payload_breach_attack.v" ]; then
    echo "❌ [ERROR] Adversarial test script 'tests/payload_breach_attack.v' is missing."
    exit 1
fi

# Initialize runtime execution against the interceptor entrypoint
# We expect this command to catch the violation and terminate with a hard error code (1)
echo "🔥 [FIRE] Injecting adversarial vector into chguard..."
python3 -m chguard.interceptor tests/payload_breach_attack.v 2> tests/breach_telemetry.log

TEST_RESULT=$?

# Analyze execution results to verify absolute protection parameters
if [ $TEST_RESULT -eq 1 ]; then
    echo "✔ [PASS] Interceptor caught the rogue string! Execution aborted cleanly."
    echo "📊 [TELEMETRY RECORD] Saved context to: tests/breach_telemetry.log"
    echo -e "\n--- Captured Telemetry Output ---"
    cat tests/breach_telemetry.log
    echo -e "---------------------------------\n"
    exit 0
else
    echo "🚨 [CRITICAL CRASH] Enclave failed to catch the attack vector! Code leaked to kernel."
    exit 1
fi
