---
description: Demonstrate F-Thread - Best-of-N pattern with result aggregation
allowed-tools: Read, Bash, Grep, Glob
---

# Fusion Thread (F-Thread) Demo

## Concept

Spawn multiple agents on the **same prompt**, then **aggregate** the best results.

```
            ┌─── Agent 1 ───┐
            │   Solution A  │
            │               │
YOU ────────┼─── Agent 2 ───┼────▶ AGGREGATOR ────▶ BEST RESULT
            │   Solution B  │
            │               │
            └─── Agent 3 ───┘
                Solution C
```

## Key Insight

- **More attempts = higher success probability**
- If 1 agent has 70% chance of success, 3 agents have ~97% chance that at least one succeeds
- Great for rapid prototyping and high-confidence answers

## When to Use F-Threads

- **Rapid prototyping**: Try multiple approaches simultaneously
- **High confidence needed**: Multiple reviewers, consensus
- **Solution comparison**: Generate N solutions, pick best
- **Research**: Multiple search strategies, merge findings

## Aggregation Strategies

1. **Best-of-N**: Simply pick the best result
2. **Consensus**: Take what most agents agree on
3. **Cherry-pick**: Combine best parts from each
4. **Synthesis**: Use another agent to merge results

## Implementation

```bash
#!/bin/bash
PROMPT="Propose a solution for: $TASK"

# Spawn 3 agents (in parallel)
RESULTS=()
for i in 1 2 3; do
  RESULTS+=("$(claude -p "$PROMPT (attempt $i)" --output-format json)")
done

# Aggregate with another Claude call
echo "${RESULTS[@]}" | jq -s '.' | \
  claude -p "Compare these 3 solutions. Select the best and explain why."
```

## Scripts

- `scripts/parallel-runner.sh`: Spawn N agents
- `scripts/fusion-aggregator.sh`: Aggregate results

## Live Demo

**Target:** $ARGUMENTS

I'll demonstrate the fusion concept by showing how you would gather multiple perspectives and aggregate them.

---

**Fusion Thread Pattern:**

For "$ARGUMENTS", a fusion approach would:

1. **Spawn 3+ agents** with the same analysis prompt
2. **Each agent** independently analyzes/solves
3. **Aggregator** compares all results:
   - Points of consensus (most agents agree)
   - Unique insights (only one agent found)
   - Conflicts (agents disagree)
4. **Final synthesis** - best answer from combined intelligence

This is especially powerful for:
- Code review (3 reviewers, synthesize findings)
- Bug hunting (parallel searches, merge discoveries)
- Architecture decisions (multiple proposals, best elements)
