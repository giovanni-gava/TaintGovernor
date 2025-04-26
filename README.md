# TaintGovernor

Declarative, dynamic taint governance for Kubernetes nodes.

---

## Overview

**TaintGovernor** is a Kubernetes Operator that automates the application and removal of taints on cluster nodes based on customizable, declarative business rules defined via Custom Resource Definitions (CRDs).

By leveraging node labels, metrics, schedules, and custom conditions, TaintGovernor enables dynamic node pool management aligned with operational, financial, and compliance strategies.

---

## Key Features

- Declarative taint policies via CRDs
- Dynamic evaluation based on:
    - Node labels
    - CPU/memory metrics
    - Scheduled time ranges
    - Spot interruption notices
    - Custom business conditions
- Reconciliation loop with intelligent caching
- Observability through Prometheus metrics and Kubernetes Events
- Optional webhook validation for CRD schemas
- Helm chart for simplified deployment

---

## Why TaintGovernor?

Managing taints manually or through static scripts is error-prone and scales poorly.  
TaintGovernor provides:

- **Agility**: Apply or remove taints dynamically as cluster conditions evolve.
- **Resilience**: Improve workload placement and availability through automated governance.
- **Cost Optimization**: Automatically isolate spot instances or maintenance windows without human intervention.
- **Policy-as-Code**: Manage taint logic declaratively, versioned alongside infrastructure code.

---

## Example: TaintPolicy CRD

```yaml
apiVersion: platform.giovanni.dev/v1alpha1
kind: TaintPolicy
metadata:
  name: spot-night-taint
spec:
  nodeSelector:
    matchLabels:
      instance-type: spot
  applyTaint:
    key: "spot-pool"
    value: "true"
    effect: "NoSchedule"
  rules:
    schedule:
      start: "20:00"
      end: "08:00"
    metrics:
      cpuIdlePercentLt: 20
    customConditions:
      - type: awsSpotTermination
