![Deploy Engine CI](https://github.com/Haidriyam/zero-downtime-deploy-engine/actions/workflows/ci.yml/badge.svg)

# Zero-Downtime Blue/Green Deployment Engine

An automated infrastructure-as-code orchestration pattern implementing non-disruptive rolling updates and traffic rerouting via Nginx dynamic upstream configuration and health probing.

```text
       [ Public Client Traffic ]
                   │
                   ▼
       [ Nginx Reverse Proxy ]
         │ (Active)       │ (Idle / Staging)
         ▼                ▼
   [ Blue Pod: v1 ]   [ Green Pod: v2 ]