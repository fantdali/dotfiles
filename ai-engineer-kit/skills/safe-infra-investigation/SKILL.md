---
name: safe-infra-investigation
description: Investigate or change Kubernetes, Linux, networking, GPU, storage, and cloud infrastructure under a session-level operating mode. Use for incidents, live diagnostics, SSH work, production changes, and bounded lab experiments.
---

# Infrastructure Sessions

Establish the target and operating mode once, then work without inventing extra command restrictions.

## Choose the session mode

- `suggest-only`: provide commands and expected signals; do not execute them.
- `observe`: execute non-mutating diagnostics; do not change live state.
- `careful-change`: investigate, then request one approval for a concrete mutation or coherent batch. Include target, expected effect, validation, and practical rollback.
- `autonomous`: execute observations and mutations without per-command approval inside the named boundary. Validate continuously and stop on scope drift or unclear impact.

If the user supplied the mode and target, accept them without re-confirming every command. If mutation authority is ambiguous, ask once before the first mutation. Production, shared, and unknown targets default to `observe` for diagnosis and `careful-change` for requested changes; `autonomous` requires explicit authorization.

Record the boundary before live work: cluster/context, namespace when relevant, SSH hosts or cloud account, goal, and stop conditions. Confirm the actual selected target before acting.

## Workflow

1. Define the symptom, scope, and success signal.
2. Read relevant repository runbooks or private documentation named in local instructions when one applies.
3. Test the cheapest discriminating hypothesis first and iterate from evidence.
4. Use any command required by the task and allowed by the selected mode; there is no static command blocklist.
5. Separate confirmed facts, inferences, and hypotheses. Record material mutations and validation results.
6. Finish with the cause or current best explanation, changes made, remaining risk, and next action.

## Boundaries

- Use the operator's existing credentials, contexts, and SSH aliases. Do not create access infrastructure unless asked.
- Avoid exposing credential material, Secret values, or customer data unnecessarily. Minimize and redact sensitive captured output.
- Prefer reversible changes and established GitOps workflows when they fit the task; they are not mandatory for an authorized live experiment.
- Native agent permissions control whether execution prompts appear. This skill controls task scope and does not add its own shell-command approval layer.
