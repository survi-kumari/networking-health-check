#!/bin/bash

# Networking Health Check Project
# Purpose: Check interfaces, routing, DNS, HTTPS and listening ports.

set -u

echo "=========================================="
echo "       NETWORKING HEALTH CHECK"
echo "=========================================="
echo "Date: $(date)"
echo

# 1. Network interfaces and IP addresses
echo "[1] NETWORK INTERFACES AND IP ADDRESSES"
if command -v ip >/dev/null 2>&1; then
    ip -brief addr
else
    echo "ERROR: ip command is not installed."
fi
echo

# 2. Routing table and default gateway
echo "[2] ROUTING TABLE"
if command -v ip >/dev/null 2>&1; then
    ip route
    if ip route | grep -q '^default'; then
        echo "Default route: FOUND"
    else
        echo "WARNING: No default route found."
    fi
fi
echo

# 3. DNS resolution
echo "[3] DNS RESOLUTION"
if command -v getent >/dev/null 2>&1; then
    if getent ahosts google.com >/dev/null 2>&1; then
        echo "DNS check: PASS (google.com resolved)"
    else
        echo "DNS check: FAIL (name resolution failed)"
    fi
else
    echo "ERROR: getent command is unavailable."
fi
echo

# 4. HTTPS connectivity
echo "[4] HTTPS CONNECTIVITY"
if command -v curl >/dev/null 2>&1; then
    if curl -fsSI --connect-timeout 5 --max-time 10 https://google.com >/dev/null 2>&1; then
        echo "HTTPS check: PASS"
    else
        echo "HTTPS check: FAIL (connection or HTTP request failed)"
    fi
else
    echo "WARNING: curl is not installed; HTTPS check skipped."
fi
echo

# 5. Listening TCP and UDP ports
echo "[5] LISTENING PORTS"
if command -v ss >/dev/null 2>&1; then
    ss -tuln
else
    echo "ERROR: ss command is unavailable."
fi
echo

echo "=========================================="
echo "       NETWORK CHECK COMPLETED"
echo "=========================================="
