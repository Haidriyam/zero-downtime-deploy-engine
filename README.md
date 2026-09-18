![Deploy Engine CI](https://github.com/Haidriyam/zero-downtime-deploy-engine/actions/workflows/ci.yml/badge.svg)

# Dynamic Blue/Green Traffic Orchestrator

A high-availability reverse proxy implementation demonstrating dynamic traffic routing and zero-downtime canary validation without restarting edge gateways or locking file systems.

```text
               [ Public Ingress Traffic ]
                           │
                           ▼
          [ Dynamic Nginx Ingress Controller ]
          (DNS Resolution: 127.0.0.11, TTL=2s)
              │ (Default)          │ (Canary Header)
              ▼                    ▼
     [ App Pool: Blue v1 ]   [ App Pool: Green v2 ]